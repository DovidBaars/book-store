const fs = require('fs');
const path = require('path');
const archiver = require('archiver');

const distDir = path.join(__dirname, './dist');

fs.readdirSync(distDir).forEach((dir) => {
  const dirPath = path.join(distDir, dir);
  if (fs.statSync(dirPath).isDirectory() && fs.existsSync(path.join(dirPath, 'index.js'))) {
    const output = fs.createWriteStream(path.join(dirPath, `${dir}.zip`));
    const archive = archiver('zip', {
      zlib: { level: 9 } // Sets the compression level.
    });

    output.on('close', () => {
      console.log(`${dir}.zip has been finalized and the output file descriptor has closed.`);
    });

    archive.pipe(output);
    archive.append(fs.createReadStream(path.join(dirPath, 'index.js')), { name: 'index.js' });
    archive.finalize();
  }
});