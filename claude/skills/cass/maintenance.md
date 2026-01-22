# CASS Maintenance Reference

Detailed documentation for index management, health checks, and diagnostics.

## Health Check

Always check health before searching in automated workflows:

```bash
cass health --json
```

### Healthy Response

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

### Unhealthy Response

```json
{
  "healthy": false,
  "latency_ms": 5,
  "state": {
    "database": { "conversations": 472, "messages": 10102 },
    "index": { "fresh": false, "stale": true }
  },
  "issues": ["Index is stale - run 'cass index' to refresh"]
}
```

## Index Management

### Incremental Index (Recommended)

Updates only changed sessions:

```bash
cass index --json
```

Response:
```json
{
  "action": "index",
  "mode": "incremental",
  "sessions_indexed": 5,
  "messages_indexed": 127,
  "duration_ms": 450,
  "success": true
}
```

### Full Rebuild

Rebuilds entire index from scratch:

```bash
cass index --full --json
```

Use when:
- Index is corrupted
- After major upgrades
- Sessions were deleted externally

### Watch Mode

Continuously monitors and indexes new sessions:

```bash
cass index --watch
```

Useful for keeping index fresh during active development.

## Status Check

Detailed status with recommended actions:

```bash
cass status --json
```

Response:
```json
{
  "healthy": false,
  "recommended_action": "Run 'cass index' to refresh the index",
  "database": {
    "conversations": 472,
    "messages": 10102,
    "size_mb": 25.4
  },
  "index": {
    "stale": true,
    "fresh": false,
    "last_indexed": "2025-01-14T15:30:00Z",
    "pending_sessions": 3
  }
}
```

## Statistics

Get overview of indexed data:

```bash
cass stats --json
```

Response:
```json
{
  "agents": {
    "claude_code": 320,
    "codex": 89,
    "gemini": 45,
    "cline": 18
  },
  "workspaces": {
    "/home/user/project-a": 150,
    "/home/user/project-b": 87
  },
  "total_conversations": 472,
  "total_messages": 10102,
  "date_range": {
    "earliest": "2024-06-15",
    "latest": "2025-01-15"
  }
}
```

## Diagnostics

Full diagnostic information:

```bash
cass diag --json
```

Response includes:
- Database path and size
- Index status and health
- Configuration settings
- Agent source directories
- Version information

## Capabilities

Check available features:

```bash
cass capabilities --json
```

Response:
```json
{
  "features": {
    "search": true,
    "aggregations": true,
    "field_selection": true,
    "chained_search": true,
    "export": true,
    "timeline": true
  },
  "agents": ["claude_code", "codex", "gemini", "cline", "cursor"],
  "version": "1.0.0"
}
```

## Exit Codes

| Code | Meaning | Action |
|------|---------|--------|
| 0 | Success | None needed |
| 2 | Usage error | Check command syntax |
| 3 | Missing index/database | Run `cass index` |
| 4 | Network error | Check connectivity |
| 5 | Data corruption | Run `cass index --full` |
| 6 | Incompatible version | Update CASS |
| 7 | Lock/busy | Wait and retry |
| 8 | Partial results | Results may be incomplete |
| 9 | Unknown error | Check `cass diag` |

## Maintenance Schedule

### After Each Session

```bash
cass index --json
```

### Daily (Automated)

```bash
cass health --json && cass index --json
```

### Weekly

```bash
cass stats --json  # Review usage patterns
cass diag --json   # Check for issues
```

### Monthly

```bash
cass index --full --json  # Full rebuild for consistency
```

## Troubleshooting

### Index is Stale

```bash
cass index --json
```

### Search Returns No Results

1. Check health: `cass health --json`
2. Check stats: `cass stats --json` (verify data exists)
3. Try broader query
4. Check time filters

### Slow Searches

1. Use `--fields minimal` to reduce output
2. Add time filters (`--week`, `--days N`)
3. Use `--limit` to cap results
4. Consider `--aggregate` for overview first

### Index Corruption

```bash
# Full rebuild
cass index --full --json

# If still failing, check diagnostics
cass diag --json
```

### Missing Sessions

1. Check agent source directories in `cass diag --json`
2. Verify session files exist
3. Run full index: `cass index --full --json`
