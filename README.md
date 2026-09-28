# AEP — AI Agent 的数字存证与验证基础设施

**AI Agent Native Digital Evidence & Integrity Infrastructure**

> 让 AI Agent 生成的代码、文件和交付物，都可以被存证、验证和追溯。

AEP（AI Evidence Protocol）将文件或代码目录封装为 `.aep` 数字证据包，并提供：

- 🔐 内容哈希与 Merkle 完整性证明
- ✍️ 数字身份与数字签名
- ⏱️ TSA 可信时间戳（符合国密 GM/T 0033 与国际 RFC 3161 双轨标准）
- ⛓️ 链上存证锚定
- 🤖 OpenClaw 原生 Agent Tools
- 🔌 标准 MCP Server
- ⚡ 零环境依赖的单文件原生 Runtime

**一句话：AEP 就是 AI Agent 的“存证与验证工具箱”。**

---

## 🚀 快速开始

### 1. 安装插件

在 OpenClaw 中一键安装 AEP 插件：

```bash
openclaw plugins install git:github.com/DJBoy520/aep-releases
```

检查注册状态：

```bash
openclaw plugins inspect aep-releases --runtime --json
```

### 2. 直接对 Agent 下达指令

安装完成后，在会话中直接吩咐 Agent：

> **存证**：“请把当前项目进行 AEP 存证，并附加可信时间戳和链上锚定。”

> **验证**：“帮我验证 ./evidence.aep 的完整性，检查签名、时间戳和链上存证状态。”

Agent 会自动调度底层的 `aep_notarize` 与 `aep_verify` 完成闭环。

---

## 🧩 Agent Tools

| 工具名称 | 参数 | 说明 |
|---|---|---|
| `aep_notarize` | `targetPath` · `projectId?` · `useTsa?` · `useChain?` | 将文件或目录打包生成 `.aep` 证据包 |
| `aep_verify` | `packagePath` | 验证证据包结构、哈希、Merkle、签名以及 TSA / Chain 证明 |

```text
AI Agent / OpenClaw
        │
        │ Tool Call (aep_notarize / aep_verify)
        ▼
 AEP OpenClaw Plugin (Agent 接入层)
        │
        │ Local IPC
        ▼
 AEP Native Runtime (底层密码学与证明引擎)
        ├── .aep Evidence Package
        ├── Hash / Merkle Tree
        ├── Digital Signature
        ├── TSA (可信时间戳)
        └── Chain (链上锚定)
```

---

## ⚡ 为什么选择 AEP？

- **开箱即用，零依赖**：底层由独立原生单文件 Runtime 执行，不依赖 Node.js、Python 或 Java 环境。
- **私钥与数据隔离**：Agent 仅表达意图，不直接接触底层私钥；原始数据保留在本地，仅摘要上链/打戳。
- **不仅是哈希，而是完整证据图谱**：`.aep` 容器完整打包代码摘要、Merkle Root、签名证书、TSA 凭证及链上存证哈希。

---

## 🌐 信任基础设施

AEP 默认直通公共信任服务网络：

| 服务 | 地址 | 核心用途 |
|---|---|---|
| **AEP-PKI** | `ca.aep.org.cn` | 数字身份、证书签发与验签 |
| **AEP-TSA** | `tsa.aep.org.cn` | 符合国密（GM/T 0033）与国际标准（RFC 3161）的可信时间戳服务 |
| **AEP-Chain** | `chain.aep.org.cn` | 区块链存证与可验证锚定 |
| **Developer IAM** | `iam.aep.org.cn` | 开发者凭证、配额管理与权益通道 |

*注：未配置 IAM API Key 时，支持使用公开基础通道匿名直签。*

---

## 🔌 更多接入方式

### 1. 标准 MCP Server（支持 Claude / Cursor / Hermes）

```json
{
  "mcpServers": {
    "aep": {
      "command": "aep",
      "args": ["mcp"]
    }
  }
}
```

### 2. 独立 CLI 命令行

```bash
# 存证项目并上链+打时间戳
aep notarize ./my-project --tsa --chain

# 验证证据包
aep validate ./my-project.aep
```

---

## 🖥️ 平台支持

- **Windows x64**：`aep.exe`（便携版 / 安装包）
- **Linux x64**：`aep-linux-x64`（静态单文件）
- **macOS / ARM64**：即将推出

---

# English Summary

**AEP (AI Evidence Protocol)** is an AI-Agent-native digital evidence and integrity infrastructure.

It packages files, source code, and deliverables into verifiable `.aep` evidence containers with content digests, Merkle integrity proofs, digital signatures, trusted timestamps (compliant with GM/T 0033 & RFC 3161), and blockchain anchoring.

```bash
openclaw plugins install git:github.com/DJBoy520/aep-releases
```

**Simply ask your Agent:**
> "Notarize the current project with AEP, add a trusted timestamp, and anchor it on-chain."  
> "Verify the integrity and attestation status of ./evidence.aep."
