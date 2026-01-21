# Beads Agent Workflows

Workflow patterns and recipes for agents using the beads task management system.

## Session Lifecycle

### Session Start

```bash
# Get workflow context
bd prime

# Find ready work (unblocked tasks)
bd ready --json

# Claim a task (atomic: sets assignee + status)
bd update bd-abc123 --claim
```

### During Work

```bash
# Create discovered subtasks
SUBTASK=$(bd q "Found: missing validation" --parent bd-abc123)
bd dep add $SUBTASK bd-abc123

# Update progress notes
bd update bd-abc123 --notes "Implemented auth flow"

# Mark task blocked if waiting on something
bd update bd-abc123 -s blocked
```

### Session End

```bash
# Close completed work
bd close bd-abc123 -r "Implemented in commit xyz"

# File issues for remaining/discovered work
bd q "Follow-up: add rate limiting" -p 2

# Sync with git (critical for persistence)
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

Create a sequence where each task depends on the previous:

```bash
A=$(bd q "Create database schema")
B=$(bd q "Implement API endpoints")
C=$(bd q "Build frontend")
D=$(bd q "Deploy to staging")

bd dep add $B $A  # B depends on A
bd dep add $C $B  # C depends on B
bd dep add $D $C  # D depends on C
```

### Parallel Workstreams with Shared Dependency

```bash
SHARED=$(bd q "Set up CI pipeline")
FRONTEND=$(bd q "Frontend development")
BACKEND=$(bd q "Backend development")
DEPLOY=$(bd q "Deploy to production")

bd dep add $FRONTEND $SHARED
bd dep add $BACKEND $SHARED
bd dep add $DEPLOY $FRONTEND
bd dep add $DEPLOY $BACKEND
```

### Bug Triage Pattern

```bash
# Create bug with high priority
BUG=$(bd q "Critical: Login fails for users with special chars" -t bug -p 0)

# Add investigation subtask
INVESTIGATE=$(bd q "Investigate root cause" --parent $BUG)
bd dep add $BUG $INVESTIGATE  # Fix depends on investigation

# After investigation, add specific fix task
FIX=$(bd q "Escape special characters in username" --parent $BUG)
bd dep add $BUG $FIX

# Close investigation
bd close $INVESTIGATE -r "Found: special chars not escaped in SQL query"
```

### Feature Branch Workflow

```bash
# Create feature epic
FEATURE=$(bd q "Add dark mode support" -t epic -p 1 -l feature,ui)

# Break down into tasks
DESIGN=$(bd q "Design dark mode color palette" --parent $FEATURE -l design)
IMPL=$(bd q "Implement theme toggle" --parent $FEATURE)
PERSIST=$(bd q "Persist theme preference" --parent $FEATURE)
TEST=$(bd q "Add dark mode tests" --parent $FEATURE -l testing)

# Set up dependencies
bd dep add $IMPL $DESIGN      # Implementation after design
bd dep add $PERSIST $IMPL     # Persistence after implementation
bd dep add $TEST $IMPL        # Tests can start after implementation
```

## Multi-Agent Coordination

### Handoff Between Agents

Agent 1 completes work and creates handoff:

```bash
# Complete current task
bd close bd-abc123 -r "API implemented, ready for frontend integration"

# Create follow-up task with context
NEXT=$(bd q "Integrate API with frontend" -p 1)
bd update $NEXT --notes "API endpoint: POST /api/auth/login, see commit abc123"

# Sync so other agents can see it
bd sync
```

Agent 2 picks up work:

```bash
bd sync              # Get latest
bd ready --json      # Find handoff task
bd update $NEXT --claim
```

### Parallel Agent Work

Each agent works on independent ready tasks:

```bash
# Agent 1
bd ready --json                    # See all ready tasks
bd update bd-task1 --claim         # Claim first ready task

# Agent 2 (different session)
bd ready --json                    # Same task now claimed
bd update bd-task2 --claim         # Claim different task
```

### Blocking Discovery

When an agent discovers a blocking issue:

```bash
# Create blocking task
BLOCKER=$(bd q "Database migration required first" -p 1)

# Add it as dependency to current work
bd dep add bd-current $BLOCKER

# Update status (now blocked)
bd update bd-current -s blocked --notes "Discovered need for migration"

# Work on blocker or sync for another agent
bd sync
```

## Best Practices

### Task Granularity

- Tasks should be completable in a single session (1-4 hours)
- Epics contain multiple tasks
- Use subtasks (`--parent`) for breakdown within features

### Claiming Work

```bash
# Always claim before starting
bd update bd-abc123 --claim

# Don't work on unclaimed tasks - another agent might take it
```

### Progress Tracking

```bash
# Add notes during work
bd update bd-abc123 --notes "Completed API layer, starting frontend"

# Use labels for status
bd update bd-abc123 --add-label wip
bd update bd-abc123 --remove-label wip
bd update bd-abc123 --add-label review-needed
```

### Sync Discipline

```bash
# Start of session
bd sync

# After significant progress
bd sync

# End of session (critical)
bd sync
git push  # Work not complete until pushed
```

### Error Handling

If sync fails:

```bash
# Check for conflicts
bd sync --dry-run

# Import only to see remote changes
bd sync --import-only

# Resolve conflicts in .beads/ files
# Then full sync
bd sync
```

## View Task Graph

Visualize task relationships:

```bash
bd graph bd-epic123
```

Output shows:
- White: open (ready to work)
- Yellow: in_progress
- Red: blocked
- Green: closed
