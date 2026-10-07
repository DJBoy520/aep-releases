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
cd some-tmp && npm init -y >/dev/null && npm i /home/dj/WorkSpaces/openclaw/aep-releases
./bin/aep version --json   # 期望 2.2.0
```
