# AEP Releases

> **AI Agent Native Digital Evidence Infrastructure**  
> 面向 AI 智能体与开发者的数字证据与不可篡改存证基础设施。

[中文说明](README.zh-CN.md) | [English](README.md)

---

AEP（Attestation & Evidence Exchange Protocol）提供了一套轻量高效的数字证据格式规范、单文件原生运行时（Runtime）以及面向各大主流 AI 助手生态（OpenClaw、Claude Desktop、Cursor、Hermes 等）的 MCP 工具接入层。

---

## ✨ 核心特性

- 🧩 **Agent Native**：原生内建 MCP 协议与 OpenClaw 插件契约，AI 助手在对话中即可直接唤醒存证与验真。
- ⚡ **Zero Dependency**：独立单文件二进制交付，无 Node.js、Python 或第三方运行时依赖，开箱即用。
- 🖥️ **Windows Native**：提供 Windows x64 独立绿色版与向导安装包。
- 🐧 **Linux Native**：提供 Linux x64 纯静态 ELF 单文件程序。
- 🔐 **Verifiable Evidence**：覆盖文件哈希指纹、实体结构、数字签名、TSA 可信时间戳及链上锚定。
- 🌐 **Cloud Infrastructure**：原生对接 AEP 官方三大核心存证基础设施（CA / TSA / Chain），并支持 IAM 统一接入。

---

## 🏛️ 体系架构 (Architecture)

```text
                     AEP 生态层
                         │
          ┌──────────────┴──────────────┐
          │                             │
     人类开发者 (Human)            AI 智能体 (AI Agent)
          │                             │
      CLI 命令行                     MCP 协议 / OpenClaw Plugin
          │                             │
          └──────────────┬──────────────┘
                         │
                  AEP 核心运行时 (Runtime)
              (aep.exe / aep-linux-x64)
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
     CA 身份证书    TSA 可信时间戳    AEP-Chain 存证锚定
   (ca.aep.org.cn) (tsa.aep.org.cn) (chain.aep.org.cn)
          │              │              │
          └──────────────┼──────────────┘
                         ▼
             可验证数字证据链 (.aep 容器)
```

---

## 🌐 官方公共存证基础设施 (Infrastructure)

AEP 生态已部署三大官方标准化公共存证基础设施，客户端默认已完成无感对接：

1. **`ca.aep.org.cn` (AEP-PKI 权威认证中心)**  
   提供基于密码学机制的公钥证书核验与身份签名背书，确立存证主体的可信数字身份。
2. **`tsa.aep.org.cn` (AEP-TSA 可信时间戳服务)**  
   提供高精度、不可逆的时间凭证签发，证明特定数据指纹在特定历史时刻确实存在且未被改动。
3. **`chain.aep.org.cn` (AEP-Chain 分布式存证锚定服务)**  
   AEP 原生区块链存证锚定网络，将证据包摘要及状态根不可篡改地锚定至链上，提供独立于本地存储的全局可验证锚点。

