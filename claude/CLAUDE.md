# Dev Config

This project uses the dev-config toolset for agentic development workflows.

## Installed Tools

| Tool | Purpose | Quick Reference |
|------|---------|-----------------|
| **ubs** | Static analysis for 7 languages | `ubs .` |
| **bd** | Dependency-aware task management | `bd ready` |
| **bv** | AI task prioritization (PageRank) | `bv --robot-triage` |
| **cm** | Procedural memory for coding agents | `cm context "<task>" --json` |
| **cass** | Search past coding sessions | `cass search "<query>" --json` |
| **oracle** | Cross-model consultation | `oracle "<question>"` |

## Hooks Active

| Hook | Trigger | Action |
|------|---------|--------|
| `git_safety_guard.py` | Before Bash | Blocks dangerous git ops |
| `on-file-write.sh` | After Write/Edit | Runs UBS static analysis |
| `cass-index-on-exit.sh` | Session End | Indexes session for search |
| `skill-router/` | Prompt Submit | Auto-suggests relevant skills |

## Starting Any Task

```bash
cm context "task description" --json   # Get relevant rules from memory
cass search "keywords" --json          # Find similar past work
```

## Task Management (Beads)

```bash
bd q "New task"                        # Quick create
bd ready                               # What's unblocked
bd close BEAD-XXX                      # Complete task
bv --robot-triage                      # AI-prioritized recommendations
```
