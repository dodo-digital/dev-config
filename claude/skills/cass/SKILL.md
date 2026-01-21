---
name: cass
description: Search and explore coding agent session histories using CASS (Coding Agent Session Search). Use when searching past sessions, finding similar work, retrieving context from previous conversations, or checking index health.
---

<auto_trigger>
- "cass", "session search", "past sessions"
- "have I done this before", "similar work"
- "search history", "find where", "when did I"
- "index sessions", "session health"
- "previous conversation", "last time"
- Searching for past work
- Finding similar implementations
- Checking session history
</auto_trigger>

# CASS - Coding Agent Session Search

Unified search over coding agent histories (Claude Code, Codex, Gemini, Cline, Cursor, and more).

## Quick Start

```bash
# Check health before searching
cass health --json

# Search past sessions
cass search "authentication error" --json --limit 5

# View result in context
cass view /path/to/session.jsonl -n 42 --json
```

## When To Use CASS

- **Finding similar work**: Search for past sessions that solved similar problems
- **Retrieving context**: Get relevant background before starting new tasks
- **Learning from history**: Find patterns in successful implementations
- **Debugging**: Locate past errors and their solutions
- **Project continuity**: Resume work with full context from previous sessions

## Core Commands

### Health Check (Always First)

```bash
cass health --json
```

Response:
```json
{
  "healthy": true,
  "latency_ms": 1,
  "state": {
    "database": { "conversations": 472, "messages": 10102 },
    "index": { "fresh": true, "stale": false }
  }
}
```

If unhealthy or stale, run `cass index --json` first.

### Search

```bash
# Basic search
cass search "your query" --json --limit 10

# With time filters
cass search "bug fix" --json --week
cass search "feature" --json --days 30

# Filter by agent
cass search "error" --json --agent claude_code

# Minimal output (reduces tokens)
cass search "query" --json --fields minimal --limit 5
```

For advanced search options, filters, and response schemas, see [search.md](search.md).

### View Result Context

```bash
# View specific line with context
cass view /path/to/session.jsonl -n 42 --json

# More context lines
cass view /path/to/session.jsonl -n 42 -C 10 --json
```

### Expand Messages

```bash
cass expand /path/to/session.jsonl -n 42 --json -C 5
```

## Output Formats

| Flag | Description |
|------|-------------|
| `--json` | Pretty-printed JSON (default for automation) |
| `--robot-format jsonl` | Newline-delimited JSON (streaming) |
| `--robot-format compact` | Single-line JSON |
| `--robot-format sessions` | Session paths only (for chaining) |

For field selection, aggregations, and schema details, see [output-formats.md](output-formats.md).

## Index Management

```bash
# Refresh index (incremental)
cass index --json

# Full rebuild
cass index --full --json

# Check status
cass status --json
```

For detailed maintenance procedures and diagnostics, see [maintenance.md](maintenance.md).

## Supported Agents

CASS indexes sessions from:
- Claude Code (`claude_code`)
- Codex (`codex`)
- Gemini (`gemini`)
- Cline (`cline`)
- Cursor (`cursor`)
- OpenCode (`opencode`)
- AMP (`amp`)
- Aider (`aider`)
- ChatGPT (`chatgpt`)

## Guidelines

- Always use `--json` flag for machine-readable output
- Check `cass health --json` before searching in automated workflows
- Use `--fields minimal` or `--fields summary` to reduce token usage
- Use time filters (`--week`, `--days N`, `--since`) to scope searches
- Run `cass index --json` periodically to keep the index fresh
- Use `cass view` to examine specific results in context
- Prefer aggregations for overview queries (99% token reduction)

## Quick Reference

```bash
# Pre-flight
cass health --json

# Search
cass search "query" --json --limit 10

# View result
cass view <source_path> -n <line_number> --json

# Refresh index
cass index --json

# Get stats
cass stats --json
```

## Reference Files

- [search.md](search.md) - Search command details, filters, and response schema
- [output-formats.md](output-formats.md) - JSON schemas, field selection, aggregations
- [maintenance.md](maintenance.md) - Index management, health checks, diagnostics
