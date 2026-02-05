# Dev Config Agent Instructions

You have access to enhanced tooling for agentic development. Follow these behaviors automatically.

## On Task Start

Before beginning any non-trivial task, gather context:
1. Run `cm context "<task description>" --json` to get relevant learned rules
2. Run `cass search "<keywords>" --json --limit 5` to find similar past work
3. Apply any relevant patterns or lessons from the results

## Task Management

Use beads (`bd`) for tracking work with dependencies:
- `bd q "task description"` — quick-create a task
- `bd ready` — see unblocked tasks
- `bd close BEAD-XXX` — mark complete
- `bv --robot-triage` — get AI-prioritized recommendations

When the user asks "what should I work on" or similar, run `bv --robot-triage`.

## When Stuck

If you've tried 2-3 approaches without success, consult another model:
```bash
oracle "your question"
oracle -f src/ "question with file context"
```

## On Session End

The `cass-index-on-exit.sh` hook automatically indexes your session. No action needed.

## Active Hooks

These run automatically:
- **git_safety_guard.py** — blocks dangerous git ops (force push, hard reset)
- **on-file-write.sh** — runs static analysis on file saves
- **skill-router/** — suggests relevant skills based on prompts

## Tool Reference

| Tool | Purpose |
|------|---------|
| `cm` | Procedural memory — learned rules and patterns |
| `cass` | Session search — find past solutions |
| `bd` | Task management with dependencies |
| `bv` | AI task prioritization (PageRank algorithm) |
| `oracle` | Cross-model consultation (GPT-5, Gemini, etc.) |
| `ubs` | Static analysis for 7 languages |
