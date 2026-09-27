# AEP Releases (Official Distribution Hub)

AEP（Attestation & Evidence Exchange Protocol）官方全平台可执行程序发布与分发中心。

提供面向 **Windows**、**Linux**、**macOS** 的原生可执行程序、绿色免安装版、系统安装器，以及各类 AI 智能体生态（OpenClaw、Claude Desktop、Cursor、Hermes Agent 等）的挂载集成入口。

---

## 一、 可执行程序发布矩阵与版本说明

各平台制品均在 GitHub 官方 [Releases 页面](../../releases) 统一挂载下载：

| 平台 / 架构 | 发布产物名称 | 版本形态 | 环境依赖与运行说明 |
| :--- | :--- | :--- | :--- |
| **Windows x64** | `aep-windows-x64.exe` | **绿色免安装版**（单文件） | **开箱即用**：零依赖，双击或命令行直接运行，无需安装 Node.js 或系统运行库。 |
| **Windows x64** | `aep-setup-x64.exe` *(规划中)* | **安装版**（向导式安装包） | 适合普通桌面用户：自动配置 PATH 环境变量、创建桌面及右键快捷存证菜单。 |
| **Linux x64** | `aep-linux-x64` | **绿色免安装版**（ELF 二进制） | **开箱即用**：赋予 `chmod +x` 即可直接运行，纯静态/单文件分发，无额外环境依赖。 |
| **Linux (deb/rpm)** | `aep_amd64.deb` / `.rpm` *(规划中)* | **系统包安装版** | 适合服务器与生产环境：支持 `apt install` / `dnf install` 统一纳管。 |
| **macOS (Apple Silicon / Intel)** | `aep-darwin-arm64` / `x64` *(规划中)* | **绿色免安装版** | macOS 终端直接执行，纯二进制，首次需允许安全访问。 |

> 💡 **版本类型说明**：
> - **绿色免安装版（Portable / Standalone）**：所有密码学算法、运行时及核心逻辑全部内嵌于单个独立可执行文件中，下载即可直接使用，删除即卸载，不留系统垃圾，适合开发者与命令行用户。
> - **系统安装版（Installer / Setup）**：提供图形化安装向导，支持自动检测运行环境、自动写注册表/配置全局环境变量，便于桌面开箱直接使用。

---

## 二、 命令行（CLI）快速上手

下载对应的绿色免安装版二进制文件后，即可直接在终端运行：

```bash
# 1. 对本地文件或代码目录执行一键存证（自动附加国密 TSA 时间戳与链上存证）
aep notarize ./my-project --tsa --chain

# 2. 对已生成的 .aep 存证包执行六阶深度验真
aep verify ./my-project.aep
```

---

## 三、 AI 助手与 MCP 插件集成

本中心发布的所有可执行程序均原生内建 **MCP（Model Context Protocol）** 接口协议，可作为 AI 智能体的后端执行体：

### 1. OpenClaw 生态集成
- **随包打包一键安装**：
  ```bash
  openclaw plugins install ./aep-plugin-1.0.0.tgz
  openclaw plugins reload
  ```
- **本地链接模式**：
  ```bash
  openclaw plugins install /path/to/aep-releases --link
  ```

### 2. Claude Desktop / Cursor（标准 MCP 模式）
在客户端配置的 `mcpServers` 中指向下载的绿色版程序即可：
```json
{
  "mcpServers": {
    "aep": {
      "command": "C:\\path\\to\\aep-windows-x64.exe",
      "args": ["mcp"]
    }
  }
}
```

---

## 四、 安全与隐私保证

1. **核心逻辑黑盒化保护**：发布的所有程序均为编译打包后的独立二进制文件，无需也不包含源代码文件。
2. **私钥本地自治**：所有国密哈希计算均在用户本地计算机完成，存证签名私钥严密保存在本地受控区域，不向外部网络泄露任何敏感数据。
