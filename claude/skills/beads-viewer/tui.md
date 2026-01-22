# TUI Features and Keybindings

Launch the interactive terminal UI with:

```bash
bv
```

## Views

Press these keys to switch between views:

| Key | View | Purpose |
|-----|------|---------|
| `b` | Kanban Board | Traditional status columns |
| `g` | Dependency Graph | Visual task dependencies |
| `i` | Insights Dashboard | PageRank, metrics, health |
| `h` | History View | Git correlation, timeline |
| `a` | Actionable Plan | Parallel execution tracks |
| `f` | Flow Matrix | Cross-label dependencies |
| `]` | Attention View | Label priority ranking |

## Navigation

| Key | Action |
|-----|--------|
| `j` | Move down |
| `k` | Move up |
| `g` | Jump to first item |
| `G` | Jump to last item |
| `/` | Fuzzy search |
| `Enter` | View item details |
| `Tab` | Toggle detail panel |
| `Esc` | Close panel / cancel |

## Filtering

| Key | Filter |
|-----|--------|
| `o` | Open issues only |
| `c` | Closed issues only |
| `r` | Ready (no blockers) |
| `s` | Cycle sort modes |

Sort modes cycle through:
- Impact score (default)
- Priority
- Created date
- Updated date
- PageRank
- Betweenness

## Actions

| Key | Action |
|-----|--------|
| `y` | Copy issue ID to clipboard |
| `C` | Copy as Markdown |
| `E` | Export to file |
| `O` | Open in editor ($EDITOR) |
| `t` | Time-travel compare |
| `?` | Show help |
| `q` | Quit |

## Kanban Board (`b`)

Traditional Kanban with columns for each status:
- Open
- In Progress
- Blocked
- Closed

Navigate between columns with `h`/`l` or arrow keys.

## Dependency Graph (`g`)

Visual representation of task dependencies.

- Nodes are tasks
- Edges show "blocks" relationships
- Node size indicates PageRank
- Colors indicate status
- Highlighted path shows critical path

Navigation:
- `+`/`-` to zoom
- Arrow keys to pan
- `Enter` to select focused node

## Insights Dashboard (`i`)

Metrics overview:
- Top PageRank tasks
- Bottlenecks (high betweenness)
- Cycle warnings
- Project health summary
- Label health breakdown

## Actionable Plan (`a`)

Parallel execution tracks respecting dependencies:
- Track 1: Tasks with no blockers (start immediately)
- Track 2: Tasks unblocked after Track 1
- Track N: Subsequent waves

Useful for:
- Sprint planning
- Parallel agent assignment
- Understanding execution order

## Flow Matrix (`f`)

Cross-label dependency visualization:
- Rows and columns are labels
- Cells show dependency count
- Highlights integration points

Useful for understanding how subsystems interact.

## History View (`h`)

Git correlation:
- Shows commits associated with tasks
- Timeline of task activity
- Correlation strength indicators

Requires git history in the repository.

## Time Travel (`t`)

Compare current state to a previous point:

1. Press `t`
2. Enter reference (tag, commit, date)
3. See diff: new tasks, closed tasks, changed priorities

Useful for:
- Sprint retrospectives
- Progress tracking
- Drift detection

## Tips

- **Quick triage**: `bv` then `a` for actionable view
- **Find specific task**: `/` then type partial ID or title
- **Copy for standup**: Select task, `C` for Markdown
- **Deep dive**: Select task, `Tab` for detail panel
- **Focus on ready work**: `r` to filter to ready tasks
