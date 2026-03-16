# Xeon ASR

🎤 基于 OpenVINO Qwen3-ASR 模型的本地语音转文字技能，为 OpenClaw/QQBot/Feishu Bot 提供本地语音识别能力。

## 架构

双服务架构（自动运行）：

| 服务 | 端口 | 作用 |
|------|------|------|
| Flask ASR | 5001 | 加载 Qwen3-ASR 模型，执行本地推理 |
| ASR Skill | 9001 | 接收 QQ 语音消息，调用 5001 推理 |

## 模型准备

**自动下载（推荐）**

`setup_env.sh` 会自动检测并下载模型到 `~/model/`，默认使用 hf-mirror + HF CLI 加速国内访问。

**手动下载**
```bash
# 1. 临时设置环境变量
export HF_ENDPOINT=https://hf-mirror.com

# 2. 下载整个模型
hf download dseditor/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO --local-dir ~/model/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO
```

如系统中仍是旧命令名，也兼容：

```bash
huggingface-cli download dseditor/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO --local-dir ~/model/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO --local-dir-use-symlinks False
```

脚本生成 `audio_config.json` 时，会把模型路径写成当前用户主目录下的绝对路径，例如 `/root/model/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO`。

> **路径说明：** `~` 表示用户主目录，配置文件中保留 `~` 格式以支持 Docker 环境，运行时自动展开为实际路径。

## 安装流程

当用户请求安装时，按以下步骤执行：

1. **从 clawhub 安装**
   ```bash
   clawhub install xeonasr
   ```

2. **运行环境配置**
   ```bash
   cd /root/.openclaw/workspace/skills/xeonasr
   bash setup_env.sh  # 默认自动下载模型到 ~/model/
   ```

3. **自动配置 OpenClaw STT 集成**
   
   安装脚本会自动：

   - 配置 `~/.openclaw/openclaw.json` 中的 QQBot STT
   - 配置 `~/.openclaw/openclaw.json` 中的 Feishu STT
   - 修补真正生效的 stock Feishu 插件
   - 处理重复安装的 feishu 插件冲突

   目标配置类似：
   ```json
   {
     "channels": {
       "qqbot": {
         "stt": {
           "enabled": true,
           "provider": "custom",
           "baseUrl": "http://127.0.0.1:9001",
           "model": "Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO",
           "apiKey": "not-needed"
         }
            },
            "feishu": {
               "stt": {
                  "enabled": true,
                  "provider": "custom",
                  "baseUrl": "http://127.0.0.1:9001",
                  "model": "Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO",
                  "apiKey": "not-needed"
               }
       }
     }
   }
   ```

4. **自动启动服务并重启 gateway**

    默认会自动执行 `./start_all.sh`，从而拉起 5001 + 9001，并在健康检查通过后重启 gateway。

    如只想安装不启动，可使用：
    ```bash
    bash install.sh --skip-start
    ```

## 使用

安装完成后，QQ 和 Feishu 收到语音消息时自动转写。

## 管理

```bash
# 进入技能目录
cd /root/.openclaw/workspace/skills/xeonasr

# 重启服务
./stop.sh && ./start_all.sh

# 健康检查
curl http://127.0.0.1:5001/health
curl http://127.0.0.1:9001/health
```

## 常见问题

**端口被占用**：`./stop.sh` 后重试

**缺少 chat_template.json**：从模型目录复制到技能目录

**Python 版本问题**：`setup_env.sh` 会自动处理

## 依赖

- Node.js 18+
- Python 3.10
- xdp-audio-service 0.1.0
- Qwen3-ASR 模型

## 许可证

MIT License

## 作者

aurora2035
