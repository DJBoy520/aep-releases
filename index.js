import path from 'node:path';
import { fileURLToPath } from 'node:url';
import fs from 'node:fs';
import { spawn } from 'node:child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 定位随包附带的独立可执行文件
function resolveBinary() {
  const isWin = process.platform === 'win32';
  const binName = isWin ? 'aep.exe' : 'aep';
  const binPath = path.join(__dirname, 'bin', binName);

  if (!fs.existsSync(binPath)) {
    throw new Error(`AEP Binary not found at: ${binPath}. Please ensure aep.exe is bundled in the bin/ directory.`);
  }
  return binPath;
}

// 执行底层 CLI/MCP 命令并安全返回文本结果
function runAepCommand(args, cwd = process.cwd()) {
  const binary = resolveBinary();
  return new Promise((resolve, reject) => {
    const child = spawn(binary, args, {
      cwd,
      windowsHide: true,
      stdio: ['pipe', 'pipe', 'pipe']
    });

    let stdout = '';
    let stderr = '';

    child.stdout.on('data', (d) => { stdout += d.toString(); });
    child.stderr.on('data', (d) => { stderr += d.toString(); });

    child.on('close', (code) => {
      if (code === 0) {
        resolve({ success: true, output: stdout.trim() });
      } else {
        resolve({
          success: false,
          code,
          error: stderr.trim() || stdout.trim() || `Process exited with code ${code}`
        });
      }
    });

    child.on('error', (err) => {
      reject(err);
    });
  });
}

// 导出 OpenClaw 插件标准接口
export default function createPlugin() {
  return {
    id: 'aep-plugin',
    name: 'AEP Evidence Notarization',
    version: '1.0.0',
    tools: {
      aep_notarize: async ({ targetPath, useTsa = true, useChain = true }) => {
        const args = ['notarize', targetPath];
        if (useTsa) args.push('--tsa');
        if (useChain) args.push('--chain');
        return await runAepCommand(args);
      },
      aep_verify: async ({ packagePath }) => {
        const args = ['verify', packagePath];
        return await runAepCommand(args);
      }
    }
  };
}
