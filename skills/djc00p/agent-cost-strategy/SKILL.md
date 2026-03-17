---
name: agent-cost-strategy
description: Tiered model selection and cost optimization strategy for multi-agent AI workflows. Use when orchestrating sub-agents, choosing which model to use for a task, trying to reduce API spend, or structuring prompts for cache efficiency. Works with any provider (Anthropic, OpenAI, Google, etc.). Triggers on phrases like "save costs", "which model should I use", "reduce API spend", "optimize model usage", "spin up a sub-agent", or when deciding how to delegate tasks.
---

# Agent Cost Strategy

A tiered model selection framework for multi-agent workflows. Use the cheapest model that can reliably do the job.

## The Tiers

| Tier | Use For | Examples |
|------|---------|---------|
| **Fast/Cheap** | Sub-agents, background workers, iterative fixes, well-defined single-step tasks | Claude Haiku, GPT-4o-mini, Gemini Flash |
| **Mid-tier** | Main dialogue, day-to-day assistance, moderate complexity tasks | Claude Sonnet, GPT-4o, Gemini Pro |
| **Powerful** | Architecture decisions, deep code reviews, hard problems, when cheaper models fail twice | Claude Opus, GPT-4.5, Gemini Ultra |

## Decision Rules

**Use Fast/Cheap when:**
- Task is well-scoped and single-step
- Input/output is straightforward (fix this test, summarize this, run this command)
- It's a background/automated task with no user interaction
- You're running many parallel sub-agents

**Use Mid-tier when:**
- Conversational context matters
- Task requires moderate reasoning or multi-step thinking
- This is the default for your main assistant session

**Use Powerful when:**
- Cheaper models have failed 2+ times on the same problem
- Making high-stakes architectural decisions
- Deep code review or security audit
- The cost of a wrong answer exceeds the cost of the model

## Sub-Agent Pattern

When delegating to a sub-agent, default to the cheapest model that fits the task:

```
Task type               → Model tier
─────────────────────────────────────
Fix failing tests       → Fast/Cheap
Write boilerplate       → Fast/Cheap
Research/search         → Fast/Cheap
Cron/scheduled tasks    → Fast/Cheap (always)
Short replies (hi/ok)   → Fast/Cheap (always)
Build new feature       → Mid-tier
Review PR               → Mid-tier
Architecture            → Powerful
Stuck after 2 tries     → Escalate up one tier
```

## Heartbeat Interval

Set heartbeat to **55 minutes** (not 30) when using Anthropic API keys. This keeps the prompt cache warm just under the 1-hour TTL — every heartbeat pays cheap cache-read rates instead of re-writing the full cache.

```json
"heartbeat": { "every": "55m" }
```

## Communication Pattern Rule

Short conversational messages (hi, thanks, ok, sure, got it, yes, no) should always use Fast/Cheap models. Never burn Sonnet or Powerful on one-word acknowledgments.

## Cache Optimization

Prompt caching can cut costs by 80-90% on repeated context. See `references/cache-optimization.md` for patterns.

## Tracking

Monitor spend by checking your provider's usage dashboard regularly. Signs you're over-spending:
- Running Powerful models on tasks Fast/Cheap can handle
- No caching on repeated system prompts
- Spawning sub-agents without a model tier strategy
- Heartbeat set to 30min (re-writes cache every time)
