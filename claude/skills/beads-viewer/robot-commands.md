# Robot Commands Reference

All `--robot-*` commands output JSON for AI agents and scripts.

## Primary Commands

### robot-triage

The mega-command for AI agents. One call gets everything needed.

```bash
bv --robot-triage
```

**Output Structure:**

```json
{
  "data_hash": "fingerprint of beads.jsonl",
  "meta": { "generated_at": "timestamp", "issue_count": 45 },
  "quick_ref": {
    "open": 15,
    "actionable": 8,
    "blocked": 7,
    "top_picks": [
      { "id": "bv-123", "title": "...", "score": 0.89, "reason": "Unblocks 3 tasks" }
    ]
  },
  "recommendations": [
    {
      "id": "bv-123",
      "title": "Implement caching layer",
      "score": 0.89,
      "reasons": ["High PageRank (0.15)", "Unblocks 3 downstream tasks"],
      "claim_command": "bd update bv-123 --assignee @me",
      "show_command": "bd show bv-123"
    }
  ],
  "quick_wins": [
    { "id": "bv-456", "title": "Fix typo", "complexity": "low", "impact": "medium" }
  ],
  "blockers_to_clear": [
    { "id": "bv-789", "unblocks_count": 5, "downstream_ids": ["bv-a", "bv-b"] }
  ],
  "project_health": {
    "by_status": { "open": 15, "in_progress": 3, "closed": 27 },
    "by_priority": { "p0": 2, "p1": 5, "p2": 8 },
    "graph_metrics": { "density": 0.12, "cycles": 0 }
  },
  "commands": {
    "claim_top": "bd update bv-123 --assignee @me",
    "show_blockers": "bv --robot-plan"
  }
}
```

**Filtering Options:**

```bash
bv --robot-triage --label backend              # Filter by label
bv --robot-triage --robot-by-assignee alice    # Filter by assignee
bv --robot-triage --robot-max-results 5        # Limit results
bv --robot-triage --robot-triage-by-track      # Group by execution track
bv --robot-triage --robot-triage-by-label      # Group by label
```

### robot-next

Single top pick with claim command.

```bash
bv --robot-next
```

Returns the single highest-impact actionable task.

### robot-insights

Full graph metrics and analysis.

```bash
bv --robot-insights
```

Returns PageRank maps, betweenness scores, cycles, articulation points, and k-core analysis.

## Execution Planning

### robot-plan

Dependency-respecting execution tracks for parallelization.

```bash
bv --robot-plan
```

**Output:**

```json
{
  "tracks": [
    {
      "track_id": 1,
      "items": [
        { "id": "bv-123", "unblocks": ["bv-456", "bv-789"] }
      ]
    }
  ],
  "summary": {
    "highest_impact": "bv-123",
    "parallelizable_tracks": 3
  }
}
```

### robot-capacity

Capacity simulation - how long to complete with N agents.

```bash
bv --robot-capacity --agents 3
bv --robot-capacity --agents 2 --capacity-label sprint-1
```

### robot-forecast

ETA forecasting for issues.

```bash
bv --robot-forecast bv-123                        # Single issue
bv --robot-forecast all --forecast-agents 2       # All open issues
```

## Priority and Health

### robot-priority

Compare impact scores to assigned priorities, suggest adjustments.

```bash
bv --robot-priority
```

### robot-label-health

Label health analysis.

```bash
bv --robot-label-health
bv --robot-label-attention --attention-limit 5
```

## History and Drift

### robot-history

Bead-to-commit correlations.

```bash
bv --robot-history
```

### robot-diff

Changes since reference.

```bash
bv --diff-since HEAD~10 --robot-diff
```

### robot-drift / check-drift

Drift detection with CI-friendly exit codes.

```bash
# Save baseline
bv --save-baseline "Before refactor"

# Check for drift (CI-friendly)
bv --check-drift
# Exit 0 = OK, 1 = critical, 2 = warning

# JSON output
bv --check-drift --robot-drift
```

### Point-in-Time Analysis

```bash
bv --robot-triage --as-of v1.0.0
```

## File Impact Analysis

### robot-file-beads

What beads touched a file.

```bash
bv --robot-file-beads src/auth/token.go
```

### robot-file-hotspots

Files with most bead activity.

```bash
bv --robot-file-hotspots
```

### robot-impact

Impact of changing specific files.

```bash
bv --robot-impact src/auth/token.go,src/auth/session.go
```

## Graph Export

### robot-graph

Export dependency graph in various formats.

```bash
bv --robot-graph --graph-format json       # JSON adjacency list
bv --robot-graph --graph-format dot        # Graphviz DOT
bv --robot-graph --graph-format mermaid    # Mermaid diagram
```

### export-graph

Visual graph exports.

```bash
bv --export-graph deps.html                    # Interactive HTML
bv --export-graph deps.png --graph-style force # PNG image
bv --export-graph deps.svg                     # SVG image
```

## Utility Commands

### robot-recipes

List available recipes.

```bash
bv --robot-recipes
```

### emit-script

Generate shell script for top items.

```bash
bv --emit-script --script-limit 5 > work.sh
bash work.sh
```

### agent-brief

Export complete briefing bundle.

```bash
bv --agent-brief ./briefing-dir
```

Creates:
- `triage.json` - Full robot-triage output
- `insights.json` - Graph metrics and analysis
- `brief.md` - Human-readable summary
- `helpers.md` - Common commands reference
