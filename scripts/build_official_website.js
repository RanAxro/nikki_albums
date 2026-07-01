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
 * 按 fallbackLang 顺序在 i18n 中查找变量值
 */
function getValueWithFallback(i18n, currentLang, keyPath) {
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
 * 替换模板中的 {{key}} 变量
 * 查找顺序：1) renderData  2) i18n fallback
 */
function renderTemplate(template, renderData, i18n, currentLang) {
  return template.replace(/\{\{\s*([^{}\s]+)\s*\}\}/g, (match, key) => {
    const localValue = getValue(renderData, key);
    if (localValue !== undefined && localValue !== null) {
      return String(localValue);
    }

    const i18nValue = getValueWithFallback(i18n, currentLang, key);
    if (i18nValue !== undefined && i18nValue !== null) {
      return String(i18nValue);
    }

    console.warn(`    ⚠️  变量未定义: {{${key}}}（回退语言也缺失）`);
    return match;
  });
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

  const languages = Object.keys(i18n);
  console.log(`🌐 发现 ${languages.length} 种语言: ${languages.join(', ')}\n`);

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

  for (const lang of languages) {
    const localeData = i18n[lang];
    console.log(`🔧 [${lang}] 开始构建...`);

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