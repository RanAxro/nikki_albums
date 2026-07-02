const fs = require('fs');
const path = require('path');

const supportedLang = ["zh", "tw", "en", "ja", "ko", "fr", "de", "es", "it", "pt", "id", "th"]
const fallbackLang = ["en", "zh"]

// ============ 1. 读取配置并计算根目录 ============
const rootDir = "../";
const CONFIG = {
  templateDir: path.join(rootDir, 'official_website', 'templates'),
  i18nFile: path.join(rootDir, 'official_website', 'i18n.json'),
  outputDir: path.join(rootDir, "build_web"),
  rootLang: "zh",
  domain: "nikki.ranaxro.com"
};

// 最大递归深度，防止循环引用导致栈溢出
const MAX_NEST_DEPTH = 10;

// ============ 2. 工具函数 ============

/** 按点号路径深层取值 */
function getValue(obj, keyPath) {
  const keys = keyPath.split('.');
  let current = obj;
  for (const key of keys) {
    if (current === null || current === undefined || typeof current !== 'object') {
      return undefined;
    }
    current = current[key];
  }
  return current;
}

/**
 * 解析字符串中的 {{key}} 占位符
 * @param {string} str - 要解析的字符串
 * @param {object} data - 当前 renderData（含 domain、toLang 等变量）
 * @param {object} i18n - 完整的 i18n 对象
 * @param {string} currentLang - 当前语言
 * @param {Set} visited - 已访问的 key 路径，用于检测循环引用
 * @param {number} depth - 当前递归深度
 * @returns {string} 解析后的字符串
 */
function resolveNestedValue(str, data, i18n, currentLang, visited = new Set(), depth = 0) {
  if (typeof str !== 'string') return str;
  if (depth > MAX_NEST_DEPTH) {
    console.warn(`    ⛔ 超过最大嵌套深度 (${MAX_NEST_DEPTH})，停止解析`);
    return str;
  }

  // 检查是否还有 {{key}} 需要替换
  const hasPlaceholders = /\{\{\s*([^{}\s]+)\s*\}\}/.test(str);
  if (!hasPlaceholders) return str;

  return str.replace(/\{\{\s*([^{}\s]+)\s*\}\}/g, (match, key) => {
    // 检测循环引用
    if (visited.has(key)) {
      console.warn(`    🔄 检测到循环引用: ${key}，保留原样`);
      return match;
    }

    const newVisited = new Set(visited);
    newVisited.add(key);

    // 1) 优先从 renderData 查找
    const localValue = getValue(data, key);
    if (localValue !== undefined && localValue !== null) {
      // 如果值是字符串且包含 {{xxx}}，继续递归解析
      if (typeof localValue === 'string' && /\{\{\s*([^{}\s]+)\s*\}\}/.test(localValue)) {
        return resolveNestedValue(localValue, data, i18n, currentLang, newVisited, depth + 1);
      }
      return String(localValue);
    }

    // 2) 从 i18n fallback 查找
    const i18nValue = getValueWithFallbackRaw(i18n, currentLang, key);
    if (i18nValue !== undefined && i18nValue !== null) {
      const strValue = String(i18nValue);
      // 如果 i18n 值包含 {{xxx}}，递归解析（传入新的 visited 集合）
      if (/\{\{\s*([^{}\s]+)\s*\}\}/.test(strValue)) {
        return resolveNestedValue(strValue, data, i18n, currentLang, newVisited, depth + 1);
      }
      return strValue;
    }

    console.warn(`    ⚠️  变量未定义: {{${key}}}（回退语言也缺失）`);
    return match;
  });
}

/**
 * 按 fallbackLang 顺序在 i18n 中查找变量值（原始值，不做嵌套解析）
 */
function getValueWithFallbackRaw(i18n, currentLang, keyPath) {
  const currentValue = getValue(i18n[currentLang], keyPath);
  if (currentValue !== undefined && currentValue !== null) {
    return currentValue;
  }

  for (const fbLang of fallbackLang) {
    if (fbLang === currentLang) continue;
    const fbValue = getValue(i18n[fbLang], keyPath);
    if (fbValue !== undefined && fbValue !== null) {
      console.warn(`    🔄 [${currentLang}] 变量 "${keyPath}" 缺失，回退到 [${fbLang}]`);
      return fbValue;
    }
  }

  return undefined;
}

