---
name: cass
description: Search and explore coding agent session histories using CASS (Coding Agent Session Search). Use when searching past sessions, finding similar work, retrieving context from previous conversations, or checking index health. Triggers on queries about past agent work, session history, or when context from previous coding sessions would be helpful.
---

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

## Key Commands

### Health Check (Pre-flight)

Always check health before searching:

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
cass search "bug fix" --json --week          # last 7 days
cass search "api" --json --today             # today only
cass search "feature" --json --days 30       # last 30 days

# Filter by agent
cass search "error" --json --agent claude_code
cass search "test" --json --agent codex

# Filter by workspace
cass search "migration" --json --workspace /path/to/project

# Minimal output (reduces tokens)
cass search "query" --json --fields minimal --limit 5
```

### Search Response Schema

```json
{
  "query": "search terms",
  "count": 5,
  "total_matches": 42,
  "hits": [
    {
      "source_path": "/home/user/.claude/projects/.../session.jsonl",
      "line_number": 123,
      "agent": "claude_code",
      "score": 27.5,
      "title": "Session title or first message...",
      "snippet": "...matching content...",
      "workspace": "/path/to/project"
    }
  ],
  "cursor": "base64-cursor-for-pagination"
}
```

### View Result Context

Follow up on search results:

```bash
# View specific line with context
cass view /path/to/session.jsonl -n 42 --json

# More context lines
cass view /path/to/session.jsonl -n 42 -C 10 --json
```

### Expand Messages

Show messages around a line in conversation:

```bash
cass expand /path/to/session.jsonl -n 42 --json -C 5
```

### Index Management

```bash
# Refresh index (incremental)
cass index --json

# Full rebuild
cass index --full --json

# Watch mode (continuous)
cass index --watch
```

### Status Check

```bash
cass status --json
```

Response includes recommended action:
```json
{
  "healthy": false,
  "recommended_action": "Run 'cass index' to refresh the index",
  "database": { "conversations": 472, "messages": 10102 },
  "index": { "stale": true, "fresh": false }
}
```

### Statistics

```bash
cass stats --json
```

Returns agent breakdown, workspace counts, and date range.

### Timeline

```bash
cass timeline --today --json
cass timeline --since 2025-01-01 --json --group-by day
```

### Export Session

```bash
cass export /path/to/session.jsonl --format markdown -o output.md
cass export /path/to/session.jsonl --format json --include-tools
```

## Output Formats

| Flag | Description |
|------|-------------|
| `--json` | Pretty-printed JSON (default for automation) |
| `--robot-format jsonl` | Newline-delimited JSON (streaming) |
| `--robot-format compact` | Single-line JSON |
| `--robot-format sessions` | Session paths only (for chaining) |

## Field Selection

Reduce token usage with field selection:

```bash
# Minimal: source_path, line_number, agent
cass search "query" --json --fields minimal

# Summary: adds title, score
cass search "query" --json --fields summary

# Custom fields
cass search "query" --json --fields source_path,line_number,snippet
```

Available fields: `score`, `agent`, `workspace`, `source_path`, `snippet`, `content`, `title`, `created_at`, `line_number`, `match_type`

## Aggregations

Get overview with minimal tokens:

```bash
# Count by agent
cass search "error" --json --aggregate agent

# Count by workspace
cass search "*" --json --aggregate workspace

# Time distribution
cass search "bug" --json --aggregate date --week
```

## Chained Searches

Narrow results progressively:

```bash
cass search "authentication" --robot-format sessions | \
  cass search "JWT token" --sessions-from - --json
```

## Workflow Integration

### Before Starting Work

```bash
# Get context from past sessions
cass search "similar task description" --json --limit 5 --fields summary

# Check if you've solved this before
cass search "exact error message" --json --week
```

### After Completing Work

```bash
# Keep index fresh
cass index --json
```

### Diagnostics

```bash
# Full diagnostic info
cass diag --json

# Check capabilities
cass capabilities --json
```

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

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 2 | Usage error |
| 3 | Missing index/database |
| 4 | Network error |
| 5 | Data corruption |
| 6 | Incompatible version |
| 7 | Lock/busy |
| 8 | Partial results |
| 9 | Unknown error |

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
