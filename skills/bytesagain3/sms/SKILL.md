---
name: sms
version: 1.0.0
author: BytesAgain
license: MIT-0
tags: [sms, tool, utility]
---

# SMS

SMS toolkit — send messages, manage contacts, template management, delivery tracking, bulk sending, and conversation history.

## Commands

| Command | Description |
|---------|-------------|
| `sms run` | Execute main function |
| `sms list` | List all items |
| `sms add <item>` | Add new item |
| `sms status` | Show current status |
| `sms export <format>` | Export data |
| `sms help` | Show help |

## Usage

```bash
# Show help
sms help

# Quick start
sms run
```

## Examples

```bash
# Run with defaults
sms run

# Check status
sms status

# Export results
sms export json
```

## How It Works

Processes input with built-in logic and outputs structured results. All data stays local.

## Tips

- Run `sms help` for all commands
- Data stored in `~/.local/share/sms/`
- No API keys required for basic features
- Works offline

---
*Powered by BytesAgain | bytesagain.com*
