---
name: spawn-worker
description: Spawn Claude Code or Codex agents in tmux sessions with specific prompts. Use when the user wants to run background agents, spawn workers, create parallel coding sessions, or delegate tasks to other Claude instances.
---

<auto_trigger>
- "spawn worker"
- "spawn agent"
- "spawn claude"
- "spawn codex"
- "start worker"
- "run worker"
- "background agent"
- "parallel agent"
- "tmux session"
- "delegate task"
- "fire and forget"
</auto_trigger>

# Spawn Worker

Quickly spawn Claude Code or Codex agents in tmux sessions. Attach anytime to watch their progress live.

## Quick Start

**Spawn a worker:**
```bash
tmux new-session -d -s worker1 'claude --dangerously-skip-permissions "Fix all TypeScript errors in src/"'
```

**Attach to watch:**
```bash
tmux attach -t worker1
```

**Detach:** Press `Ctrl+B` then `D`

## Instructions

When the user wants to spawn a worker agent:

1. **Choose a session name** - Use descriptive names like `worker-fix-types`, `worker-refactor`, `agent-tests`

2. **Choose the CLI tool:**
   - `claude` - Claude Code (default, recommended)
   - `codex` - OpenAI Codex (uses different syntax!)

3. **Spawn the session:**

**For Claude:**
```bash
tmux new-session -d -s SESSION_NAME 'claude --dangerously-skip-permissions "PROMPT"'
```

**For Codex:**
```bash
tmux new-session -d -s SESSION_NAME 'codex exec --dangerously-bypass-approvals-and-sandbox "PROMPT"'
```

> **Note:** Codex requires `exec` subcommand and uses `--dangerously-bypass-approvals-and-sandbox` (not `--dangerously-skip-permissions`)

4. **Confirm to user** with attach command:
```
Worker spawned in tmux session: SESSION_NAME
Attach with: tmux attach -t SESSION_NAME
```

## Common Patterns

### Simple task worker
```bash
tmux new-session -d -s worker1 'claude --dangerously-skip-permissions "Add error handling to all API routes"'
```

### Worker in specific directory
```bash
tmux new-session -d -s worker-api -c ~/Projects/myapp 'claude --dangerously-skip-permissions "Write tests for the auth module"'
```

### Codex worker
```bash
tmux new-session -d -s codex1 'codex exec --dangerously-bypass-approvals-and-sandbox "Refactor the database layer"'
```

### Multiple workers in parallel
```bash
tmux new-session -d -s worker-frontend 'claude --dangerously-skip-permissions "Fix CSS issues in components/"'
tmux new-session -d -s worker-backend 'claude --dangerously-skip-permissions "Add input validation to controllers/"'
tmux new-session -d -s worker-tests 'claude --dangerously-skip-permissions "Write missing unit tests"'
```

## Managing Workers

**List all sessions:**
```bash
tmux ls
```

**Attach to a session:**
```bash
tmux attach -t SESSION_NAME
```

**Kill a session:**
```bash
tmux kill-session -t SESSION_NAME
```

**Kill all worker sessions:**
```bash
tmux ls | grep worker | cut -d: -f1 | xargs -I{} tmux kill-session -t {}
```

## Guidelines

- Always use `--dangerously-skip-permissions` for autonomous operation
- Use descriptive session names for easy identification
- Quote the prompt to handle special characters
- Use `-c /path` to set working directory if needed
- Workers run independently - attach anytime to check progress
- Detach with `Ctrl+B, D` to leave worker running
