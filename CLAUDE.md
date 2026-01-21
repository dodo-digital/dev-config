# Dev Config

Power-user Claude Code setup with integrated tooling for agentic development.

## Quick Start (Every Task)

```bash
cm context "your task description" --json  # Get relevant rules from memory
cass search "keywords" --json --limit 5    # Find similar past work
bv --robot-triage                          # See AI-prioritized tasks
```

## Tool Overview

| Tool | Purpose | Primary Command |
|------|---------|-----------------|
| **cm** | Procedural memory - learned rules | `cm context "<task>" --json` |
| **cass** | Search past sessions | `cass search "<query>" --json` |
| **bd** | Task management with deps | `bd ready` |
| **bv** | AI task prioritization | `bv --robot-triage` |
| **oracle** | Call GPT-5 Pro when stuck | `oracle -f src/ "<question>"` |
| **ubs** | Static analysis (auto on save) | `ubs .` |

## Workflows

**Starting work:**
```bash
cm context "implement feature X" --json   # Get relevant rules
cass search "feature X" --json            # Find past similar work
bv --robot-triage                         # See prioritized tasks
```

**During development:**
```bash
bd close BEAD-123                         # Mark task complete
bd q "Follow-up task discovered"          # Quick capture new task
oracle -f src/problem/ "What's wrong?"    # When stuck, ask GPT-5 Pro
```

**End of session:**
```bash
cm reflect --days 1 --json                # Extract learnings
cass index --json                         # Index this session
```

## Task System (Beads)

Tasks have priorities (p0-p4) and dependencies. Completing one unblocks downstream.

```bash
bd q "New task"                           # Quick create
bd ready                                  # What's unblocked
bd close BEAD-XXX                         # Complete task
bd dep add BEAD-B --blocked-by BEAD-A     # Add dependency
```

`bv --robot-triage` uses PageRank to recommend highest-impact work.

## Memory System

Builds a playbook of rules learned from coding sessions.

```bash
cm context "<task>" --json                # Get rules for task
cm playbook add "lesson" --category X     # Add manual rule
cm reflect --days 7 --json                # Auto-extract rules
```

Categories: `debugging`, `testing`, `architecture`, `workflow`, `security`, `performance`

## Session Search (CASS)

```bash
cass search "query" --json --limit 10     # Search past sessions
cass view /path/to/file:42                # View specific result
cass index --json                         # Keep index fresh
```

## Oracle (GPT-5 Pro)

```bash
oracle "question"                         # Simple query
oracle -f src/ -f docs/ "question"        # With file context
oracle -m gemini-3-pro "question"         # Different model
```

## Hooks

| Hook | Trigger | Action |
|------|---------|--------|
| `git_safety_guard.py` | Before Bash | Blocks dangerous git ops |
| `on-file-write.sh` | After Write/Edit | Runs UBS static analysis |

## Plugins

- **compound-engineering**: Multi-agent workflows, code reviewers
- **agent-pipelines**: Ralph loops, autonomous pipelines, beads integration

## Directories

| Path | Purpose |
|------|---------|
| `.claude/pipeline-runs/` | Pipeline session data |
| `.beads/` | Task database |
| `docs/plans/` | Planning documents |

## Key Principle

**Fresh context every task.** Always start with `cm context` + `cass search`. The tools compound - the more you use them, the smarter they get.
