# Dev Config

Batteries-included Claude Code setup for agentic development workflows. One command installs tools, hooks, skills, and configuration.

## Quick Start

```bash
git clone https://github.com/hwells4/dev-config.git ~/Projects/dev-config
cd ~/Projects/dev-config
./install.sh
```

## What's Included

### Tools (Binaries)

| Tool | Purpose | Source |
|------|---------|--------|
| **ubs** | Static analysis for 7 languages | [ultimate_bug_scanner](https://github.com/Dicklesworthstone/ultimate_bug_scanner) |
| **bv** | Task prioritization with PageRank | [beads_viewer](https://github.com/Dicklesworthstone/beads_viewer) |
| **bd** | Dependency-aware task management | [beads](https://github.com/steveyegge/beads) |
| **cm** | Procedural memory for coding agents | Cast Memory |
| **cass** | Search past coding sessions | Agent Session Search |
| **oracle** | Cross-model consultation (GPT-5 Pro, Gemini, etc.) | [steipete/oracle](https://github.com/steipete/oracle) |

### Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| `git_safety_guard.py` | PreToolUse (Bash) | Blocks destructive git operations (force push, hard reset, etc.) |
| `on-file-write.sh` | PostToolUse (Write/Edit) | Runs UBS static analysis on every file save |
| `cass-index-on-exit.sh` | SessionEnd | Indexes your session for future search |
| `skill-router/` | UserPromptSubmit | Auto-suggests relevant skills based on your prompt |

### Skills

**Included:**
- `oracle` — Cross-model consultation when stuck
- `memory` — Procedural memory system (get context, store learnings)
- `cass` — Session search (find past solutions)
- `beads` / `beads-viewer` — Task management and prioritization
- `spawn-worker` — Spawn Claude/Codex agents in tmux sessions
- `agent-browser` — Browser automation with Playwright
- `react-best-practices` — React/Next.js performance guide (40+ rules)
- `web-design-guidelines` — UI/UX design review
- `ui-skills` — Interface building constraints

**Auto-cloned by installer:**
- [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) — Official Vercel engineering skills

### Plugins

| Plugin | Purpose |
|--------|---------|
| **compound-engineering** | Multi-agent workflows, code reviewers, research agents |
| **agent-pipelines** | Ralph loops, pipeline orchestration, beads integration |

## Selective Installation

Install everything (default):
```bash
./install.sh
```

Install only specific components:
```bash
./install.sh --tools-only      # Just CLI tools
./install.sh --hooks-only      # Just Claude Code hooks
./install.sh --skills-only     # Just Claude Code skills
```

Skip specific components:
```bash
./install.sh --no-cron         # Everything except crontab
./install.sh --no-git-hooks    # Everything except global git hooks
./install.sh --no-tools        # Hooks + skills + config only
```

See all options:
```bash
./install.sh --help
```

## Directory Structure

```
dev-config/
├── install.sh                 # Main installer script
├── README.md
├── CLAUDE.md                  # Tool workflows & reference
├── crontab.txt                # Background cron jobs (templated)
├── claude/
│   ├── CLAUDE.md              # Project-level Claude instructions
│   ├── hooks/
│   │   ├── git_safety_guard.py    # Prevent destructive git ops
│   │   ├── on-file-write.sh       # UBS static analysis on save
│   │   ├── cass-index-on-exit.sh  # Index sessions on exit
│   │   └── skill-router/          # Auto-skill suggestion engine
│   ├── skills/                    # Custom skills (10+)
│   └── settings.template.json    # Claude Code settings (templated)
└── git/
    └── hooks/
        └── pre-commit             # Global git pre-commit (UBS)
```

## How Templating Works

Files use `__HOME__` as a placeholder for the user's home directory. The installer automatically resolves these at install time:

- `settings.template.json` → `~/.claude/settings.json` (with `__HOME__` → `/home/you`)
- `crontab.txt` → crontab entries (with `__HOME__` → `/home/you`)

This means the repo is OS-agnostic — works on Linux (`/home/user`), macOS (`/Users/user`), or any other layout.

## Requirements

- **Claude Code CLI** installed
- **Node.js 22+** (for oracle, cm)
- **Rust** (for bd, cass) — optional, installer will warn if missing
- **Python 3** (for bv, hooks)

## Post-Install

```bash
# Enable plugins
claude plugins enable compound-engineering@every-marketplace
claude plugins enable agent-pipelines@dodo-digital

# Set OpenAI key for oracle
export OPENAI_API_KEY=sk-...

# Initialize Cast Memory
cm init

# Index coding sessions
cass index
```

## Key Workflows

**Start every task with fresh context:**
```bash
cm context "your task description" --json
cass search "keywords" --json --limit 5
```

**Manage work with dependency-aware tasks:**
```bash
bd q "New task"           # Quick create
bd ready                  # What's unblocked
bv --robot-triage         # AI-prioritized recommendations
```

**When stuck, consult another model:**
```bash
oracle "How should I structure this auth system?"
oracle -f src/ -f docs/ "What's wrong with this approach?"
```

## License

MIT
