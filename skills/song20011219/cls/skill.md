# OpenClaw CLS 日志采集 Skill

## 功能介绍

一键配置 OpenClaw 机器的日志采集，自动将本地日志上传到腾讯云 CLS（日志服务），返回实时仪表盘 URL。支持三大核心功能：

- **💰 成本治理** - Token 消耗、缓存命中率、成本趋势分析
- **📊 运维观测** - 系统性能监控、安全风险检测、错误日志分析  
- **💬 会话管理** - 对话交互记录、会话统计、Skill 使用排行

**适用场景**：运维监控、问题排查、性能分析、安全审计

## 使用方法

### 一键配置

运行以下命令在目标机器上完成日志采集配置：

```bash
curl -fsSL -o setup https://mirrors.tencent.com/install/cls/openclaw/setup && \
chmod +x setup && \
./setup \
  --AKID <YOUR_ACCESS_KEY_ID> \
  --secret-key <YOUR_SECRET_KEY> \
  --region <TARGET_REGION> && \
rm ./setup
```

### 参数说明

| 参数 | 必需 | 说明 | 示例 |
|------|------|------|------|
| `--AKID` | 是 | 腾讯云访问密钥 ID | `AKIDX4d4GEyYyA9xYyCbrw0taBYhcMvsfEbt` |
| `--secret-key` | 是 | 腾讯云访问密钥 | `d3dz70f5PZVJvMiqtjLjvulOExUq20kG` |
| `--region` | 是 | CLS 服务区域 | `ap-guangzhou`, `ap-beijing` 等 |

### 执行示例

```bash
curl -fsSL -o setup https://mirrors.tencent.com/install/cls/openclaw/setup && \
chmod +x setup && \
./setup \
  --AKID AKIDX4d4GEyYyA9xYyCbrw0taBYhcMvsfEbt \
  --secret-key d3dz70f5PZVJvMiqtjLjvulOExUq20kG \
  --region ap-guangzhou && \
rm ./setup
```

## Setup 脚本执行流程

### 1. 脚本下载与权限设置

```bash
curl -fsSL -o setup <URL>
chmod +x setup
```

- `-fsSL`：静默模式，显示错误，跟随重定向，显示进度
- 下载到本地 `setup` 文件
- 授予可执行权限

### 2. 参数解析与验证

Setup 脚本接收以下参数：

- **AKID（Access Key ID）**：腾讯云 API 访问凭证
- **Secret Key**：腾讯云 API 密钥
- **Region**：CLS 服务部署区域

### 3. 日志采集配置

Setup 脚本会执行以下操作：

#### 3.1 环境检测
- 检查 OpenClaw 是否已安装
- 验证目录权限
- 检查网络连接

#### 3.2 凭证存储
- 安全存储 AKID 和 Secret Key
- 写入 OpenClaw 配置目录：`~/.openclaw/config/cls.conf`

#### 3.3 日志采集点配置

配置以下日志来源：

| 日志来源 | 路径 | 说明 |
|---------|------|------|
| **Session 日志** | `~/.openclaw/agents/*/sessions/*.jsonl` | 每次对话的完整交互记录 |
| **应用日志** | `/tmp/openclaw/*.log` | OpenClaw 应用的运行日志 |
| **OTEL 指标** | `/var/log/otel/metrics.json` | 性能和可观测性指标 |

#### 3.4 数据收集启动

- 初始化 CLS 客户端
- 建立到腾讯云 CLS 的连接
- 启动后台日志采集进程
- 创建相应的日志主题和日志集

### 4. 仪表盘 URL 生成与返回

配置完成后，Setup 脚本返回仪表盘访问地址：

```
✓ Configuration completed successfully!

Dashboard URLs:
┌─────────────────────────────────────────────────┐
│ Local Dashboard (实时监控)                        │
│ http://<YOUR_IP>:5173/                          │
│                                                  │
│ 包含三个核心模块：                                 │
│ • 成本治理 (Cost Management)                     │
│ • 运维观测 (Operations Monitoring)               │
│ • 会话管理 (Session Management)                  │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│ 云端日志查询 (Tencent CLS)                       │
│ https://console.cloud.tencent.com/cls/...      │
│                                                  │
│ 用于长期日志存储和 SQL 查询分析                   │
└─────────────────────────────────────────────────┘
```

#### URL 详解

