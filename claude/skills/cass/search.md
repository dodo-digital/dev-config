# CASS Search Reference

Detailed documentation for the `cass search` command.

## Basic Syntax

```bash
cass search "query" [options]
```

## Time Filters

| Flag | Description |
|------|-------------|
| `--today` | Today only |
| `--week` | Last 7 days |
| `--days N` | Last N days |
| `--since YYYY-MM-DD` | Since specific date |
| `--until YYYY-MM-DD` | Until specific date |

Examples:
```bash
cass search "bug fix" --json --week
cass search "api" --json --today
cass search "feature" --json --days 30
cass search "migration" --json --since 2025-01-01 --until 2025-01-31
```

## Agent Filters

Filter by specific coding agent:

```bash
cass search "error" --json --agent claude_code
cass search "test" --json --agent codex
cass search "refactor" --json --agent gemini
```

Available agents: `claude_code`, `codex`, `gemini`, `cline`, `cursor`, `opencode`, `amp`, `aider`, `chatgpt`

## Workspace Filters

Filter by project directory:

```bash
cass search "migration" --json --workspace /path/to/project
cass search "api" --json --workspace ~/Projects/myapp
```

## Result Limits

```bash
cass search "query" --json --limit 5   # Default is 10
cass search "query" --json --limit 50  # Up to 50 results
```

## Pagination

Use the `cursor` from search response for pagination:

```bash
# First page
cass search "query" --json --limit 10

# Next page (using cursor from response)
cass search "query" --json --limit 10 --cursor "base64-cursor-string"
```

## Search Response Schema

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
      "workspace": "/path/to/project",
      "created_at": "2025-01-15T10:30:00Z",
      "match_type": "content"
    }
  ],
  "cursor": "base64-cursor-for-pagination"
}
```

### Hit Fields

| Field | Description |
|-------|-------------|
| `source_path` | Full path to session file |
| `line_number` | Line number of match |
| `agent` | Which coding agent |
| `score` | Relevance score (higher = better) |
| `title` | Session title or first message |
| `snippet` | Matching content excerpt |
| `workspace` | Project directory |
| `created_at` | Timestamp of message |
| `match_type` | Type of match (`content`, `title`, etc.) |

## Chained Searches

Narrow results progressively by piping session paths:

```bash
# Find sessions with "authentication", then search those for "JWT"
cass search "authentication" --robot-format sessions | \
  cass search "JWT token" --sessions-from - --json
```

## Workflow Examples

### Before Starting Work

```bash
# Get context from past sessions
cass search "similar task description" --json --limit 5 --fields summary

# Check if you've solved this before
cass search "exact error message" --json --week
```

### Finding Similar Problems

```bash
# Search for error patterns
cass search "TypeError: Cannot read property" --json --agent claude_code

# Search for specific technologies
cass search "PostgreSQL migration" --json --workspace /path/to/rails-app
```

### Debugging Previous Solutions

```bash
# Find past debugging sessions
cass search "debugger" --json --days 14

# Find test-related work
cass search "failing test" --json --week
```
