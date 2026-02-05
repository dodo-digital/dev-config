# Dev Config

Batteries-included Claude Code setup for agentic development. Install once, and Claude automatically uses enhanced tooling — memory, task management, session search, and more.

## Quick Start

**Requirements:** Claude Code CLI, Node.js 18+, Python 3. Optional: Rust (for some tools).

```bash
curl -fsSL https://raw.githubusercontent.com/dodo-digital/dev-config/main/setup.sh | bash
```

## After Install

Run these once to complete setup:

```bash
# Enable plugins (multi-agent workflows, pipelines)
claude plugins enable compound-engineering@every-marketplace
claude plugins enable agent-pipelines@dodo-digital

# Initialize memory system
cm init

# Index your existing sessions (optional)
cass index

# Set API key for cross-model consultation (optional)
export OPENAI_API_KEY=sk-...
```

## How It Works

Once installed, **Claude handles everything automatically**:

- **Starting tasks** — Claude runs `cm context` and `cass search` to gather relevant patterns and past solutions
- **Task management** — Claude uses `bd` (beads) to track work with dependencies
- **When stuck** — Claude consults other models via `oracle` after 2-3 failed attempts
- **Code quality** — Static analysis runs automatically on every file save
- **Safety** — Dangerous git operations are blocked automatically

You don't run commands. Claude does.

## What's Installed

### Tools

| Tool | Purpose |
|------|---------|
| **cm** | Procedural memory — learned rules and patterns |
| **cass** | Session search — find past solutions |
| **bd** | Task management with dependencies |
| **bv** | AI task prioritization (PageRank) |
| **oracle** | Cross-model consultation (GPT-5, Gemini) |
| **ubs** | Static analysis for 7 languages |

### Hooks (run automatically)

| Hook | Trigger | Action |
|------|---------|--------|
| `git_safety_guard.py` | Before Bash | Blocks force push, hard reset, etc. |
| `on-file-write.sh` | After file save | Runs static analysis |
| `cass-index-on-exit.sh` | Session end | Indexes session for search |
| `skill-router/` | Prompt submit | Suggests relevant skills |

### Plugins

| Plugin | Purpose |
|--------|---------|
| **compound-engineering** | Multi-agent workflows, specialized reviewers |
| **agent-pipelines** | Autonomous pipelines, task orchestration |

## Install Options

```bash
# Skip specific components
curl ... | bash -s -- --no-cron
curl ... | bash -s -- --no-tools

# Install only specific components
curl ... | bash -s -- --hooks-only
curl ... | bash -s -- --tools-only

# See all options
./install.sh --help
```

Or clone manually:
```bash
git clone https://github.com/dodo-digital/dev-config.git
cd dev-config && ./install.sh
```

## License

MIT
