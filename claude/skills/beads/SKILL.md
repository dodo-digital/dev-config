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

# Close when done
bd close bd-abc123
```

## Core Concepts

**Hash-based IDs:** Tasks use format `bd-a1b2` (prefix + hash). Eliminates merge conflicts in multi-agent workflows.

**Dependencies:** Tasks can block other tasks. Only unblocked tasks appear in `bd ready`.

**Priority levels:** P0 (critical) through P4 (lowest). Default is P2.

**Git-backed:** Tasks stored as JSONL in `.beads/` directory, versioned with git.

## Finding Ready Work

```bash
# Show unblocked tasks (default limit 10)
bd ready --json

# Filter by priority
bd ready -p 0 --json

# Filter by label
bd ready -l backend --json

# Filter by assignee
bd ready -a claude --json

# Show unassigned only
bd ready -u --json
```

## Creating Tasks

### Quick Capture (Preferred for Agents)

Outputs only the task ID - ideal for scripting:

```bash
# Basic task
bd q "Fix login validation"

# With priority (0=highest, 4=lowest)
bd q "Critical security fix" -p 0

# With labels
bd q "Add caching layer" -l backend,performance

# With type
bd q "Memory leak in auth" -t bug
```

### Full Create Command

For more options:

```bash
# With description
bd create "Implement OAuth" -d "Add Google OAuth support" -p 1 -t feature

# With assignee
bd create "Review PR" -a alice -p 2

# With estimate (minutes)
bd create "Write tests" -e 120

# With acceptance criteria
bd create "Add dark mode" --acceptance "Toggle works, persists across sessions"

# Create as child of epic
bd create "API endpoint" --parent bd-epic123

# Create with dependencies
bd create "Deploy" --deps "bd-abc,bd-def"
```

### Task Types

`-t/--type`: bug, feature, task, epic, chore, merge-request

## Viewing Tasks

### List Tasks

```bash
# Open tasks (default)
bd list --json

# All tasks including closed
bd list --all --json

# Filter by status
bd list -s open --json
bd list -s in_progress --json
bd list -s blocked --json

# Filter by priority
bd list -p 0 --json

# Filter by label
bd list -l urgent --json

# Filter by type
bd list -t bug --json

# Filter by assignee
bd list -a claude --json

# Show children of an epic
bd list --parent bd-epic123 --json
```

### Show Task Details

```bash
# Full details
bd show bd-abc123 --json

# Compact one-line
bd show bd-abc123 --short

# Show what references this task
bd show bd-abc123 --refs
```

### Search Tasks

```bash
bd search "authentication" --json
```

## Managing Dependencies

### Add Dependencies

```bash
# bd-child depends on bd-parent (parent blocks child)
bd dep add bd-child bd-parent

# Specify dependency type
bd dep add bd-child bd-parent -t blocks
```

### Dependency Types

| Type | Meaning |
|------|---------|
| `blocks` | Must complete before dependent can start (default) |
| `tracks` | Soft tracking, doesn't block |
| `related` | Related issues, no blocking |
| `parent-child` | Epic/subtask hierarchy |
| `discovered-from` | Auto-created when finding related work |

### View Dependencies

```bash
# List dependencies of a task
bd dep list bd-abc123 --json

# Show dependency tree
bd dep tree bd-abc123

# Visual graph (ASCII art)
bd graph bd-abc123

# Detect cycles
bd dep cycles
```

### Remove Dependencies

```bash
bd dep remove bd-child bd-parent
```

## Updating Tasks

**IMPORTANT:** Never use `bd edit` - it opens an interactive editor. Use `bd update` with flags:

```bash
# Update status
bd update bd-abc123 -s in_progress
bd update bd-abc123 -s blocked
bd update bd-abc123 -s open

# Claim task (atomic: sets assignee + in_progress)
bd update bd-abc123 --claim

# Update priority
bd update bd-abc123 -p 0

# Update title
bd update bd-abc123 --title "New title"

# Update description
bd update bd-abc123 -d "New description"

# Add/remove labels
bd update bd-abc123 --add-label urgent
bd update bd-abc123 --remove-label wip

# Update assignee
bd update bd-abc123 -a claude
```

## Closing Tasks

```bash
# Close single task
bd close bd-abc123

# Close with reason
bd close bd-abc123 -r "Fixed in commit abc123"

# Close multiple
bd close bd-abc bd-def bd-ghi

# Close and show what's unblocked
bd close bd-abc123 --suggest-next
```

## Labels

```bash
# Add label to task
bd label add bd-abc123 urgent

# Remove label
bd label remove bd-abc123 wip

# List labels on a task
bd label list bd-abc123 --json

# List all labels in database
bd label list-all --json
```

## Priority System

| Priority | Meaning | Use Case |
|----------|---------|----------|
| P0 | Critical | Production down, security issues |
| P1 | High | Important blockers, urgent features |
| P2 | Medium | Normal work (default) |
| P3 | Low | Nice-to-have, minor improvements |
| P4 | Lowest | Backlog, someday/maybe |

## Status Values

| Status | Meaning |
|--------|---------|
| `open` | Ready to work on |
| `in_progress` | Currently being worked on |
| `blocked` | Waiting on dependencies |
| `deferred` | Postponed for later |
| `closed` | Completed |

## Syncing with Git

```bash
# Full sync (export, commit, pull, import, push)
bd sync

# Just export to JSONL
bd sync --flush-only

# Just import from JSONL
bd sync --import-only

# Preview without changes
bd sync --dry-run
```

## Agent Workflow

### Session Start

```bash
# Get workflow context
bd prime

# Find ready work
bd ready --json

# Claim a task
bd update bd-abc123 --claim
```

### During Work

```bash
# Create discovered subtasks
SUBTASK=$(bd q "Found: missing validation" --parent bd-abc123)
bd dep add $SUBTASK bd-abc123

# Update progress
bd update bd-abc123 --notes "Implemented auth flow"
```

### Session End

```bash
# Close completed work
bd close bd-abc123 -r "Implemented in commit xyz"

# File issues for remaining work
bd q "Follow-up: add rate limiting" -p 2

# Sync with git
bd sync
```

## Common Patterns

### Create Epic with Subtasks

```bash
EPIC=$(bd q "User authentication system" -t epic -p 1)
bd q "Design auth flow" --parent $EPIC
bd q "Implement login" --parent $EPIC
bd q "Add logout" --parent $EPIC
bd q "Write tests" --parent $EPIC
```

### Chain Dependent Tasks

```bash
A=$(bd q "Create database schema")
B=$(bd q "Implement API endpoints")
C=$(bd q "Build frontend")
D=$(bd q "Deploy to staging")

bd dep add $B $A  # B depends on A
bd dep add $C $B  # C depends on B
bd dep add $D $C  # D depends on C
```

### View Task Graph

```bash
bd graph $EPIC
# Shows ASCII visualization with colors:
# White: open (ready)
# Yellow: in_progress
# Red: blocked
# Green: closed
```

## Global Flags

| Flag | Purpose |
|------|---------|
| `--json` | JSON output for parsing |
| `--quiet` | Suppress non-essential output |
| `--sandbox` | Disable daemon and auto-sync |
| `--readonly` | Block write operations |

## Guidelines

- Always use `--json` flag when parsing output programmatically
- Use `bd q` for quick task creation (outputs only ID)
- Never use `bd edit` - use `bd update` with specific flags
- Use `bd ready` to find unblocked work, not `bd list`
- Run `bd sync` at end of session to persist changes
- Work is not complete until `git push` succeeds after `bd sync`
