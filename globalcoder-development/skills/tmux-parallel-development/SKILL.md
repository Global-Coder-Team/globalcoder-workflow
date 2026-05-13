---
name: tmux-parallel-development
description: Use when executing an implementation plan with two or more independent tasks via tmux processes — separate claude instances per task, no inter-worker messaging, no experimental flag required. Requires tmux installed.
---

# tmux Parallel Development

Execute a plan by spawning parallel `claude` CLI instances in separate tmux windows. Each worker implements one task independently. The lead session monitors completion via git commit markers and runs final verification.

**Core principle:** Independent tmux windows = true process isolation + visual monitoring + no experimental flags.

## When to Use

- Have an implementation plan with 2+ independent tasks
- tmux is installed
- Tasks touch different files (no overlap)
- You want parallel execution without `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`

**vs. Agent Team Development:**
- No experimental flag required
- Each worker gets full fresh context (no shared context window)
- User can visually monitor all workers via tmux
- No inter-worker messaging — workers are fully isolated
- Simpler coordination (git commits, not task list + messages)

**vs. Subagent-Driven Development:**
- Parallel (not sequential)
- Each worker is a separate OS process (not a Task tool subagent)
- Workers cannot ask the lead questions mid-task (fire-and-forget) or require tmux intervention (observable)

## Prerequisites

Before starting, verify:
1. `which tmux` succeeds
2. Implementation plan exists (from globalcoder-development:writing-plans)
3. Clean git state (`git status` shows no uncommitted changes)
4. Correct branch checked out

If any prerequisite fails, stop and resolve before continuing.

## Mode Selection

Ask the user which mode to use:

**Fire-and-forget** — `claude -p` (non-interactive). Workers implement, test, commit, and exit. No human intervention possible mid-task. Best for straightforward tasks with clear specs. Includes `--max-budget-usd 5` per worker as a safety cap.

**Observable autopilot** — Interactive `claude` with `--permission-mode bypassPermissions`. Workers run autonomously but the user can attach to any tmux window to watch or intervene. Best for complex tasks or when you want visibility.

## The Process

### Phase 1: Analyze plan

1. Read the plan file
2. List all tasks with their dependencies
3. Identify the first batch of independent (unblocked) tasks
4. Identify tasks that must wait for dependencies
5. For each task, extract: task number, name, description, files in scope, test command

**Test command auto-detection:**
```bash
# Detect test command from project files
if [ -f package.json ]; then TEST_CMD="npm test -- --run"; fi
if [ -f Cargo.toml ]; then TEST_CMD="cargo test"; fi
if [ -f pyproject.toml ]; then TEST_CMD="pytest"; fi
if [ -f go.mod ]; then TEST_CMD="go test ./..."; fi
```
Use the detected command for `{{TEST_COMMAND}}` in worker prompts.

### Phase 2: Create tmux session

```bash
tmux new-session -d -s <session-name>
```

Session name: derived from plan filename, e.g., `tmux-parallel-dev-<feature>`. If session already exists, ask user whether to kill it and start fresh.

### Phase 3: Spawn workers

For each independent task, construct the command and spawn a tmux window.

**Fire-and-forget command:**

```bash
tmux new-window -t <session> -n "task-N-short-name" \
  "claude -p '<filled-task-prompt>' \
    --plugin-dir ~/Projects/globalcoder-development \
    --allowedTools 'Bash Edit Read Write Glob Grep Task Skill' \
    --model sonnet \
    --max-budget-usd 5 \
    --add-dir '{{PROJECT_ROOT}}' \
    --append-system-prompt '<filled-system-prompt>'"
```

**Observable autopilot command:**

```bash
tmux new-window -t <session> -n "task-N-short-name" \
  "claude \
    --plugin-dir ~/Projects/globalcoder-development \
    --permission-mode bypassPermissions \
    --model sonnet \
    --add-dir '{{PROJECT_ROOT}}' \
    --append-system-prompt '<filled-system-prompt>'"
```

For observable mode, after spawning the window, send the task prompt as the first message:

```bash
tmux send-keys -t <session>:task-N-short-name '<filled-task-prompt>' Enter
```

**Fill templates** using `./worker-system-prompt.md` and `./worker-task-prompt.md`. Replace all `{{PLACEHOLDER}}` values with actual data from the plan.

Tell the user: "Workers spawned in tmux session `<session-name>`. Attach with: `tmux attach -t <session-name>`"

### Phase 4: Monitor

Enter a polling loop. Every 15 seconds:

1. Check for new commits:
   ```bash
   git log --oneline --since="<start-time>" --grep="\[task-"
   ```
2. Check tmux window status:
   ```bash
   tmux list-windows -t <session> -F "#{window_name} #{window_activity}"
   ```
3. Update and print status:
   ```
   [2/5 complete] task-1 done  task-2 done  task-3 running  task-4 queued (blocked by task-2)  task-5 running
   ```

**Dependency handling:** When a blocked task's dependency commit is detected, spawn that task's tmux window immediately.

**Timeout warning:** If a worker has been running for 10+ minutes with no commit, warn the user.

**Failed worker (fire-and-forget only):** If a tmux window's process has exited but no `[task-N]` commit was found, flag it:
```
task-3 FAILED — worker exited without committing. Retry in observable mode? (y/n)
```

### Phase 5: Final verification

Once all tasks have committed:

1. Check for conflicts: `git diff --check`
2. Run full build (detect build command from package.json, Cargo.toml, etc.)
3. Run full test suite
4. Report results to user
5. Clean up: `tmux kill-session -t <session>`

If conflicts or test failures:
- Report which tasks' commits conflict
- Suggest resolution order
- Offer to open an observable session for fixing

### Phase 6: Completion

Use globalcoder-development:finishing-a-development-branch to complete the work.

## Error Recovery

- **Worker crashes (no commit):** Ask user to retry in observable mode or skip task.
- **Merge conflicts between workers:** Pause, report conflicting files and tasks, suggest resolution order.
- **Test failures after all commits:** Report which tests fail, offer to spawn a fix-up worker.
- **tmux session lost:** Check `git log` for commits already made, respawn session for remaining tasks.

## Red Flags

**Never:**
- Spawn workers for tasks that modify the same files
- Skip final verification
- Let fire-and-forget workers run without `--max-budget-usd`
- Proceed if prerequisites fail
- Ignore failed workers

**If all tasks are sequential:**
- Stop. Use subagent-driven-development instead.
- tmux parallelism adds overhead without benefit for sequential work.

## Integration

**Required workflow skills:**
- **globalcoder-development:writing-plans** — Creates the plan this skill executes
- **globalcoder-development:finishing-a-development-branch** — Complete development after all tasks

**Pairs with:**
- **globalcoder-development:brainstorming** — Creates design doc referenced by workers
- **globalcoder-development:using-git-worktrees** — Creates isolated workspace
