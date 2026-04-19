# DogeShield Maps CDN

刀盾代碼（DogeShield）遊戲地圖資源託管 repo。純靜態檔，部署到 Zeabur 即可。

## 檔案結構

```
.
├── index.html              # Zeabur 首頁（說明頁）
├── version.json            # 全域版本戳
├── regions/
│   ├── index.json          # 區域總清單（所有 region metadata 摘要）
│   ├── taipei.json         # 台北區詳細資料
│   ├── taipei_map.png      # 台北背景圖（1024×1024 tileable）
│   ├── tainan.json
│   ├── tainan_map.png
│   ├── hualien.json
│   └── hualien_map.png
└── README.md
```

## Zeabur 部署步驟

### 0. 前置：把這個目錄 push 到你的 GitHub

```bash
cd ~/dogshield-maps
git init
git add -A
git commit -m "initial: taipei/tainan/hualien regions"
# 在 GitHub 建一個 new repo（建議 public），然後：
git remote add origin git@github.com:<你的帳號>/dogshield-maps.git
git branch -M main
git push -u origin main
```

### 1. Zeabur 新建專案

1. 登入 https://zeabur.com
2. 點右上 **Create Project**（命名可叫 `dogshield-maps`）
3. 選區域：建議 `Hong Kong` 或 `Tokyo`（台灣玩家延遲最低）

### 2. 接 GitHub repo

1. 專案內點 **Add Service** → **Git Service**
2. 授權 Zeabur 存取你的 GitHub
3. 選剛才 push 的 `dogshield-maps` repo
4. Branch 選 `main`

### 3. 讓 Zeabur 識別為靜態站

Zeabur 會自動偵測到 `index.html` → 當成 Static Site 部署。  
若它要求選 template：選 **Static**。

無須 build command，直接 serve repo 根目錄即可。

### 4. 取得網址

部署完成後 Zeabur 會分配 `xxxxxx.zeabur.app` 網址。  
點 **Networking** 頁確認或設自訂網域。

### 5. 驗證

打開瀏覽器：
- `https://<你的網址>.zeabur.app/` → 應顯示 README 首頁
- `https://<你的網址>.zeabur.app/regions/index.json` → 應 JSON 回應
- `https://<你的網址>.zeabur.app/regions/taipei_map.png` → 應顯示背景圖

### 6. 告訴遊戲端這個網址

把網址傳給 Claude，我會更新 `~/game/scripts/RemoteAssetManager.gd` 的 `BASE_URL`。

## 未來加新區

1. 用工具產一張 tileable PNG（1024×1024 建議）
2. 丟到 `regions/<新區>_map.png`
3. 寫 `regions/<新區>.json`
4. 編輯 `regions/index.json` 加一筆
5. 編輯 `version.json` 升版本號（玩家才知道要重抓）
6. `git commit && git push`
7. Zeabur 自動部署，10 分鐘內所有玩家看到新區

## 版本控制策略

- **全域版本**（`version.json` 的 `global_version`）：整批素材的時間戳
- **個別區域版本**（`taipei.json` 的 `version`）：該區改了就升
- Client 啟動時撈 `version.json`，與本地快取比對，只重抓版本不同的區

## 為什麼選 Zeabur

- ✅ Static site 免費額度充足
- ✅ 香港/東京節點，台灣玩家 < 50ms
- ✅ git push 自動部署（CI/CD 0 配置）
- ✅ HTTPS 自動、可綁自訂網域
- ✅ 帶 CDN（Cloudflare in front）

## CORS

Zeabur 預設允許同源 + `*` 跨域。Godot HTTPRequest 不受 CORS 限制（不是瀏覽器），不會有問題。
