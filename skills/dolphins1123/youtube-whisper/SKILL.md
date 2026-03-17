---
name: youtube-whisper
description: Download YouTube videos and transcribe audio using local Whisper. Use when you need to extract text from YouTube videos that don't have subtitles, or when youtube-watcher fails due to missing captions.
version: 1.2.2
---

# YouTube Whisper / YouTube Whisper 語音轉文字

下載 YouTube 影片並使用本地 Whisper 進行語音轉文字。

## 硬體需求 / Hardware Requirements

| 項目 | 最低需求 | 建議需求 |
|------|----------|----------|
| 記憶體 | 4 GB | 8 GB+ |
| 儲存空間 | 1 GB | 5 GB+ |
| CPU | 任意 | Apple Silicon M 系列 |

## 測試環境 / Test Environment

| 項目 | 規格 |
|------|------|
| 主機 | Mac mini M4 |
| 記憶體 | 16 GB |
| 模型 | Whisper small |
| 影片時長 | 5:55 |
| 轉錄時間 | 約 3-5 分鐘 |

## When to Use / 使用時機

- YouTube 影片沒有字幕 / YouTube video has no subtitles
- youtube-watcher 因為沒有字幕而失敗 / youtube-watcher fails due to missing captions
- 需要離線轉錄 / Need offline transcription
- 高品質本地轉錄 (比 YouTube 自動字幕更好) / High-quality local transcription

## Usage / 使用方式

```bash
# 基本轉錄 / Basic transcription
youtube-whisper.sh "https://www.youtube.com/watch?v=VIDEO_ID"

# 指定輸出檔案 / Specify output filename
youtube-whisper.sh "URL" "output.txt"

# 指定模型 / Use specific Whisper model (tiny, base, small, medium, large)
# 預設語言: 繁體中文 / Default language: Traditional Chinese (zh)
youtube-whisper.sh "URL" "output.txt" "small"
```

## Requirements / 需求

- yt-dlp: `brew install yt-dlp`
- Whisper: `pip3 install openai-whisper` or use openai-whisper skill
- ffmpeg: `brew install ffmpeg`

## Output / 輸出

轉錄文字檔案 (Transcript text file).

## Notes / 備註

- 影片會下載到 /tmp 並在轉錄後刪除 / Videos are downloaded to /tmp and cleaned up after transcription
- 預設模型: small (速度與準確度的最佳平衡) / Default model: small
- 較大的模型 (medium, large) 較慢但更準確 / Larger models are slower but more accurate

## Author

Kuanlin