/**
 * 按 fallbackLang 顺序在 i18n 中查找变量值（解析嵌套）
 * 用于 renderTemplate 中直接获取 i18n 值时做嵌套解析
 */
function getValueWithFallback(i18n, currentLang, keyPath, data) {
  const rawValue = getValueWithFallbackRaw(i18n, currentLang, keyPath);
  if (rawValue === undefined || rawValue === null) return undefined;
  
  const strValue = String(rawValue);
  // 如果值包含 {{xxx}}，递归解析
  if (/\{\{\s*([^{}\s]+)\s*\}\}/.test(strValue)) {
    return resolveNestedValue(strValue, data, i18n, currentLang);
  }
  return strValue;
}

/** 
 * 替换模板中的 {{key}} 变量
 * 查找顺序：1) renderData  2) i18n fallback
 * 支持嵌套解析和多次遍历
 */
function renderTemplate(template, renderData, i18n, currentLang) {
  let html = template;
  let prevHtml;
  let iteration = 0;
  const maxIterations = MAX_NEST_DEPTH;

  // 多次遍历，直到没有变化或达到最大迭代次数
  do {
    prevHtml = html;
    html = html.replace(/\{\{\s*([^{}\s]+)\s*\}\}/g, (match, key) => {
      // 1) 优先从 renderData 查找
      const localValue = getValue(renderData, key);
      if (localValue !== undefined && localValue !== null) {
        const strValue = String(localValue);
        // 如果 renderData 中的值包含 {{xxx}}，递归解析
        if (/\{\{\s*([^{}\s]+)\s*\}\}/.test(strValue)) {
          return resolveNestedValue(strValue, renderData, i18n, currentLang);
        }
        return strValue;
      }

      // 2) 从 i18n fallback 查找（会自动解析嵌套）
      const i18nValue = getValueWithFallback(i18n, currentLang, key, renderData);
      if (i18nValue !== undefined && i18nValue !== null) {
        return String(i18nValue);
      }

      console.warn(`    ⚠️  变量未定义: {{${key}}}（回退语言也缺失）`);
      return match;
    });
    iteration++;
  } while (html !== prevHtml && iteration < maxIterations);

  if (iteration >= maxIterations && html !== prevHtml) {
    console.warn(`    ⛔ 模板渲染超过最大迭代次数 (${maxIterations})，可能存在循环引用`);
  }

  return html;
}

/** 移除带有 zh-only class 的 HTML 元素 */
function removeZhOnlyElements(html) {
  return html.replace(
    /<([a-zA-Z][a-zA-Z0-9]*)[^>]*\bclass="[^"]*\bzh-only\b[^"]*"[^>]*>[\s\S]*?<\/\1>/g,
    ''
  );
}

/** 清理多余空行 */
function cleanEmptyLines(html) {
  return html.replace(/\n\s*\n\s*\n/g, '\n\n');
}

/** 确保目录存在 */
function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

function computeRootPath(outputPath) {
  const relative = path.relative(rootDir, outputPath);
  const segments = relative.split(path.sep).filter(Boolean);
  const depth = segments.length - 1;
  if (depth <= 0) return '.';
  return Array(depth).fill('..').join('/');
}

/** 映射输出文件名：homepage.html → index.html */
function mapOutputName(templateName) {
  if (templateName === 'homepage.html') {
    return 'index.html';
  }
  return templateName;
}

/** 生成域名相关变量对象 */
function buildDomainVars(currentLang) {
  const domain = CONFIG.domain;
  const vars = {
    domain: domain,
    domain_current: currentLang === CONFIG.rootLang ? domain : `${domain}/${currentLang}`
  };

  for (const lang of supportedLang) {
    vars[`domain_${lang}`] = lang === CONFIG.rootLang ? domain : `${domain}/${lang}`;
  }

  return vars;
}

/** 
 * 生成 to_xx 变量：从当前文件所在目录到其他语言目录的相对路径
 * @param {string} currentOutputDir - 当前输出文件相对于 outputDir 的目录（如 "."、"en"、"en/subdir"）
 */
