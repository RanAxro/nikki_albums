const fs = require('fs');
const path = require('path');

console.log('Starting locale HTML generation...');

// 1. Load index i18n data
const i18nContent = fs.readFileSync(path.join(__dirname, '../website/pages/index_lang.js'), 'utf8');
const i18n = eval(i18nContent.replace('const i18n = ', '(').replace(/;?\s*$/, ')'));

// Load download lang data
const langJsContent = fs.readFileSync(path.join(__dirname, '../website/pages/lang.js'), 'utf8');
const downloadLang = eval(langJsContent.replace('const lang = ', '(').replace(/;?\s*$/, ')'));

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

    // Build a rich SEO description that includes the game name
    let seoDesc = '';
    if (dict['app_name'] && dict['hero_desc'] && dict['hero_subdesc']) {
        seoDesc = `${dict['app_name']}: ${dict['hero_desc']}. ${dict['hero_subdesc']}`.replace(/"/g, '&quot;');
    } else if (dict['hero_subdesc']) {
        seoDesc = dict['hero_subdesc'].replace(/"/g, '&quot;');
    }

    // Update meta tags dynamically
    if (seoDesc) {
        content = content.replace(/<meta name="description" content="[^"]*">/, `<meta name="description" content="${seoDesc}">`);
    }
    if (dict['app_name']) {
        const escapedAppName = dict['app_name'].replace(/"/g, '&quot;');
        content = content.replace(/<meta property="og:title" content="[^"]*">/, `<meta property="og:title" content="${escapedAppName}">`);
        content = content.replace(/<meta name="twitter:title" content="[^"]*">/, `<meta name="twitter:title" content="${escapedAppName}">`);
    }
    
    // Robustly update JSON-LD blocks via JSON parsing
    content = content.replace(/<script type="application\/ld\+json">\s*({[\s\S]*?})\s*<\/script>/g, (match, jsonStr) => {
        try {
            const jsonObj = JSON.parse(jsonStr);
            if (jsonObj.description && seoDesc) jsonObj.description = seoDesc;
            if (jsonObj.name && dict['app_name']) {
                if (jsonObj['@type'] === 'WebSite' || jsonObj['@type'] === 'SoftwareApplication') {
                    jsonObj.name = dict['app_name'];
                }
            }
            return `<script type="application/ld+json">\n${JSON.stringify(jsonObj, null, 2)}\n</script>`;
        } catch (e) {
            return match;
        }
    });
    if (dict['hero_desc']) {
        content = content.replace(/<meta property="og:description" content="[^"]*">/, `<meta property="og:description" content="${dict['hero_desc'].replace(/"/g, '&quot;')}">`);
        content = content.replace(/<meta name="twitter:description" content="[^"]*">/, `<meta name="twitter:description" content="${dict['hero_desc'].replace(/"/g, '&quot;')}">`);
    }

    // Update canonical link
    content = content.replace(/<link rel="canonical" href="https:\/\/nikki\.ranaxro\.com\/">/, `<link rel="canonical" href="https://nikki.ranaxro.com/${lang}/">`);

    // Rewrite hreflang links inside this generated file
    content = content.replace(/https:\/\/nikki\.ranaxro\.com\/\?lang=([a-z-]+)/g, 'https://nikki.ranaxro.com/$1/');

    // Update download page links for crawlers
    content = content.replace(/href="website\/pages\/download\.html[^"]*"/g, `href="/${lang}/download.html"`);

    // Create directory and write file
    const dirPath = path.join(__dirname, `../${lang}`);
    if (!fs.existsSync(dirPath)) {
        fs.mkdirSync(dirPath, { recursive: true });
    }
    fs.writeFileSync(path.join(dirPath, 'index.html'), content);
    console.log(`✅ Generated /${lang}/index.html`);
}

// 4.5 Generate download.html for each locale
const downloadPath = path.join(__dirname, '../website/pages/download.html');
let downloadHtmlContent = fs.readFileSync(downloadPath, 'utf8');

for (const [lang, dict] of Object.entries(i18n)) {
    let content = downloadHtmlContent;

    // Update <html lang="en">
    content = content.replace(/<html[^>]*>/, `<html lang="${htmlLangMap[lang] || lang}">`);
    if (!content.includes('<html')) { // if download.html didn't have lang attr
        content = content.replace('<html>', `<html lang="${htmlLangMap[lang] || lang}">`);
    }

    // Add <base href="/website/pages/"> so relative paths like "../assets/" resolve correctly
    content = content.replace('<head>', '<head>\n<base href="/website/pages/">');

    // Update title and meta for SEO
    if (downloadLang['page_title'] && downloadLang['page_title'][lang]) {
        content = content.replace(/<title>.*?<\/title>/, `<title>${downloadLang['page_title'][lang]}</title>`);
        content = content.replace(/<meta property="og:title" content="[^"]*">/, `<meta property="og:title" content="${downloadLang['page_title'][lang]}">`);
        content = content.replace(/<meta name="twitter:title" content="[^"]*">/, `<meta name="twitter:title" content="${downloadLang['page_title'][lang]}">`);
    }
    
    // Translate description using the rich SEO description
    let downloadSeoDesc = '';
    if (dict['app_name'] && dict['hero_desc'] && dict['hero_subdesc']) {
        downloadSeoDesc = `${dict['app_name']}: ${dict['hero_desc']}. ${dict['hero_subdesc']}`.replace(/"/g, '&quot;');
    } else if (dict['hero_subdesc']) {
        downloadSeoDesc = dict['hero_subdesc'].replace(/"/g, '&quot;');
    }
    
    if (downloadSeoDesc) {
        content = content.replace(/<meta name="description" content="[^"]*">/, `<meta name="description" content="${downloadSeoDesc}">`);
        content = content.replace(/<meta property="og:description" content="[^"]*">/, `<meta property="og:description" content="${downloadSeoDesc}">`);
        content = content.replace(/<meta name="twitter:description" content="[^"]*">/, `<meta name="twitter:description" content="${downloadSeoDesc}">`);
    }
    
    // Robustly update JSON-LD blocks for download page
    content = content.replace(/<script type="application\/ld\+json">\s*({[\s\S]*?})\s*<\/script>/g, (match, jsonStr) => {
        try {
            const jsonObj = JSON.parse(jsonStr);
            if (jsonObj.description && downloadSeoDesc) jsonObj.description = downloadSeoDesc;
            if (jsonObj.name && downloadLang['app_name'] && downloadLang['app_name'][lang]) {
                if (jsonObj['@type'] === 'WebSite' || jsonObj['@type'] === 'SoftwareApplication') {
                    jsonObj.name = downloadLang['app_name'][lang];
                }
            }
            return `<script type="application/ld+json">\n${JSON.stringify(jsonObj, null, 2)}\n</script>`;
        } catch (e) {
            return match;
        }
    });
    
    // Update canonical/og:url
    content = content.replace(/<meta property="og:url" content="https:\/\/nikki\.ranaxro\.com">/, `<meta property="og:url" content="https://nikki.ranaxro.com/${lang}/download.html">`);

    const dirPath = path.join(__dirname, `../${lang}`);
    fs.writeFileSync(path.join(dirPath, 'download.html'), content);
    console.log(`✅ Generated /${lang}/download.html`);
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
