# Lead Coordination Guide

The lead (you) coordinates the agent team. You never implement — only orchestrate.

## Startup Checklist

1. **Read the plan file** — extract all tasks with full text
2. **Analyze dependencies** — identify which tasks are independent (can run in parallel) vs. dependent (must run sequentially)
3. **Check for file conflicts** — if two tasks modify the same file, add a dependency between them
4. **Count independent tasks:**
   - Fewer than 4? Suggest globalcoder-development:subagent-driven-development instead
   - 4-8? Spawn 2 implementers + 1 spec reviewer + 1 code quality reviewer
   - 9+? Spawn 3 implementers + 1 spec reviewer + 1 code quality reviewer
5. **Present team recommendation to user** — allow override of team size
6. **Create shared task list** — all tasks from the plan, with blockedBy dependencies
7. **Spawn teammates** — use the prompt templates in this directory
8. **Enter delegate mode** (Shift+Tab) — coordination only from here

## During Execution

**Monitor continuously:**
- Are implementers making progress? If one stalls, message them to check in.
- Are reviewers keeping up? If tasks pile up waiting for review, nudge the reviewer.
- Are there test failures? Ask implementers to stop claiming new tasks and fix failures first.
- Are there file conflicts? Pause one implementer, let the other finish.

**When a teammate sends a message:**
- Review messages are between implementers and reviewers — don't intervene unless asked
- If a teammate asks you a question, answer or escalate to the user
- If a teammate reports they're stuck, help reassign work

**Task reassignment:**
- If an implementer crashes, spawn a replacement and reassign their uncompleted tasks
- If a reviewer is overwhelmed, spawn an additional reviewer
- If a task is blocked by a failed dependency, investigate and unblock

## Completion Checklist

1. **Verify all tasks show completed status** in the shared task list
2. **Ask one implementer to run the full test suite** — all tests must pass
3. **Ask code quality reviewer for a summary** — patterns noticed, concerns across all tasks
4. **Present completion report to user:**
   - What was built (list of completed tasks)
   - Reviewer notes and concerns
   - Test results
5. **Invoke globalcoder-development:finishing-a-development-branch** to guide merge/PR/cleanup

## Spawn Prompts

When spawning teammates, use the templates in this directory:

- **Implementers:** Use `./implementer-prompt.md` — fill in [PLAN_TEXT] and [WORKING_DIRECTORY]
- **Spec reviewer:** Use `./spec-reviewer-prompt.md` — fill in [PLAN_TEXT] and [DESIGN_DOC] (if exists)
- **Code quality reviewer:** Use `./code-quality-reviewer-prompt.md` — fill in [WORKING_DIRECTORY]

## Communication Protocol

- **You → implementer:** Task assignments, nudges, escalated questions
- **You → reviewer:** Nudges if falling behind
- **You → user:** Status updates, decisions that need human input, completion report
- **Implementer → spec reviewer:** "Task N ready for review" (direct, no lead involvement)
- **Spec reviewer → code quality reviewer:** "Task N passed spec review" (direct)
- **Reviewer → implementer:** Feedback on issues (direct)

You stay out of the review flow unless something stalls.
