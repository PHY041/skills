---
name: ascii-chord
description: Show ASCII guitar chord diagrams using the ascii_chord CLI tool (Yz's own Rust repo). Use when asked how to play a guitar chord, or to show chord charts/diagrams for any chord name (e.g. E, B7, Am, C, G, Dm, etc.).
---

# ascii-chord

Display ASCII guitar chord diagrams using https://github.com/yzhong52/ascii_chord.

## Setup

Repo is cloned at `/tmp/ascii_chord`. If missing, clone it:

```bash
git clone https://github.com/yzhong52/ascii_chord /tmp/ascii_chord
```

## Usage

**Single chord:**
```bash
cd /tmp/ascii_chord && cargo run -- get <CHORD> 2>/dev/null
```

**Multiple chords side by side:**
```bash
cd /tmp/ascii_chord && cargo run -- list <CHORD1> <CHORD2> ... 2>/dev/null
```

**List all supported chords:**
```bash
cd /tmp/ascii_chord && cargo run -- all 2>/dev/null
```

## Examples

```bash
cargo run -- get E
cargo run -- get B7
cargo run -- list C G Am F
```

## Notes

- Suppress compiler warnings with `2>/dev/null`
- Chord names are case-sensitive (e.g. `Am` not `am`)
- See `all_supported_chords.md` in the repo for full list of supported chords
