# Dev Config

Private Claude Code power-user configuration with batteries included.

## Quick Start

```bash
git clone <this-repo> ~/Projects/dev-config
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
| **oracle** | Call GPT-5 Pro when stuck | [steipete/oracle](https://github.com/steipete/oracle) |

### Plugins

| Plugin | Purpose |
|--------|---------|
| **compound-engineering** | Multi-agent workflows, code reviewers, research agents |
| **agent-pipelines** | Ralph loops, pipeline orchestration, beads integration |

### Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| `git_safety_guard.py` | PreToolUse (Bash) | Prevents dangerous git operations |
| `on-file-write.sh` | PostToolUse (Write/Edit) | Runs UBS static analysis on save |

### Skills

**Custom skills (included):**
- `vercel-ai-browser` - Browser automation with Playwright MCP
- `vercel-react` - React/Next.js performance best practices (40+ rules)

**Vercel official skills (cloned by installer):**
- `react-best-practices` - Full Vercel engineering guide

**From plugins:**
- Agent Pipelines: `/start`, `/sessions`, `/work`, `/refine`, `/ideate`
- Compound Engineering: reviewers, researchers, workflows

## Directory Structure

```
dev-config/
├── install.sh                 # Main installer script
├── README.md
├── claude/
│   ├── hooks/
│   │   ├── git_safety_guard.py   # Prevent dangerous git ops
│   │   └── on-file-write.sh      # UBS static analysis hook
│   ├── skills/
│   │   ├── vercel-ai-browser/    # Browser automation skill
│   │   └── vercel-react/         # React best practices skill
│   └── settings.template.json    # Claude Code settings template
├── scripts/                   # Helper scripts
└── tools/                     # Tool-specific installers
```

## What the Installer Does

1. Installs binary tools (ubs, bv, bd, cm, cass, oracle)
2. Copies hooks to `~/.claude/hooks/`
3. Copies skills to `~/.claude/skills/`
4. Clones [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) to `~/.claude/vendor/`
5. Creates settings.json if missing (or warns to merge)
6. Prints plugin enable commands

## Requirements

- **Node.js 22+** (for oracle, cm)
- **Rust** (for bd, cass)
- **Python 3** (for bv)
- **Claude Code CLI** installed

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

**Daily development:**
```
/work implement auth module     # Spawn Codex to implement
bv --robot-triage               # See what to work on next
bd ready                        # List ready tasks
```

**When stuck:**
```
oracle "How should I structure this auth system?"  # Ask GPT-5 Pro
```

**Before commit:**
```
ubs .                           # Run full static analysis
```
