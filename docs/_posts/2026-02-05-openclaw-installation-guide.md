---
title: OpenClaw 安裝流程
date: 2026-02-05 10:00:00 +0800
categories: [部署指南, 安裝教學]
tags: [openclaw, linode, nodejs, systemd, chrome, playwright]
pin: true
toc: true
---

## 費用分析

在開始安裝之前，以下是相關服務的費用參考：

| 項目 | 規格 | 費用 | 週期 |
|------|------|------|------|
| Linode 主機 | 1 CPU / 2 GB RAM | $12 USD | 月繳 |
| Linode 主機 | 2 CPU / 4 GB RAM | $24 USD | 月繳 |
| GitHub Copilot Pro | - | $100 USD | 年繳 |
| Google AI Pro | 優惠價 | NT$3,250 | 年繳 |
| Google AI Pro | 原價 | NT$7,800 | 年繳 |

> 初學者可先使用 1C2G 方案，若效能不足再升級。
{: .prompt-tip }

---

## 基本安裝步驟

### 1. 架設 Linode 主機

前往 [Linode](https://www.linode.com/) 建立一台 Linux 主機。

### 2. SSH 連線到主機

```bash
ssh root@YOUR_SERVER_IP
```

### 3. 安裝必要套件

```bash
apt update && apt install curl -y
```

### 4. 安裝 NVM（Node Version Manager）

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
```

### 5. 重新載入環境設定

```bash
source ~/.bashrc
```

### 6. 確認 NVM 安裝

```bash
nvm -v
```

### 7. 安裝 Node.js LTS 版本

```bash
nvm install --lts
```

### 8. 確認 Node.js 版本

```bash
node -v
```

### 9. 安裝 Git

```bash
apt update && apt install git -y
```

### 10. 安裝 Gemini CLI（選用）

```bash
npm install -g @google/gemini-cli
```

### 11. 安裝 OpenClaw

```bash
npm i -g openclaw@latest
```

### 12. 執行 OpenClaw 初始化

```bash
openclaw onboard --install-daemon
```

---

## 選用：設定 Systemd 服務

如果需要將 OpenClaw Gateway 設定為系統服務，請執行以下步驟：

### 13. 建立 systemd 使用者目錄

```bash
mkdir -p ~/.config/systemd/user
```

### 14. 建立服務設定檔

```bash
nano ~/.config/systemd/user/openclaw-gateway.service
```

### 15. 服務設定檔內容

確認檔案包含以下內容：

```ini
[Unit]
Description=OpenClaw Gateway (profile: <profile>, v<version>)
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/openclaw gateway --port 18789
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
```
{: file="~/.config/systemd/user/openclaw-gateway.service" }

### 16. 重新載入 systemd 設定

```bash
systemctl --user daemon-reload
```

### 17. 啟用並啟動服務

```bash
systemctl --user enable --now openclaw-gateway.service
```

### 18. 查看服務狀態

```bash
systemctl --user status openclaw-gateway.service
```

---

## Chrome 安裝

如果需要使用瀏覽器功能，請安裝 Google Chrome：

### 19. 下載 Chrome 安裝檔

```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
```

### 20. 安裝 Chrome

```bash
sudo dpkg -i google-chrome-stable_current_amd64.deb
```

### 21. 修復相依套件

```bash
sudo apt -f install -y
```

### 22. 確認 Chrome 版本

```bash
google-chrome-stable --version
```

---

## Playwright 安裝

安裝 Playwright 及其相依套件：

### 23. 安裝系統相依套件（方法一）

```bash
apt install -y libnss3 libatk-bridge2.0-0 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libasound2
```

> 如果上述指令失敗，請改用方法二。
{: .prompt-warning }

### 24. 安裝系統相依套件（方法二）

適用於較新版本系統：

```bash
apt install -y libnss3 libatk-bridge2.0-0t64 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libasound2t64
```

### 25. 安裝 Playwright

```bash
npm install -g playwright
```

### 26. 安裝 Chromium 及相依套件

```bash
npx playwright install --with-deps chromium
```

### 27. 確認 Playwright 版本

```bash
npx playwright --version
```

---

## 瀏覽器設定

### 28. 編輯 OpenClaw 設定檔

編輯 `~/.openclaw/openclaw.json`，加入以下瀏覽器設定：

```json
{
  "browser": {
    "enabled": true,
    "executablePath": "/usr/bin/google-chrome-stable",
    "headless": true,
    "noSandbox": true
  }
}
```
{: file="~/.openclaw/openclaw.json" }

> 設定完成後，重新啟動 OpenClaw Gateway 服務即可生效。
{: .prompt-info }
