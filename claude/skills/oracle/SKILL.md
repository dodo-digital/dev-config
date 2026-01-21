---
name: oracle
description: Consult GPT-5 Pro, Gemini 3 Pro, or Claude with full file context when stuck on hard problems. Use when debugging fails after 2-3 attempts, need architecture validation, or want cross-model verification.
---

<auto_trigger>
Human phrases:
- "I'm stuck", "I can't figure this out", "this isn't working"
- "I've tried everything", "nothing is working"
- "can you ask GPT", "what would GPT say", "get another opinion"
- "I need help with this", "I'm lost here"
- "this is really hard", "I don't know what's wrong"
- "been debugging for hours", "spent all day on this"
- "is this the right approach", "am I doing this right"

Keep for explicit mentions:
- "oracle", "gpt-5", "gemini"
</auto_trigger>

# Oracle CLI

> Bundle prompts with file context to consult GPT-5 Pro, Gemini 3 Pro, or Claude for hard problems.

## When to Use Oracle

Use Oracle when you are **stuck on a difficult problem** and need a second opinion from a frontier model with full codebase context:

- **Debugging complex issues** - Strange behavior that defies initial analysis
- **Architecture decisions** - Design validation, refactoring strategies
- **Cross-model verification** - Get a second opinion on your proposed solution
- **Code review at scale** - Review large portions of codebase with context
- **Stuck after 2-3 attempts** - When your debugging attempts aren't working

**Do NOT use Oracle for:**
- Simple questions you can answer yourself
- Tasks that don't require file context
- Rapid iteration (Oracle is one-shot, not conversational)

## Installation

```bash
npm install -g @steipete/oracle
# or
brew install steipete/tap/oracle
# or run directly
npx -y @steipete/oracle [options]
```

Requires Node 22+.

## Core Commands

### Preview Before Spending Tokens

```bash
# Dry run to see what will be sent
oracle --dry-run summary -p "Your question" --file "src/**/*.ts"

# See token usage per file
oracle --dry-run summary --files-report -p "Your question" --file "src/**"
```

### API Mode (Requires API Key)

```bash
# Basic API run
oracle -p "Debug this authentication flow" --file "src/auth/**/*.ts"

# Multi-model comparison
oracle -p "Review architecture" --models gpt-5.2-pro,gemini-3-pro --file "src/**"

# Wait for completion (default detaches for gpt-5.2-pro)
oracle --wait -p "Your question" --file "src/**"
```

### Browser Mode (No API Key Needed)

```bash
# Uses ChatGPT in browser with your account
oracle --engine browser -p "Your question" --file "src/**/*.ts"

# Specify model in browser
oracle --engine browser --model gpt-5.2-pro -p "Your question" --file "src/**"
```

### Manual Clipboard Mode

```bash
# Build bundle, copy to clipboard for manual paste
oracle --render --copy -p "Your question" --file "src/**/*.ts"
```

## File Context Patterns

### Basic Patterns

```bash
# Single file
--file src/index.ts

# Directory (all files)
--file src/

# Glob pattern
--file "src/**/*.ts"

# Multiple patterns
--file "src/**/*.ts" --file "docs/*.md"

# Combined in one flag
--file "src/**/*.ts,docs/*.md"
```

### Exclusion Patterns

```bash
# Exclude test files
--file "src/**/*.ts" --file "!src/**/*.test.ts"

# Exclude multiple patterns
--file "src/**" --file "!**/*.test.ts" --file "!**/__mocks__/**"
```

### Auto-Ignored Directories

Oracle automatically excludes: `node_modules`, `dist`, `.git`, `.next`, `build`, `coverage`

### File Limits

- Individual files > 1 MB are rejected
- Target total input under ~196k tokens
- Use `--files-report` to identify token-heavy files

## Model Options

