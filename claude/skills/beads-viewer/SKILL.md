---
name: beads-viewer
description: AI-powered task prioritization using PageRank and graph analysis with bv. Use when deciding what to work on next, analyzing project bottlenecks, understanding task dependencies, or getting AI-powered work recommendations. Triggers on "what should I work on", "prioritize tasks", "bv", "triage", or dependency analysis requests.
---

# Beads Viewer (bv)

Terminal UI and robot interface for the Beads issue tracker with graph-theoretic analysis.

## Quick Start

```bash
# Primary command - get AI-powered recommendations
bv --robot-triage

# Single top pick with claim command
bv --robot-next

# Interactive TUI
bv
```

## Robot Triage (Primary Entry Point)

`bv --robot-triage` is the mega-command for AI agents. One call gets everything needed.

```bash
bv --robot-triage
```

### Output Structure

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

### Filtering Options

```bash
# Filter by label
bv --robot-triage --label backend

# Filter by assignee
bv --robot-triage --robot-by-assignee alice

# Limit results
bv --robot-triage --robot-max-results 5

# Group by execution track
bv --robot-triage --robot-triage-by-track

# Group by label
bv --robot-triage --robot-triage-by-label
```

## PageRank and Graph Metrics

bv computes nine graph-theoretic metrics:

| Metric | What It Measures | High Score Means |
|--------|------------------|------------------|
| **PageRank** | Recursive dependency importance | Foundational blocker |
| **Betweenness** | Shortest-path traffic | Bottleneck/bridge |
| **Critical Path** | Longest dependency chain | Keystone with zero slack |
| **HITS Hub** | Outgoing dependencies | Epic/coordinator |
| **HITS Authority** | Incoming dependencies | Infrastructure/utility |
| **Eigenvector** | Influence via neighbors | Strategic dependency |
| **Degree** | Direct connections | Immediate blocker |
| **K-Core** | Graph decomposition | Core vs peripheral |
| **Slack** | Parallelism headroom | Can be delayed safely |

### Composite Impact Score

```
Impact = 0.30*PageRank + 0.30*Betweenness + 0.20*BlockerRatio
         + 0.10*Staleness + 0.10*PriorityBoost
```

### Get Full Metrics

```bash
bv --robot-insights
```

Returns PageRank maps, betweenness scores, cycles, articulation points, and k-core analysis.

## Agent Brief Export

Export a complete briefing bundle for agent handoff:

```bash
bv --agent-brief ./briefing-dir
```

Creates:
- `triage.json` - Full robot-triage output
- `insights.json` - Graph metrics and analysis
- `brief.md` - Human-readable summary
- `helpers.md` - Common commands reference

## Execution Planning

### Parallel Tracks

```bash
bv --robot-plan
```

Returns dependency-respecting execution tracks that can be parallelized:

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

### Capacity Simulation

```bash
# How long to complete with N agents?
bv --robot-capacity --agents 3

# Scoped to label
bv --robot-capacity --agents 2 --capacity-label sprint-1
```

### ETA Forecasting

```bash
# Single issue forecast
bv --robot-forecast bv-123

# All open issues
bv --robot-forecast all --forecast-agents 2
```

## TUI Features

Launch with `bv` (no flags).

### View Switching

| Key | View |
|-----|------|
| `b` | Kanban board |
| `g` | Dependency graph |
| `i` | Insights dashboard |
| `h` | History/git correlation |
| `a` | Actionable plan (parallel tracks) |
| `f` | Flow matrix (cross-label deps) |
| `]` | Attention view (label priority) |

### Navigation

| Key | Action |
|-----|--------|
| `j/k` | Move down/up |
| `g/G` | Jump to first/last |
| `/` | Fuzzy search |
| `Enter` | View details |
| `Tab` | Toggle detail panel |

### Filtering

| Key | Filter |
|-----|--------|
| `o` | Open issues only |
| `c` | Closed issues only |
| `r` | Ready (no blockers) |
| `s` | Cycle sort modes |

### Actions

| Key | Action |
|-----|--------|
| `y` | Copy issue ID |
| `C` | Copy as Markdown |
| `E` | Export to file |
| `O` | Open in editor |
| `t` | Time-travel compare |

## Additional Robot Commands

### Priority Recommendations

```bash
bv --robot-priority
```

Compares impact scores to assigned priorities, suggests adjustments.

### Label Health

```bash
bv --robot-label-health
bv --robot-label-attention --attention-limit 5
```

### Drift Detection

```bash
# Save baseline
bv --save-baseline "Before refactor"

# Check for drift (CI-friendly exit codes)
bv --check-drift
# Exit 0 = OK, 1 = critical, 2 = warning

# JSON output
bv --check-drift --robot-drift
```

### Graph Export

```bash
# JSON adjacency list
bv --robot-graph --graph-format json

# Graphviz DOT
bv --robot-graph --graph-format dot > deps.dot

# Mermaid diagram
bv --robot-graph --graph-format mermaid

# Interactive HTML
bv --export-graph deps.html

# PNG/SVG image
bv --export-graph deps.png --graph-style force
```

### History and Correlation

```bash
# Bead-to-commit correlations
bv --robot-history

# Changes since reference
bv --diff-since HEAD~10 --robot-diff

# View at point in time
bv --robot-triage --as-of v1.0.0
```

### File Impact Analysis

```bash
# What beads touched this file?
bv --robot-file-beads src/auth/token.go

# Files with most bead activity
bv --robot-file-hotspots

# Impact of changing files
bv --robot-impact src/auth/token.go,src/auth/session.go
```

## Recipes

Pre-configured filters:

```bash
bv --recipe actionable    # Ready to work (no blockers)
bv --recipe high-impact   # Top PageRank scores
bv --recipe bottlenecks   # High betweenness nodes
bv --recipe quick-wins    # Easy items, no blockers
bv --recipe stale         # Untouched 30+ days
bv -r triage              # Sorted by triage score
```

List available:
```bash
bv --robot-recipes
```

## Workflow Integration

### Start of Session

```bash
# 1. Get AI recommendations
triage=$(bv --robot-triage)

# 2. Extract top pick
echo "$triage" | jq '.quick_ref.top_picks[0]'

# 3. Or just get the single top pick
bv --robot-next
```

### Emit Work Script

```bash
# Generate shell script for top 5 items
bv --emit-script --script-limit 5 > work.sh

# Execute
bash work.sh
```

### Planning Session

```bash
# Interactive with parallel tracks
bv
# Press 'a' for actionable plan view
```

## Guidelines

- Always use `--robot-*` flags for automation, never bare `bv` in scripts
- `--robot-triage` is the primary entry point - start there
- Check `blockers_to_clear` for highest-leverage work
- PageRank identifies foundational blockers
- Betweenness identifies bottlenecks
- Use `--label` to scope analysis to a subsystem
- Commit `.beads/` changes alongside code changes
