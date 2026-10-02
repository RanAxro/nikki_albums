#!/usr/bin/env node
/**
 * build_icons.mjs — Flutter 图标字体编译脚本
 *
 * 流程:
 *   1. 读取 resources/icon/svg 下所有 .svg
 *   2. 描边转填充: 把 SVG 里用 stroke 画的图元展开成填充轮廓(见下方说明)
 *   3. SVGO 清理优化 -> svgicons2svgfont 拼成 SVG 字体 -> svg2ttf 转成 TTF
 *   4. 生成 lib/gen/app_icons.dart, 代码里直接 AppIcons.xxx 使用
 *   5. codepoint 固化在 icon_map.json 中, 新增图标不会导致已有图标乱码
 *
 * 用法:
 *   node scripts/build_icons/build_icons.mjs
 *   node scripts/build_icons/build_icons.mjs --svg-dir resources/icon/svg --font-name AppIcons \
 *        --out-font assets/fonts/app_icons.ttf --out-dart lib/gen/app_icons.dart
 *   node scripts/build_icons/build_icons.mjs --stroke-scale 1.5       # 描边整体加粗到 1.5 倍
 *   node scripts/build_icons/build_icons.mjs --stroke-to-fill false   # 关闭描边转填充
 *
 * 关于描边:
 *   SVG 可以继续用 stroke 画线, 脚本会自动展成填充路径, 不需要手改 SVG。
 *   字体字形只有填充轮廓, 没有描边概念, 所以如果关掉这步, stroke 会被
 *   svgicons2svgfont 忽略: 线段会变成零面积的细线, 空心矩形会变成实心块。
 *   同理, 静态 TTF 只有一个字重, Flutter Icon 的 weight/fill 依赖可变字体的
 *   wght/FILL 轴, 静态字体不会响应; 想要粗细差异只能生成多套字体或用可变字体。
 */

import fs from 'node:fs';
import fsp from 'node:fs/promises';
import path from 'node:path';
import { Readable } from 'node:stream';
import { fileURLToPath } from 'node:url';
import { optimize } from 'svgo';
import SVGIcons2SVGFontStream from 'svgicons2svgfont';
import svg2ttf from 'svg2ttf';
import { SVGPathData } from 'svg-pathdata';
import xmldom from '@xmldom/xmldom';

const { DOMParser, XMLSerializer } = xmldom;

const __dirname = path.dirname(fileURLToPath(import.meta.url));

/* ------------------------------ 默认配置 ------------------------------ */
const DEFAULTS = {
  svgDir: 'resources/icon/svg',          // SVG 源目录
  outFont: 'src/nikki_albums/assets/fonts/app_icons.ttf', // 输出字体
  outDart: 'src/nikki_albums/lib/gen/app_icons.dart',     // 输出 Dart 代码
  mapFile: 'resources/icon/icon_map.json', // codepoint 固化映射
  fontName: 'AppIcons',                  // 字体族名(需与 pubspec 一致)
  className: 'AppIcons',                 // 生成的 Dart 类名
  fontHeight: 1000,                      // em 框高度
  startCode: 0xe001,                     // Private Use Area 起点
  strokeToFill: true,                    // 是否把 stroke 图元展开成填充轮廓
  strokeScale: 1,                        // 描边宽度倍率(1 = 用 SVG 原值)
};

// --svg-dir / --svgDir 都接受
const toCamelCase = (s) => s.replace(/-([a-zA-Z0-9])/g, (_, c) => c.toUpperCase());

function parseArgs(argv) {
  const opts = { ...DEFAULTS };
  for (let i = 2; i < argv.length; i++) {
    const key = argv[i];
    if (!key.startsWith('--')) continue;
    const k = toCamelCase(key.slice(2));
    if (!(k in DEFAULTS)) {
      console.warn(`⚠ 未知参数: ${key}`);
      continue;
    }
    if (typeof DEFAULTS[k] === 'boolean') {
      // 布尔开关: --stroke-to-fill / --stroke-to-fill false / --stroke-to-fill=false 都可以
      const next = argv[i + 1];
      if (next != null && !next.startsWith('--')) {
        opts[k] = !/^(false|0|no|off)$/i.test(next);
        i++;
      } else {
        opts[k] = true;
      }
    } else if (i + 1 < argv.length && !argv[i + 1].startsWith('--')) {
      opts[k] = argv[++i];
    }
  }
  opts.fontHeight = Number(opts.fontHeight);
  opts.startCode = Number(opts.startCode);
  opts.strokeScale = Number(opts.strokeScale);
  if (!Number.isFinite(opts.strokeScale) || opts.strokeScale <= 0) opts.strokeScale = 1;
  return opts;
}

