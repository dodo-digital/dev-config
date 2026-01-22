---
name: cass-memory
description: Cross-agent memory and learning system. Get context before starting tasks, extract lessons learned, manage playbook rules. Use when starting work, after completing tasks, or checking for patterns.
---

<auto_trigger>
- "get context"
- "get memory"
- "what do we know"
- "past lessons"
- "playbook"
- "learned rules"
- "extract lessons"
- "cm context"
- "cm playbook"
- "before I start"
- "relevant context"
</auto_trigger>

# CM - Cass Memory System

Cross-agent memory and learning system that extracts lessons from past coding sessions and maintains a playbook of proven patterns.

## When to Use This Skill

Use CM when:
- Starting a new task and want relevant context from past work
- After completing a significant piece of work to extract lessons learned
- When troubleshooting a recurring issue
- To check for anti-patterns or gotchas before implementing something

## Tool: cm

The `cm` CLI is installed at `/home/ubuntu/.local/bin/cm` and provides memory management for coding agents.

### Getting Context Before Work

```bash
# Get relevant context for a task
cm context "implementing authentication with JWT" --json

# Quick system overview
cm quickstart --json
```

### Health Check

```bash
cm doctor --json
```

### Onboarding (Extracting Rules from Sessions)

```bash
# Check onboarding status
cm onboard status --json

# Get sessions to analyze (prioritizing knowledge gaps)
cm onboard sample --fill-gaps --json

# Read a session with contextual guidance
cm onboard read /path/to/session.jsonl --template

# Mark a session as processed
cm onboard mark-done /path/to/session.jsonl
```

### Managing the Playbook

The playbook contains rules learned from past sessions.

```bash
# List all rules
cm playbook list --json

# Add a new rule
cm playbook add "Always use parameterized queries to prevent SQL injection" --category security

# Add rules from a file
cm playbook add --file rules.json

# Search rules
cm playbook search "authentication" --json
```

### Rule Categories

Rules are organized into these categories:
- `debugging` - Troubleshooting approaches
- `testing` - Testing strategies and patterns
- `architecture` - Design patterns and decisions
- `workflow` - Development workflow optimizations
- `documentation` - Documentation practices
- `integration` - Integration patterns
- `collaboration` - Team practices
- `git` - Version control patterns
- `security` - Security best practices
- `performance` - Performance optimizations

### Adding Rules

When extracting rules from sessions, use this format:

```bash
cm playbook add "Rule description" \
  --category debugging \
  --confidence 0.8 \
  --source "session_id"
```

Or batch import as JSON:

```json
[
  {
    "content": "Rule description",
    "category": "debugging",
    "confidence": 0.8,
    "source": "session_id"
  }
]
```

## Workflow for Session Analysis

1. **Check gaps**: `cm onboard status --json` to see what categories need rules
2. **Get sessions**: `cm onboard sample --fill-gaps --json` to get relevant sessions
3. **Read session**: `cm onboard read <path> --template` to see the session
4. **Extract rules**: Identify patterns, solutions, anti-patterns
5. **Add rules**: `cm playbook add "..." --category X`
6. **Mark done**: `cm onboard mark-done <path>`

## Best Practices

1. **Get context first**: Always run `cm context "task description"` before starting significant work
2. **Extract regularly**: After solving tricky problems, extract the solution as a rule
3. **Categorize accurately**: Put rules in the right category for better retrieval
4. **Include confidence**: High confidence (0.8+) for proven patterns, lower for theories
5. **Cite sources**: Link rules to their source sessions for traceability

## Integration with CAS Search

CM uses CAS (cass) for searching session histories. They work together:
- `cass search` - Find specific content in sessions
- `cm context` - Get relevant rules + related session context
- `cm onboard` - Extract rules from sessions found via cass