| Model ID | Description |
|----------|-------------|
| `gpt-5.2-pro` | Default. Best for complex reasoning (API detaches by default) |
| `gpt-5.2` | Faster GPT-5.2 variant |
| `gpt-5.1-pro` | Previous generation Pro |
| `gemini-3-pro` | Google's Gemini 3 Pro |
| `claude-4.5-sonnet` | Anthropic Claude Sonnet |
| `claude-4.1-opus` | Anthropic Claude Opus |

OpenRouter models: Use full ID like `openai/gpt-4o-mini`

## Session Management

Sessions persist at `~/.oracle/sessions`. **Critical rule: If CLI times out, reattach instead of re-running.**

```bash
# List recent sessions
oracle status --hours 72

# Attach to specific session
oracle session <id>

# Render session output
oracle session <id> --render

# Use memorable slugs
oracle --slug "auth-flow-debug" -p "Your question" --file "src/**"
```

## Writing Effective Prompts

Oracle is **one-shot** - it has no memory of prior runs. Every prompt must be self-contained.

### Include in Every Prompt

1. **Project briefing** - Stack, framework versions, build commands
2. **Directory structure** - What the attached files represent
3. **Specific question** - Exact error messages, observed behavior
4. **Prior attempts** - What you already tried
5. **Desired output** - What format you want the answer in

### Example Effective Prompt

```bash
oracle -p "Project: Next.js 15 + TypeScript + Prisma
Directory: src/api contains API routes, src/lib has utilities
Error: 'Cannot read property id of undefined' at line 42 of src/api/users.ts
Tried: Added null checks, verified database has data
Question: Why is the user object undefined after authentication middleware?
Please: Show the fix with explanation" \
  --file "src/api/users.ts" --file "src/middleware/auth.ts" --file "src/lib/db.ts"
```

## Best Practices

### Before Running Oracle

1. **Exhaust local debugging first** - Oracle is for hard problems
2. **Gather context** - Collect relevant files, error messages, logs
3. **Run dry-run** - Check token usage with `--dry-run summary --files-report`
4. **Redact secrets** - Never attach `.env`, credentials, or API keys

### During Oracle Session

1. **Don't re-run on timeout** - Use `oracle session <id>` to reattach
2. **Check status first** - `oracle status` before starting new runs
3. **Use slugs** - `--slug "descriptive-name"` for easy reference

### File Selection Strategy

1. **Start broad, then narrow** - Include more context initially
2. **Exclude tests unless relevant** - Use `!**/*.test.ts`
3. **Include related files** - Dependencies, types, configs
4. **Check token budget** - Stay under ~196k tokens total

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `OPENAI_API_KEY` | OpenAI API access |
| `GEMINI_API_KEY` | Google Gemini API access |
| `ANTHROPIC_API_KEY` | Anthropic Claude API access |
| `ORACLE_HOME_DIR` | Override session storage location |

## Advanced Options

```bash
# Custom timeout (default: 60m for pro, 120s otherwise)
--timeout 300

# Write output to file
--write-output result.md

# Remote browser server
oracle serve --host 0.0.0.0 --port 9473 --token secret123
oracle --remote-host 192.168.1.10:9473 --remote-token secret123 -p "..." --file "..."

# Browser model strategy
--browser-model-strategy select|current|ignore

# Override ChatGPT URL (for workspaces/projects)
--chatgpt-url "https://chatgpt.com/g/.../project"
```

## Quick Reference

```bash
# Stuck on hard bug - full context
oracle --wait -p "PROJECT BRIEF + EXACT ERROR + QUESTION" \
  --file "src/**/*.ts" --file "!**/*.test.ts"

# Architecture review
oracle --models gpt-5.2-pro,gemini-3-pro \
  -p "Review this design for [concern]" --file "src/**"

# Manual mode when automation fails
oracle --render --copy -p "Your question" --file "src/**"

# Check running sessions
oracle status --hours 24

# Reattach to session
oracle session auth-flow-debug
```
