# Keep Available / 保持活跃

一款轻量级的 macOS 应用，帮助你在 **Microsoft Teams、Slack、钉钉、飞书、企业微信、Zoom、Discord、Google Chat、Webex** 等协作工具中始终保持 **在线 / 活跃 / 可用** 状态，防止因键盘鼠标无操作而被标记为 **离开 / 空闲 / 离线**。

[English Documentation](README.md)

## 为什么需要它

协作工具通常会在几分钟无操作后将你的状态设为 **离开 / 空闲 / 离线**。Keep Available 会按设定的间隔自动模拟 Caps Lock 按键，让你的系统保持活跃状态，从而阻止这些应用进入空闲 — 完全不影响你的实际工作。

与物理鼠标抖动器或硬件适配器不同，Keep Available 是纯软件方案、完全免费，且不会改变 Caps Lock 的实际开关状态（它会快速双击以还原）。

## 功能特性

- **模拟 Caps Lock 按键**，间隔可配置（10 秒至 3600 秒）
- **双击还原** — 快速连续按下两次 Caps Lock，实际开关状态保持不变
- **定时自动停止** — 设置每天自动停止的时间（如下班时间）
- **实时倒计时** — 显示距离下次触发和自动停止的剩余时间
- **辅助功能权限检测**，一键跳转系统设置
- **中英文双语支持**
- **原生 macOS SwiftUI 界面** — 非 Electron，轻量无臃肿

## 系统要求

- macOS 26.5 或更高版本
- 辅助功能权限（用于通过 `CGEvent` 发送键盘事件）

## 安装

### 直接下载（推荐）

从 [Releases](https://github.com/lemoncha/KeepAvailable/releases) 页面下载最新版本，将 `KeepAvailable.app` 拖入 `应用程序` 文件夹。

### 从源码构建

```bash
git clone https://github.com/lemoncha/KeepAvailable.git
cd KeepAvailable
DEVELOPER_DIR=/Applications/Xcode.app xcodebuild -project KeepAvailable.xcodeproj -scheme KeepAvailable -destination 'platform=macOS' build
```

## 使用方法

1. 启动 **Keep Available**
2. 根据提示授予 **辅助功能权限**（系统设置 → 隐私与安全性 → 辅助功能）
3. 配置 **触发间隔**（Caps Lock 模拟频率，默认 100 秒）
4. （可选）设置 **自动停止时间**（每天定时停止，如 18:00）
5. 点击 **开始**

应用在前台运行，最小化到 Dock 后依然继续工作。

### 工作原理

每个周期，应用会以 80 毫秒的间隔快速发布两组 Caps Lock 按下+释放事件：

1. 切换 Caps Lock（按下 + 释放）
2. 等待 80 毫秒
3. 再次切换 Caps Lock（按下 + 释放）

这使系统产生键盘事件 — 足以让协作应用认为你在活跃操作 — 同时 Caps Lock 恢复原始状态。停止时（手动或定时），应用会检查 Caps Lock 状态并在需要时关闭它。

## 适用场景

- 远程办公时保持 **Microsoft Teams** 状态为 **可用**（绿灯）
- 防止 **Slack** 显示 **离开** 状态
- 在 **钉钉、飞书、企业微信** 中保持在线
- 在 **Discord、Zoom、Google Chat、Webex** 中显示为活跃
- 演示时防止屏幕锁定或屏保启动
- 任何需要保持系统活跃不被标记为挂机的场景

## 隐私与安全

- **无网络请求** — Keep Available 永远不会连接互联网
- **无分析、无追踪、无遥测** — 你的活动数据不会离开你的设备
- **沙盒运行** — 以 macOS App Sandbox 模式运行，权限最小化
- **完全开源** — 详情见 [LICENSE](LICENSE)

## 开源协议

MIT License。详见 [LICENSE](LICENSE)。

---

远程办公者，值得一个永远的绿灯。
