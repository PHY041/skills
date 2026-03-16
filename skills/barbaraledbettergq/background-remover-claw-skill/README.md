![banner](./banner.webp)

<!--skill-metadata
name: background-remover-claw-skill
description: Remove backgrounds from AI-generated images in one command. Pass a picture UUID and get back a clean transparent-background image URL.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: [NETA_TOKEN]
      bins: [node]
    primaryEnv: NETA_TOKEN
    emoji: "✂️"
-->

# Background Remover Claw Skill

> Core tool: `node bgremove.js` — wraps the background removal API, no extra dependencies required.

Remove backgrounds from AI-generated images in one command. Pass a picture UUID, get back a clean cutout.

---

## 0. Initialization

On trigger, **immediately output**:
```
✂️ Background remover ready. Give me a picture UUID or paste an image URL.
```

Token check (silent): reads from `NETA_TOKEN` env or `~/.openclaw/workspace/.env`.

---

## 1. Usage

```bash
node bgremove.js remove <picture_uuid>
# stderr: ✂️  Removing background from: <uuid>...
# stderr: ⏳ Task submitted: xxx
# stdout: {"status":"SUCCESS","url":"https://...","task_uuid":"...","source_uuid":"..."}
```

**Trigger conditions:**
- User says: remove background / cut out / transparent background / cutout / no background
- User shares a picture UUID after generating an image

---

## 2. Chaining with Image Generation

Works great as a two-step pipeline:

```bash
# Step 1 — generate image
node imagegen.js gen "your prompt" --char "character" --size portrait
# → {"url":"...","task_uuid":"abc123-..."}

# Step 2 — remove background
node bgremove.js remove abc123-...
# → {"status":"SUCCESS","url":"...transparent cutout..."}
```

---

## 3. Display Result

On success, output the URL on its own line:

```
━━━━━━━━━━━━━━━━━━━━━━━━
✂️ Background removed!
{image_url}
━━━━━━━━━━━━━━━━━━━━━━━━
```

Quick buttons:
- `Generate new image 🎨` → `@{bot_name} generate an image`
- `Remove another ✂️` → `@{bot_name} remove background from <uuid>`

---

## 4. Error Handling

| Error | Message |
|-------|---------|
| Token missing | "Add `NETA_TOKEN=...` to `~/.openclaw/workspace/.env`" |
| status=FAILURE | ⚠️ Removal failed — try a different image |
| status=TIMEOUT | ⏳ Timed out — retry with the same UUID |

---

## CLI Reference

```bash
node bgremove.js remove <picture_uuid>
```

**Output (stdout, JSON):**
```json
{
  "status": "SUCCESS",
  "url": "https://oss.talesofai.cn/picture/<task_uuid>.webp",
  "task_uuid": "...",
  "source_uuid": "<input_uuid>"
}
```

## Setup

Add your API token to `~/.openclaw/workspace/.env`:
```
NETA_TOKEN=your_token_here
```
