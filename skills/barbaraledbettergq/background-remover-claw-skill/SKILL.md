---
name: background-remover-claw-skill
description: Remove backgrounds from AI-generated images in one command. Pass a picture UUID and get back a clean transparent-background image URL.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env:
        - NETA_TOKEN
      bins:
        - node
    primaryEnv: NETA_TOKEN
    emoji: "✂️"
    homepage: https://github.com/BarbaraLedbettergq/background-remover-claw-skill
---

# Background Remover Claw Skill

Remove backgrounds from AI-generated images in one command.

## Usage

```bash
node bgremove.js remove <picture_uuid>
```

## Workflow

Works great chained after `image-generation-claw-skill`:

1. Generate an image → get a `picture_uuid`
2. Run `bgremove.js remove <picture_uuid>` → get a clean cutout

## Output (JSON)

```json
{
  "status": "SUCCESS",
  "url": "https://oss.talesofai.cn/picture/<task_uuid>.webp",
  "task_uuid": "...",
  "source_uuid": "..."
}
```

## Setup

Add your API token to `~/.openclaw/workspace/.env`:
```
NETA_TOKEN=your_token_here
```
