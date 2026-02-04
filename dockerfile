FROM ghcr.io/openclaw/openclaw:latest

# 切換到 root 安裝額外工具
USER root

# 避免安裝過程中的互動式提示
ENV DEBIAN_FRONTEND=noninteractive

# ==================== 持久化目錄設定 ====================
# 掛載 Volume 到 /home/node 以持久化所有資料：
#   - /home/node/.openclaw     : OpenClaw 配置與工作區
#   - /home/node/.gemini       : Gemini CLI 認證與設定
#   - /home/node/.config/gh    : GitHub CLI 認證與設定
#
# 使用方式 (docker-compose 或 docker run):
#   docker run -v openclaw-data:/home/node -p 18789:18789 your-image
#
# 或在 Zeabur 中設定 Volume 掛載到 /home/node

# 安裝額外系統工具
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    sudo \
    ca-certificates \
    gnupg \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# ==================== GitHub CLI ====================
# 參考: https://github.com/cli/cli
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# ==================== Gemini CLI ====================
# 參考: https://github.com/google-gemini/gemini-cli
RUN npm install -g @google/gemini-cli

# ==================== 環境變數設定 ====================
# 在 Zeabur 或 docker run 時設定這些環境變數

# 時區設定（建議設定）
ENV TZ="Asia/Taipei"

# GitHub Token（用於 GitHub CLI 認證）
ENV GH_TOKEN=""

# Telegram Bot Token（用於 OpenClaw 連接 Telegram）
ENV TELEGRAM_BOT_TOKEN=""

# Gemini API Key（免登入使用 Gemini CLI）
ENV GEMINI_API_KEY=""

# ==================== OpenClaw 設定 ====================
ENV OPENCLAW_GATEWAY_PORT="18789"
ENV OPENCLAW_BRIDGE_PORT="18790"
ENV OPENCLAW_GATEWAY_BIND="lan"
ENV OPENCLAW_GATEWAY_TOKEN=""

# Gemini CLI 設定
ENV GEMINI_HOME="/home/node/.gemini"

# 設定工作目錄
WORKDIR /home/node

# 切回 node 使用者（官方映像預設）
USER node

# 宣告持久化 Volume
VOLUME ["/home/node"]

# 暴露端口
# - 8080: Zeabur 預設端口
# - 18789: OpenClaw Gateway
# - 18790: OpenClaw Bridge
EXPOSE 8080 18789 18790

# 啟動指令（自動啟動 OpenClaw Gateway）
CMD ["openclaw", "gateway", "start"]
