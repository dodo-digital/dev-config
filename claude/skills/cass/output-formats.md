# CASS Output Formats Reference

Detailed documentation for output formatting, field selection, and aggregations.

## Output Format Flags

| Flag | Description | Use Case |
|------|-------------|----------|
| `--json` | Pretty-printed JSON | Default for automation, readable |
| `--robot-format jsonl` | Newline-delimited JSON | Streaming, large result sets |
| `--robot-format compact` | Single-line JSON | Minimal output, piping |
| `--robot-format sessions` | Session paths only | Chaining searches |

### Examples

```bash
# Pretty JSON (default)
cass search "query" --json

# JSONL for streaming
cass search "query" --robot-format jsonl

# Compact for minimal output
cass search "query" --robot-format compact

# Session paths for chaining
cass search "query" --robot-format sessions
```

## Field Selection

Reduce token usage by selecting specific fields:

### Preset Field Sets

```bash
# Minimal: source_path, line_number, agent
cass search "query" --json --fields minimal

# Summary: adds title, score
cass search "query" --json --fields summary

# Full: all fields (default)
cass search "query" --json --fields full
```

### Custom Field Selection

```bash
# Specify exact fields needed
cass search "query" --json --fields source_path,line_number,snippet

# Multiple specific fields
cass search "query" --json --fields agent,workspace,score,title
```

### Available Fields

| Field | Description | Included In |
|-------|-------------|-------------|
| `source_path` | Full path to session file | minimal, summary, full |
| `line_number` | Line number of match | minimal, summary, full |
| `agent` | Which coding agent | minimal, summary, full |
| `score` | Relevance score | summary, full |
| `title` | Session title | summary, full |
| `snippet` | Matching content excerpt | full |
| `content` | Full message content | full |
| `workspace` | Project directory | full |
| `created_at` | Timestamp | full |
| `match_type` | Type of match | full |

### Token Reduction

| Field Set | Approximate Tokens | Reduction |
|-----------|-------------------|-----------|
| `full` | 100% (baseline) | - |
| `summary` | ~40% | 60% reduction |
| `minimal` | ~15% | 85% reduction |

## Aggregations

Get overview statistics with minimal tokens:

### By Agent

```bash
cass search "error" --json --aggregate agent
```

Response:
```json
{
  "query": "error",
  "aggregation": "agent",
  "buckets": [
    { "key": "claude_code", "count": 45 },
    { "key": "codex", "count": 12 },
    { "key": "gemini", "count": 8 }
  ],
  "total": 65
}
```

### By Workspace

```bash
cass search "*" --json --aggregate workspace
```

Response:
```json
{
  "query": "*",
  "aggregation": "workspace",
  "buckets": [
    { "key": "/home/user/project-a", "count": 150 },
    { "key": "/home/user/project-b", "count": 87 }
  ],
  "total": 237
}
```

### By Date (Time Distribution)

```bash
cass search "bug" --json --aggregate date --week
```

Response:
```json
{
  "query": "bug",
  "aggregation": "date",
  "buckets": [
    { "key": "2025-01-15", "count": 5 },
    { "key": "2025-01-14", "count": 8 },
    { "key": "2025-01-13", "count": 3 }
  ],
  "total": 16
}
```

### Aggregation Benefits

- **99% token reduction** compared to full search results
- Quick overview of data distribution
- Useful for scoping searches before diving deep

## Timeline Command

Get session activity over time:

```bash
# Today's activity
cass timeline --today --json

# Activity since date
cass timeline --since 2025-01-01 --json

# Group by day
cass timeline --since 2025-01-01 --json --group-by day

# Group by week
cass timeline --week --json --group-by week
```

## Export Command

Export sessions in different formats:

```bash
# Export as Markdown
cass export /path/to/session.jsonl --format markdown -o output.md

# Export as JSON
cass export /path/to/session.jsonl --format json

# Include tool calls
cass export /path/to/session.jsonl --format json --include-tools

# Export to stdout
cass export /path/to/session.jsonl --format markdown
```

## Best Practices

1. **Start with aggregations** to understand data distribution
2. **Use `--fields minimal`** for initial searches, then expand
3. **Use `--robot-format sessions`** when chaining searches
4. **Use `--limit`** to control output size
5. **Prefer `--json`** for reliable parsing
