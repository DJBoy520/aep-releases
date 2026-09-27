import path from 'node:path';
import { fileURLToPath } from 'node:url';
import fs from 'node:fs';
import { spawn } from 'node:child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function resolveBinary() {
  const isWin = process.platform === 'win32';
  const binDir = path.join(__dirname, 'bin');

  const candidates = isWin
    ? [path.join(binDir, 'aep.exe'), path.join(binDir, 'aep-windows-x64.exe')]
    : [path.join(binDir, 'aep'), path.join(binDir, 'aep-linux-x64')];

  for (const p of candidates) {
    if (fs.existsSync(p)) {
      return p;
    }
  }

  throw new Error(
    `AEP Binary not found. Searched candidates: ${candidates.join(', ')}.\n` +
    `Please download the binary from https://github.com/DJBoy520/aep-releases/releases and place it in the bin/ directory.`
  );
}

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

const toolPluginMetadataSymbol = Symbol.for("openclaw.plugin-sdk.tool-plugin.metadata");

const tools = [
  {
    name: 'aep_notarize',
    label: 'AEP Notarize',
    description: '一键执行本地证据链上公证与TSA国密时间戳锚定，产出L4不可篡改存证包(.aep)',
    parameters: {
      type: 'object',
      properties: {
        targetPath: { type: 'string', description: '待存证的目标文件或目录绝对路径' },
        useTsa: { type: 'boolean', default: true, description: '是否追加TSA国密时间戳' },
        useChain: { type: 'boolean', default: true, description: '是否锚定至AEP存证链' }
      },
      required: ['targetPath']
    },
    async execute({ targetPath, useTsa = true, useChain = true }) {
      const args = ['notarize', targetPath];
      if (useTsa) args.push('--tsa');
      if (useChain) args.push('--chain');
      return await runAepCommand(args);
    }
  },
  {
    name: 'aep_verify',
    label: 'AEP Verify',
    description: '对.aep存证包执行六阶完整性深度验真并输出报告',
    parameters: {
      type: 'object',
      properties: {
        packagePath: { type: 'string', description: '待校验的.aep存证包绝对路径' }
      },
      required: ['packagePath']
    },
    async execute({ packagePath }) {
      const args = ['validate', packagePath];
      return await runAepCommand(args);
    }
  }
];

export const plugin = {
  id: 'aep-releases',
  name: 'AEP Evidence Notarization',
  description: 'AEP (Attestation & Evidence Exchange Protocol) Official Binary Plugin',
  version: '2.1.7',

  register(api) {
    if (!api) return;
    for (const tool of tools) {
      if (api.registerTool) {
        api.registerTool({
          name: tool.name,
          description: tool.description,
          parameters: tool.parameters,
          execute: tool.execute
        });
      }
    }
  }
};

plugin[toolPluginMetadataSymbol] = {
  id: 'aep-releases',
  name: 'AEP Evidence Notarization',
  description: 'AEP (Attestation & Evidence Exchange Protocol) Official Binary Plugin',
  activation: { onStartup: true },
  configSchema: { type: 'object', additionalProperties: false },
  tools: tools.map(t => ({
    name: t.name,
    label: t.label,
    description: t.description,
    parameters: t.parameters
  }))
};

export default plugin;
