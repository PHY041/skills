---
name: lottery
version: 1.0.0
author: BytesAgain
license: MIT-0
tags: [lottery, tool, utility]
---

# Lottery

Lottery toolkit — number generator, odds calculator, result checker, and statistics.

## Commands

| Command | Description |
|---------|-------------|
| `lottery help` | Show usage info |
| `lottery run` | Run main task |
| `lottery status` | Check state |
| `lottery list` | List items |
| `lottery add <item>` | Add item |
| `lottery export <fmt>` | Export data |

## Usage

```bash
lottery help
lottery run
lottery status
```

## Examples

```bash
lottery help
lottery run
lottery export json
```

## Output

Results go to stdout. Save with `lottery run > output.txt`.

## Configuration

Set `LOTTERY_DIR` to change data directory. Default: `~/.local/share/lottery/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
