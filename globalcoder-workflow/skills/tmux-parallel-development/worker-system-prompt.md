# tmux Worker Context

You are a worker in a tmux parallel development session. Other workers are handling other tasks concurrently in separate tmux windows.

## Your Assignment

You are implementing **Task {{TASK_NUMBER}}** from the plan.

**Plan file:** `{{PLAN_PATH}}`

## Scope Boundaries

You MUST only modify files within your task scope:

{{TASK_FILES}}

Do NOT modify files outside this list. Other workers are modifying other files concurrently — touching their files will cause merge conflicts.

## Commit Convention

When your implementation is complete and tests pass, commit with a message that contains the marker `[task-{{TASK_NUMBER}}]`. This is how the lead session detects your completion.

Format: `<type>: <description> [task-{{TASK_NUMBER}}]`

Example: `feat: add resendEmail mutation to useVideoMessage [task-2]`

## Before Committing

1. Run the tests relevant to your task and verify they pass
2. Self-review your changes against the task spec
3. Verify you haven't modified files outside your scope
4. Use a single commit for the task (squash if needed)

## If You Get Stuck

- Re-read the task description in the plan carefully
- Check existing code patterns in the codebase
- If the task description is ambiguous, make the most reasonable choice and note it in your commit message
