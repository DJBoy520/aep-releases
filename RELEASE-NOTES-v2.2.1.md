## 相对上一版的变化

**新增**
- 验证报告全新呈现层：结论横幅（状态色标识 + 按实际通过项动态生成的结论句）、统计口径 KPI 网格（等宽数字 + 状态胶囊 + 章节锚点）、六项验证结果状态卡、左侧章节目录（状态标记 + 滚动高亮）
- 状态语义系统：通过 / 未通过 / 待确认 / 未包含四态各配图标、文字、前景色、底纹色与打印灰度形态；状态图标为内联 SVG，不再依赖 ● 等文本字形
- 报告工具：全局「显示完整值」开关、「打印 / 导出 PDF」按钮；深色模式跟随系统
- 证据文件浏览器：名称 / 大小 / 状态三列，目录级未通过计数，路径搜索与命中计数，窄屏下主从切换（点文件进详情、返回列表）
- 报告打印文档头：验证对象、证据包、验证时间、证据包指纹前 16 位
- `notarize` 新增 `--produced-by` / `--agent-model`：把产生来源（AI 助手名与模型）写入 manifest 并在报告首屏显示，未提供时显示「未记录」

**修复**
- 报告存为 PDF 时身份证书链、技术验证详情、未通过原因等折叠内容丢失；现打印前自动展开全部折叠区、打印后按原状还原，截断显示的哈希在打印件中还原为完整值
- 长哈希按任意字符断开、无法逐字段比对；现统一前 16…后 8 截断，点击可复制全文，并支持一处开关展开全局完整值
- CLI 输出经管道消费时超过 64KB 被截断（`validate --format json` 等下游 JSON 解析失败）；现退出前排空输出缓冲
- 国密与国际双时间戳此前只签发一条：`--cipher-suite` 未接线、幂等键未按套件分轨、国际套件需要带 `sha256:` 前缀的 messageImprint
- 国际时间戳包在线复核恒失败（`sha256:` 前缀规范化）
- 待确认状态下报告不得出现任何「通过」视觉暗示：状态色、徽章与图标严格跟随数据推导

**变更**
- 报告体积：同一份 172 文件证据包 350KB → 114KB；4588 文件样本 4.42MB → 648KB（内联数据改位置数组编码、路径只存储一次、关联事件与产生时间去重成索引表）
- 报告版式由灰阶线框文档改为卡片化产品报告：浅灰页面底 + 白色卡片面，正文行宽约束在 72ch 以内
- 报告无障碍：键值表语义化（`th scope="row"`）、图标与 aria 标注补齐、状态胶囊带读屏前缀、焦点可见性与小字号对比度提升
- 证据文件清单在打印时全量展开（此前只有一级目录），打印后恢复

## 附件（仅压缩包，解压即用）

| 文件 | 平台 | 大小 |
|---|---|---|
| `aep-windows-x64.zip` | Windows | 35.3 MB |
| `aep-linux-x64.tar.gz` | Linux | 42.5 MB |

## 完整性校验（SHA-256 / SM3 双摘要）

```
SHA-256: 87722179b4e1b4d4ad8a9df68f2e88b95fdff52bda1ce5e4c6d405e08f14a212  aep-windows-x64.zip
SM3:     06b50f8bbab54de8f23983e1d5a9cb02777147366cd2d53991f7f1dd30cd69ca  aep-windows-x64.zip

SHA-256: 0fda7be1435d4312dfc0db138b671e654a2d691b7971ff71ecd8ca9a8dd1f73e  aep-linux-x64.tar.gz
SM3:     916eede110b6850ab85e06d46c5e1da5f3f6ce24501a5a0653587ad706eea12c  aep-linux-x64.tar.gz
```

> SM3 校验：`openssl dgst -sm3 <文件>`；SHA-256 校验：`sha256sum <文件>`

## 使用

Linux：
```bash
curl -LO https://github.com/DJBoy520/aep-releases/releases/latest/download/aep-linux-x64.tar.gz
tar xzf aep-linux-x64.tar.gz && ./aep version
```

Windows：下载 `aep-windows-x64.zip` 解压，运行其中的 `aep.exe`。

MCP 挂载（AI 助手通用）：
```json
{ "command": "<aep 可执行文件路径>", "args": ["mcp"] }
```

插件方式安装（OpenClaw）：
```bash
openclaw plugins install github:DJBoy520/aep-releases
```
