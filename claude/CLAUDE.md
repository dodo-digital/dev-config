# VPS: vmi2997899 (Contabo US Central)

## Primary Role

This Claude instance manages the Linux VPS. Main responsibilities:
- Navigate and manage the Linux environment
- Spawn worker agents in tmux sessions or via the agent pipeline system (`~/Projects/agent-pipelines/`)
- Orchestrate tasks across multiple Claude instances

## Tailscale Network

| Device | IP |
|--------|-----|
| This VPS | 100.95.25.7 |
| MacBook Pro | 100.121.233.114 |
| iPhone 14 | 100.98.192.27 |

## VibeTunnel (Mobile Terminal)

- **URL**: `http://100.95.25.7:4020`
- **Auth**: Running with `--no-auth`
- **Runs as systemd service** - auto-starts on boot

```bash
sudo systemctl [status|restart|stop] vibetunnel
sudo journalctl -u vibetunnel -f   # view logs
```

### If VibeTunnel Breaks After Update
```bash
cd /usr/lib/node_modules/vibetunnel && sudo npm install chokidar
sudo systemctl restart vibetunnel
```

## Services Running

| Service | Port | Purpose |
|---------|------|---------|
| VibeTunnel | 4020 | Mobile terminal access |
| PostgreSQL | 5432 | Database (localhost only) |
| Tailscale | - | VPN mesh network |
| SSH | 22 | Remote access |

## Directory Structure

| Path | Purpose |
|------|---------|
| `~/Projects/` | Main projects |
| `~/Projects/agent-pipelines/` | Agent orchestration system |
| `~/Development/` | Development work |
| `~/products/` | Product files |

## Shell Aliases & Quirks

- `grep` → `rg` (ripgrep) - use `/usr/bin/grep` for real grep
- Bun shadows Node.js in PATH - use `/usr/bin/node` for real Node

## Key Paths

| Tool | Path |
|------|------|
| Node.js (real) | `/usr/bin/node` (v22.22.0) |
| npm (real) | `/usr/bin/npm` |
| Bun | `~/.bun/bin/bun` |
| Python | `/usr/bin/python3` |
| Go | `/usr/bin/go` |
| Rust | `~/.cargo/bin/rustc` |
| cass (session search) | `~/.local/bin/cass` |
| cm (memory system) | `~/.local/bin/cm` |

## Quick Commands

```bash
ss -tlnp              # check listening ports
tailscale status      # check tailscale connections
tmux ls               # list tmux sessions
tmux new -s name      # create new tmux session
tmux attach -t name   # attach to session
```

## Spawning Workers

### Via tmux
```bash
tmux new -s worker1 -d 'claude --dangerously-skip-permissions'
```

### Via Agent Pipelines (when ready)
```bash
cd ~/Projects/agent-pipelines/
# TODO: Add pipeline commands when system is complete
```

## CAS - Coding Agent Session Search & Memory

**Before starting work**, get relevant context from past sessions:
```bash
cm context "task description" --json
```

**Search past sessions**:
```bash
cass search "query" --json --limit 10
```

**Add learned rules** (categories: debugging, testing, architecture, workflow, documentation, integration, collaboration, git, security, performance):
```bash
cm playbook add "lesson learned" --category debugging
```

**List/search playbook rules**:
```bash
cm playbook list --json
cm playbook search "keyword" --json
```

**Keep index fresh**: Run `cass index --json` after significant work sessions.
