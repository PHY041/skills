# 安全性与数据隐私说明

## 概述

Baidu Yijian Vision 是一个**客户端工具**，用于与百度一见视觉分析平台交互。本文档说明数据流、安全考虑事项和最佳实践。

## 数据流

```
用户图像/视频
     ↓
[本地脚本处理]
     ↓
[转换为 Base64]
     ↓
[通过 HTTPS 发送]
     ↓
https://yijian-next.cloud.baidu.com
     ↓
[远程处理和分析]
     ↓
[返回检测结果 JSON]
     ↓
[本地保存/可视化]
```

## 远程端点

### 主 API 服务

**基础端点：** `https://yijian-next.cloud.baidu.com`

**协议：** HTTPS（加密传输）

**认证：** Bearer Token（YIJIAN_API_KEY）

### 所有 API Endpoints 模板

所有脚本调用的网络 endpoints（其中 `{epId}` 为具体的技能ID）：

| 脚本 | 方法 | Endpoint 模板 | 说明 |
|------|------|--------------|------|
| `invoke.mjs` | POST | `https://yijian-next.cloud.baidu.com/api/skills/v1/{epId}/run` | 执行技能（主要操作） |
| `register.mjs` | GET | `https://yijian-next.cloud.baidu.com/api/skills/v1/{epId}/metadata` | 获取技能元数据 |
| `list.mjs` | — | 无网络调用 | 仅读取本地 preset-skills.json |
| `update.mjs` | — | 无网络调用 | 仅修改本地 skill.json |
| `delete.mjs` | — | 无网络调用 | 仅删除本地配置 |

**实际调用的 Endpoints 只有两个**：
1. `GET /api/skills/v1/{epId}/metadata` - 获取技能定义和参数（register.mjs 使用）
2. `POST /api/skills/v1/{epId}/run` - 执行技能（invoke.mjs 使用）

**示例 URL**（带实际 epId）：
```
GET  https://yijian-next.cloud.baidu.com/api/skills/v1/ep-public-k8wsrv3c/metadata
POST https://yijian-next.cloud.baidu.com/api/skills/v1/ep-public-k8wsrv3c/run
```

所有 epId 都以 `ep-` 前缀开始，后跟随机字符串。无其他端点或重定向。

### 数据传输

**发送的数据：**
1. **图像：** Base64 编码的图像数据
2. **元数据：** 源 ID、时间戳、帧标识符（用于视频处理）
3. **ROI/绊线：** 用户定义的几何数据（多边形点、检测线）

**返回的数据：**
1. **检测结果：** 边框、置信度、分类、跟踪 ID
2. **属性：** 年龄、性别、表情等推理结果
3. **OCR：** 识别的文本内容

## API Key 管理

### 安全最佳实践

✅ **正确做法：**
```bash
# 临时设置（仅当前 shell 会话有效）
export YIJIAN_API_KEY="your-api-key"

# 然后运行工具
node scripts/invoke.mjs ep-public-k8wsrv3c

# 在生产环境中，使用密钥管理服务（如 Kubernetes secrets）
```

❌ **错误做法：**
```bash
# 不要硬编码到代码中
YIJIAN_API_KEY="xxx" node scripts/invoke.mjs

# 不要添加到 shell 配置文件（会永久存储密钥）
echo 'export YIJIAN_API_KEY="your-api-key"' >> ~/.bashrc

# 不要提交到版本控制
git add .env  # ❌ 会暴露 API Key
```

### API Key 轮换

定期轮换 API Key：
1. 在一见平台生成新 Key
2. 更新环境变量
3. 删除旧 Key

## 脚本审计

**所有网络请求均通过 `scripts/utils.mjs` 中的 `httpsRequest` 函数发出，URL 集中定义在该文件的 `metadataUrl()` 和 `runUrl()` 两个函数中，指向唯一域名 `yijian-next.cloud.baidu.com`。**

### 各脚本网络行为

| 脚本 | 网络调用 | Endpoint |
|------|---------|---------|
| `invoke.mjs` | ✅ 有 | `POST /api/skills/v1/{epId}/run` |
| `register.mjs` | ✅ 有 | `GET /api/skills/v1/{epId}/metadata` |
| `list.mjs` | ❌ 无 | 仅读取本地 `preset-skills.json` 和本地 skill 配置 |
| `update.mjs` | ❌ 无 | 仅修改本地 skill 配置文件 |
| `delete.mjs` | ❌ 无 | 仅删除本地 skill 配置文件 |
| `migrate.mjs` | ❌ 无 | 仅操作本地文件 |
| `visualize.mjs` | ❌ 无 | 仅读写本地图像文件 |
| `show-grid.mjs` | ❌ 无 | 仅读写本地图像文件 |
| `skill-writer.mjs` | ❌ 无 | 仅操作本地 skill 配置文件 |

网络调用脚本均通过 `utils.mjs` 中相同的 `httpsRequest` 封装，携带 `Authorization: Bearer $YIJIAN_API_KEY` 头，无其他远程端点。

## 合规性

- **HTTPS：** 所有网络通信使用 TLS 1.2+
- **数据加密：** 传输中加密，遵循行业标准
- **API 认证：** Bearer Token 认证
- **无本地日志：** 脚本不记录敏感数据

## 相关文档

- [安装指南](./INSTALL.md) - 系统要求和安装步骤
- [SKILL.md](./SKILL.md) - 使用指南
- [类型定义](./types-guide.md) - 数据结构
