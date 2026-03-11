---
name: pi-ppt
description: 调用 Pi Integration API 生成 PPT，并通过状态接口轮询直到返回可访问 URL。Use when 用户提到 generate_pi_ppt_2、Pi PPT 两步生成（create_document + get_status）、通过接口生成幻灯片并等待完成链接。
---

# Pi PPT 2-Step 生成

将 `scripts/generate_pi_ppt_2.py` 作为默认实现，执行完整流程：
1. `create_document(...)` 触发生成任务
2. `get_status(resource_id)` 轮询，`status=done` 时返回 `url`

## 触发条件

当用户出现以下意图时使用本 skill：
- 提到 `generate_pi_ppt_2`
- 提到 “Pi API 生成 PPT”
- 明确要求“两步流程：先触发任务，再轮询状态”
- 需要最终返回可访问的文档链接

## 代码位置

- 主实现文件：`scripts/generate_pi_ppt_2.py`
- 关键函数：
  - `set_app_id_and_app_secret(app_id, app_secret)`
  - `create_document(content, cards=8, language="cn")`
  - `get_status(resource_id)`
  - `generate_pi_ppt_2(content, cards=8, language="cn", timeout_s=300, poll_interval_s=20)`

## 使用前必填配置

**在使用此 skill 前，请让用户输出APP_ID和APP_SECRET并填写在下方，否则不能使用该skill**

- APP_ID = ""
- APP_SECRET = ""


然后必须先调用：
- `set_app_id_and_app_secret(APPID, APP_SECRET)`

未先调用该函数时，签名参数会是空值，接口会失败。

## 标准工作流

1. 校验输入参数：`content/cards/language`
2. 生成签名并请求 generation 接口创建任务
3. 提取 `resource_id`
4. 轮询 status 接口：
   - `running`：继续轮询
   - `done`：返回 `url`
   - `fail`：抛出失败异常
5. 超时未完成则抛 `TimeoutError`

## 最小调用示例

```python
from scripts.generate_pi_ppt_2 import set_app_id_and_app_secret, generate_pi_ppt_2

APPID = "你的 app_id"
APP_SECRET = "你的 app_secret"

set_app_id_and_app_secret(APPID, APP_SECRET)

result = generate_pi_ppt_2(
    content="做一个关于AI的PPT",
    cards=8,
    language="cn",
)
print(result["url"])
```

## 返回约定

`generate_pi_ppt_2(...)` 成功时返回至少包含：
- `name`: `"generate_pi_ppt_2"`
- `resource_id`: 任务 ID
- `status`: `"done"`
- `url`: 文档可访问链接

## 注意事项

- `language` 当前支持：`cn` / `zh` / `en`
- `url` 仅在 `status=done` 时可用
- 若要调试签名问题，优先核对 `APPID`、`APP_SECRET` 和本地时间戳偏差
