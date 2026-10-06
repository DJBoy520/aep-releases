---
name: aep-evidence
description: AEP 存证与验真工作流——为 AI 产出打不可篡改时间烙印。创建项目、登记产物、存证（含 TSA 时间戳与区块链锚定）、七阶段验真、检查包内容。当用户要求"存证/取证/时间戳/上链锚定/验证证据包"时使用。
---

# AEP 存证与验真工作流

## 铁律
1. **验签必须用 AEP 工具本身**（MCP `aep_verify_evidence` 或 CLI `aep validate`）——七阶段验证包含容器安全、图连通性、Merkle 树、签名、等级计算，手写脚本必然遗漏。
2. **存证必须显式指定 project**；工具无默认项目，省略会报错。
3. 存储模式默认 `hash_only`（只存哈希不泄露原文）；`plaintext` 需项目支持。
4. 一切配置走 `~/.aep/config.json`（logging 段控制审计日志），不要设置环境变量。

## 标准存证流程（MCP 优先）
1. `aep_project_create(slug="...")` — 创建项目（slug 仅小写字母/数字/连字符）
2. `aep_artifact_add(project="...", path="...")` — 登记产物
3. `aep_request_evidence(project="...", ...)` — 触发证据收集
4. `aep_request_cert` — （可选）在线申请身份证书（匿名轨免费站点或 token 站点）
5. `aep_export_evidence(project="...", ...)` — 导出 .aep 包
6. 时间戳/上链：CLI `aep notarize <path> --project <slug> --tsa --chain` 或
   `aep attest timestamp|chain <file.aep>`（对已有包补注）
7. 验真：MCP `aep_verify_evidence` 或 CLI `aep validate <file.aep> --json`

## CLI 速查
```bash
aep notarize <目录或文件> --project <slug> --verify --json   # L2 存证+自验
aep notarize <path> --project <slug> --tsa --chain --json    # L3/L4 带时间戳与链锚定
aep validate <file.aep> --json                               # 七阶段验真（读 state 字段）
aep inspect <file.aep> --json                                # 查看包内容
aep doctor                                                   # 环境体检
```

## 结果判读
- `validate --json` 的权威字段是 **state**（valid / inconclusive / invalid）与 **level**；
  state=invalid 时 level 为 null（包不可信，不亮级别牌）。
- TSA/链锚定失败不会破坏已完成的低阶凭证；断锚后可用 `aep attest chain <pkg>` 补锚。
