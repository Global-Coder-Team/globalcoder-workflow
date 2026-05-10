---
name: agent-team-development
description: Use when executing an implementation plan with four or more independent tasks touching different files, via the experimental agent-teams flag — parallel implementer teammates plus continuous async reviewers. Higher token cost; requires CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1.
---

# Agent Team Development

Execute plan by spawning an agent team with parallel implementers and continuous async reviewers. The lead coordinates via delegate mode, implementers self-claim tasks, and reviewers review continuously as work completes.

**Core principle:** Parallel implementers + continuous async review = maximum throughput with quality gates preserved.

## When to Use

```dot
digraph when_to_use {
    "Have implementation plan?" [shape=diamond];
    "4+ independent tasks?" [shape=diamond];
    "Tasks touch different files?" [shape=diamond];
    "agent-team-development" [shape=box];
    "subagent-driven-development" [shape=box];
    "Manual execution or brainstorm first" [shape=box];

    "Have implementation plan?" -> "4+ independent tasks?" [label="yes"];
    "Have implementation plan?" -> "Manual execution or brainstorm first" [label="no"];
    "4+ independent tasks?" -> "Tasks touch different files?" [label="yes"];
    "4+ independent tasks?" -> "subagent-driven-development" [label="no - too few or sequential"];
    "Tasks touch different files?" -> "agent-team-development" [label="yes"];
    "Tasks touch different files?" -> "subagent-driven-development" [label="no - conflict risk"];
}
```

**vs. Subagent-Driven Development:**
- Parallel implementation (not sequential)
- Teammates communicate directly (not just report back)
- Reviewers accumulate context across tasks (not fresh each time)
- Higher token cost (each teammate is a separate session)

**vs. Executing Plans (parallel session):**
- Automated team coordination (not human-in-loop between batches)
- Parallel work (not sequential batches)
- Continuous review (not batch review)

**Prerequisites:**
- Implementation plan from globalcoder-workflow:writing-plans
- Agent teams enabled: set `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in settings.json or environment
- Clean git branch or worktree

## The Process

```dot
digraph process {
    rankdir=TB;

    "Verify CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 is set" [shape=box];
    "Read plan, analyze tasks and dependencies" [shape=box];
    "4+ independent tasks?" [shape=diamond];
    "Suggest subagent-driven-development instead" [shape=box];
    "Recommend team size (user can override)" [shape=box];
    "Create shared task list with dependencies" [shape=box];
    "Spawn implementer teammates (./implementer-prompt.md)" [shape=box];
    "Spawn spec reviewer teammate (./spec-reviewer-prompt.md)" [shape=box];
    "Spawn code quality reviewer teammate (./code-quality-reviewer-prompt.md)" [shape=box];
    "Enter delegate mode (Shift+Tab)" [shape=box];
    "Monitor: all tasks completed?" [shape=diamond];
    "Nudge stalled teammates, reassign if needed" [shape=box];
    "Final test suite run" [shape=box];
    "Completion report" [shape=box];
    "Use globalcoder-workflow:finishing-a-development-branch" [shape=box style=filled fillcolor=lightgreen];

    "Verify CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 is set" -> "Read plan, analyze tasks and dependencies";
    "Read plan, analyze tasks and dependencies" -> "4+ independent tasks?";
    "4+ independent tasks?" -> "Suggest subagent-driven-development instead" [label="no"];
    "4+ independent tasks?" -> "Recommend team size (user can override)" [label="yes"];
    "Recommend team size (user can override)" -> "Create shared task list with dependencies";
    "Create shared task list with dependencies" -> "Spawn implementer teammates (./implementer-prompt.md)";
    "Spawn implementer teammates (./implementer-prompt.md)" -> "Spawn spec reviewer teammate (./spec-reviewer-prompt.md)";
    "Spawn spec reviewer teammate (./spec-reviewer-prompt.md)" -> "Spawn code quality reviewer teammate (./code-quality-reviewer-prompt.md)";
    "Spawn code quality reviewer teammate (./code-quality-reviewer-prompt.md)" -> "Enter delegate mode (Shift+Tab)";
    "Enter delegate mode (Shift+Tab)" -> "Monitor: all tasks completed?";
    "Monitor: all tasks completed?" -> "Nudge stalled teammates, reassign if needed" [label="no"];
    "Nudge stalled teammates, reassign if needed" -> "Monitor: all tasks completed?";
    "Monitor: all tasks completed?" -> "Final test suite run" [label="yes"];
    "Final test suite run" -> "Completion report";
    "Completion report" -> "Use globalcoder-workflow:finishing-a-development-branch";
}
```

## Prerequisites Verification

Before proceeding with team creation, verify:

1. Check that `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set in settings.json or environment. If not set, **STOP** and instruct the user:
   ```
   Agent teams require CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1.
   Add this to your ~/.claude/settings.json under the "env" key, or export it in your shell.
   ```
