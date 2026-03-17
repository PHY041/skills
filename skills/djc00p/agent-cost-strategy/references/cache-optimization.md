# Cache Optimization Patterns

Prompt caching saves cost by reusing previously processed context. Most providers charge ~10% of normal input price for cache reads.

## What Caches Well

- System prompts (static instructions, personas, rules)
- Large documents loaded repeatedly (codebases, docs, schemas)
- Conversation history in long sessions
- Repeated tool definitions

## What Doesn't Cache

- Dynamic content that changes every request (timestamps, random values)
- Very short prompts (not worth caching)
- One-off requests with unique context

## Patterns

### Static system prompt
Put stable instructions at the top of your system prompt — they get cached after the first request and reused on every subsequent call.

```
[CACHED] System prompt with rules, persona, tools
[NOT CACHED] Current user message
```

### Large document analysis
When repeatedly querying a large document (codebase, PDF, schema):
1. Load the document first in a separate turn
2. Ask questions in follow-up turns — the document stays cached

```
Turn 1: "Here is the codebase: [10k tokens]" → cache miss, charged full price
Turn 2: "What does the auth module do?" → cache hit, ~90% cheaper
Turn 3: "Find all API endpoints" → cache hit, ~90% cheaper
```

### Sub-agent prompts
When spawning many sub-agents with the same base prompt, put shared context first:

```
[SHARED - gets cached]
You are a Rails test fixer. Rules: never comment out tests...

[UNIQUE per agent]
Fix this specific failure: <failure details>
```

## Provider Cache Notes

| Provider | Cache Behavior |
|----------|---------------|
| Anthropic | Automatic on repeated prefixes >1024 tokens; ~90% discount on cache reads |
| OpenAI | Automatic on prompts >1024 tokens; ~50% discount on cache reads |
| Google | Context caching available via API; charged per cache storage + reads |

## Quick Wins

1. **Keep system prompts stable** — avoid injecting dynamic timestamps or session IDs into the system prompt
2. **Order matters** — put static content before dynamic content in your prompt
3. **Batch similar requests** — run related sub-agents with the same base prompt together to maximize cache hits
4. **Check your cache hit rate** — most providers show this in usage dashboards or API responses
