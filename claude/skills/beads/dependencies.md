# Beads Dependency Management

Deep dive into dependency management with beads. Dependencies are the core feature that makes beads powerful for managing complex work.

## Core Concepts

### Dependency Direction

When you add a dependency:

```bash
bd dep add bd-child bd-parent
```

This means: **bd-child depends on bd-parent** (parent blocks child)

- `bd-parent` must be completed before `bd-child` can start
- `bd-child` will have status `blocked` until `bd-parent` is closed
- `bd-parent` appears in `bd ready`, `bd-child` does not

### The Ready Queue

`bd ready` shows tasks with **no blocking dependencies**:

```bash
bd ready --json
```

This is the primary way to find work. Tasks only appear here when:
1. Status is `open` or `in_progress`
2. All `blocks` dependencies are `closed`
3. Not assigned to someone else (unless using `-a`)

## Dependency Types

### blocks (default)

Hard dependency - must complete before dependent can start.

```bash
bd dep add bd-child bd-parent
# or explicitly:
bd dep add bd-child bd-parent -t blocks
```

Use for:
- Sequential work
- Prerequisites
- Gatekeeping (code review before merge)

### tracks

Soft tracking - related but doesn't block.

```bash
bd dep add bd-task bd-tracked -t tracks
```

Use for:
- Monitoring related work
- Cross-team visibility
- External dependencies you're watching

### related

Informational link - no blocking, just reference.

```bash
bd dep add bd-task bd-related -t related
```

Use for:
- Similar bugs
- Related features
- Documentation links

### parent-child

Hierarchy relationship for epics and subtasks.

```bash
bd q "Subtask" --parent bd-epic123
```

This creates:
- Subtask with parent reference
- `parent-child` dependency type
- Epic can aggregate subtask status

### discovered-from

Auto-created when finding related work during investigation.

```bash
# Created automatically when using discovery workflows
bd dep add bd-new bd-original -t discovered-from
```

## Commands

### Add Dependency

```bash
bd dep add <child-id> <parent-id> [-t type]
```

Examples:
```bash
bd dep add bd-deploy bd-test           # deploy after test
bd dep add bd-feature bd-design -t blocks
bd dep add bd-bug bd-related -t related
```

### List Dependencies

```bash
bd dep list <task-id> --json
```

Output includes:
- Dependencies this task has (what blocks it)
- Dependents of this task (what it blocks)
- Dependency types

### View Dependency Tree

```bash
bd dep tree <task-id>
```

Shows hierarchical view:
```
bd-epic123 User Authentication
├── bd-design Design auth flow [closed]
├── bd-impl Implement login [in_progress]
│   └── bd-test Write tests [blocked]
└── bd-deploy Deploy [blocked]
```

### Remove Dependency

```bash
bd dep remove <child-id> <parent-id>
```

### Detect Cycles

```bash
bd dep cycles
```

Finds circular dependencies that would cause deadlock.

## Visualizing Dependencies

### ASCII Graph

```bash
bd graph <task-id>
```

Output:
```
┌──────────┐
│ bd-design│ ← GREEN (closed)
└────┬─────┘
     │
┌────▼─────┐
│ bd-impl  │ ← YELLOW (in_progress)
└────┬─────┘
     │
┌────▼─────┐
│ bd-test  │ ← RED (blocked)
└──────────┘
```

Colors:
- White: open (ready to work)
- Yellow: in_progress
- Red: blocked
- Green: closed

## Patterns

### Linear Chain

```bash
A=$(bd q "Step 1: Schema")
B=$(bd q "Step 2: API")
C=$(bd q "Step 3: Frontend")
D=$(bd q "Step 4: Deploy")

bd dep add $B $A
bd dep add $C $B
bd dep add $D $C
```

Result: A -> B -> C -> D (serial execution)

### Fan-out (Parallel Work)

```bash
SETUP=$(bd q "Setup infrastructure")
FEAT1=$(bd q "Feature A")
FEAT2=$(bd q "Feature B")
FEAT3=$(bd q "Feature C")

bd dep add $FEAT1 $SETUP
bd dep add $FEAT2 $SETUP
bd dep add $FEAT3 $SETUP
```

Result: After SETUP completes, all features are ready simultaneously.

### Fan-in (Merge Point)

```bash
FEAT1=$(bd q "Feature A")
FEAT2=$(bd q "Feature B")
FEAT3=$(bd q "Feature C")
RELEASE=$(bd q "Release")

bd dep add $RELEASE $FEAT1
bd dep add $RELEASE $FEAT2
bd dep add $RELEASE $FEAT3
```

Result: RELEASE only becomes ready when all features are closed.

### Diamond Pattern

```bash
START=$(bd q "Start")
PATH_A=$(bd q "Path A")
PATH_B=$(bd q "Path B")
END=$(bd q "End")

bd dep add $PATH_A $START
bd dep add $PATH_B $START
bd dep add $END $PATH_A
bd dep add $END $PATH_B
```

Result: START -> (PATH_A || PATH_B) -> END

### Epic with Gated Phases

```bash
EPIC=$(bd q "Major Feature" -t epic)

# Phase 1: Design
DESIGN=$(bd q "Design" --parent $EPIC)

# Phase 2: Implementation (depends on design)
IMPL=$(bd q "Implement" --parent $EPIC)
bd dep add $IMPL $DESIGN

# Phase 3: Testing (depends on implementation)
TEST=$(bd q "Test" --parent $EPIC)
bd dep add $TEST $IMPL

# Phase 4: Deploy (depends on testing)
DEPLOY=$(bd q "Deploy" --parent $EPIC)
bd dep add $DEPLOY $TEST
```

## Best Practices

### Avoid Deep Chains

Keep dependency chains shallow (3-5 levels max). Deep chains:
- Create bottlenecks
- Make it hard to parallelize
- Increase risk of blocking

### Use Fan-out for Parallelism

When work can happen in parallel, model it that way:

```bash
# Good: Parallel after setup
bd dep add $task1 $setup
bd dep add $task2 $setup
bd dep add $task3 $setup

# Avoid: Unnecessary serialization
bd dep add $task2 $task1  # Unless truly required
bd dep add $task3 $task2
```

### Check for Cycles

Before complex dependency changes:

```bash
bd dep cycles
```

Cycles cause tasks to be perpetually blocked.

### Use Appropriate Types

- `blocks` for hard prerequisites
- `tracks` for monitoring
- `related` for reference

Don't overuse `blocks` - it creates artificial bottlenecks.

### Document Why

When adding non-obvious dependencies:

```bash
bd dep add $task $blocker
bd update $task --notes "Blocked by $blocker because we need the API schema first"
```

## Troubleshooting

### Task Stuck in Blocked

```bash
# Check what's blocking it
bd dep list bd-stuck --json

# Look for unclosed blockers
bd show bd-blocker --json
```

### Unexpected Ready State

```bash
# Check all dependencies
bd dep list bd-task --json

# Verify blocker status
bd show bd-blocker --json
```

### Circular Dependencies

```bash
# Detect cycles
bd dep cycles

# Break the cycle by removing one dependency
bd dep remove bd-task bd-other
```
