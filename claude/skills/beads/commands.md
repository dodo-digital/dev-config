# Beads Command Reference

Complete reference for all `bd` (beads) CLI commands with full option documentation.

## Finding Tasks

### bd ready

Show tasks that are ready to work on (no blocking dependencies).

```bash
bd ready --json                    # Default limit 10
bd ready -p 0 --json               # Filter by priority
bd ready -l backend --json         # Filter by label
bd ready -a claude --json          # Filter by assignee
bd ready -u --json                 # Unassigned only
bd ready --limit 20 --json         # Custom limit
```

### bd list

List tasks with filtering options.

```bash
bd list --json                     # Open tasks (default)
bd list --all --json               # All tasks including closed
bd list -s open --json             # Filter by status
bd list -s in_progress --json
bd list -s blocked --json
bd list -p 0 --json                # Filter by priority
bd list -l urgent --json           # Filter by label
bd list -t bug --json              # Filter by type
bd list -a claude --json           # Filter by assignee
bd list --parent bd-epic123 --json # Children of an epic
```

### bd search

Search task titles and descriptions.

```bash
bd search "authentication" --json
```

### bd show

Display task details.

```bash
bd show bd-abc123 --json           # Full details
bd show bd-abc123 --short          # Compact one-line
bd show bd-abc123 --refs           # Show what references this task
```

### bd prime

Get workflow context for session start.

```bash
bd prime
```

## Creating Tasks

### bd q (Quick Capture)

Create a task with minimal output - returns only the task ID. Preferred for scripting and agents.

```bash
bd q "Fix login validation"
bd q "Critical security fix" -p 0
bd q "Add caching layer" -l backend,performance
bd q "Memory leak in auth" -t bug
bd q "Subtask" --parent bd-epic123
```

**Options:**
| Flag | Description |
|------|-------------|
| `-p, --priority` | Priority 0-4 (0=highest) |
| `-l, --labels` | Comma-separated labels |
| `-t, --type` | Task type |
| `--parent` | Parent task ID |

### bd create

Full task creation with all options.

```bash
bd create "Implement OAuth" -d "Add Google OAuth support" -p 1 -t feature
bd create "Review PR" -a alice -p 2
bd create "Write tests" -e 120
bd create "Add dark mode" --acceptance "Toggle works, persists across sessions"
bd create "API endpoint" --parent bd-epic123
bd create "Deploy" --deps "bd-abc,bd-def"
```

**Options:**
| Flag | Description |
|------|-------------|
| `-d, --description` | Task description |
| `-p, --priority` | Priority 0-4 |
| `-t, --type` | Task type |
| `-a, --assignee` | Assignee name |
| `-e, --estimate` | Estimate in minutes |
| `-l, --labels` | Comma-separated labels |
| `--acceptance` | Acceptance criteria |
| `--parent` | Parent task ID |
| `--deps` | Comma-separated dependency IDs |

### Task Types

Available types for `-t/--type`:

- `bug` - Bug report
- `feature` - New feature
- `task` - General task
- `epic` - Epic (container for subtasks)
- `chore` - Maintenance work
- `merge-request` - Code review

## Updating Tasks

### bd update

Update task properties. **Never use `bd edit`** - it opens an interactive editor.

```bash
# Status updates
bd update bd-abc123 -s in_progress
bd update bd-abc123 -s blocked
bd update bd-abc123 -s open
bd update bd-abc123 -s deferred

# Claim task (atomic: sets assignee + in_progress)
bd update bd-abc123 --claim

# Other updates
bd update bd-abc123 -p 0                      # Priority
bd update bd-abc123 --title "New title"       # Title
bd update bd-abc123 -d "New description"      # Description
bd update bd-abc123 -a claude                 # Assignee
bd update bd-abc123 --notes "Progress note"   # Add notes

# Labels
bd update bd-abc123 --add-label urgent
bd update bd-abc123 --remove-label wip
```

**Options:**
| Flag | Description |
|------|-------------|
| `-s, --status` | Update status |
| `--claim` | Atomic claim (assignee + in_progress) |
| `-p, --priority` | Update priority |
| `--title` | Update title |
| `-d, --description` | Update description |
| `-a, --assignee` | Update assignee |
| `--notes` | Add progress notes |
| `--add-label` | Add a label |
| `--remove-label` | Remove a label |

## Closing Tasks

### bd close

Mark tasks as completed.

```bash
bd close bd-abc123                     # Close single task
bd close bd-abc123 -r "Fixed in xyz"   # With reason
bd close bd-abc bd-def bd-ghi          # Close multiple
bd close bd-abc123 --suggest-next      # Show what's unblocked
```

**Options:**
| Flag | Description |
|------|-------------|
| `-r, --reason` | Closure reason |
| `--suggest-next` | Show newly unblocked tasks |

## Labels

### bd label

Manage task labels.

```bash
bd label add bd-abc123 urgent          # Add label
bd label remove bd-abc123 wip          # Remove label
bd label list bd-abc123 --json         # List labels on task
bd label list-all --json               # List all labels in database
```

## Dependencies

### bd dep

Manage task dependencies.

```bash
# Add dependency (child depends on parent)
bd dep add bd-child bd-parent
bd dep add bd-child bd-parent -t blocks    # Specify type

# View dependencies
bd dep list bd-abc123 --json
bd dep tree bd-abc123

# Remove dependency
bd dep remove bd-child bd-parent

# Detect cycles
bd dep cycles
```

See [dependencies.md](dependencies.md) for detailed dependency documentation.

### bd graph

Visualize task graph with ASCII art.

```bash
bd graph bd-abc123
```

Colors:
- White: open (ready)
- Yellow: in_progress
- Red: blocked
- Green: closed

## Syncing

### bd sync

Synchronize with git.

```bash
bd sync                    # Full sync (export, commit, pull, import, push)
bd sync --flush-only       # Just export to JSONL
bd sync --import-only      # Just import from JSONL
bd sync --dry-run          # Preview without changes
```

## Reference Tables

### Status Values

| Status | Meaning |
|--------|---------|
| `open` | Ready to work on |
| `in_progress` | Currently being worked on |
| `blocked` | Waiting on dependencies |
| `deferred` | Postponed for later |
| `closed` | Completed |

### Priority Levels

| Priority | Meaning | Use Case |
|----------|---------|----------|
| P0 | Critical | Production down, security issues |
| P1 | High | Important blockers, urgent features |
| P2 | Medium | Normal work (default) |
| P3 | Low | Nice-to-have, minor improvements |
| P4 | Lowest | Backlog, someday/maybe |

### Global Flags

| Flag | Purpose |
|------|---------|
| `--json` | JSON output for parsing |
| `--quiet` | Suppress non-essential output |
| `--sandbox` | Disable daemon and auto-sync |
| `--readonly` | Block write operations |
