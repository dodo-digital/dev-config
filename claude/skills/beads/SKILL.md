---
name: beads-task-management
description: Manages tasks with first-class dependency support using the bd (beads) CLI. Use when tracking work items, creating tasks with dependencies, finding ready work, managing priorities (P0-P4), organizing with labels, or visualizing task graphs. Triggers on task management, issue tracking, dependency chains, or mentions of bd/beads.
---

# Beads (bd) Task Management

A distributed, git-backed task tracker with first-class dependency support. Tasks chain together like beads on a string.

## Quick Start

```bash
# Find work ready to do (no blockers)
bd ready --json

# Create a task
bd q "Fix authentication bug" -p 1

# Claim and start working
bd update bd-abc123 --claim

# Close when done
bd close bd-abc123

# Sync with git at end of session
bd sync
```

## Core Concepts

| Concept | Description |
|---------|-------------|
| **Hash-based IDs** | Tasks use format `bd-a1b2` (prefix + hash). Eliminates merge conflicts. |
| **Dependencies** | Tasks can block other tasks. Only unblocked tasks appear in `bd ready`. |
| **Priority levels** | P0 (critical) through P4 (lowest). Default is P2. |
| **Git-backed** | Tasks stored as JSONL in `.beads/` directory, versioned with git. |

## Essential Commands

### Find Ready Work

```bash
bd ready --json              # Unblocked tasks (default limit 10)
bd ready -p 0 --json         # Filter by priority
bd ready -l backend --json   # Filter by label
bd ready -u --json           # Unassigned only
```

### Create Tasks

```bash
bd q "Fix login validation"              # Basic task
bd q "Critical security fix" -p 0        # With priority
bd q "Add caching" -l backend,perf       # With labels
bd q "Memory leak" -t bug                # With type
```

### Update Tasks

**IMPORTANT:** Never use `bd edit` - it opens an interactive editor. Use `bd update`:

```bash
bd update bd-abc123 --claim              # Atomic: sets assignee + in_progress
bd update bd-abc123 -s in_progress       # Update status
bd update bd-abc123 -p 0                 # Update priority
bd update bd-abc123 --add-label urgent   # Add label
```

### Close Tasks

```bash
bd close bd-abc123                       # Close single task
bd close bd-abc123 -r "Fixed in abc"     # With reason
bd close bd-abc123 --suggest-next        # Show what's unblocked
```

### Manage Dependencies

```bash
bd dep add bd-child bd-parent            # child depends on parent
bd dep list bd-abc123 --json             # List dependencies
bd dep tree bd-abc123                    # Show dependency tree
bd graph bd-abc123                       # Visual ASCII graph
```

## Priority & Status

| Priority | Meaning |
|----------|---------|
| P0 | Critical - production down, security |
| P1 | High - important blockers |
| P2 | Medium - normal work (default) |
| P3 | Low - nice-to-have |
| P4 | Lowest - backlog |

| Status | Meaning |
|--------|---------|
| `open` | Ready to work on |
| `in_progress` | Currently being worked on |
| `blocked` | Waiting on dependencies |
| `closed` | Completed |

## Global Flags

| Flag | Purpose |
|------|---------|
| `--json` | JSON output for parsing |
| `--quiet` | Suppress non-essential output |
| `--sandbox` | Disable daemon and auto-sync |

## Reference Documentation

For detailed documentation, see:

- [commands.md](commands.md) - Full command reference with all options
- [workflows.md](workflows.md) - Agent workflow patterns and common recipes
- [dependencies.md](dependencies.md) - Dependency management deep dive

## Guidelines

- Always use `--json` flag when parsing output programmatically
- Use `bd q` for quick task creation (outputs only ID)
- Never use `bd edit` - use `bd update` with specific flags
- Use `bd ready` to find unblocked work, not `bd list`
- Run `bd sync` at end of session to persist changes
- Work is not complete until `git push` succeeds after `bd sync`
