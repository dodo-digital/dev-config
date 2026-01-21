---
name: beads-viewer
description: AI-powered task prioritization using PageRank and graph analysis with bv. Use when deciding what to work on next, analyzing project bottlenecks, understanding task dependencies, or getting AI-powered work recommendations.
---

<auto_trigger>
- "bv", "beads viewer", "triage"
- "what should I work on", "what's next", "prioritize"
- "bottleneck", "bottlenecks", "high impact"
- "pagerank", "graph analysis", "dependency graph"
- "robot-triage", "robot triage"
- Deciding what to work on
- Finding highest impact tasks
- Analyzing task dependencies
</auto_trigger>

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

## Overview

`bv` provides two interfaces:

1. **Robot Commands** - JSON output for AI agents and scripts
2. **Interactive TUI** - Terminal UI for human exploration

The core insight: tasks form a dependency graph. `bv` uses graph algorithms (PageRank, betweenness centrality) to identify high-impact work - tasks that unblock the most downstream work.

## Robot Triage (Primary Entry Point)

`bv --robot-triage` is the mega-command for AI agents. One call gets everything needed:

```bash
bv --robot-triage
```

Returns JSON with:
- `quick_ref.top_picks` - Highest impact tasks to work on
- `recommendations` - Detailed task info with claim commands
- `quick_wins` - Low-effort high-impact items
- `blockers_to_clear` - Tasks that unblock many others
- `project_health` - Status and priority breakdowns

### Common Filters

```bash
bv --robot-triage --label backend           # Filter by label
bv --robot-triage --robot-max-results 5     # Limit results
bv --robot-triage --robot-triage-by-track   # Group by execution track
```

For complete robot command reference, see [robot-commands.md](robot-commands.md).

## Understanding Scores

`bv` computes a composite **Impact Score** combining:

- **PageRank** (30%) - Recursive dependency importance
- **Betweenness** (30%) - Bottleneck detection
- **Blocker Ratio** (20%) - Direct blocking relationships
- **Staleness** (10%) - Time since last update
- **Priority Boost** (10%) - Explicit priority tags

High PageRank = foundational blocker (work on this first).
High Betweenness = bottleneck (clears multiple paths).

For detailed metrics explanation, see [metrics.md](metrics.md).

## Interactive TUI

Launch with `bv` (no flags) for the terminal interface:

| Key | View |
|-----|------|
| `b` | Kanban board |
| `g` | Dependency graph |
| `i` | Insights dashboard |
| `a` | Actionable plan (parallel tracks) |

| Key | Action |
|-----|--------|
| `j/k` | Move down/up |
| `/` | Fuzzy search |
| `Enter` | View details |
| `o` | Open issues only |

For complete TUI reference, see [tui.md](tui.md).

## Recipes

Pre-configured filters for common needs:

```bash
bv --recipe actionable    # Ready to work (no blockers)
bv --recipe high-impact   # Top PageRank scores
bv --recipe bottlenecks   # High betweenness nodes
bv --recipe quick-wins    # Easy items, no blockers
bv --recipe stale         # Untouched 30+ days
bv -r triage              # Sorted by triage score
```

List available recipes:
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

### Agent Brief Export

Export a complete briefing bundle for agent handoff:

```bash
bv --agent-brief ./briefing-dir
```

Creates: `triage.json`, `insights.json`, `brief.md`, `helpers.md`

## Reference Files

| File | Content |
|------|---------|
| [robot-commands.md](robot-commands.md) | All `--robot-*` commands and JSON schemas |
| [metrics.md](metrics.md) | PageRank, betweenness, and graph metrics explained |
| [tui.md](tui.md) | TUI features, views, and keybindings |

## Guidelines

- Always use `--robot-*` flags for automation, never bare `bv` in scripts
- `--robot-triage` is the primary entry point - start there
- Check `blockers_to_clear` for highest-leverage work
- PageRank identifies foundational blockers
- Betweenness identifies bottlenecks
- Use `--label` to scope analysis to a subsystem
- Commit `.beads/` changes alongside code changes
