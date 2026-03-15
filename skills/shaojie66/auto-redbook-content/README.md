# auto-redbook-content

小红书热点内容抓取与改写工具。**按需调用**，抓取首页热点→图片识别→AI改写→本地存储。

## 快速开始

1. **安装依赖**
```bash
cd ~/.openclaw/skills/auto-redbook-content
npm install
```

2. **配置环境变量（可选）**
```bash
cp .env.example .env
# 编辑 .env 文件
```

3. **使用**
```
抓取 3 条小红书笔记
```

## 核心功能

- 抓取小红书首页热点
- 图片内容识别（Vision + OCR）
- AI 智能改写
- 本地 JSON 存储
- 可选：飞书表格集成

## 输出示例

```json
{
  "original_title": "原始标题",
  "original_content": "原始内容",
  "rewritten_title": "改写后标题",
  "rewritten_content": "改写后内容",
  "tags": ["标签1", "标签2"],
  "image_analysis": {
    "vision": "图片描述",
    "ocr": "提取的文字"
  },
  "metadata": {
    "author": "作者",
    "likes": 1234,
    "timestamp": "2026-03-15T15:00:00Z"
  }
}
```

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| XHS_MAX_RESULTS | 抓取数量 | 3 |
| REWRITE_MODE | 改写模式 | direct |
| FEISHU_APP_TOKEN | 飞书 token（可选） | - |
| FEISHU_TABLE_ID | 飞书 table_id（可选） | - |

## 依赖工具

**必需：**
- Node.js >= 14.0.0
- tesseract-ocr

**可选：**
- xiaohongshu MCP
- moltshell-vision
- image-ocr

## 安全特性

- ✅ 按需调用，无自动调度
- ✅ 环境变量管理敏感信息
- ✅ 防注入保护
- ✅ 文件与网络分离

## License

MIT