const fail = (msg) => { console.error(`✖ ${msg}`); process.exit(1); };

/* ------------------------------ 名称处理 ------------------------------ */
// 文件名 -> 字体内部 glyph 名 (只允许字母数字下划线连字符)
const toGlyphName = (base) => base.replace(/[^a-zA-Z0-9_-]/g, '-') || 'icon';

// 文件名 -> Dart 变量名 (小驼峰, 非法开头加 icon 前缀)
function toDartName(base) {
  const parts = base.split(/[^a-zA-Z0-9]+/).filter(Boolean);
  let name = parts
    .map((p, i) => (i === 0 ? p.toLowerCase() : p.charAt(0).toUpperCase() + p.slice(1)))
    .join('');
  if (!name) name = 'icon';
  if (/^[0-9]/.test(name)) name = 'icon' + name.charAt(0).toUpperCase() + name.slice(1);
  return name;
}

/* ------------------------------ 描边转填充 ------------------------------ */
/*
 * 字体字形(glyf)只有「填充轮廓」, 没有描边这个概念。
 * svgicons2svgfont 只读 path 的 d, stroke / stroke-width 会被直接丢弃, 于是:
 *   - 开口路径(线段) -> 填充面积为零, 渲染出来只有一条几乎看不见的细线
 *   - 闭合路径(rect) -> 轮廓被当成填充, 空心边框变成实心块
 * 这里在进入 svgo / 字体流水线之前, 先按 stroke-width / linecap / linejoin
 * 把带 stroke 的图元展开成等价的填充路径(transform 原样保留), SVG 源文件不用改。
 */

const SHAPE_TAGS = ['path', 'rect', 'circle', 'ellipse', 'line', 'polyline', 'polygon'];
// 这些容器里的图元不是直接可见的描边(渐变/裁剪/符号定义等), 不做转换
const SKIP_TAGS = [
  'defs', 'clippath', 'mask', 'marker', 'pattern', 'symbol', 'filter',
  'lineargradient', 'radialgradient', 'style', 'title', 'desc', 'metadata',
];
const STROKE_ATTRS = [
  'stroke', 'stroke-width', 'stroke-linecap', 'stroke-linejoin',
  'stroke-miterlimit', 'stroke-dasharray', 'stroke-opacity',
];
const PROP_NAMES = ['fill', ...STROKE_ATTRS];

