const fs = require('fs');
const path = require('path');

const supportedLang = ["zh", "tw", "en", "ja", "ko", "fr", "de", "es", "it", "pt", "id", "th"];
const fallbackLang = ["en", "zh"];

// ============ 1. 配置 ============
const rootDir = "";
const CONFIG = {
  templateDir: path.join(rootDir, 'official_website', 'templates'),
  i18nFile: path.join(rootDir, 'official_website', 'i18n.json'),
  outputDir: path.join(rootDir, ""),
  rootLang: "zh",
  domain: "nikki.ranaxro.com",
  /**
   * ✅ 条件变量开关列表
   * 作用：{{#if X}} / {{#unless X}} 时，若 X 在此数组中则为真，不在则为假
   */
  conditionalVars: ["server"]
};

const MAX_NEST_DEPTH = 10;

// ============ 2. 工具函数 ============

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

function resolveNestedValue(str, data, i18n, currentLang, visited = new Set(), depth = 0) {
  if (typeof str !== 'string') return str;
  if (depth > MAX_NEST_DEPTH) {
    console.warn(`    ⛔ 超过最大嵌套深度 (${MAX_NEST_DEPTH})，停止解析`);
    return str;
  }
  if (!/\{\{\s*([^{}\s]+)\s*\}\}/.test(str)) return str;

  return str.replace(/\{\{\s*([^{}\s]+)\s*\}\}/g, (match, key) => {
    if (visited.has(key)) {
      console.warn(`    🔄 检测到循环引用: ${key}，保留原样`);
      return match;
    }
    const newVisited = new Set(visited);
    newVisited.add(key);

    const localValue = getValue(data, key);
    if (localValue !== undefined && localValue !== null) {
      if (typeof localValue === 'string' && /\{\{\s*([^{}\s]+)\s*\}\}/.test(localValue)) {
        return resolveNestedValue(localValue, data, i18n, currentLang, newVisited, depth + 1);
      }
      return String(localValue);
    }

    for (const lang of [currentLang, ...fallbackLang.filter(l => l !== currentLang)]) {
      const i18nVal = getValue(i18n[lang], key);
      if (i18nVal !== undefined && i18nVal !== null) {
        const strValue = String(i18nVal);
        if (/\{\{\s*([^{}\s]+)\s*\}\}/.test(strValue)) {
          return resolveNestedValue(strValue, data, i18n, currentLang, newVisited, depth + 1);
        }
        return strValue;
      }
    }

    console.warn(`    ⚠️  变量未定义: {{${key}}}（回退语言也缺失）`);
    return match;
  });
}