2. Implementation plan exists (from globalcoder-workflow:writing-plans)
3. Clean git state

## Team Scaling

| Plan Size | Implementers | Reviewers | Notes |
|-----------|-------------|-----------|-------|
| 1-3 tasks | — | — | Suggest subagent-driven-development |
| 4-8 tasks | 2 | 2 (1 spec, 1 code quality) | Default for most plans |
| 9+ tasks | 3 | 2 (1 spec, 1 code quality) | Cap at 3 implementers |

User can override: "use 4 implementers" or "skip code quality review."

## Task Lifecycle

Task states use the shared task list (pending/in_progress/completed) plus messaging conventions for review:

```
pending → in_progress → needs_spec_review → needs_code_review → completed
          (task list)   (via message)        (via message)       (task list)
```

1. Implementer self-claims pending, unblocked task
2. Implements, tests, commits, self-reviews
3. Messages spec reviewer: "Task N ready for review" — moves on to next task
4. Spec reviewer reviews → pass: messages code quality reviewer / fail: messages implementer
5. Code quality reviewer reviews → pass: marks completed / fail: messages implementer
6. Implementer addresses feedback after finishing current task, not by interrupting

## Prompt Templates

- `./lead-prompt.md` - Lead coordination behavior
- `./implementer-prompt.md` - Spawn prompt for implementer teammates
- `./spec-reviewer-prompt.md` - Spawn prompt for spec reviewer teammate
- `./code-quality-reviewer-prompt.md` - Spawn prompt for code quality reviewer teammate

## Error Recovery

**Teammate crashes:** Spawn replacement with same role, reassign uncompleted tasks.
**Reviewer bottleneck:** Message reviewer to prioritize. Spawn additional reviewer if needed.
**Implementer stuck:** Message to check in. Reassign task to another implementer if no progress.
**File conflicts:** Pause one implementer, let other finish, then unblock. Dependency analysis should prevent most conflicts.
**Cross-task test failures:** Implementers stop claiming new tasks, fix failures first.

## Red Flags

**Never:**
- Let the lead implement tasks (delegate mode only)
- Skip spec review or code quality review
- Let implementers work on tasks that touch the same files simultaneously
- Proceed with failing tests
- Ignore reviewer feedback
- Spawn more than 3 implementers (coordination overhead exceeds benefit)

**If tasks are highly sequential:**
- Stop. Use subagent-driven-development instead.
- Agent teams add overhead without benefit for sequential work.

**If file conflicts arise:**
- Stop parallel work on conflicting files
- Add dependency between conflicting tasks
- Let one complete before the other starts

## Integration

**Required workflow skills:**
- **globalcoder-workflow:writing-plans** - Creates the plan this skill executes
- **globalcoder-workflow:finishing-a-development-branch** - Complete development after all tasks

**Pairs with:**
- **globalcoder-workflow:brainstorming** - Creates design doc referenced by reviewers
- **globalcoder-workflow:using-git-worktrees** - Creates isolated workspace
- **globalcoder-workflow:requesting-code-review** - Optional final review before merge
