const fs = require('fs');
const path = require('path');

const rootDir = path.join(__dirname, '..', '..');
const staticApiDir = path.join(rootDir, 'static_api');

// Keep the legacy endpoints working after the source files were
// moved into static_api/:
//   /api.json
//   /app_api/hot_update.json
const copies = [
  {
    from: path.join(staticApiDir, 'api.json'),
    to: path.join(rootDir, 'api.json')
  },
  {
    from: path.join(staticApiDir, 'hot_update.json'),
    to: path.join(rootDir, 'app_api', 'hot_update.json')
  }
];

for (const { from, to } of copies) {
  if (!fs.existsSync(from)) {
    console.error(`[copy_static_api] missing source file: ${from}`);
    process.exit(1);
  }
  fs.mkdirSync(path.dirname(to), { recursive: true });
  fs.copyFileSync(from, to);
  console.log(`[copy_static_api] ${from} -> ${to}`);
}

console.log('[copy_static_api] done');
