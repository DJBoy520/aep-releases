# AEP Releases

> **AI Agent Native Digital Evidence Infrastructure**  
> An immutable digital evidence and integrity verification infrastructure designed for AI Agents and developers.

[English](https://github.com/DJBoy520/aep-releases#readme) | [中文说明](https://github.com/DJBoy520/aep-releases/blob/main/README.zh-CN.md)

---

AEP (Attestation & Evidence Exchange Protocol) provides a lightweight, efficient digital evidence format specification, standalone native runtimes, and MCP tool adapters for major AI assistant ecosystems (OpenClaw, Claude Desktop, Cursor, Hermes, etc.).

---

## ✨ Key Features

- 🧩 **Agent Native**: Built-in native support for the Model Context Protocol (MCP) and OpenClaw plugin contracts. AI agents can notarize and verify artifacts directly within conversation loops.
- ⚡ **Zero Dependency**: Distributed as standalone single-file binaries with zero Node.js, Python, or dynamic library dependencies. Ready to run out of the box.
- 🖥️ **Windows Native**: High-performance Windows x64 portable binary and wizard setup installer.
- 🐧 **Linux Native**: Pure static single-file ELF executable for Linux x64 distributions.
- 🔐 **Verifiable Evidence**: Comprehensive audit coverage spanning content digest trees, entity hierarchies, digital signatures, authoritative TSA timestamps, and blockchain anchors.
- 🌐 **Cloud Infrastructure**: Seamless zero-configuration connection to official public trust endpoints (CA, TSA, Chain), complemented by unified IAM developer management.

---

## 🏛️ System Architecture

```text
                       AEP Ecosystem Layer
                               │
            ┌──────────────────┴──────────────────┐
            │                                     │
      Human Developers                        AI Agents
            │                                     │
       CLI Commands                    MCP Protocol / OpenClaw Plugin
            │                                     │
            └──────────────────┬──────────────────┘
                               │
                     AEP Core Runtime Engine
                    (aep.exe / aep-linux-x64)
                               │
            ┌──────────────────┼──────────────────┐
            ▼                  ▼                  ▼
     CA Identity Cert    TSA Trusted Time    AEP-Chain Anchoring
     (ca.aep.org.cn)     (tsa.aep.org.cn)     (chain.aep.org.cn)
            │                  │                  │
            └──────────────────┼──────────────────┘
                               ▼
               Verifiable Evidence Container (.aep)
```

---

## 🌐 Public Trust Infrastructure

AEP is backed by three standardized official public trust infrastructures, connected by default:

1. **`ca.aep.org.cn` (AEP-PKI Certification Authority)**  
   Provides cryptographic public key verification and identity endorsement to establish trusted digital identities.
2. **`tsa.aep.org.cn` (AEP-TSA Trusted Timestamp Authority)**  
   Issues high-precision, tamper-proof timestamp tokens verifying that a given cryptographic digest existed at a specific point in time.
3. **`chain.aep.org.cn` (AEP-Chain Distributed Evidence Anchor)**  
   An immutable ledger anchoring evidence package digests and Merkle roots to provide global, independent verification points.

### 🔑 IAM Developer Access & Token Portal (`iam.aep.org.cn`)
Visit [https://iam.aep.org.cn](https://iam.aep.org.cn) to register a developer account:
- Obtain dedicated **API Keys / Tokens**;
- Access higher rate-limit quotas, audit dashboards, and enterprise SLA support;
- When unconfigured, the client automatically defaults to public anonymous channels.

---

## 🚀 Quick Start: Initialization

Before first use via CLI or AI Agent, initialize the local secure keystore and configuration:

### Interactive Setup
```bash
# Linux
./aep init

# Windows
.\aep.exe init
```

### Automated / Silent Setup (Recommended for CI/CD & AI Agents)
```bash
./aep init --non-interactive --write-secret
```
*Creates the base configuration and initial credentials under the data directory (default `~/.aep`), writing secure tokens automatically.*

---

## 🤖 AI Agent Ecosystem Integration

### 1. OpenClaw Plugin (Adaptive Lightweight Install)
The AEP plugin automatically detects the host OS at install time (Linux downloads only Linux binaries, Windows downloads only Windows binaries). The plugin package is only ~15 KB:

```bash
openclaw plugins install github:DJBoy520/aep-releases
openclaw plugins reload
```

#### Available Agent Tools
| Tool Name | Parameters | Description |
| :--- | :--- | :--- |
| `aep_notarize` | `targetPath`, `project`, `useTsa`, `useChain` | Packages files/directories into an immutable `.aep` evidence container, appends TSA timestamps, and anchors to the blockchain. |
| `aep_verify` | `packagePath` | Runs a complete multi-stage cryptographic integrity audit and diagnostic report on an `.aep` container. |

#### Agent Prompt Examples
> "Please notarize the current source code directory with AEP, attach a trusted timestamp, and anchor it on-chain."  
> "Audit and verify the digital evidence package at `./evidence.aep`."

---

### 2. Claude Desktop / Cursor (Standard MCP Mode)
Add the server entry to your MCP configuration file:

#### Windows Configuration
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

#### Linux Configuration
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

## 💻 CLI Commands

### 1. Verify Installation
```bash
# Linux
./aep --version
./aep --help

# Windows
.\aep.exe --version
.\aep.exe --help
```

### 2. Notarize Artifacts
```bash
# Single file
aep notarize contract.pdf --tsa --chain

# Project directory
aep notarize ./my-project --tsa --chain

# AI-generated deliverables
aep notarize ./dist-output --tsa --chain
```

### 3. Verify Evidence
```bash
aep validate ./my-project.aep
```

---

## 🖥️ Platform Support & Artifacts

| Platform / Architecture | Artifact Name | Format | Status & Usage |
| :--- | :--- | :---: | :--- |
| **Windows x64** | `aep.exe` | Portable Binary | ✅ **Tested & Supported**. Portable execution for CLI & MCP. |
| **Windows x64** | `aep-windows-x64-setup.exe` | Setup Installer | ✅ **Tested & Supported**. Automatic PATH setup for desktop users. |
| **Linux x64 (Ubuntu/Debian)** | `aep-linux-x64` | Standalone Binary | ✅ **Tested & Supported**. Pure static ELF binary (`chmod +x`). |
| **macOS (Apple Silicon M-Series)** | `aep-darwin-arm64` | Standalone Binary | ⏳ *In Progress* (Cross-compilation & Code Signing). |
| **macOS (Intel x64)** | `aep-darwin-x64` | Standalone Binary | ⏳ *In Progress*. |
| **Linux (ARM64 / Raspberry Pi)** | `aep-linux-arm64` | Standalone Binary | ⏳ *In Progress*. |

---

## 🔎 Binary Verification (Release Integrity)

Official multi-platform binaries and SHA256 checksums are hosted on GitHub:  
👉 [GitHub Official Releases](https://github.com/DJBoy520/aep-releases/releases/latest)

Verify binary integrity after download:

#### Linux:
```bash
sha256sum aep-linux-x64
```

#### Windows PowerShell:
```powershell
Get-FileHash .\aep.exe -Algorithm SHA256
```