function buildToLangVars(currentOutputDir) {
  const vars = {};
  for (const lang of supportedLang) {
    const targetDir = lang === CONFIG.rootLang ? '.' : lang;
    let rel = path.relative(currentOutputDir, targetDir);

    if (!rel || rel === '.') {
      rel = '.';
    } else {
      rel = rel.replace(/\\/g, '/');
    }

    vars[`to_${lang}`] = rel;
  }
  return vars;
}

// ============ 3. 主构建流程 ============

function build() {
  console.log('🚀 开始构建多语言网站...\n');
  console.log(`📋 配置: root_lang=${CONFIG.rootLang}, output=${CONFIG.outputDir}`);

  let i18n;
  try {
    i18n = JSON.parse(fs.readFileSync(CONFIG.i18nFile, 'utf-8'));
  } catch (e) {
    console.error(`❌ 读取 ${CONFIG.i18nFile} 失败:`, e.message);
    process.exit(1);
  }

  console.log(`🌐 支持 ${supportedLang.length} 种语言: ${supportedLang.join(', ')}\n`);
  console.log(`🌐 i18n 中已定义: ${Object.keys(i18n).join(', ')}\n`);

  if (fs.existsSync(CONFIG.outputDir)) {
    fs.rmSync(CONFIG.outputDir, { recursive: true });
  }
  ensureDir(CONFIG.outputDir);

  const templateFiles = [];
  function collectTemplates(dir, prefix = '') {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      const relPath = prefix ? `${prefix}/${entry.name}` : entry.name;
      if (entry.isDirectory()) {
        collectTemplates(fullPath, relPath);
      } else if (entry.name.endsWith('.html')) {
        templateFiles.push(relPath);
      }
    }
  }

  if (!fs.existsSync(CONFIG.templateDir)) {
    console.error(`❌ 模板目录不存在: ${CONFIG.templateDir}`);
    process.exit(1);
  }
  collectTemplates(CONFIG.templateDir);
  console.log(`📄 发现 ${templateFiles.length} 个模板文件:`);
  for (const f of templateFiles) {
    const outName = mapOutputName(f);
    if (outName !== f) {
      console.log(`   - ${f} → ${outName}`);
    } else {
      console.log(`   - ${f}`);
    }
  }
  console.log('');

  let totalFiles = 0;

  // 遍历所有 supportedLang，确保每种语言都生成页面
  for (const lang of supportedLang) {
    const localeData = i18n[lang] || {};
    if (!i18n[lang]) {
      console.log(`🔧 [${lang}] 开始构建（i18n 中未定义，将使用 fallback）...`);
    } else {
      console.log(`🔧 [${lang}] 开始构建...`);
    }

    for (const templateRelPath of templateFiles) {
      const templatePath = path.join(CONFIG.templateDir, templateRelPath);
      const template = fs.readFileSync(templatePath, 'utf-8');

      const outputFileName = mapOutputName(templateRelPath);

      let outputRelPath;
      if (lang === CONFIG.rootLang) {
        outputRelPath = outputFileName;
      } else {
        outputRelPath = path.join(lang, outputFileName);
      }
      const outputPath = path.join(CONFIG.outputDir, outputRelPath);
      ensureDir(path.dirname(outputPath));

      const root = computeRootPath(outputPath);
      const domainVars = buildDomainVars(lang);

      // 计算当前文件所在目录（相对于 outputDir）
      const currentOutputDir = path.dirname(outputRelPath);
      const toLangVars = buildToLangVars(currentOutputDir);

      const renderData = {
        ...localeData,
        ...domainVars,
        ...toLangVars,
        root,
        current_lang: lang,
        is_root_lang: lang === CONFIG.rootLang
      };

      let html = renderTemplate(template, renderData, i18n, lang);

      // 非 rootLang 移除 zh-only 元素
      if (lang !== CONFIG.rootLang) {
        html = removeZhOnlyElements(html);
        html = cleanEmptyLines(html);
      }

      fs.writeFileSync(outputPath, html, 'utf-8');
      console.log(`   ✓ ${outputRelPath}  (root="${root}")`);
      totalFiles++;
    }

    console.log('');
  }

  console.log(`✅ 构建完成！共生成 ${totalFiles} 个页面`);
  console.log(`📁 输出目录: ${path.resolve(CONFIG.outputDir)}`);
}

build();