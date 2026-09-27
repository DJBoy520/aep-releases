#!/usr/bin/env node
/**
 * scripts/install-binary.js
 * 跨平台二进制自适应自动下载与授权脚本 (用于 postinstall 或首次运行懒加载)
 *
 * 规则：
 * - Linux (Ubuntu/Debian等 x64): 仅下载 aep-linux-x64 -> bin/aep 并赋予可执行权限
 * - Windows (x64): 仅下载 aep.exe -> bin/aep.exe
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import https from 'node:https';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.join(__dirname, '..');
const binDir = path.join(projectRoot, 'bin');

const VERSION = 'v2.1.7';
const REPO = 'DJBoy520/aep-releases';

const isWin = process.platform === 'win32';
const isLinux = process.platform === 'linux';

if (!isWin && !isLinux) {
  console.warn(`[aep-releases] 提示: 当前平台 ${process.platform} 暂未提供预编译二进制，请手动编译或配置。`);
  process.exit(0);
}

const targetFile = isWin ? 'aep.exe' : 'aep';
const remoteAssetName = isWin ? 'aep.exe' : 'aep-linux-x64';
const targetPath = path.join(binDir, targetFile);

if (!fs.existsSync(binDir)) {
  fs.mkdirSync(binDir, { recursive: true });
}

// 检查是否已经存在
if (fs.existsSync(targetPath)) {
  const stat = fs.statSync(targetPath);
  if (stat.size > 10 * 1024 * 1024) { // 文件大于10MB认为有效
    console.log(`[aep-releases] ✓ 已存在二进制制品: ${targetPath} (${(stat.size / 1024 / 1024).toFixed(1)} MB)，跳过下载。`);
    if (!isWin) {
      try { fs.chmodSync(targetPath, 0o755); } catch {}
    }
    process.exit(0);
  }
}

const downloadUrl = `https://github.com/${REPO}/releases/download/${VERSION}/${remoteAssetName}`;
console.log(`[aep-releases] 正在为当前系统 (${process.platform}) 下载专属 AEP 执行体...`);
console.log(`[aep-releases] 源地址: ${downloadUrl}`);
console.log(`[aep-releases] 目标路径: ${targetPath}`);

function download(url, dest, cb) {
  const file = fs.createWriteStream(dest);
  
  const request = (targetUrl) => {
    https.get(targetUrl, (res) => {
      // 处理 GitHub 302 重定向
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        request(res.headers.location);
        return;
      }

      if (res.statusCode !== 200) {
        fs.unlink(dest, () => {});
        cb(new Error(`下载失败，服务器返回 HTTP ${res.statusCode}`));
        return;
      }

      const total = parseInt(res.headers['content-length'] || '0', 10);
      let cur = 0;
      let lastPercent = 0;

      res.on('data', (chunk) => {
        cur += chunk.length;
        if (total > 0) {
          const percent = Math.floor((cur / total) * 100);
          if (percent - lastPercent >= 20 || percent === 100) {
            process.stdout.write(`\r[aep-releases] 下载进度: ${percent}% (${(cur / 1024 / 1024).toFixed(1)}MB / ${(total / 1024 / 1024).toFixed(1)}MB)`);
            lastPercent = percent;
          }
        }
      });

      res.pipe(file);

      file.on('finish', () => {
        file.close(() => {
          if (total > 0 && cur < total) {
            fs.unlink(dest, () => {});
            cb(new Error(`下载连接中断，数据不完整: 仅接收 ${(cur / 1024 / 1024).toFixed(1)}MB / 期望 ${(total / 1024 / 1024).toFixed(1)}MB`));
            return;
          }
          console.log('\n[aep-releases] ✓ 下载完成且完整性核对无误!');
          cb(null);
        });
      });
    }).on('error', (err) => {
      fs.unlink(dest, () => {});
      cb(err);
    });
  };

  request(url);
}

download(downloadUrl, targetPath, (err) => {
  if (err) {
    console.error(`[aep-releases] ❌ 下载出错:`, err.message);
    process.exit(1);
  }

  if (!isWin) {
    try {
      fs.chmodSync(targetPath, 0o755);
      console.log(`[aep-releases] ✓ 已赋予可执行权限 (+x)`);
    } catch (e) {
      console.warn(`[aep-releases] 警告: 赋予权限失败:`, e.message);
    }
  }

  console.log(`[aep-releases] 🎉 AEP 智能体执行体安装成功，开箱即用！`);
});
