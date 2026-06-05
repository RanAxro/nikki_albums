const fs = require('fs');
const path = require('path');

console.log('Starting locale HTML generation...');

// 1. Load i18n data
const i18nContent = fs.readFileSync(path.join(__dirname, '../website/pages/index_lang.js'), 'utf8');
// Evaluate the JS content to extract the i18n object by converting it to an expression
const i18n = eval(i18nContent.replace('const i18n = ', '(').replace(/;?\s*$/, ')'));

// 2. Read index.html
const indexPath = path.join(__dirname, '../index.html');
let indexHtmlContent = fs.readFileSync(indexPath, 'utf8');

// 3. Map internal lang codes to HTML lang attribute values
const htmlLangMap = {
    'zh': 'zh-Hans', 'zh-tw': 'zh-Hant', 'en': 'en',
    'ja': 'ja', 'ko': 'ko', 'fr': 'fr', 'de': 'de',
    'es': 'es', 'it': 'it', 'pt': 'pt', 'id': 'id', 'th': 'th'
};

// 4. Generate a file for each locale
for (const [lang, dict] of Object.entries(i18n)) {
    let content = indexHtmlContent;

    // Update <html lang="en">
    content = content.replace(/<html lang="[^"]+">/, `<html lang="${htmlLangMap[lang] || lang}">`);

    // Add <base href="/"> after <head> so relative paths like "website/assets/..." resolve correctly
    content = content.replace('<head>', '<head>\n<base href="/">');

    // Update <title> and data-i18n elements
    content = content.replace(/(<([a-zA-Z1-6]+)\s+[^>]*data-i18n="([^"]+)"[^>]*>)([\s\S]*?)(<\/\2>)/gi, (match, openTag, tagName, key, inner, closeTag) => {
        if (dict[key]) {
            return openTag + dict[key] + closeTag;
        }
        return match;
    });

    // Update meta tags dynamically
    if (dict['hero_subdesc']) {
        content = content.replace(/<meta name="description" content="[^"]*">/, `<meta name="description" content="${dict['hero_subdesc'].replace(/"/g, '&quot;')}">`);
    }
    if (dict['app_name']) {
        content = content.replace(/<meta property="og:title" content="[^"]*">/, `<meta property="og:title" content="${dict['app_name'].replace(/"/g, '&quot;')}">`);
        content = content.replace(/<meta name="twitter:title" content="[^"]*">/, `<meta name="twitter:title" content="${dict['app_name'].replace(/"/g, '&quot;')}">`);
    }
    if (dict['hero_desc']) {
        content = content.replace(/<meta property="og:description" content="[^"]*">/, `<meta property="og:description" content="${dict['hero_desc'].replace(/"/g, '&quot;')}">`);
        content = content.replace(/<meta name="twitter:description" content="[^"]*">/, `<meta name="twitter:description" content="${dict['hero_desc'].replace(/"/g, '&quot;')}">`);
    }

    // Update canonical link
    content = content.replace(/<link rel="canonical" href="https:\/\/nikki\.ranaxro\.com\/">/, `<link rel="canonical" href="https://nikki.ranaxro.com/${lang}/">`);

    // Rewrite ?lang=XX to /XX/ in hreflang links inside this generated file
    content = content.replace(/https:\/\/nikki\.ranaxro\.com\/\?lang=([a-z-]+)/g, 'https://nikki.ranaxro.com/$1/');

    // Create directory and write file
    const dirPath = path.join(__dirname, `../${lang}`);
    if (!fs.existsSync(dirPath)) {
        fs.mkdirSync(dirPath, { recursive: true });
    }
    fs.writeFileSync(path.join(dirPath, 'index.html'), content);
    console.log(`✅ Generated /${lang}/index.html`);
}

// 5. Modify root index.html to use /lang/ instead of ?lang= for Vercel deployment
indexHtmlContent = indexHtmlContent.replace(/https:\/\/nikki\.ranaxro\.com\/\?lang=([a-z-]+)/g, 'https://nikki.ranaxro.com/$1/');
fs.writeFileSync(indexPath, indexHtmlContent);
console.log('✅ Updated root index.html with directory URLs.');

// 6. Modify root sitemap.xml to use /lang/ instead of ?lang= for Vercel deployment
const sitemapPath = path.join(__dirname, '../sitemap.xml');
let sitemapContent = fs.readFileSync(sitemapPath, 'utf8');
sitemapContent = sitemapContent.replace(/https:\/\/nikki\.ranaxro\.com\/\?lang=([a-z-]+)/g, 'https://nikki.ranaxro.com/$1/');
fs.writeFileSync(sitemapPath, sitemapContent);
console.log('✅ Updated sitemap.xml with directory URLs.');

console.log('🎉 Locale generation complete.');
