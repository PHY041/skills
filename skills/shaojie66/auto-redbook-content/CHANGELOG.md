# Changelog

## [2.2.0] - 2026-03-15

### 🔒 Security & Simplification
- **移除自动调度功能**：不再包含 HEARTBEAT 定时任务
- **明确定位**：按需调用工具，非自动化服务
- **简化文档**：聚焦核心功能，移除复杂配置说明

### 📝 Documentation
- 重写 SKILL.md：突出"按需调用"特性
- 简化 README.md：快速开始指南
- 移除交付报告文件

### ✨ Features
- 核心功能不变：抓取→识别→改写→存储
- 可选飞书集成保留

---

## [2.1.1] - 2026-03-14

### 🔒 Security Refactor
- 移除硬编码敏感信息
- 使用 spawnSync 替代 execSync
- 环境变量管理优化

---

## [2.0.0] - Initial Release
- 小红书内容抓取
- 图片识别（Vision + OCR）
- AI 改写
- 本地 JSON 输出
