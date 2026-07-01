const fs = require('fs');
const path = require('path');

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

/** 替换模板中的 {{key}} 变量 */
function renderTemplate(template, data) {
  return template.replace(/\{\{\s*([^{}\s]+)\s*\}\}/g, (match, key) => {
    const value = getValue(data, key);
    if (value !== undefined && value !== null) {
      return String(value);
    }
    console.warn(`    ⚠️  变量未定义: {{${key}}}`);
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
  // 目录层级数 = 段数 - 1（最后一段是文件名）
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

// ============ 3. 主构建流程 ============

function build() {
  console.log('🚀 开始构建多语言网站...\n');
  console.log(`📋 配置: root_lang=${CONFIG.rootLang}, output=${CONFIG.outputDir}`);

  // 读取 i18n
  let i18n;
  try {
    i18n = JSON.parse(fs.readFileSync(CONFIG.i18nFile, 'utf-8'));
  } catch (e) {
    console.error(`❌ 读取 ${CONFIG.i18nFile} 失败:`, e.message);
    process.exit(1);
  }

  const languages = Object.keys(i18n);
  console.log(`🌐 发现 ${languages.length} 种语言: ${languages.join(', ')}\n`);

  // 清空输出目录
  if (fs.existsSync(CONFIG.outputDir)) {
    fs.rmSync(CONFIG.outputDir, { recursive: true });
  }
  ensureDir(CONFIG.outputDir);

  // 收集所有模板文件
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

  // 遍历每种语言
  for (const lang of languages) {
    const localeData = i18n[lang];
    console.log(`🔧 [${lang}] 开始构建...`);

    // 遍历每个模板文件
    for (const templateRelPath of templateFiles) {
      const templatePath = path.join(CONFIG.templateDir, templateRelPath);
      const template = fs.readFileSync(templatePath, 'utf-8');

      // 映射输出文件名
      const outputFileName = mapOutputName(templateRelPath);

      // 确定输出路径
      let outputRelPath;
      if (lang === CONFIG.rootLang) {
        outputRelPath = outputFileName;
      } else {
        outputRelPath = path.join(lang, outputFileName);
      }
      const outputPath = path.join(CONFIG.outputDir, outputRelPath);
      ensureDir(path.dirname(outputPath));

      // 计算 {{root}} — 相对于网站根目录
      const root = computeRootPath(outputPath);

      // 构建渲染数据
      const renderData = {
        ...localeData,
        root,
        current_lang: lang,
        is_root_lang: lang === CONFIG.rootLang
      };

      // 渲染
      let html = renderTemplate(template, renderData);

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