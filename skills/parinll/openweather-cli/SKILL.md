---
name: openweathermap-cli
description: Use this skill when the user wants to run, troubleshoot, or extend the owget CLI for geocoding, current weather, and 5-day forecasts with OpenWeatherMap.
homepage: https://github.com/ParinLL/OpenWeatherMap-script
metadata: {"openclaw":{"homepage":"https://github.com/ParinLL/OpenWeatherMap-script","requires":{"env":["OPENWEATHER_API_KEY"],"binaries":["go"]},"primaryEnv":"OPENWEATHER_API_KEY"}}
---

# OpenWeatherMap CLI Skill

純說明型技能文件：用於 `owget`（OpenWeatherMap CLI）之使用與故障排查。

## Skill 用途與觸發情境

- 使用者想查詢天氣、預報或地理編碼（`geo`）時。
- 使用者詢問 `owget` 指令怎麼執行、參數怎麼下時。
- 使用者遇到 API key、HTTP 錯誤或城市查詢失敗時。

## 安裝指令（或 GitHub 連結到安裝章節）

- GitHub：https://github.com/ParinLL/OpenWeatherMap-script

安裝（建議）：

```bash
git clone git@github.com:ParinLL/OpenWeatherMap-script.git
cd OpenWeatherMap-script
go install .
```

系統層安裝（選用，需要 `sudo`）：

```bash
CGO_ENABLED=0 go build -ldflags="-s -w" -o owget .
sudo install owget /usr/local/bin/
```

## 必要環境變數 / 權限

必要環境變數：

```bash
export OPENWEATHER_API_KEY="your-api-key"
```

- 需要 `go` 工具鏈（用於 build/install）。
- 若使用 `sudo install ... /usr/local/bin/`，需具備系統管理權限。
- 請勿在輸出中暴露完整 API key；debug request log 應遮罩憑證參數（例如 `appid`）。

## 常見錯誤排查

- `error: OPENWEATHER_API_KEY env is required`
  - 尚未設定環境變數，先 `export OPENWEATHER_API_KEY="..."`。
- API 回傳 `401`
  - API key 無效、過期或輸入錯誤，請重新確認 OpenWeatherMap 金鑰。
- API 回傳 `404` 或查不到城市
  - 城市格式改用 `City,Country`，例如 `Taipei,TW`；先用 `owget geo "<query>"` 驗證。
- 啟動 debug 時擔心憑證外洩
  - 目前 debug request URL 已遮罩敏感參數；仍建議避免在共享日誌環境長期開啟 debug。
