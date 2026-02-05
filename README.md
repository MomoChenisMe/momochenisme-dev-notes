# OpenClaw 部署文件

使用 Jekyll + Chirpy 主題建置的文件站。

**線上網址**：https://MomoChenisMe.github.io/momochenisme-dev-notes/

---

## 本地開發環境

### 方法一：使用 Ruby

```bash
# 安裝 Ruby 3.x 後執行
cd docs
bundle install
bundle exec jekyll serve
```

### 方法二：使用 Docker

```bash
cd docs
docker run --rm -it -p 4000:4000 -v "$(pwd):/srv/jekyll" \
  jekyll/jekyll:4.2.2 \
  bash -c "bundle install && bundle exec jekyll serve --host 0.0.0.0"
```

啟動後訪問：`http://localhost:4000/momochenisme-dev-notes/`

---

## 文章管理

### 新增文章

在 `docs/_posts/` 建立檔案，**檔名必須為英文**：

```
YYYY-MM-DD-article-name.md
```

例如：`2026-02-05-openclaw-installation-guide.md`

### Front Matter 範本

每篇文章開頭必須包含：

```yaml
---
title: 文章標題（可用中文）
date: 2026-02-05 10:00:00 +0800
categories: [主分類, 子分類]
tags: [標籤1, 標籤2, 標籤3]
pin: false      # true 則置頂於首頁
toc: true       # 顯示文章目錄
---
```

### 編輯現有文章

直接編輯 `docs/_posts/` 下的 `.md` 檔案即可。

### 刪除文章

刪除對應的 `.md` 檔案。

---

## Chirpy 主題語法

### 提示區塊

```markdown
> 提示內容
{: .prompt-tip }

> 資訊內容
{: .prompt-info }

> 警告內容
{: .prompt-warning }

> 危險內容
{: .prompt-danger }
```

顯示效果：
- `.prompt-tip` - 綠色提示框
- `.prompt-info` - 藍色資訊框
- `.prompt-warning` - 黃色警告框
- `.prompt-danger` - 紅色危險框

### 程式碼區塊標示檔名

````markdown
```json
{
  "key": "value"
}
```
{: file="~/.config/example.json" }
````

程式碼區塊上方會顯示檔案路徑。

### 圖片

```markdown
![說明文字](/assets/img/example.png)
```

圖片放在 `docs/assets/img/` 目錄下。

---

## 頁面管理

### 導覽頁面

位於 `docs/_tabs/`：

| 檔案 | 用途 |
|------|------|
| `about.md` | 關於頁面 |
| `archives.md` | 文章歸檔 |
| `categories.md` | 分類列表 |
| `tags.md` | 標籤列表 |

### 修改網站設定

編輯 `docs/_config.yml`：

```yaml
title: 網站標題
tagline: 網站副標題
description: 網站描述
lang: zh-TW
timezone: Asia/Taipei
theme_mode: ""   # 留空=用戶切換, light=淺色, dark=深色
```

---

## 部署

### 自動部署

Push 到 `main` 分支後，GitHub Actions 會自動建置並部署。

### 首次設定 GitHub Pages

1. 進入 GitHub 專案 → **Settings** → **Pages**
2. Source 選擇 **GitHub Actions**
3. 儲存後 Push 即可觸發部署

### 手動觸發部署

1. 進入 GitHub 專案 → **Actions**
2. 選擇 **Build and Deploy**
3. 點擊 **Run workflow**

---

## 目錄結構

```
docs/
├── _config.yml        # 網站設定
├── Gemfile            # Ruby 依賴
├── index.html         # 首頁
├── _posts/            # 文章目錄（主要編輯區）
├── _tabs/             # 導覽頁面
├── _data/locales/     # 語系檔
└── assets/img/        # 圖片資源
```
