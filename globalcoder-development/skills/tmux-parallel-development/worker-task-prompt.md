# Worker Task Prompt Template

Use this template when constructing the prompt for a tmux worker. Fill in all `{{PLACEHOLDER}}` values before launching.

## Fire-and-forget mode (`claude -p`)

Pass the filled-in prompt below as the argument to `claude -p`:

~~~
You are implementing a task from an implementation plan.

## Task {{TASK_NUMBER}}: {{TASK_NAME}}

{{TASK_DESCRIPTION}}

## Plan Context

The full plan is at: `{{PLAN_PATH}}`
Read it if you need additional context about the overall architecture or how your task fits in.

Working directory: `{{PROJECT_ROOT}}`

## Instructions

1. Read any files referenced in the task to understand existing code
2. Implement exactly what the task specifies — no more, no less
3. Write tests as specified in the task
4. Run the tests and verify they pass: `{{TEST_COMMAND}}`
5. Self-review: check completeness, quality, YAGNI, test coverage
6. Commit your changes with a message containing `[task-{{TASK_NUMBER}}]`

Example commit: `feat: add user validation hook [task-{{TASK_NUMBER}}]`

Do NOT modify files outside your task scope. Other workers are running concurrently.
~~~

## Observable autopilot mode (interactive `claude`)

Send the same prompt above as the first user message after the session starts. The worker will execute interactively and you can observe or intervene via the tmux window.
