---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Step 0: Read Project Context

Before writing the plan, read the project-init files at repo root if they exist — they encode constraints that should shape the plan:

- **`tech_stack.md`** — Frameworks, data layer, infra, and tooling. The plan's verification commands and code patterns should match what's actually used here, not a guess. If this file says "Postgres + Drizzle", don't write a plan that uses Prisma.
- **`style_guide.md`** — Naming, formatter/linter, commit format. The plan's tasks should follow these conventions (e.g., generate test files with the project's naming pattern).
- **`backlog.md`** — Check whether the task being planned is already listed under "Next Up". If yes, move it to "In Progress" as part of starting the plan. If no, ask whether the task should be added to the backlog before planning continues.

If none of these files exist, suggest running `globalcoder-development:project-init` first — it's much cheaper than writing a plan that fights the actual stack.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use globalcoder-development:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

```markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
```

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills using `globalcoder-development:<name>` format (do not use `@` — that force-loads files)
- DRY, YAGNI, TDD, frequent commits

## Execution Handoff

After saving the plan, analyze the plan's tasks and offer execution choice:

**"Plan complete and saved to `docs/plans/<filename>.md`. Four execution options:**

**1. Subagent-Driven (this session)** - Sequential: fresh subagent per task, two-stage review between tasks, fast iteration. Best for plans with <4 tasks or sequential dependencies.

**2. Agent Team (this session)** - Parallel: spawns multiple implementer teammates + reviewer teammates, continuous async review. Best for plans with 4+ independent tasks touching different files. Higher token cost.

**3. tmux Parallel (this terminal)** - Spawns `claude` instances in separate tmux windows, one per independent task. Two sub-modes: fire-and-forget (`claude -p`) or observable autopilot (interactive). Best for 2-6 independent tasks. Requires tmux.

**4. Parallel Session (separate)** - Open new session with executing-plans, batch execution with human checkpoints between batches.

**Which approach?"**

**If tmux is not installed** (`which tmux` fails), do not show option 3.

**If all tasks are sequential** (every task depends on the previous), note that options 2 and 3 won't provide parallel benefit and recommend option 1.

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use globalcoder-development:subagent-driven-development
- Stay in this session
- Fresh subagent per task + code review

**If Agent Team chosen:**
- **REQUIRED SUB-SKILL:** Use globalcoder-development:agent-team-development
- Stay in this session
- Spawns agent team with parallel implementers + async reviewers
- Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` enabled

**If tmux Parallel chosen:**
- **REQUIRED SUB-SKILL:** Use globalcoder-development:tmux-parallel-development
- Stay in this session as the lead
- Follow up: ask fire-and-forget vs observable autopilot
- Lead orchestrates tmux windows + monitors completion

**If Parallel Session chosen:**
- Guide them to open new session in worktree
- **REQUIRED SUB-SKILL:** New session uses globalcoder-development:executing-plans
