# OpenClaw CLS 日志采集 Skill

## 简介

一键配置 OpenClaw 机器的日志采集，自动上传日志到腾讯云 CLS，返回实时仪表盘 URL。

## 核心功能

### 💰 成本治理
- Token 消耗统计（input/output/cache）
- 缓存命中率分析
- 成本趋势预测
- 按模型/渠道分类

### 📊 运维观测
- 系统性能实时监控
- 安全风险检测（敏感数据、危险工具）
- 错误日志分析
- KPI 指标展示

### 💬 会话管理
- 对话交互完整记录
- 会话列表和详情
- 统计汇总分析
- Skill 使用排行

## 快速开始

### 1. 获取腾讯云凭证

在 [腾讯云控制台](https://console.cloud.tencent.com/cam/capi) 获取：
- AKID（访问密钥 ID）
- Secret Key（访问密钥）

### 2. 运行 Setup 脚本

```bash
curl -fsSL -o setup https://mirrors.tencent.com/install/cls/openclaw/setup && \
chmod +x setup && \
./setup \
  --AKID YOUR_ACCESS_KEY_ID \
  --secret-key YOUR_SECRET_KEY \
  --region ap-guangzhou && \
rm ./setup
```

支持的区域：`ap-beijing`、`ap-shanghai`、`ap-guangzhou` 等

### 3. 访问仪表盘

脚本完成后返回本地仪表盘 URL：

```
http://<YOUR_IP>:5173/
```

在浏览器中访问即可查看实时数据。

## Setup 执行流程

| 步骤 | 操作 | 说明 |
|------|------|------|
| 1 | 下载脚本 | curl 从腾讯云镜像下载 setup 脚本 |
| 2 | 参数验证 | 验证 AKID、Secret Key、Region 有效性 |
| 3 | 配置采集 | 配置 Session、应用日志、OTEL 指标采集 |
| 4 | 启动服务 | 建立到腾讯云 CLS 的连接，启动采集进程 |
| 5 | 返回 URL | 输出本地仪表盘 URL 和云端 CLS 链接 |

## 数据来源

- **Session 日志**：`~/.openclaw/agents/*/sessions/*.jsonl`
- **应用日志**：`/tmp/openclaw/*.log`
- **OTEL 指标**：`/var/log/otel/metrics.json`

所有数据实时上传到腾讯云 CLS，支持长期存储和 SQL 查询。

## 仪表盘 URL 说明

Setup 完成后返回两个 URL：

### 本地仪表盘（推荐）
```
http://<YOUR_IP>:5173/
```
- 实时展示本机收集的数据
- 无需云端连接，内网即可访问
- 三个核心模块完整呈现
- 数据延迟 <1 秒

### 云端日志服务
```
https://console.cloud.tencent.com/cls/...
```
- 腾讯云 CLS 控制台
- 长期日志存储和查询
- 支持 SQL 分析、告警、导出

## 常见问题

### Q: 如何查看采集状态？
```bash
curl http://localhost:5173/api/session/fs/ids
```
返回 Session 列表即表示采集正常。

### Q: 日志多久同步到云端？
- 实时采集：<10ms
- 批量上传：5-30 秒
- CLS 可查询：<1 分钟

### Q: 如何停止日志采集？
```bash
systemctl stop openclaw-cls-collector
# 或
killall openclaw-cls-collector
```

### Q: 采集不到日志怎么办？

检查项：
1. 验证凭证：`cat ~/.openclaw/config/cls.conf`
2. 检查网络：`curl -I https://cls.tencentcloudapi.com`
3. 查看进程：`ps aux | grep openclaw-cls`

### Q: 仪表盘无法访问？

检查项：
1. 服务运行状态：`ps aux | grep server.py`
2. 端口占用：`lsof -i :5173`
3. 网络连接：`telnet <IP> 5173`

## 安全提示

- AKID 和 Secret Key 仅本地存储在 `~/.openclaw/config/cls.conf`
- 配置文件权限自动设置为 600（仅所有者可读）
- 敏感数据在仪表盘中自动检测和隔离
- 本地仪表盘仅支持 localhost 或内网访问

## 相关资源

- [OpenClaw 官方文档](https://cloud.tencent.com/document/product/1577)
- [CLS 日志服务文档](https://cloud.tencent.com/document/product/614)
- [腾讯云 API 认证](https://cloud.tencent.com/document/api/607/35411)

## 版本信息

- **当前版本**：1.0
- **发布日期**：2024-03-16
- **维护者**：OpenClaw 团队

---

**需要帮助？** 查看完整的 `skill.md` 文档了解更多详情。
