# AEP Releases

> **面向 AI 智能体与开发者的数字证据与可验证完整性存证基础设施。**  
> *AI Agent Native Digital Evidence & Integrity Infrastructure.*

---

AEP (AI Evidence Protocol) 提供了一套轻量高效的数字证据格式规范、单文件原生运行时（Native Runtime）以及面向各大主流 AI 助手生态（OpenClaw、Claude Desktop、Cursor、Hermes 等）的 Agent 工具与 MCP 接入层。  
*AEP (AI Evidence Protocol) provides a lightweight, tamper-evident digital evidence format specification, standalone native runtimes, and Agent tool/MCP adapters for major AI assistant ecosystems (OpenClaw, Claude Desktop, Cursor, Hermes, etc.).*

---

## ✨ 核心特性 / Key Features

- 🧩 **原生智能体接入 (Agent Native Adapter)**  
  提供原生 OpenClaw 插件契约与 MCP 协议支持，AI 智能体在对话决策循环中可直接唤醒存证与验真工具。  
  *Provides native OpenClaw plugin contracts and Model Context Protocol (MCP) support, enabling AI agents to invoke notarization and verification tools directly within conversational loops.*

- ⚡ **原生单文件运行时 (Standalone Native Runtime)**  
  AEP 核心运行时采用独立单文件二进制交付，不依赖 Python、Node.js 或额外运行时环境；OpenClaw 插件仅作为 Agent 接入层调用该 Runtime。  
  *The AEP core runtime is distributed as a standalone binary without Python, Node.js, or dynamic runtime dependencies. The OpenClaw plugin acts as the Agent integration layer and invokes the native runtime.*

- 🖥️ **Windows 原生支持 (Windows Native)**  
  提供 Windows x64 独立绿色版与向导式安装包，全面兼容控制台与桌面环境。  
  *High-performance Windows x64 portable binary and wizard setup installer for both console and desktop usage.*

- 🐧 **Linux 原生支持 (Linux Native)**  
  提供 Linux x64 纯静态 ELF 单文件程序，赋予执行权限后直接使用。  
  *Pure static single-file ELF executable for Linux x64 distributions, ready to run after `chmod +x`.*

- 🔐 **可验证完整性证明 (Verifiable Integrity & Attestation)**  
  覆盖文件内容哈希树、实体拓扑结构、数字签名、TSA 可信时间戳及链上锚定证明。  
  *Comprehensive audit coverage spanning content digest trees, entity hierarchies, digital signatures, authoritative TSA timestamps, and blockchain anchors.*

- 🌐 **公共信任基础设施协同 (Public Trust Infrastructure)**  
  原生对接 AEP 官方三大公共信任基础设施（CA / TSA / Chain），并支持 IAM 统一开发者管理。  
  *Seamless zero-configuration connection to official public trust endpoints (CA, TSA, Chain), complemented by unified IAM developer identity management.*

---

## 🏛️ 体系架构 / System Architecture

```text
                        AEP 生态层 (Ecosystem Layer)
                                     │
            ┌────────────────────────┴────────────────────────┐
            │                                                 │
     人类开发者 (Human)                                 AI 智能体 (AI Agent)
            │                                                 │
        CLI 命令行                                 OpenClaw Plugin / MCP Server
            │                                                 │
            └────────────────────────┬────────────────────────┘
                                     ▼
                         AEP 核心运行时 (Native Runtime)
                             (aep.exe / aep-linux-x64)
                                     │
            ┌────────────────────────┼────────────────────────┐
            │                        │                        │
       证据包生成与验真          公共信任服务 (Trust)      分布式存证锚定 (Anchor)
      (Evidence Package)             │                        │
            │                        ├── CA 权威认证           └── AEP-Chain 存证锚定
            ▼                        └── TSA 可信时间戳
     .aep 存证容器文件                                         │
            │                                                  ▼
            └──────────────────────────────────────── 可验证完整性证据 (Verifiable Evidence)
```

---

## 🛡️ 安全与信任边界 / Security & Trust Boundary

AEP 遵循最小权限与职责分离原则，明确划分 Agent 接入层与底层密码学运行时的信任边界：  
*AEP enforces least privilege and separation of concerns, delineating trust boundaries between the Agent layer and native cryptographic runtime:*

```text
       AI Agent / LLM
             │
             │ [MCP / Tool Call] (严格受限的参数校验与安全模式)
             ▼
   AEP OpenClaw Plugin / MCP Adapter
             │
             │ [Local Subprocess / stdio IPC] (本地进程隔离通信)
             ▼
      AEP Native Runtime
      ├── 本地证据仓库 (Local Repo DB - 沙箱受限路径)
      ├── 本地密钥与签名 (Local Signing / Keystore - 内存隔离置零)
      ├── 可信时间戳客户端 (TSA Client - 仅发送哈希摘要，数据不出域)
      └── 存证锚定客户端 (Chain Anchor Client - 认证凭据通信)
```

