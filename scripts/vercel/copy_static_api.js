const fs = require('fs');
const path = require('path');

const rootDir = path.join(__dirname, '..', '..');
const outputDir = path.join(rootDir, 'build_official_website');

// Files/folders that must exist inside the Vercel output root.
const copies = [
  // Legacy API endpoints for old client versions:
  {
    from: path.join(rootDir, 'static_api', 'api.json'),
    to: path.join(outputDir, 'api.json')
  },
  {
    from: path.join(rootDir, 'static_api', 'hot_update.json'),
    to: path.join(outputDir, 'app_api', 'hot_update.json')
  },
  // Runtime assets referenced by the generated pages ({{root}}/official_website/...):
  {
    from: path.join(rootDir, 'official_website'),
    to: path.join(outputDir, 'official_website')
  },
  // SEO / search-verification files that must stay at the site root:
  {
    from: path.join(rootDir, 'official_website', 'robots.txt'),
    to: path.join(outputDir, 'robots.txt')
  },
  {
    from: path.join(rootDir, 'official_website', 'sitemap.xml'),
    to: path.join(outputDir, 'sitemap.xml')
  },
  {
    from: path.join(rootDir, 'official_website', '0d383df4f2444c4eaf00f5d2931df6ef.txt'),
    to: path.join(outputDir, '0d383df4f2444c4eaf00f5d2931df6ef.txt')
  }
];

for (const { from, to } of copies) {
  if (!fs.existsSync(from)) {
    console.error(`[copy_static_api] missing source file: ${from}`);
    process.exit(1);
  }
  fs.mkdirSync(path.dirname(to), { recursive: true });
  if (fs.statSync(from).isDirectory()) {
    fs.cpSync(from, to, { recursive: true });
  } else {
    fs.copyFileSync(from, to);
  }
  console.log(`[copy_static_api] ${from} -> ${to}`);
}

console.log('[copy_static_api] done');