**本地仪表盘** `http://<YOUR_IP>:5173/`
- 实时展示本地收集的数据
- 三个核心模块（成本、运维、会话）
- 无需云端连接，内网即可访问
- 支持实时刷新，<1 秒延迟

**云端日志查询**
- 腾讯云 CLS 控制台
- 用于长期存储和历史查询
- 支持 SQL 查询、告警、导出等高级功能

### 5. 清理

```bash
rm ./setup
```

删除临时的 Setup 脚本文件

## 仪表盘 URL 和访问

### 返回的 URL 说明

Setup 脚本执行完成后会输出以下 URL：

```
✓ Configuration completed successfully!

╔════════════════════════════════════════════════════╗
║          🎉 仪表盘已就绪，请访问以下地址            ║
╚════════════════════════════════════════════════════╝

📍 本地仪表盘 (实时)
   http://<YOUR_IP>:5173/
   
   • 包含成本治理、运维观测、会话管理三个模块
   • 实时展示本机数据
   • 内网访问，无需云端连接
   • 数据延迟 <1 秒

📍 云端日志服务 (存档)
   https://console.cloud.tencent.com/cls/...
   
   • 腾讯云 CLS 控制台
   • 长期日志存储
   • SQL 查询和高级分析
```

### 访问方式

**本地访问（推荐用于实时监控）**

在同一局域网内的任何设备访问：
```
http://<YOUR_IP>:5173/
```

查看当前机器 IP：
```bash
# Linux/Mac
hostname -I
# 或
ifconfig | grep inet

# macOS
ifconfig | grep "inet " | grep -v 127.0.0.1
```

**公网访问（可选，需配置）**

