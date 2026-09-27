# AEP Releases (Official Distribution Hub)

AEP（Attestation & Evidence Exchange Protocol）官方全平台原生可执行程序与智能体插件发布中心。

---

## 一、 AEP 解决了什么问题？

在 AI 与数字化创作时代，代码、设计资产、业务合同与关键文档的生成极易面临：
1. **真实性与防伪难题**：如何证明一份文件在某个特定历史时间点真实存在且内容未被篡改？
2. **AI 生成物版权与归属纠纷**：AI 助手生成的代码与内容，缺乏权威时间与多方存证背书，容易陷入知识产权扯皮。
3. **传统存证流程割裂复杂**：传统司法与公证流程门槛高、成本大，市面工具往往依赖复杂网络环境与笨重的环境配置。

### AEP 核心破局方案
AEP 是一套轻量高效的**证据交换与不可篡改存证协议**：
- **六阶深度验真体系**：层层核验文件指纹、实体元数据、国密数字签名与链上锚定，实现全链条自证清白。
- **双轨时间戳（TSA）与区块链存证（AEP-Chain）**：一键生成符合国家密码标准（GM/T）的不可逆时间烙印。
- **开箱即用单文件交付**：将完整的密码学算法、执行引擎与校验机制压制成独立二进制程序，**0 安装依赖，无需环境配置**。
- **AI 智能体无缝集成**：原生内建 MCP 协议与 OpenClaw 插件契约，让 AI 助手一句话即可完成作品固证与验真。

---

## 二、 平台与系统兼容现状

| 平台 / 操作系统 | 架构 | 当前支持状态 | 说明 |
| :--- | :--- | :---: | :--- |
| **Windows 10 / 11 / Server** | x64 (AMD64) | ✅ **已测试，正式支持** | 提供绿色免安装版（`aep.exe`）与向导安装包（`aep-windows-x64-setup.exe`）。 |
| **Ubuntu / Debian / CentOS** | x64 (AMD64) | ✅ **已测试，正式支持** | 提供纯静态独立单文件 ELF 二进制（`aep-linux-x64`），赋予权限即可直接运行。 |
| **macOS (Apple Silicon M系列)** | arm64 (aarch64) | ⏳ *后续支持中* | 正在完成 Apple Silicon 交叉编译与代码签名适配，敬请期待。 |
| **macOS (Intel)** | x64 | ⏳ *后续支持中* | 正在构建适配，敬请期待。 |
| **Linux (ARM64 / 树莓派)** | arm64 | ⏳ *后续支持中* | 适配 ARM64 边缘与服务器架构。 |

> 📌 **最新制品下载入口**：请访问 GitHub [Releases 官方页面](https://github.com/DJBoy520/aep-releases/releases/tag/v2.1.7) 获取已发布的最新二进制与安装包。

---

## 三、 怎么使用？

### 方式 1：终端命令行（CLI）开箱即用

下载对应平台的独立二进制文件后即可直接使用：

#### 1. Linux / Ubuntu
```bash
# 1. 下载可执行文件并赋予权限
curl -sL -o aep https://github.com/DJBoy520/aep-releases/releases/download/v2.1.7/aep-linux-x64
chmod +x aep

# 2. 一键对文件或目录存证（自动附加权威国密 TSA 时间戳与存证链公证）
./aep notarize ./my-project --tsa --chain

# 3. 对已生成的 .aep 存证包执行六阶深度验真
./aep validate ./my-project.aep
```

#### 2. Windows 命令行 / PowerShell
```powershell
# 1. 下载 aep.exe 放置到任意工作目录
# 2. 一键执行存证
.\aep.exe notarize C:\path\to\my-project --tsa --chain

# 3. 验证存证包完整性与时间戳
.\aep.exe validate C:\path\to\my-project.aep
```

---

### 方式 2：在 OpenClaw 中作为智能体插件使用

AEP Releases 原生支持 OpenClaw 插件契约。插件具备**自适应按需下载能力**：
- 在 Ubuntu 上安装时，**仅自动拉取 Linux 执行体**；
- 在 Windows 上安装时，**仅自动拉取 Windows 执行体**；
- 插件包本体仅十几 KB，秒级完成安装与配置。

#### 一键安装命令：
```bash
openclaw plugins install github:DJBoy520/aep-releases
openclaw plugins reload
```

#### 在对话中直接唤醒：
安装完成后，您可以在 OpenClaw 对话中直接对 AI 下达指令：
> “请对当前代码工程进行 AEP 存证公证，打上时间戳并上链。”  
> “帮我深度校验一下 `/data/project.aep` 这个存证包是否被篡改过。”

---

### 方式 3：在 Claude Desktop / Cursor 中挂载（标准 MCP 模式）

本中心发布的所有可执行程序均原生内建 **MCP（Model Context Protocol）** 接口协议。

在客户端的 MCP 配置文件（如 `claude_desktop_config.json` 或 `cursor_mcp.json`）中添加如下配置即可：

#### Windows 配置示例：
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

#### Linux 配置示例：
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

## 四、 安全与隐私保证

1. **核心逻辑黑盒化保护**：发布的所有程序均为编译打包后的独立二进制文件，无需也不包含源代码文件。
2. **私钥本地自治**：所有国密哈希计算均在用户本地计算机完成，存证签名私钥严密保存在本地受控区域，不向外部网络泄露任何敏感数据。
3. **纯净无依赖**：无需安装 Node.js、Python 或任何第三方密码学动态库，不写系统冗余残留。
