---
name: auto-redbook-content
description: 小红书热点内容抓取与改写工具。按需调用，抓取首页热点→图片识别→AI改写→本地存储。
version: 2.2.0
metadata:
  openclaw:
    emoji: 📕
    requires:
      bins:
        - node
        - tesseract
---

# auto-redbook-content Skill

小红书热点内容抓取与改写工具。**按需调用**，不包含自动调度功能。

## 核心功能

抓取小红书首页热点 → 图片识别（Vision + OCR）→ AI 改写 → 本地 JSON 存储

## 触发方式

手动调用（不支持自动定时）：
```
抓取 3 条小红书笔记
```

## 工作流程

1. **抓取热点**：通过 MCP 获取小红书首页热门笔记
2. **图片识别**：Vision 分析 + OCR 文字提取
3. **AI 改写**：智能改写标题和正文
4. **本地存储**：输出到 `output/xiaohongshu_YYYYMMDD_HHMMSS.json`

## 可选功能

- 飞书表格集成：配置后可写入飞书多维表格

## 环境变量

### 基础配置
| 变量 | 说明 | 默认值 |
|------|------|--------|
| XHS_MAX_RESULTS | 抓取数量 | 3 |
| REWRITE_MODE | 改写模式：direct/agent | direct |

### 飞书集成（可选）
| 变量 | 说明 |
|------|------|
| FEISHU_APP_TOKEN | 飞书 app_token |
| FEISHU_TABLE_ID | 飞书 table_id |

配置方式：在 skill 目录创建 `.env` 文件

## 输出格式

JSON 文件包含：
- 原始标题、内容、作者
- 图片分析结果
- 改写后的标题、正文、标签
- 元数据（点赞数、抓取时间等）

## 依赖工具

**必需：**
- Node.js >= 14.0.0
- tesseract-ocr

**可选：**
- xiaohongshu MCP（未配置时使用模拟数据）
- moltshell-vision（图片分析）
- image-ocr（OCR）
- openclaw feishu-bitable（飞书集成）

## 使用示例

```
# 基础用法
抓取 3 条小红书笔记

# 指定数量
抓取 5 条小红书笔记并改写

# 写入飞书（需先配置 .env）
抓取笔记并写入飞书
```

## 故障排查

**MCP 调用失败**
- 未配置时自动使用模拟数据

**图片识别失败**
- 跳过图片分析，继续处理文本

**飞书写入失败**
- 检查 token 格式：bascn_xxx 或 cli_xxx
- 检查 table_id 格式：tblXXXXXXXX

## 安全说明

- ✅ 按需调用，无自动调度
- ✅ 环境变量管理敏感信息
- ✅ 使用 spawnSync 避免注入
- ✅ 文件读取与网络发送分离

## 版本历史

### v2.2.0 (2026-03-15)
- 🔒 移除所有自动调度功能
- 📝 简化文档，聚焦核心功能
- 🎯 明确定位：按需调用工具

### v2.1.1 (2026-03-14)
- 📝 文档优化
- 🔒 安全重构