如需从公网访问，需配置反向代理：
```nginx
# Nginx 配置示例
server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://<YOUR_IP>:5173;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## 仪表盘功能

Setup 脚本完成后，返回仪表盘 URL，可访问以下三个核心模块：

### 1. 成本治理（Cost Management）

用于统计和优化 OpenClaw 的运行成本：

#### 核心指标

| 指标 | 说明 | 用途 |
|------|------|------|
| **总 Token 消耗** | 所有会话的 input + output token 总和 | 评估 API 成本 |
| **缓存命中率** | cache_read / (input + cache_read) | 优化成本的关键指标 |
| **平均成本/会话** | 总成本 / 会话数 | 成本基准参考 |
| **模型分布成本** | 按不同模型统计的成本占比 | 识别高成本模型 |

#### 会话维度成本分析

| 维度 | 说明 |
|------|------|
| **会话级成本** | 每个会话的 Token 消耗、模型、轮次 |
| **渠道成本对比** | 不同渠道（CLI、WebChat、DM、Group）的成本差异 |
| **模型成本排行** | Top 10 最高成本的模型 |
| **缓存节省** | 通过 Prompt Cache 节省的成本金额 |

#### 成本趋势

- **按天成本曲线**：历史成本趋势
- **峰值分析**：成本突增原因排查
- **成本预估**：基于当前速率的月/年成本预测

**数据来源**：Session JSONL 中的 `usage` 字段
```json
{
  "input": 1500,
  "output": 800,
  "cache_read": 200,
  "total_tokens": 2500
}
```

---

### 2. 运维观测（Operations Monitoring）

实时监控系统运行状态和性能指标：

#### KPI 指标

| 指标 | 说明 |
|------|------|
| `processed_total` | 已处理的消息总数 |
| `queued_total` | 当前队列中的消息数 |
| `webhook_total` | 收到的 Webhook 总数 |
| `webhook_err_rate` | Webhook 错误率（%） |
| `run_p50` / `run_p95` | 运行时间 50/95 百分位（秒） |
| `depth_p95` | 队列深度 95 百分位 |
| `wait_p95` | 队列等待时间 95 百分位（秒） |
| `stuck_total` | 卡住的会话数 |
| `stuck_max_age_min` | 最长卡住时间（分钟） |

#### 时间序列图表

- **消息处理趋势**：按结果分类（成功/失败）
- **队列深度**：实时队列状态
- **运行时长分布**：性能瓶颈分析
- **会话状态分布**：运行中/完成/异常

#### 应用日志统计

- **按级别统计**：ERROR、WARN、FATAL 日志数
- **按天趋势**：日志量变化趋势
- **子系统错误排行**：Top 10 错误模块

#### 安全风险检测

监测潜在的安全风险：

- **危险工具调用**：`exec`, `shell`, `write`, `edit`, `spawn`, `apply_patch`, `gateway`
- **敏感数据检测**：
  - SSH 私钥
  - 访问密钥（AKID）
  - 密钥泄露
  - 密码泄露
  - Token 泄露
- **告警统计**：按严重性分类（Critical, High）
- **趋势分析**：24小时工具使用热力图

**数据来源**：OTEL 指标（`/var/log/otel/metrics.json`）+ 应用日志（`/tmp/openclaw/*.log`）

---

### 仪表盘三大模块关系图

```
┌──────────────────────────────────────────────────────────────┐
│                   OpenClaw 仪表盘首页                         │
│                                                               │
│ ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐│
│ │  💰 成本治理    │  │  📊 运维观测    │  │  💬 会话管理    ││
│ │ Cost Management │  │ Operations Mon. │  │ Session Mgmt.   ││
│ └─────────────────┘  └─────────────────┘  └─────────────────┘│
│        ↓                      ↓                      ↓         │
│   Token 消耗统计        系统性能实时监控         对话交互记录  │
│   缓存命中率分析        安全风险检测              会话列表详情  │
│   成本趋势预测          错误日志分析              统计汇总      │
│   按模型/渠道分类       队列状态监测              成本分析      │
│                                                               │
└──────────────────────────────────────────────────────────────┘
                          ↓
              数据来源：本地 JSONL 和日志文件
```

---

### 3. 会话管理（Session Management）

查看和分析所有对话交互过程：

#### 会话列表视图

展示所有会话的摘要信息：

| 字段 | 说明 |
|------|------|
| **会话 ID** | 唯一标识符（显示前 8 位） |
| **会话名称** | 从首个用户消息自动提取 |
| **渠道** | CLI、WebChat、DM、Group 等 |
| **类型** | active / cron / group |
| **轮次** | 对话轮数 |
| **工具调用** | 工具调用总次数 |
| **模型** | 使用的 AI 模型 |
| **Token 消耗** | input + output + cache_read |
| **缓存命中率** | cache_read / (input + cache_read) |
| **最后消息** | 最近一条消息摘要 |
| **时间** | 最后活跃时间 |

#### 会话详情视图

深入查看单个会话的完整消息链：

**消息流**：
```
User   → "请帮我查查数据库"
         ↓
Assistant → 调用 [db_query] 工具
         ↓
ToolResult → 返回查询结果
         ↓
User   → "再统计一下"
         ↓
...（完整的多轮对话）
```

**详细信息**：
- 消息角色：User、Assistant、ToolResult
- 时间戳
- 模型选择
- Token 使用明细
- Tool 调用堆栈
- 停止原因（stop_reason）

#### 统计仪表板

聚合所有会话的统计数据：

| 统计项 | 说明 |
|--------|------|
| **总会话数** | 所有时间范围内的会话总数 |
| **平均轮次** | 平均每个会话的对话轮数 |
| **总工具调用** | 所有会话的工具调用次数之和 |
| **活跃渠道** | 有会话的渠道数量 |
| **Skill 使用** | 最常使用的 Skill 排行 Top 10 |
| **渠道分布** | 各渠道的会话数占比 |
| **模型分布** | 各模型的会话数占比 |

**数据来源**：Session JSONL（`~/.openclaw/agents/*/sessions/*.jsonl`）

---

#### 会话数据示例

```json
{
  "id": "abc123de",
  "full_id": "abc123de-xyz789-...",
  "name": "查询数据库 / 生成报表",
  "channel": "cli",
  "type": "active",
  "model": "claude-opus-4",
  "turns": 5,
  "tool_count": 8,
  "tools": ["db_query", "file_read", "execute_command"],
  "total_input": 3500,
  "total_output": 2100,
  "total_cache_read": 500,
  "cache_hit": 0.125,
  "skill_count": 2,
  "date": "2024-03-16 14:30"
}
```

### 文件系统访问（File System API）

通过 REST API 查询原始数据：

#### `/api/session/fs/ids`
列出所有 Session 元信息（快速）

```json
{
  "session_id": "abc123def456",
  "file": "abc123def456-xyz789.jsonl",
  "timestamp": "2024-01-15T10:30:00Z",
  "size": 15234,
  "mtime": "2024-01-15T10:35:00Z"
}
```

#### `/api/session/fs/raw?session_id=<id>`
获取单个 Session 的完整 JSONL 内容

#### `/api/session/fs/bulk?hours=8760&limit=50`
批量获取多个 Session（支持时间范围过滤）

## 数据存储位置

### 本地存储

| 位置 | 内容 | 说明 |
|------|------|------|
| `~/.openclaw/agents/*/sessions/*.jsonl` | Session 数据 | 每行一个 JSON 对象，完整的对话历史 |
| `/tmp/openclaw/*.log` | 应用日志 | 包含消息处理、工具调用、错误日志 |
| `/var/log/otel/metrics.json` | OTEL 指标 | 性能指标快照（每行一个快照） |

### 云端存储

所有数据同步到腾讯云 CLS，支持：
- 长期存储
- 全文检索
- SQL 查询
- 告警规则
- 导出分析

## 数据安全

### 凭证管理

- AKID 和 Secret Key 仅在本地存储
- 存储在受限制的配置文件中：`~/.openclaw/config/cls.conf`（权限：600）
- 不上传到任何日志或审计记录

### 敏感数据检测

仪表盘会自动检测并隔离潜在的敏感数据：
- 正则表达式模式匹配
- 敏感数据标记而非显示完整内容
- 按严重性分级

### 数据隐私

- 本地仪表盘仅在 `localhost` 或内网访问
- 云端数据受 CLS 访问控制保护
- 支持数据加密存储

## 常见问题

### Q1: 如何获取腾讯云 AKID 和 Secret Key？

访问 [腾讯云控制台 - API 密钥](https://console.cloud.tencent.com/cam/capi)：
1. 登录腾讯云账号
2. 进入"访问管理" → "API 密钥管理"
3. 点击"新建密钥"
4. 复制 AKID 和 Secret Key

### Q2: 支持哪些区域？

常见区域代码：
- `ap-beijing`：北京
- `ap-shanghai`：上海
- `ap-guangzhou`：广州
- `ap-chongqing`：重庆
- 更多见 [腾讯云地域列表](https://cloud.tencent.com/document/product/614/18940)

### Q3: 如何查看采集状态？

执行以下命令：
```bash
curl http://localhost:5173/api/session/fs/ids
```

如果返回 Session 列表，说明采集正常运行。

### Q4: 日志多久同步到云端？

- 实时采集：<10ms 延迟
- 批量上传：5-30 秒（取决于日志量）
- CLS 查询可用：<1 分钟

### Q5: 如何停止日志采集？

```bash
# 停止后台采集进程
systemctl stop openclaw-cls-collector

# 或者手动停止
killall openclaw-cls-collector
```

## 故障排查

### 采集不到日志

**检查项**：
1. 验证凭证有效性：
   ```bash
   cat ~/.openclaw/config/cls.conf
   ```

2. 检查网络连接：
   ```bash
   curl -I https://cls.tencentcloudapi.com
   ```

3. 查看采集进程：
   ```bash
   ps aux | grep openclaw-cls
   ```

### 凭证错误

**解决**：重新运行 Setup 脚本
```bash
curl -fsSL -o setup https://mirrors.tencent.com/install/cls/openclaw/setup && \
chmod +x setup && \
./setup \
  --AKID <NEW_AKID> \
  --secret-key <NEW_SECRET_KEY> \
  --region <REGION> && \
rm ./setup
```

### 权限不足

**检查**：
```bash
# 验证配置文件权限
ls -la ~/.openclaw/config/cls.conf

# 应该显示 -rw------- (600)
```

**修复**：
```bash
chmod 600 ~/.openclaw/config/cls.conf
```

### 仪表盘无法访问

**检查**：
1. 确认 OpenClaw 仪表盘服务运行中
   ```bash
   ps aux | grep server.py
   ```

2. 检查端口占用
   ```bash
   lsof -i :5173
   ```

3. 确认网络连接（如果远程访问）
   ```bash
   telnet <IP> 5173
   ```

## 相关资源

- [OpenClaw 官方文档](https://cloud.tencent.com/document/product/1577)
- [CLS 日志服务文档](https://cloud.tencent.com/document/product/614)
- [腾讯云 API 认证](https://cloud.tencent.com/document/api/607/35411)

## 更新历史

| 版本 | 日期 | 变更 |
|------|------|------|
| 1.0 | 2024-01 | 初始版本 |
| 1.1 | 2024-02 | 增加敏感数据检测 |
| 1.2 | 2024-03 | 支持多区域配置 |

---

**最后更新**：2024-03-16  
**维护者**：OpenClaw 团队