### 🔑 IAM 开发者接入与高级服务 (`iam.aep.org.cn`)
访问 [https://iam.aep.org.cn](https://iam.aep.org.cn) 注册开发者账号：
- 获取专属 **API Key / Token**；
- 享有专属配额、高频存证调用、存证状态审计面板及高级 SLA 保障；
- 未配置 Token 时，客户端默认走公共直签与基础通道。

---

## 🚀 快速上手：初始化 (Initialization)

首次使用无论是命令行还是作为 AI 插件，建议先执行一次初始化，生成本地受控密钥库与基础配置：

### 交互式初始化
```bash
# Linux
./aep init

# Windows
.\aep.exe init
```

### 自动化 / 非交互式静默初始化（推荐 CI/CD 或 Agent 脚本）
```bash
./aep init --non-interactive --write-secret
```
*该命令会自动在数据目录（默认 `~/.aep`）下创建主配置与初始身份凭据，并自动写入安全凭据。*

---

## 🤖 AI 智能体生态接入 (AI Agent Integration)

### 1. OpenClaw 生态一键安装
AEP 插件支持自适应按需加载（Ubuntu 下仅下载 Linux 执行体，Windows 下仅下载 Win 执行体，插件包本体仅 15KB）：

```bash
openclaw plugins install github:DJBoy520/aep-releases
openclaw plugins reload
```

#### 提供的 Agent Tools
| Tool 工具名 | 参数 | 功能说明 |
| :--- | :--- | :--- |
| `aep_notarize` | `targetPath`, `project`, `useTsa`, `useChain` | 对指定文件或代码目录生成数字证据包（.aep），附加时间戳并锚定上链 |
| `aep_verify` | `packagePath` | 对已生成的 .aep 存证包执行底层七阶深度完整性验证并输出诊断报告 |

#### Agent 对话交互示例
> “请对当前代码工程进行 AEP 存证公证，生成证据包并上链。”  
> “帮我验证一下 `./evidence.aep` 这个存证包的签名和链上状态。”

---

### 2. Claude Desktop / Cursor 接入 (标准 MCP 模式)
在对应客户端的 MCP Server 配置段中加入如下内容即可：

#### Windows 配置示例
```json
{
  "mcpServers": {
    "aep": {
      "command": "C:\\tools\\aep.exe",
      "args": ["mcp"]
    }
  }
}
```

#### Linux 配置示例
```json
{
  "mcpServers": {
    "aep": {
      "command": "/usr/local/bin/aep",
      "args": ["mcp"]
    }
  }
}
```

---

## 💻 命令行 CLI 常用指令

### 1. 验证客户端就绪
```bash
# Linux
./aep --version
./aep --help

# Windows
.\aep.exe --version
.\aep.exe --help
```

### 2. 存证公证 (Notarize)
```bash
# 单文件存证
aep notarize contract.pdf --tsa --chain

# 项目目录存证
aep notarize ./my-project --tsa --chain

# AI 生成物及交付归档存证
aep notarize ./dist-output --tsa --chain
```

### 3. 证据验真 (Validate)
```bash
# 对生成的存证包执行完整性校验
aep validate ./my-project.aep
```

---

## 🖥️ 平台支持与制品形态

| 平台 / 系统架构 | 制品文件名 | 形态 | 适用场景与说明 |
| :--- | :--- | :---: | :--- |
| **Windows x64** | `aep.exe` | 绿色免安装版 | **已测试，正式支持**。CLI、MCP 调用、便携运行。 |
| **Windows x64** | `aep-windows-x64-setup.exe` | 系统安装包 | **已测试，正式支持**。普通桌面用户，自动配置 PATH 环境变量。 |
| **Linux x64 (Ubuntu/Debian等)** | `aep-linux-x64` | 绿色免安装版 | **已测试，正式支持**。纯静态单文件，`chmod +x` 后直接运行。 |
| **macOS (Apple Silicon M系列)** | `aep-darwin-arm64` | 单文件程序 | ⏳ *后续支持中*（适配 Apple Silicon 交叉编译与签名）。 |
| **macOS (Intel x64)** | `aep-darwin-x64` | 单文件程序 | ⏳ *后续支持中*。 |
| **Linux (ARM64 / 树莓派)** | `aep-linux-arm64` | 单文件程序 | ⏳ *后续支持中*。 |

---

## 🔎 制品完整性校验 (Release Integrity)

最新全平台编译制品与 SHA256 校验清单统一发布于：  
👉 [GitHub Official Releases 页面](https://github.com/DJBoy520/aep-releases/releases/latest)

在下载二进制后，建议校验其哈希完整性：

#### Linux:
```bash
sha256sum aep-linux-x64
```

#### Windows PowerShell:
```powershell
Get-FileHash .\aep.exe -Algorithm SHA256
```