// 只支持无单位或 px; 其它单位(%, em, pt...)视为不支持
function parseLength(value) {
  if (value == null) return NaN;
  const m = /^\s*([+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?)\s*(?:px)?\s*$/.exec(String(value));
  return m ? parseFloat(m[1]) : NaN;
}

function num(value, fallback = 0) {
  const n = parseFloat(value);
  return Number.isFinite(n) ? n : fallback;
}

// style="stroke:#fff;stroke-width:2" -> { stroke: '#fff', 'stroke-width': '2' }
function parseStyle(value) {
  const out = {};
  if (!value) return out;
  for (const decl of String(value).split(';')) {
    const i = decl.indexOf(':');
    if (i < 0) continue;
    out[decl.slice(0, i).trim().toLowerCase()] = decl.slice(i + 1).trim();
  }
  return out;
}

// 解析 svg 的继承属性(元素自身 > style > 祖先)
function resolveProps(el, inherited) {
  const style = parseStyle(el.getAttribute && el.getAttribute('style'));
  const props = { ...inherited };
  for (const name of PROP_NAMES) {
    if (style[name] != null) props[name] = style[name];
    const attr = el.getAttribute && el.getAttribute(name);
    if (attr != null) props[name] = String(attr).trim();
  }
  return props;
}

const pickEnum = (value, allowed, fallback) => {
  const v = String(value == null ? '' : value).trim().toLowerCase();
  return allowed.includes(v) ? v : fallback;
};

// 采样椭圆弧(rx/ry 可为 0, 角度单位为弧度)
function sampleEllipseArc(cx, cy, rx, ry, a0, a1, tol, out) {
  const radius = Math.max(Math.abs(rx), Math.abs(ry), 1e-6);
  const step = Math.max(0.05, 2 * Math.acos(Math.min(1, Math.max(-1, 1 - tol / radius))));
  const n = Math.max(1, Math.ceil(Math.abs(a1 - a0) / step));
  for (let i = 0; i <= n; i++) {
    const t = a0 + (a1 - a0) * (i / n);
    out.push({ x: cx + rx * Math.cos(t), y: cy + ry * Math.sin(t) });
  }
}

// 三次贝塞尔扁平化(按最大偏差 tol 自适应细分)
function flattenCubic(p0, c1, c2, p1, tol, out, depth = 0) {
  if (depth >= 16 || cubicIsFlat(p0, c1, c2, p1, tol)) {
    out.push({ x: p1.x, y: p1.y });
    return;
  }
  const mid = (a, b) => ({ x: (a.x + b.x) / 2, y: (a.y + b.y) / 2 });
  const a = mid(p0, c1);
  const b = mid(c1, c2);
  const c = mid(c2, p1);
  const ab = mid(a, b);
  const bc = mid(b, c);
  const m = mid(ab, bc);
  flattenCubic(p0, a, ab, m, tol, out, depth + 1);
  flattenCubic(m, bc, c, p1, tol, out, depth + 1);
}

function cubicIsFlat(p0, c1, c2, p1, tol) {
  const dx = p1.x - p0.x;
  const dy = p1.y - p0.y;
  const len = Math.hypot(dx, dy);
  if (len < 1e-9) {
    return Math.hypot(c1.x - p0.x, c1.y - p0.y) <= tol && Math.hypot(c2.x - p0.x, c2.y - p0.y) <= tol;
  }
  const d1 = Math.abs((c1.x - p0.x) * dy - (c1.y - p0.y) * dx) / len;
  const d2 = Math.abs((c2.x - p0.x) * dy - (c2.y - p0.y) * dx) / len;
  return Math.max(d1, d2) <= tol;
}

// path 的 d -> 若干折线子路径(曲线/弧线已扁平化)
function pathGeometry(d, tol) {
  if (!d) return [];
  let commands;
  try {
    commands = new SVGPathData(d).toAbs().normalizeHVZ().normalizeST().qtToC().aToC().commands;
  } catch (err) {
    throw new Error(`path 的 d 无法解析: ${err.message}`);
  }
  const subs = [];
  let cur = null;
  let x = 0;
  let y = 0;
  let startX = 0;
  let startY = 0;
  const flush = () => {
    if (cur && cur.points.length >= 2) subs.push(cur);
    cur = null;
  };
  for (const c of commands) {
    if (c.type === SVGPathData.MOVE_TO) {
      flush();
      cur = { points: [{ x: c.x, y: c.y }], closed: false };
      x = startX = c.x;
      y = startY = c.y;
    } else if (c.type === SVGPathData.LINE_TO) {
      if (!cur) cur = { points: [{ x, y }], closed: false };
      cur.points.push({ x: c.x, y: c.y });
      x = c.x;
      y = c.y;
    } else if (c.type === SVGPathData.CURVE_TO) {
      if (!cur) cur = { points: [{ x, y }], closed: false };
      flattenCubic({ x, y }, { x: c.x1, y: c.y1 }, { x: c.x2, y: c.y2 }, { x: c.x, y: c.y }, tol, cur.points);
      x = c.x;
      y = c.y;
    } else if (c.type === SVGPathData.CLOSE_PATH) {
      if (cur) {
        cur.closed = true;
        flush();
      }
      x = startX;
      y = startY;
    }
  }
  flush();
  return subs;
}

// 图元 -> 若干折线子路径(坐标为元素自身坐标系)
function shapeGeometry(tag, el, tol) {
  const attr = (name, fallback = 0) => (el.getAttribute(name) == null ? fallback : num(el.getAttribute(name), fallback));
  if (tag === 'rect') {
    const w = attr('width');
    const h = attr('height');
    if (!(w > 0) || !(h > 0)) return [];
    const x = attr('x');
    const y = attr('y');
    const rawRx = el.getAttribute('rx');
    const rawRy = el.getAttribute('ry');
    const hasRx = rawRx != null && rawRx !== 'auto';
    const hasRy = rawRy != null && rawRy !== 'auto';
    let rx = hasRx ? num(rawRx) : hasRy ? num(rawRy) : 0;
    let ry = hasRy ? num(rawRy) : rx;
    rx = Math.min(Math.max(rx, 0), w / 2);
    ry = Math.min(Math.max(ry, 0), h / 2);
    const pts = [];
    if (rx < 1e-9 || ry < 1e-9) {
      pts.push({ x, y }, { x: x + w, y }, { x: x + w, y: y + h }, { x, y: y + h });
    } else {
      const hpi = Math.PI / 2;
      pts.push({ x: x + rx, y });
      pts.push({ x: x + w - rx, y });
      sampleEllipseArc(x + w - rx, y + ry, rx, ry, -hpi, 0, tol, pts);
      pts.push({ x: x + w, y: y + h - ry });
      sampleEllipseArc(x + w - rx, y + h - ry, rx, ry, 0, hpi, tol, pts);
      pts.push({ x: x + rx, y: y + h });
      sampleEllipseArc(x + rx, y + h - ry, rx, ry, hpi, Math.PI, tol, pts);
      pts.push({ x, y: y + ry });
      sampleEllipseArc(x + rx, y + ry, rx, ry, Math.PI, Math.PI + hpi, tol, pts);
    }
    return [{ points: pts, closed: true }];
  }
  if (tag === 'circle' || tag === 'ellipse') {
    const cx = attr('cx');
    const cy = attr('cy');
    const rx = tag === 'circle' ? attr('r') : el.getAttribute('rx') == null ? attr('ry') : attr('rx');
    const ry = tag === 'circle' ? attr('r') : el.getAttribute('ry') == null ? rx : attr('ry');
    if (!(rx > 0) || !(ry > 0)) return [];
    const pts = [];
    sampleEllipseArc(cx, cy, rx, ry, 0, Math.PI * 2, tol, pts);
    return [{ points: pts, closed: true }];
  }
  if (tag === 'line') {
    return [{ points: [{ x: attr('x1'), y: attr('y1') }, { x: attr('x2'), y: attr('y2') }], closed: false }];
  }
  if (tag === 'polyline' || tag === 'polygon') {
    const nums = String(el.getAttribute('points') || '').trim().split(/[\s,]+/).map(Number).filter(Number.isFinite);
    const pts = [];
    for (let i = 0; i + 1 < nums.length; i += 2) pts.push({ x: nums[i], y: nums[i + 1] });
    if (pts.length < 2) return [];
    return [{ points: pts, closed: tag === 'polygon' }];
  }
  if (tag === 'path') return pathGeometry(el.getAttribute('d'), tol);
  return [];
}

const signedArea = (points) => {
  let sum = 0;
  for (let i = 0; i < points.length; i++) {
    const a = points[i];
    const b = points[(i + 1) % points.length];
    sum += a.x * b.y - b.x * a.y;
  }
  return sum / 2;
};

function dedupePoints(points, eps) {
  const out = [];
  for (const p of points) {
    const last = out[out.length - 1];
    if (last && Math.abs(last.x - p.x) < eps && Math.abs(last.y - p.y) < eps) continue;
    out.push(p);
  }
  return out;
}

const normalizeAngle = (a) => {
  let v = a;
  while (v > Math.PI) v -= Math.PI * 2;
  while (v < -Math.PI) v += Math.PI * 2;
  return v;
};

// 从 from 到 to 的圆弧(圆心 c, 半径 r), outward 用来决定绕行方向
function appendArc(out, c, from, to, r, outward, tol) {
  const a0 = Math.atan2(from.y - c.y, from.x - c.x);
  const a1 = Math.atan2(to.y - c.y, to.x - c.x);
  let ccw = a1 - a0;
  while (ccw < 0) ccw += Math.PI * 2;
  let delta = ccw;
  if (outward) {
    const ref = Math.atan2(outward.y, outward.x);
    const dCCW = Math.abs(normalizeAngle(a0 + ccw / 2 - ref));
    const dCW = Math.abs(normalizeAngle(a0 - (Math.PI * 2 - ccw) / 2 - ref));
    if (dCW < dCCW) delta = ccw - Math.PI * 2;
  }
  const step = Math.max(0.05, 2 * Math.acos(Math.min(1, Math.max(-1, 1 - tol / Math.max(r, 1e-6)))));
  const n = Math.max(1, Math.ceil(Math.abs(delta) / step));
  for (let i = 1; i <= n; i++) {
    const t = a0 + delta * (i / n);
    out.push({ x: c.x + r * Math.cos(t), y: c.y + r * Math.sin(t) });
  }
}

// 一条折线子路径 -> 描边后的填充轮廓(可能多段)
function strokeSubpath(sub, width, opts, contours) {
  const r = width / 2;
  const tol = opts.tol;
  const eps = tol / 10;
  let pts = dedupePoints(sub.points, eps);
  let closed = !!sub.closed;
  if (pts.length > 2 && Math.abs(pts[0].x - pts[pts.length - 1].x) < eps && Math.abs(pts[0].y - pts[pts.length - 1].y) < eps) {
    pts = pts.slice(0, -1);
    closed = true;
  }
  const n = pts.length;
  if (n < 2) return;
  if (closed && n < 3) return;

  const segCount = closed ? n : n - 1;
  const dir = [];
  const nor = [];
  for (let i = 0; i < segCount; i++) {
    const a = pts[i];
    const b = pts[(i + 1) % n];
    const dx = b.x - a.x;
    const dy = b.y - a.y;
    const len = Math.hypot(dx, dy) || 1;
    dir.push({ x: dx / len, y: dy / len });
    nor.push({ x: -dir[i].y, y: dir[i].x });
  }

  // 顶点 i 在 side 侧的转角点(side = ±1)
  const corner = (side, i) => {
    const prev = (i - 1 + segCount) % segCount;
    const A = { x: pts[i].x + side * r * nor[prev].x, y: pts[i].y + side * r * nor[prev].y };
    const B = { x: pts[i].x + side * r * nor[i].x, y: pts[i].y + side * r * nor[i].y };
    const cross = dir[prev].x * dir[i].y - dir[prev].y * dir[i].x;
    const dot = nor[prev].x * nor[i].x + nor[prev].y * nor[i].y;
    if (Math.abs(cross) < 1e-9) return dot < 0 ? [A, B] : [A]; // 共线: A、B 基本重合
    const denom = 1 + dot;
    const isOuter = side * cross < 0;
    if (denom > 1e-6) {
      // miter 交点(内外侧都用它), 外侧还要看是否超出 miter-limit
      const miter = {
        x: pts[i].x + (side * r * (nor[prev].x + nor[i].x)) / denom,
        y: pts[i].y + (side * r * (nor[prev].y + nor[i].y)) / denom,
      };
      const ratio = Math.hypot(miter.x - pts[i].x, miter.y - pts[i].y) / width;
      if (!isOuter || (opts.join === 'miter' && ratio <= opts.miterLimit)) return [miter];
    }
    if (!isOuter) return [A, B]; // 内侧且角度过尖: 退化成 bevel
    if (opts.join === 'round') {
      const outward = { x: A.x + B.x - 2 * pts[i].x, y: A.y + B.y - 2 * pts[i].y };
      const arc = [];
      appendArc(arc, pts[i], A, B, r, outward, tol);
      return arc;
    }
    return [A, B]; // bevel
  };

  const sideLoops = [1, -1].map((side) => {
    const loop = [];
    if (closed) {
      for (let i = 0; i < n; i++) loop.push(...corner(side, i));
    } else {
      loop.push({ x: pts[0].x + side * r * nor[0].x, y: pts[0].y + side * r * nor[0].y });
      for (let i = 1; i <= n - 2; i++) loop.push(...corner(side, i));
      loop.push({ x: pts[n - 1].x + side * r * nor[segCount - 1].x, y: pts[n - 1].y + side * r * nor[segCount - 1].y });
    }
    return loop;
  });

  if (closed) {
    let [outer, inner] = sideLoops;
    // 内外两侧绕向必须相反, 非零环绕才能挖出中间的空心
    if (Math.sign(signedArea(outer)) === Math.sign(signedArea(inner))) {
      if (Math.abs(signedArea(outer)) >= Math.abs(signedArea(inner))) inner = inner.slice().reverse();
      else outer = outer.slice().reverse();
    }
    if (outer.length >= 3) contours.push(outer);
    if (inner.length >= 3) contours.push(inner);
    return;
  }

  const loop = [...sideLoops[0]];
  const pushCap = (point, d, nrm, reverse) => {
    if (opts.cap === 'butt') return;
    const ux = reverse ? -d.x : d.x;
    const uy = reverse ? -d.y : d.y;
    const nx = reverse ? -nrm.x : nrm.x;
    const ny = reverse ? -nrm.y : nrm.y;
    const A = { x: point.x + r * nx, y: point.y + r * ny };
    const B = { x: point.x - r * nx, y: point.y - r * ny };
    if (opts.cap === 'round') {
      appendArc(loop, point, A, B, r, { x: ux, y: uy }, tol);
    } else {
      loop.push({ x: A.x + r * ux, y: A.y + r * uy }, { x: B.x + r * ux, y: B.y + r * uy });
    }
  };
  pushCap(pts[n - 1], dir[segCount - 1], nor[segCount - 1], false); // 末端
  loop.push(...sideLoops[1].slice().reverse());
  pushCap(pts[0], dir[0], nor[0], true); // 起点
  if (loop.length >= 3) contours.push(loop);
}

const formatCoord = (v, precision = 3) => {
  let s = v.toFixed(precision);
  if (s.includes('.')) s = s.replace(/0+$/, '').replace(/\.$/, '');
  return s === '-0' ? '0' : s;
};

const contoursToPathData = (contours) =>
  contours
    .map(
      (c) =>
        'M' + formatCoord(c[0].x) + ' ' + formatCoord(c[0].y) +
        c.slice(1).map((p) => 'L' + formatCoord(p.x) + ' ' + formatCoord(p.y)).join('') +
        'Z'
    )
    .join('');

// 把 SVG 里所有描边图元就地展开成填充路径, 返回新的 SVG 文本
function inlineStrokes(svgText, opts) {
  const warnings = [];
  const errors = [];
  let doc;
  try {
    doc = new DOMParser({
      onError: (level, msg) => {
        if (level === 'warning') warnings.push(msg);
        else errors.push(msg);
      },
    }).parseFromString(svgText, 'image/svg+xml');
  } catch (err) {
    return { svg: svgText, converted: 0, warnings: [`XML 解析失败, 跳过描边转换: ${err.message}`] };
  }
  const root = doc && doc.documentElement;
  if (!root || errors.length) return { svg: svgText, converted: 0, warnings: [`XML 解析失败, 跳过描边转换: ${errors[0] || 'no root'}`] };

  const viewBox = String(root.getAttribute('viewBox') || '').trim().split(/[\s,]+/).map(Number);
  const viewSize =
    viewBox.length === 4 && viewBox.every(Number.isFinite)
      ? Math.max(Math.abs(viewBox[2]), Math.abs(viewBox[3]))
      : num(root.getAttribute('width'), 256) || 256;
  const tol = Math.max(viewSize / 2000, 0.01); // 扁平化容差: 字体放大后也看不出棱角
  const scale = opts.strokeScale;

  let converted = 0;
  const visit = (el, inherited) => {
    const tag = String(el.nodeName || '').toLowerCase();
    const props = resolveProps(el, inherited);
    if (SKIP_TAGS.includes(tag)) return;
    const children = [];
    for (let c = el.firstChild; c; c = c.nextSibling) if (c.nodeType === 1) children.push(c);

    if (SHAPE_TAGS.includes(tag)) {
      const paint = props.stroke == null ? 'none' : String(props.stroke).trim();
      if (paint !== 'none' && paint !== 'transparent') {
        const rawWidth = parseLength(props['stroke-width']);
        const width = Number.isFinite(rawWidth) ? rawWidth * scale : NaN;
        if (!Number.isFinite(width) || width <= 0) {
          warnings.push(`<${tag}> 的 stroke-width="${props['stroke-width']}" 无法识别(只支持无单位或 px), 已按 1 处理`);
        }
        const strokeWidth = Number.isFinite(width) && width > 0 ? width : 1;
        if (/^url\(/i.test(paint)) {
          warnings.push(`<${tag}> 的 stroke="${paint}" 是渐变/图案引用, 无法转成填充`);
        } else if (props['stroke-dasharray'] && props['stroke-dasharray'] !== 'none') {
          warnings.push(`<${tag}> 使用了 stroke-dasharray, 虚线暂不支持, 按实线处理`);
        }
        if (!/^url\(/i.test(paint)) {
          let contours = [];
          try {
            for (const sub of shapeGeometry(tag, el, tol)) {
              strokeSubpath(sub, strokeWidth, {
                cap: pickEnum(props['stroke-linecap'], ['butt', 'round', 'square'], 'butt'),
                join: pickEnum(props['stroke-linejoin'], ['miter', 'round', 'bevel'], 'miter'),
                miterLimit: Number.isFinite(Number(props['stroke-miterlimit'])) ? Math.max(1, Number(props['stroke-miterlimit'])) : 4,
                tol,
              }, contours);
            }
          } catch (err) {
            warnings.push(`<${tag}> 描边转换失败, 已跳过: ${err.message}`);
            contours = [];
          }
          const d = contoursToPathData(contours);
          if (d) {
            const pathEl = doc.createElement('path');
            pathEl.setAttribute('d', d);
            pathEl.setAttribute('fill', paint === 'currentColor' ? 'currentColor' : paint);
            const transform = el.getAttribute('transform');
            if (transform) pathEl.setAttribute('transform', transform);
            const fillPaint = props.fill == null ? 'black' : String(props.fill).trim();
            const keepFill = fillPaint !== 'none' && fillPaint !== 'transparent';
            if (keepFill) {
              for (const name of STROKE_ATTRS) el.removeAttribute(name);
              el.parentNode.insertBefore(pathEl, el.nextSibling);
            } else {
              el.parentNode.replaceChild(pathEl, el);
            }
            converted++;
          }
        }
      }
    }
    for (const child of children) visit(child, props);
  };
  visit(root, {});

  return { svg: converted > 0 ? new XMLSerializer().serializeToString(doc) : svgText, converted, warnings };
}

/* ------------------------------ 主流程 ------------------------------ */
async function main() {
  const opts = parseArgs(process.argv);
  const svgDir = path.resolve(process.cwd(), opts.svgDir);
  const outFont = path.resolve(process.cwd(), opts.outFont);
  const outDart = path.resolve(process.cwd(), opts.outDart);
  const mapPath = path.resolve(process.cwd(), opts.mapFile);

  if (!fs.existsSync(svgDir)) fail(`SVG 目录不存在: ${svgDir}`);

  const files = (await fsp.readdir(svgDir))
    .filter((f) => f.toLowerCase().endsWith('.svg'))
    .sort((a, b) => a.localeCompare(b, 'en'));
  if (files.length === 0) fail(`目录中没有 SVG 文件: ${svgDir}`);

  /* 1. 读取/分配 codepoint(保证已上线的图标 codepoint 不变) */
  let codeMap = {};
  if (fs.existsSync(mapPath)) codeMap = JSON.parse(await fsp.readFile(mapPath, 'utf8'));
  const bases = files.map((f) => path.basename(f, path.extname(f)));
  // 清理已删除的图标
  for (const k of Object.keys(codeMap)) if (!bases.includes(k)) delete codeMap[k];
  let next = Math.max(opts.startCode - 1, ...Object.values(codeMap).map(Number), 0) + 1;
  for (const b of bases) if (!(b in codeMap)) codeMap[b] = next++;

  /* 2. 读入 -> 描边转填充 -> 优化 SVG */
  const glyphs = [];
  let outlinedShapes = 0;
  let outlinedFiles = 0;
  for (const file of files) {
    const base = path.basename(file, path.extname(file));
    const raw = await fsp.readFile(path.join(svgDir, file), 'utf8');
    let source = raw;
    if (opts.strokeToFill) {
      const inflated = inlineStrokes(raw, opts);
      source = inflated.svg;
      for (const w of inflated.warnings) console.warn(`⚠ ${file}: ${w}`);
      if (inflated.converted > 0) {
        outlinedShapes += inflated.converted;
        outlinedFiles++;
      }
    }
    const { data } = optimize(source, {
      multipass: true,
      plugins: [
        {
          name: 'preset-default',
          params: { overrides: { removeViewBox: false } }, // 字体需要 viewBox 计算尺寸
        },
        'removeDimensions',   // 去掉 width/height, 保留 viewBox
        'convertShapeToPath', // 矩形/圆等统一转 path
      ],
    });
    glyphs.push({
      file,
      glyphName: toGlyphName(base),
      dartName: toDartName(base),
      codepoint: codeMap[base],
      svg: data,
    });
  }
  if (opts.strokeToFill) {
    console.log(`✔ 描边转填充: ${outlinedFiles} 个文件 / ${outlinedShapes} 个图元`);
  }

  // Dart 变量名冲突检测 (如 a-b.svg 与 a_b.svg)
  const seen = new Map();
  for (const g of glyphs) {
    if (seen.has(g.dartName))
      fail(`Dart 变量名冲突: "${g.file}" 与 "${seen.get(g.dartName)}", 请重命名其一`);
    seen.set(g.dartName, g.file);
  }

  /* 3. 生成 SVG 字体 -> 转 TTF */
  const svgFont = await new Promise((resolve, reject) => {
    const chunks = [];
    const fontStream = new SVGIcons2SVGFontStream({
      fontName: opts.fontName,
      fontId: opts.fontName,
      fontStyle: 'normal',
      fontWeight: 'normal',
      fixedWidth: true,        // 所有图标统一字宽, 等宽对齐
      centerHorizontally: true,
      centerVertically: true,
      normalize: true,         // 自动缩放到 em 框
      fontHeight: opts.fontHeight,
      round: 10e3,
      metadata: opts.fontName,
    });
    fontStream.on('data', (c) => chunks.push(c));
    fontStream.on('end', () => resolve(Buffer.concat(chunks)));
    fontStream.on('error', reject);
    for (const g of glyphs) {
      const glyphStream = Readable.from([g.svg]);
      glyphStream.metadata = {
        unicode: [String.fromCodePoint(g.codepoint)],
        name: g.glyphName,
      };
      fontStream.write(glyphStream);
    }
    fontStream.end();
  });

  const ttf = Buffer.from(
    svg2ttf(svgFont.toString('utf8'), {
      version: '1.0',
      description: `${opts.fontName} icon font`,
      copyright: `Generated by build_icons.mjs`,
    }).buffer
  );

  /* 4. 写文件 */
  await fsp.mkdir(path.dirname(outFont), { recursive: true });
  await fsp.mkdir(path.dirname(outDart), { recursive: true });
  await fsp.mkdir(path.dirname(mapPath), { recursive: true });
  await fsp.writeFile(outFont, ttf);
  await fsp.writeFile(mapPath, JSON.stringify(codeMap, null, 2) + '\n');
  await fsp.writeFile(outDart, generateDart(glyphs, opts));

  /* 5. 输出摘要 */
  console.log(`✔ 字体: ${path.relative(process.cwd(), outFont)} (${ttf.length} bytes, ${glyphs.length} glyphs)`);
  console.log(`✔ Dart: ${path.relative(process.cwd(), outDart)}`);
  console.log(`✔ 映射: ${path.relative(process.cwd(), mapPath)}`);
  console.log('\ncodepoint 对照:');
  for (const g of glyphs)
    console.log(`  0x${g.codepoint.toString(16).padStart(4, '0')}  ${g.dartName.padEnd(24)} ${g.file}`);
}

/* ------------------------------ Dart 生成 ------------------------------ */
function generateDart(glyphs, opts) {
  const L = [];
  L.push('// GENERATED CODE - DO NOT MODIFY BY HAND');
  L.push('// 由 scripts/build_icons.mjs 自动生成, 重新执行脚本即可更新');
  L.push('');
  L.push("import 'package:flutter/widgets.dart';");
  L.push('');
  L.push(`class ${opts.className} {`);
  L.push(`  ${opts.className}._();`);
  L.push('');
  L.push(`  static const String fontFamily = '${opts.fontName}';`);
  L.push('');
  for (const g of glyphs) {
    L.push(`  /// ${g.file}`);
    L.push(
      `  static const IconData ${g.dartName} = IconData(0x${g.codepoint.toString(16)}, fontFamily: fontFamily);`
    );
    L.push('');
  }
  L.push('}');
  return L.join('\n') + '\n';
}

main().catch((err) => fail(err.stack || String(err)));
