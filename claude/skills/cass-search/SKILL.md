---
name: cass-search
description: Search past coding agent sessions for relevant context. Find previous solutions, code patterns, and discussions from Claude Code, Codex, Cursor, and other agent histories.
---

<auto_trigger>
- "search sessions"
- "search past"
- "find previous"
- "how did we"
- "when did we"
- "past sessions"
- "session history"
- "cass search"
- "search history"
- "find in history"
</auto_trigger>

# CAS - Coding Agent Session Search

Search through past coding agent session histories to find relevant context, solutions, and patterns from previous work.

## When to Use This Skill

Use CAS search when:
- Looking for how something was implemented before
- Finding past solutions to similar problems
- Searching for specific code patterns or discussions
- Retrieving context from previous sessions
- Understanding what work was done in a particular workspace

## Tool: cass

The `cass` CLI is installed at `/home/ubuntu/.local/bin/cass` and provides unified search over coding agent histories.

### Basic Search

```bash
cass search "your query" --json --limit 10
```

### Filtered Searches

```bash
# Search only Claude Code sessions
cass search "authentication" --agent claude_code --json

# Search in specific workspace
cass search "database migration" --workspace /home/ubuntu/Projects/agent-pipelines --json

# Search recent sessions (last 7 days)
cass search "error handling" --week --json

# Search last N days
cass search "turbo streams" --days 14 --json
```

### Field Selection (Token Optimization)

Use `--fields` to reduce output size:

```bash
# Minimal output - just paths and line numbers
cass search "query" --json --fields minimal

# Summary output - includes title and score
cass search "query" --json --fields summary

# Custom fields
cass search "query" --json --fields score,workspace,snippet,title
```

Available fields: `score`, `agent`, `workspace`, `source_path`, `snippet`, `content`, `title`, `created_at`, `line_number`, `match_type`, `source_id`, `origin_kind`, `origin_host`

### Viewing Results

After finding a match, view the source file with context:

```bash
cass view /path/to/session.jsonl -n 42 -C 5
```

### Aggregations

Get overview statistics without full content:

```bash
cass search "query" --aggregate agent,workspace --json
```

### Status and Health

```bash
cass status --json     # Check index freshness
cass stats --json      # Get conversation/message counts
cass health            # Quick health check (exit 0=healthy)
```

### Indexing

Keep the index fresh:

```bash
cass index --json      # Incremental update
cass index --full      # Full rebuild
```

## Response Format

Search results are returned as JSON with this structure:

```json
{
  "hits": [
    {
      "score": 0.95,
      "agent": "claude_code",
      "workspace": "/home/ubuntu",
      "source_path": "/home/ubuntu/.claude/projects/...",
      "title": "Session title",
      "snippet": "...matching text...",
      "line_number": 42,
      "created_at": "2026-01-15T10:30:00Z"
    }
  ],
  "total": 15,
  "elapsed_ms": 45
}
```

## Best Practices

1. **Start broad, then narrow**: Begin with general queries, then add filters
2. **Use field selection**: Reduce token usage with `--fields minimal` for initial searches
3. **Time filters**: Use `--week` or `--days N` to focus on recent work
4. **Aggregate first**: Use `--aggregate` to understand result distribution before fetching full content
5. **View in context**: Use `cass view` to see messages in their original context

## Supported Agents

CAS indexes sessions from:
- `claude_code` - Claude Code CLI sessions
- `codex` - OpenAI Codex sessions
- `gemini` - Google Gemini sessions
- `cursor` - Cursor editor sessions
- `aider` - Aider sessions
- `amp` - AMP sessions
- `cline` - Cline sessions
