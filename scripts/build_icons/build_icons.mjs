#!/usr/bin/env node
/**
 * build_icons.mjs — Flutter 图标字体编译脚本
 *
 * 流程:
 *   1. 读取 resources/icon/svg 下所有 .svg
 *   2. SVGO 清理优化 -> svgicons2svgfont 拼成 SVG 字体 -> svg2ttf 转成 TTF
 *   3. 生成 lib/gen/app_icons.dart, 代码里直接 AppIcons.xxx 使用
 *   4. codepoint 固化在 icon_map.json 中, 新增图标不会导致已有图标乱码
 *
 * 用法:
 *   node scripts/build_icons.mjs
 *   node scripts/build_icons.mjs --svg-dir resources/icon/svg --font-name AppIcons \
 *        --out-font assets/fonts/app_icons.ttf --out-dart lib/gen/app_icons.dart
 */

import fs from 'node:fs';
import fsp from 'node:fs/promises';
import path from 'node:path';
import { Readable } from 'node:stream';
import { fileURLToPath } from 'node:url';
import { optimize } from 'svgo';
import SVGIcons2SVGFontStream from 'svgicons2svgfont';
import svg2ttf from 'svg2ttf';

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
};

function parseArgs(argv) {
  const opts = { ...DEFAULTS };
  for (let i = 2; i < argv.length; i++) {
    const key = argv[i];
    if (!key.startsWith('--')) continue;
    const k = key.slice(2);
    if (i + 1 < argv.length && !argv[i + 1].startsWith('--')) {
      opts[k] = argv[++i];
    }
  }
  opts.fontHeight = Number(opts.fontHeight);
  opts.startCode = Number(opts.startCode);
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

  /* 2. 读入并优化 SVG */
  const glyphs = [];
  for (const file of files) {
    const base = path.basename(file, path.extname(file));
    const raw = await fsp.readFile(path.join(svgDir, file), 'utf8');
    const { data } = optimize(raw, {
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