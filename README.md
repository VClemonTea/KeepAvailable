# Keep Available

A lightweight macOS app that keeps your status **online / available / active** in apps like **Microsoft Teams, Slack, Zoom, DingTalk, Lark, Discord, Google Chat, and Webex** — or any app that tracks keyboard/mouse activity to detect idle/away/AFK status.

[中文文档](README.zh-CN.md)

## Why

Collaboration tools often set your status to **Away / Idle / Offline** after a few minutes of inactivity. Keep Available simulates Caps Lock key presses at a configurable interval to keep your system active, preventing these apps from going idle — without interfering with your real work.

Unlike mouse jigglers or hardware dongles, Keep Available is purely software-based, free, and leaves no permanent Caps Lock state change (it double-toggles).

## Features

- **Simulates Caps Lock key presses** at a configurable interval (10s–3600s)
- **Double-toggle** — rapidly taps Caps Lock twice so the actual Caps Lock state never changes
- **Auto-stop timer** — schedule a daily stop time (e.g., end of your workday)
- **Real-time countdown** — shows seconds until the next toggle and auto-stop time
- **Accessibility permission** check with one-click system settings access
- **Localized** in English and Simplified Chinese
- **Minimal, native macOS UI** — built with SwiftUI, no Electron, no bloat

## Requirements

- macOS 26.5 or later
- Accessibility permission (required to post keyboard events via `CGEvent`)

## Installation

### Download (Recommended)

Download the latest release from the [Releases](https://github.com/bennettxxbb/KeepAvailable/releases) page. Drag `KeepAvailable.app` to your `Applications` folder.

### Build from Source

```bash
git clone https://github.com/bennettxxbb/KeepAvailable.git
cd KeepAvailable
DEVELOPER_DIR=/Applications/Xcode.app xcodebuild -project KeepAvailable.xcodeproj -scheme KeepAvailable -destination 'platform=macOS' build
```

## Usage

1. Launch **KeepAvailable**
2. Grant **Accessibility permission** when prompted (System Settings → Privacy & Security → Accessibility)
3. Configure the **interval** (how often Caps Lock is toggled, default: 100s)
4. Optionally set an **auto-stop time** (daily stop, e.g., 6:00 PM)
5. Click **Start**

The app runs in the foreground. Minimize it to the Dock — it keeps working.

### How it Works

Each cycle, the app posts two Caps Lock key-down+key-up pairs with an 80ms gap:

1. Toggle Caps Lock (press + release)
2. Wait 80ms
3. Toggle Caps Lock again (press + release)

This makes your system register a keyboard event — enough to keep apps from going idle — while leaving Caps Lock in its original state. On stop (manual or scheduled), the app checks if Caps Lock is on and turns it off if needed.

## Ideal For

- Keeping **Microsoft Teams** status **Available** (green) during work-from-home
- Preventing **Slack** from showing you as **Away**
- Staying **Online** in **Discord**, **Zoom**, **DingTalk**, **Lark**, **Google Chat**, **Webex**
- Preventing screen lock or screensaver during presentations
- Keeping any idle-tracking app from marking you AFK

## Privacy & Security

- **No network requests** — Keep Available never connects to the internet
- **No analytics, no tracking, no telemetry** — your activity data never leaves your device
- **Sandboxed** — runs in macOS App Sandbox with minimal privileges
- **Open source** — see the [LICENSE](LICENSE) for details

## License

MIT License. See [LICENSE](LICENSE).

---

Made with ♥ for remote workers who just want to stay green.
