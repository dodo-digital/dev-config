# PageRank and Graph Metrics

`bv` treats tasks as nodes in a dependency graph and computes graph-theoretic metrics to identify high-impact work.

## Why Graph Metrics?

Traditional priority systems (P0-P4) capture urgency but miss structural importance. A P2 task that blocks five other tasks has more impact than a P1 task blocking nothing.

Graph algorithms reveal:
- **Foundational blockers** - Tasks that must complete first
- **Bottlenecks** - Tasks that sit on many critical paths
- **Quick wins** - Low-effort tasks that unblock downstream work

## The Nine Metrics

| Metric | What It Measures | High Score Means |
|--------|------------------|------------------|
| **PageRank** | Recursive dependency importance | Foundational blocker |
| **Betweenness** | Shortest-path traffic | Bottleneck/bridge |
| **Critical Path** | Longest dependency chain | Keystone with zero slack |
| **HITS Hub** | Outgoing dependencies | Epic/coordinator |
| **HITS Authority** | Incoming dependencies | Infrastructure/utility |
| **Eigenvector** | Influence via neighbors | Strategic dependency |
| **Degree** | Direct connections | Immediate blocker |
| **K-Core** | Graph decomposition | Core vs peripheral |
| **Slack** | Parallelism headroom | Can be delayed safely |

## Key Metrics Explained

### PageRank

Originally Google's web ranking algorithm. For tasks:
- High PageRank = many tasks depend on it (directly or indirectly)
- A task blocked by high-PageRank tasks inherits importance
- Identifies foundational infrastructure work

**Interpretation:** Work on high-PageRank tasks first - they unblock the most downstream work.

### Betweenness Centrality

Measures how often a task appears on shortest paths between other tasks.

- High betweenness = bottleneck that bridges different parts of the graph
- Clearing it opens up multiple parallel work streams
- Often identifies integration or infrastructure tasks

**Interpretation:** High-betweenness tasks are leverage points - completing them enables parallelization.

### Critical Path

The longest chain of dependent tasks.

- Tasks on the critical path have zero slack
- Any delay on critical path delays the whole project
- Critical path tasks should be prioritized

**Interpretation:** Critical path work cannot be delayed without delaying everything.

### HITS Hub and Authority

From the HITS (Hyperlink-Induced Topic Search) algorithm:

- **Hub Score** - Task depends on many others (epic/coordinator)
- **Authority Score** - Many tasks depend on this (infrastructure/utility)

**Interpretation:** Hubs are coordinators to watch; Authorities are foundations to complete.

### Eigenvector Centrality

Like PageRank but simpler - importance based on neighbors' importance.

- High eigenvector = connected to other important tasks
- Captures "strategic" position in the graph

**Interpretation:** Tasks with high eigenvector are strategically positioned - completing them affects many important neighbors.

### Degree Centrality

Simply counts direct connections.

- High in-degree = many blockers (hard to start)
- High out-degree = blocks many (high impact)
- Combined degree = central to the graph

**Interpretation:** High out-degree tasks have immediate impact when completed.

### K-Core

Graph decomposition by connectivity.

- Higher k-core = more central to the graph
- Peripheral tasks (low k-core) can be deferred
- Core tasks (high k-core) are structurally important

**Interpretation:** Focus on core tasks; peripheral tasks can wait.

### Slack

How much a task can be delayed without affecting critical path.

- Zero slack = on critical path
- High slack = can be parallelized or deferred
- Useful for resource planning

**Interpretation:** High-slack tasks are safe to defer if needed.

## Composite Impact Score

`bv` combines metrics into a single Impact Score:

```
Impact = 0.30 * PageRank
       + 0.30 * Betweenness
       + 0.20 * BlockerRatio
       + 0.10 * Staleness
       + 0.10 * PriorityBoost
```

Where:
- **PageRank** - Normalized PageRank (0-1)
- **Betweenness** - Normalized betweenness (0-1)
- **BlockerRatio** - Fraction of open tasks this blocks
- **Staleness** - Time since last update (encourages progress)
- **PriorityBoost** - Explicit priority (P0=1.0, P1=0.75, etc.)

## Getting Metrics

### Full Insights

```bash
bv --robot-insights
```

Returns:
- PageRank map for all tasks
- Betweenness scores
- Cycle detection (problematic dependencies)
- Articulation points (single points of failure)
- K-core analysis
- Critical path identification

### In Triage Output

```bash
bv --robot-triage
```

The `recommendations[].reasons` array explains why each task scored high:
- "High PageRank (0.15)" - Foundational blocker
- "Unblocks 3 downstream tasks" - Direct impact
- "On critical path" - Cannot be delayed
- "High betweenness" - Bottleneck

## Practical Guidance

1. **Start with high PageRank** - These are foundations
2. **Clear high betweenness next** - Opens parallel tracks
3. **Use slack for scheduling** - Zero-slack tasks are time-critical
4. **Watch for cycles** - Dependency cycles indicate design issues
5. **Articulation points are risky** - Single points of failure in the graph