- 🔑 **私钥隔离**：AI Agent 仅发起存证意图，不直接接触、导出或持久化本地私钥。  
  *AI Agents never inspect, export, or handle raw cryptographic private keys directly.*
- 🛡️ **数据隐私**：TSA 与 Chain 锚定仅提交密码学哈希摘要，原始业务文件与代码不出本地。  
  *Only cryptographic digests are submitted to TSA and Chain endpoints—raw payloads stay strictly local.*
- 🚧 **路径沙箱**：插件在调用 CLI/Runtime 前对所有输入路径执行绝对路径与沙箱范围校验，严防路径穿越。  
  *The plugin validates all input targets against strict path boundaries to prevent directory traversal attacks.*

---

## 🌐 官方公共信任基础设施 / Public Trust Infrastructure

AEP 生态已部署三大官方标准化公共信任基础设施，客户端默认已完成无感对接：  
*AEP is backed by three standardized official public trust infrastructures, connected by default:*

1. 🏛️ **`ca.aep.org.cn` (AEP-PKI 权威认证中心 / Certification Authority)**  
   提供基于密码学机制的公钥证书核验与身份签名背书，确立存证主体的可信数字身份。  
   *Provides cryptographic public key verification and identity endorsement to establish trusted digital identities.*

2. ⏱️ **`tsa.aep.org.cn` (AEP-TSA 可信时间戳服务 / Trusted Timestamp Authority)**  
   提供高精度、可验证的可信时间凭证签发，证明特定数据摘要在特定历史时刻确实存在且未被改动。  
   *Issues high-precision, cryptographically verifiable trusted timestamp tokens verifying that a given digest existed at a specific time.*

3. ⛓️ **`chain.aep.org.cn` (AEP-Chain 分布式存证锚定服务 / Distributed Evidence Anchor)**  
   AEP 原生区块链存证锚定网络，将证据包摘要及状态根锚定至链上，提供独立于本地存储的全局可验证锚点。  
   *An immutable ledger anchoring evidence package digests and Merkle roots to provide global, independent verification points.*

