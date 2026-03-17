---
name: polymarket-cybersecurity-trader
description: Trades Polymarket prediction markets on major cyberattacks, ransomware incidents, data breaches, zero-day exploits, and national cybersecurity legislation.
metadata:
  author: Diagnostikon
  version: "1.0"
  displayName: Cybersecurity & Hacking Events Trader
  difficulty: advanced
---

# Cybersecurity & Hacking Events Trader

Cybersecurity prediction markets are the least efficiently priced category on Polymarket — most traders can’t read a CVE advisory, let alone a CISA KEV entry. That’s the edge.

This skill scans for breach, ransomware, and legislation markets using threat intelligence keywords. The base signal is probability-extreme detection. The serious signal is CISA’s Known Exploited Vulnerabilities catalog: when a new KEV entry hits critical infrastructure, related Polymarket legislation and incident markets reprice — but typically 6–12 hours after the catalog update. That window is where the alpha lives. Wire in the CISA KEV JSON feed (free, public API, updates within hours of incidents) to `compute_signal()` to activate it.

## Strategy Overview

CVE severity score spikes as leading indicator. CISA KEV (Known Exploited Vulnerabilities) catalog additions precede regulatory market moves.

## Edge Thesis

Cyber incident markets are among the least efficient on Polymarket because most traders lack technical background to interpret threat intelligence feeds. Key edge: CISA's KEV catalog (mandatory patch list) is updated within hours of a major breach. When a KEV entry affects critical infrastructure, related legislation markets spike within 24h — but Polymarket often takes 6–12h to fully reprice.

### Remix Signal Ideas
- **CISA KEV Catalog API**: https://www.cisa.gov/known-exploited-vulnerabilities-catalog — JSON feed of all actively exploited CVEs — updated within hours of incidents
- **Ransomware.live API**: https://www.ransomware.live/#/api — Real-time ransomware attack tracker with victim data
- **NVD CVE API (NIST)**: https://nvd.nist.gov/developers/vulnerabilities — CVSS severity scores for all published CVEs

## Safety & Execution Mode

**The skill defaults to paper trading (`venue="sim"`). Real trades only with `--live` flag.**

| Scenario | Mode | Financial risk |
|---|---|---|
| `python trader.py` | Paper (sim) | None |
| Cron / automaton | Paper (sim) | None |
| `python trader.py --live` | Live (polymarket) | Real USDC |

`autostart: false` and `cron: null` — nothing runs automatically until you configure it in Simmer UI.

## Required Credentials

| Variable | Required | Notes |
|---|---|---|
| `SIMMER_API_KEY` | Yes | Trading authority. Treat as high-value credential. |

## Tunables (Risk Parameters)

All declared as `tunables` in `clawhub.json` and adjustable from the Simmer UI.

| Variable | Default | Purpose |
|---|---|---|
| `SIMMER_MAX_POSITION` | See clawhub.json | Max USDC per trade |
| `SIMMER_MIN_VOLUME` | See clawhub.json | Min market volume filter |
| `SIMMER_MAX_SPREAD` | See clawhub.json | Max bid-ask spread |
| `SIMMER_MIN_DAYS` | See clawhub.json | Min days until resolution |
| `SIMMER_MAX_POSITIONS` | See clawhub.json | Max concurrent open positions |

## Dependency

`simmer-sdk` by Simmer Markets (SpartanLabsXyz)
- PyPI: https://pypi.org/project/simmer-sdk/
- GitHub: https://github.com/SpartanLabsXyz/simmer-sdk
