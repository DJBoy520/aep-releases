# v2.2.0 Release 清单（待老板一键完成）

代码、版本号、安装器逻辑、Linux 二进制均已就绪。**唯一缺一步**：在 GitHub 网页上创建
Release 对象并挂附件（本机无 GitHub API token，无法代发）。

## 步骤（2 分钟）
1. 打开 https://github.com/DJBoy520/aep-releases/releases/new
2. Tag: 选择已推送的 `v2.2.0`
3. Title: `AEP v2.2.0（审计日志版本）`
4. 附件上传（二选一或都传）：
   - 本机 `aep-releases/bin/aep-linux-x64.tar.gz`（43MB，install-binary.js 默认下载名）
   - `aep-releases/bin/aep-linux-x64`（裸二进制）
5. Windows exe：到 https://github.com/DJBoy520/aep-refimpl/actions 手动运行
   **build-windows-exe** 工作流（workflow_dispatch），产物自动挂到 Actions Artifacts，
   下载后可作为 Release 附件补传（或直接分发）。
6. OpenCloud 插件：openclaw.plugin.json 已升 2.2.0；插件市场重新打包发布即可
   （插件只含引导器，二进制走 install-binary.js 自动下载）。

## 验证（发布后）
```bash
cd some-tmp && npm init -y >/dev/null && npm i /home/dj/WorkSpaces/AEP/aep-releases
./bin/aep version --json   # 期望 2.2.0
```

## 本机可执行流出铁律（2026-10-07 定，所有后续版本沿用）

- 构建产物先落暂存区 `bin/`（无版本名 `aep` / `aep-linux-x64` 是 install-binary.js /
  index.js / pack-plugin.sh 的固定契约，禁止改名）。
- 再晋升到本机唯一权威执行点 `~/WorkSpaces/AEP/bin/`：
  `scripts/promote.sh <版本>`（校验自版本 → 复制为 `aep-<版本>` → 原子切 symlink → 自检
  → **自动清理历史版本，运行时只留最新**）。
- 旧版本一律不上本机，归档在 GitHub Release；回滚 = 取回旧版产物后
  `promote.sh <版本> <产物路径>` 重新晋升。
- 全局目录（`~/.local/bin`、`/usr/local/bin` 等）不落任何 AEP 文件；
  PATH 只挂 `$HOME/WorkSpaces/AEP/bin`。规则详见 `~/WorkSpaces/AEP/bin/README.md`。

## 发布资产铁律（2026-10-07 老板指定，所有后续版本沿用）

- **只发两个压缩包**：`aep-windows-x64.zip` + `aep-linux-x64.tar.gz`（恰好是
  install-binary.js 的固定下载契约名，安装器零改动）。裸二进制（aep.exe /
  aep-linux-x64）与 Windows 安装器（setup.exe）不再作为 Release 附件。
- **每个附件必须算 SHA-256 + SM3 双摘要**，写入 Release 说明正文
  （SM3：`openssl dgst -sm3 <文件>`；SHA-256：`sha256sum <文件>`）。
- 摘要只进 Release body，不作为额外附件（附件总数恒为 2）。
- **Release 说明只写相对上一版的变化**（新增/修复/变更三段式 changelog）；
  不写亮点、不写测试用例数量、不写版本字样、不写尚不存在的平台（如 macOS）；
  name 字段留空只显示 tag。