### 🔑 IAM 开发者身份与服务接入 / IAM Developer Identity & Access (`iam.aep.org.cn`)
访问 [https://iam.aep.org.cn](https://iam.aep.org.cn) 注册开发者账号：  
*Visit [https://iam.aep.org.cn](https://iam.aep.org.cn) to register a developer account:*
- 注册开发者账号、管理 API Key / Token、服务权限、调用配额及服务权益；  
  *Register developer accounts, manage API Keys / Tokens, service permissions, and quotas;*
- 未配置 Token 时，客户端默认走公共直签与基础通道。  
  *When unconfigured, the client automatically defaults to public anonymous channels.*

---

## 🚀 快速上手：初始化 / Quick Start: Initialization

首次使用无论是命令行还是作为 AI 插件，建议先执行一次初始化，生成本地受控密钥库与基础配置：  
*Before first use via CLI or AI Agent, initialize the local secure keystore and configuration:*

### 交互式初始化 / Interactive Setup
```bash
# Linux
./aep init

# Windows
.\aep.exe init
```

### 自动化 / 静默初始化（推荐 CI/CD 与 Agent 脚本） / Automated Silent Setup
```bash
./aep init --non-interactive --write-secret
```
*该命令会自动在数据目录（默认 `~/.aep`）下创建主配置与初始身份凭据，并自动写入安全凭据。*  
*Creates base configuration and credentials under the data directory (default `~/.aep`), writing secure tokens automatically.*

---

## 🤖 AI 智能体生态接入 / AI Agent Integration

### 1. OpenClaw 原生插件接入 / OpenClaw Native Plugin
AEP 针对 OpenClaw 提供了 Native Plugin，安装时自适应仅下载当前操作系统的轻量二进制（插件外壳仅 ~15KB）：  
*AEP provides a native OpenClaw plugin that exposes AEP operations as Agent tools, while the underlying AEP Runtime remains an independent native binary. Downloads only the current OS binary:*

```bash
# 使用标准 Git 源形式安装 / Install via canonical Git URI
openclaw plugins install git:github.com/DJBoy520/aep-releases

# 安装完成后检查工具注册状态 / Inspect plugin runtime & tool registrations
openclaw plugins inspect aep-releases --runtime --json
```

#### 提供的 Agent Tools 工具契约 / Available Agent Tools
| Tool 工具名 | 参数 / Parameters | 功能说明 / Description |
| :--- | :--- | :--- |
| `aep_notarize` | `targetPath`<br>`projectId?`<br>`useTsa?`<br>`useChain?` | 将指定文件或代码目录归档为 `.aep` 证据容器，支持附加 TSA 可信时间戳及链上锚定。<br>*Packages files/directories into an `.aep` evidence container, with optional TSA timestamps and blockchain anchoring.* |
| `aep_verify` | `packagePath` | 验证 `.aep` 证据包的结构格式、证据哈希、Merkle 完整性、身份签名以及可用的 TSA/Chain 证明，并输出诊断报告。<br>*Performs comprehensive cryptographic integrity and attestation verification (structure, digests, Merkle tree, signatures, TSA/Chain proofs) and returns diagnostics.* |

#### Agent 对话交互示例 / Prompt Examples
> 💬 **中文示例**：“请对当前代码工程进行 AEP 存证公证，生成证据包并上链。”  
> 💬 *English Example*: "Please notarize the current source code directory with AEP, attach a trusted timestamp, and anchor it on-chain."  
> 💬 **中文示例**：“帮我验证一下 `./evidence.aep` 这个存证包的完整性、证书链与存证状态。”  
> 💬 *English Example*: "Verify the cryptographic integrity, certificate chain, and attestation status of `./evidence.aep`."

---

### 2. Claude Desktop / Cursor / 通用 MCP 接入 / Standard MCP Mode
AEP 内置原生 MCP Server，作为本地 stdio 进程运行，**无需额外部署 HTTP 服务或单独常驻守护进程**：  
*The AEP MCP Server runs as a local stdio process and does not require a separately deployed service or daemon:*

#### Windows 配置示例 / Windows Configuration (`claude_desktop_config.json`)
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

#### Linux 配置示例 / Linux Configuration (`claude_desktop_config.json`)
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

## 💻 命令行 CLI 常用指令 / CLI Commands

### 1. 验证客户端就绪 / Verify Installation
```bash
# Linux
./aep --version
./aep --help

# Windows
.\aep.exe --version
.\aep.exe --help
```

### 2. 存证公证 / Notarize Artifacts
```bash
# 单文件存证 / Single file
aep notarize contract.pdf --tsa --chain

# 项目目录存证 / Project directory
aep notarize ./my-project --tsa --chain

# AI 生成物及交付归档存证 / AI deliverables
aep notarize ./dist-output --tsa --chain
```

### 3. 证据验真 / Validate Evidence
```bash
# 对生成的存证包执行完整性校验 / Run full verification pipeline
aep validate ./my-project.aep
```

---

## 🖥️ 平台支持与制品形态 / Platform Support & Artifacts

| 平台架构 / Platform | 制品文件名 / Artifact | 形态 / Format | 适用场景与说明 / Status & Usage |
| :--- | :--- | :---: | :--- |
| **Windows x64** | `aep.exe` | 绿色免安装版 / Portable Binary | ✅ **已测试，正式支持**。CLI、MCP 调用、便携运行。<br>*✅ Tested & Supported. Portable execution for CLI & MCP.* |
| **Windows x64** | `aep-windows-x64-setup.exe` | 系统安装包 / Setup Installer | ✅ **已测试，正式支持**。普通桌面用户，自动配置 PATH 环境变量。<br>*✅ Tested & Supported. Automatic PATH setup for desktop users.* |
| **Linux x64 (Ubuntu/Debian)** | `aep-linux-x64` | 绿色免安装版 / Standalone Binary | ✅ **已测试，正式支持**。纯静态单文件，`chmod +x` 后直接运行。<br>*✅ Tested & Supported. Pure static ELF binary (`chmod +x`).* |
| **macOS (Apple Silicon M系列)** | `aep-darwin-arm64` | 单文件程序 / Standalone Binary | ⏳ *后续支持中*（适配 Apple Silicon 交叉编译与签名）。<br>*⏳ In Progress (Cross-compilation & Code Signing).* |
| **macOS (Intel x64)** | `aep-darwin-x64` | 单文件程序 / Standalone Binary | ⏳ *后续支持中*。<br>*⏳ In Progress.* |
| **Linux (ARM64 / 树莓派)** | `aep-linux-arm64` | 单文件程序 / Standalone Binary | ⏳ *后续支持中*。<br>*⏳ In Progress.* |

---

## 🔎 制品完整性校验 / Release Integrity

所有公开发布的二进制制品均提供 SHA-256 校验和以验证文件完整性：  
*Official releases provide SHA-256 checksums for binary integrity verification:*  
👉 [GitHub Official Releases 页面](https://github.com/DJBoy520/aep-releases/releases/latest)

在下载二进制后，建议校验其哈希完整性：  
*Verify binary integrity after download:*

#### Linux:
```bash
sha256sum aep-linux-x64
```

#### Windows PowerShell:
```powershell
Get-FileHash .\aep.exe -Algorithm SHA256
```