// ✅ 处理块级条件 {{#if var}}...{{/if}} 和 {{#unless var}}...{{/unless}}
// 逻辑：var 在 CONFIG.conditionalVars 中 → 真；不在 → 假
function resolveConditionBlocks(template, data, i18n, currentLang) {
  let html = template;
  
  // {{#if var}} ... {{/if}}
  const ifRegex = /\{\{\s*#if\s+([a-zA-Z_][a-zA-Z0-9_.]*)\s*\}\}([\s\S]*?)\{\{\s*\/if\s*\}\}/g;
  html = html.replace(ifRegex, (match, varName, content) => {
    if (CONFIG.conditionalVars.includes(varName)) {
      // 变量在白名单中 → 条件为真，保留内容并递归解析内部变量
      return renderTemplate(content, data, i18n, currentLang);
    } else {
      // 变量不在白名单中 → 条件为假，整块删除
      return '';
    }
  });
  
  // {{#unless var}} ... {{/unless}}（与 if 逻辑相反）
  const unlessRegex = /\{\{\s*#unless\s+([a-zA-Z_][a-zA-Z0-9_.]*)\s*\}\}([\s\S]*?)\{\{\s*\/unless\s*\}\}/g;
  html = html.replace(unlessRegex, (match, varName, content) => {
    if (!CONFIG.conditionalVars.includes(varName)) {
      // 变量不在白名单中 → 条件为真（unless），保留内容
      return renderTemplate(content, data, i18n, currentLang);
    } else {
      // 变量在白名单中 → 条件为假，整块删除
      return '';
    }
  });
  
  return html;
}

function renderTemplate(template, renderData, i18n, currentLang) {
  let html = template;
  
  // 步骤1：先处理块级条件（if/unless）
  html = resolveConditionBlocks(html, renderData, i18n, currentLang);
  
  // 步骤2：常规 {{key}} 替换
  let prevHtml;
  let iteration = 0;
  const maxIterations = MAX_NEST_DEPTH;

  do {
    prevHtml = html;
    html = html.replace(/\{\{\s*([^{}\s]+)\s*\}\}/g, (match, key) => {
      // 跳过条件标签残留
      if (key.startsWith('#') || key.startsWith('/')) return match;
      
      const localValue = getValue(renderData, key);
      if (localValue !== undefined && localValue !== null) {
        const strValue = String(localValue);
        if (/\{\{\s*([^{}\s]+)\s*\}\}/.test(strValue)) {
          return resolveNestedValue(strValue, renderData, i18n, currentLang);
        }
        return strValue;
      }

      for (const lang of [currentLang, ...fallbackLang.filter(l => l !== currentLang)]) {
        const i18nVal = getValue(i18n[lang], key);
        if (i18nVal !== undefined && i18nVal !== null) {
          const strValue = String(i18nVal);
          if (/\{\{\s*([^{}\s]+)\s*\}\}/.test(strValue)) {
            return resolveNestedValue(strValue, renderData, i18n, currentLang);
          }
          return strValue;
        }
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

function removeZhOnlyElements(html) {
  return html.replace(
    /<([a-zA-Z][a-zA-Z0-9]*)[^>]*\bclass="[^"]*\bzh-only\b[^"]*"[^>]*>[\s\S]*?<\/\1>/g,
    ''
  );
}

function cleanEmptyLines(html) {
  return html.replace(/\n\s*\n\s*\n/g, '\n\n');
}

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

function mapOutputName(templateName) {
  if (templateName === 'homepage.html') {
    return 'index.html';
  }
  return templateName;
}

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
  console.log(`📋 配置: root_lang=${CONFIG.rootLang}, output=${CONFIG.outputDir || '.'}`);

  let i18n;
  try {
    i18n = JSON.parse(fs.readFileSync(CONFIG.i18nFile, 'utf-8'));
  } catch (e) {
    console.error(`❌ 读取 ${CONFIG.i18nFile} 失败:`, e.message);
    process.exit(1);
  }

  console.log(`🌐 支持 ${supportedLang.length} 种语言: ${supportedLang.join(', ')}\n`);
  console.log(`🌐 i18n 中已定义: ${Object.keys(i18n).join(', ')}\n`);

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

  console.log('🧹 清理旧构建产物...');
  for (const templateRelPath of templateFiles) {
    const outputFileName = mapOutputName(templateRelPath);
    const filePath = path.join(CONFIG.outputDir, outputFileName);
    if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
      fs.rmSync(filePath);
      console.log(`   🗑️  ${filePath}`);
    }
  }
  for (const lang of supportedLang) {
    if (lang === CONFIG.rootLang) continue;
    const langDir = path.join(CONFIG.outputDir, lang);
    if (fs.existsSync(langDir) && fs.statSync(langDir).isDirectory()) {
      fs.rmSync(langDir, { recursive: true, force: true });
      console.log(`   🗑️  ${langDir}/`);
    }
  }
  console.log('');

  ensureDir(CONFIG.outputDir);

  let totalFiles = 0;

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
      const currentOutputDir = path.dirname(outputRelPath);
      const toLangVars = buildToLangVars(currentOutputDir);

      // ✅ 不再手动注入条件变量，conditionalVars 本身就是开关
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