---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches.

**Core principle:** Batch execution with checkpoints for architect review.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Create TodoWrite and proceed

### Step 2: Execute Batch
**Default: First 3 tasks**

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Report
When batch complete:
- Show what was implemented
- Show verification output
- If any dependency manifest was modified in this batch (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile`), prompt: "New dependency added — update `tech_stack.md` to reflect it?" Accept "skip" for incidental dev-only additions.
- Say: "Ready for feedback."

### Step 4: Continue
Based on feedback:
- Apply changes if needed
- Execute next batch
- Repeat until complete

### Step 5: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use globalcoder-development:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker mid-batch (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "The plan looks fine — I'll just start" | Critical review *before* execution catches gaps before sunk cost makes them costly to fix. Review first. |
| "This step is obvious — I can skip the verification" | The verification is the safety net for the obvious steps too. Run it. |
| "I'm on a roll — I'll do 6 tasks before reporting" | The 3-task batch is for review pacing, not throughput. Bigger batches mean later, harder course corrections. |
| "I hit a blocker but I think I can work around it" | Working around blockers hides root causes. Stop, ask, get unblocked the right way. |
| "Step 3 is ambiguous, but I'll pick what seems best" | Ambiguity is a bug in the plan. Ask, don't guess — guessing makes the plan author's intent invisible. |
| "I don't need to reference the skill the plan mentions — I know it" | Knowing ≠ using. Plans reference skills because that skill encodes the discipline the task needs. |
| "The plan needs an update — I'll just patch it as I go" | Stop and revisit Step 1 (review) with the partner. Silent in-place edits to the plan defeat checkpointing. |

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Between batches: just report and wait
- Stop when blocked, don't guess
