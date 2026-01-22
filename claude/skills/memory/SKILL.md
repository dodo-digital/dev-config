---
name: memory
description: Procedural memory system for AI coding agents using the `cm` CLI tool. Use when starting any coding task to get relevant context, when learning patterns from past sessions, when adding rules to the playbook, or when the user mentions memory, context, playbook, or learning from history.
---

<auto_trigger>
Human phrases:
- "what do I know about this", "have I done this before"
- "what should I remember", "any tips for this"
- "I learned something", "remember this for next time"
- "add this to my notes", "save this lesson"
- "what went wrong last time", "don't make that mistake again"
- "start of session", "beginning work"

Keep for explicit mentions:
- "cm", "memory", "playbook", "context"
</auto_trigger>

# Memory (cm)

Procedural memory system that helps agents learn from past sessions and apply accumulated knowledge to new tasks.

## Quick Start

**Before starting ANY task**, get relevant context:

```bash
cm context "your task description" --json
```

This returns:
- `relevantBullets` - Rules that may help
- `antiPatterns` - Pitfalls to avoid
- `historySnippets` - Past solutions from similar work
- `suggestedCassQueries` - Deeper searches to run

## Primary Workflow

### 1. Start of Task

Always begin with context retrieval:

```bash
cm context "fix the authentication timeout bug" --json
cm context "implement JWT authentication" --json
cm context "optimize database queries" --json
```

Options:
- `--workspace <path>` - Filter by workspace
- `--top <n>` - Number of rules to show
- `--history <n>` - Number of history snippets
- `--days <n>` - Lookback days for history

### 2. During Work

Reference rule IDs when following them. Leave inline feedback comments:

```javascript
// [cass: helpful b-abc123] - This pattern prevented the race condition
// [cass: harmful b-xyz789] - This advice didn't apply to async context
```

### 3. End of Task

Just finish. Learning happens automatically when reflection is scheduled.

## Playbook Management

The playbook stores learned rules organized by category.

### List Rules

```bash
cm playbook list --json
cm playbook list --category debugging --json
```

### Add Rules

```bash
cm playbook add "Always check error handling before refactoring" --category debugging --json
cm playbook add "Use --json flag for machine-readable output" --category workflow --json
```

### Categories

| Category | Use For |
|----------|---------|
| `debugging` | Bug investigation patterns |
| `testing` | Test writing and validation |
| `architecture` | System design decisions |
| `workflow` | Process and tooling patterns |
| `documentation` | Doc writing standards |
| `integration` | API and service connections |
| `collaboration` | Team coordination patterns |
| `git` | Version control practices |
| `security` | Security considerations |
| `performance` | Optimization patterns |
| `general` | Default category |

### Get Rule Details

```bash
cm playbook get <bulletId> --json
cm why <bulletId> --json  # Show origin evidence
```

### Remove Rules

```bash
cm forget <bulletId> --reason "outdated after migration" --json
cm forget <bulletId> --reason "wrong context" --invert --json  # Create anti-pattern
```

## Reflection and Learning

Reflection extracts new rules from recent sessions.

### Manual Reflection (Solo Users)

```bash
cm reflect --days 1 --json   # After significant work
cm reflect --days 7 --json   # Weekly maintenance
cm reflect --dry-run --json  # Preview without applying
```

Options:
- `--days <n>` - Lookback period
- `--max-sessions <n>` - Limit sessions to process
- `--workspace <path>` - Filter by workspace
- `--session <path>` - Process specific session

### Onboarding (Bootstrap Playbook)

For new setups, use guided onboarding:

```bash
cm onboard status --json    # Check progress
cm onboard gaps --json      # Find category gaps
cm onboard sample --json    # Find sessions to analyze
cm onboard read <path> --json  # Read session for extraction
```

## Feedback Commands

### Mark Rules Helpful/Harmful

```bash
cm mark <bulletId> --helpful --json
cm mark <bulletId> --harmful --reason caused_bug --json
```

Harmful reasons: `caused_bug`, `wasted_time`, `contradicted_requirements`, `wrong_context`, `outdated`, `other`

### View Top Rules

```bash
cm top 10 --json
cm top --category debugging --json
```

## Health and Diagnostics

### System Health

```bash
cm doctor --json        # Check health
cm doctor --fix --json  # Auto-fix issues
cm stats --json         # Playbook metrics
```

### Validate Rules

```bash
cm validate "proposed rule text" --json  # Test against history
cm similar "query text" --json           # Find similar existing rules
```

## Privacy Controls

Cross-agent enrichment is opt-in and off by default:

```bash
cm privacy status --json
cm privacy enable --json
cm privacy disable --json
```

## Do NOT Do

- Run `cm reflect` manually in automated pipelines (operators schedule it)
- Use `cm mark` directly (prefer inline comments)
- Add rules without validation
- Worry about the learning pipeline during normal work

## Degraded Mode

If `cass` (session search) is missing or not indexed, `historySnippets` may be empty. Run:

```bash
cm doctor --json  # Check and get next steps
cass index --json # Rebuild session index
```

## Starter Playbooks

Bootstrap with curated rules:

```bash
cm starters --json  # List available starters
```

Available: `general`, `node`, `python`, `react`, `rust`

## Example Session

```bash
# 1. Get context before starting
cm context "add rate limiting to API endpoints" --json

# 2. Review returned rules and history
# 3. Do the work, referencing rule IDs in comments
# 4. Leave inline feedback: // [cass: helpful b-xxx] - reason

# 5. (Weekly) Reflect to extract learnings
cm reflect --days 7 --json
```
