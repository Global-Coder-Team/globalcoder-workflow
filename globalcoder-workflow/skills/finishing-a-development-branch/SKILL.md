---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup
---

# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling chosen workflow.

**Core principle:** Verify tests → Present options → Execute choice → Clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

## The Process

### Step 1: Verify Tests

**Before presenting options, verify tests pass:**

```bash
# Auto-detect and run project's test suite
if [ -f package.json ]; then npm test -- --run
elif [ -f Cargo.toml ]; then cargo test
elif [ -f pyproject.toml ]; then pytest
elif [ -f go.mod ]; then go test ./...
else echo "No test framework detected — ask user for test command"
fi
```

**If tests fail:**
```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```

Stop. Don't proceed to Step 2.

**If tests pass:** Continue to Step 2.

### Step 2: Determine Base Branch

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main - is that correct?"

### Step 3: Present Options

Present exactly these 4 options:

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Don't add explanation** - keep options concise.

### Step 4: Execute Choice

#### Option 1: Merge Locally

```bash
# Switch to base branch
git checkout <base-branch>

# Pull latest
git pull

# Merge feature branch
git merge <feature-branch>

# Verify tests on merged result
<test command>

# If tests pass
git branch -d <feature-branch>
```

Then: Cleanup worktree (Step 5)

#### Option 2: Push and Create PR

```bash
# Push branch
git push -u origin <feature-branch>

# Create PR
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>
EOF
)"
```

Then: Cleanup worktree (Step 5)

#### Option 3: Keep As-Is

Report: "Keeping branch <name>. Worktree preserved at <path>."

**Don't cleanup worktree.**

#### Option 4: Discard

**Confirm first:**
```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for exact confirmation.

If confirmed:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

Then: Cleanup worktree (Step 5)

### Step 5: Update Tracking Files

Before cleanup, update the project-init tracking files (if they exist at repo root) to close the loop. Show the proposed diff before writing.

**For Options 1 (merge) and 2 (PR):**

- **`backlog.md`** — Move the completed work item from "In Progress" → "Done". If the item wasn't pre-listed in the backlog, ask the user for a one-line description and append it directly to "Done".
- **`memory.md`** — If the work introduced an architectural decision, a non-obvious convention, or pitfall worth remembering, append a one-line entry under "Key Decisions" or "To Remember Across Sessions". Ask the user "Anything from this work worth recording in memory.md?" — accept "skip" for routine work.

**For Option 4 (discard):**

- **`backlog.md`** — If the item was in "In Progress", move it back to "Next Up" (or remove it, depending on whether the user wants to retry). Ask first.
- **`memory.md`** — If the discard revealed a dead-end approach worth not repeating, append a one-line entry under "To Remember Across Sessions".

**For Option 3 (keep as-is):** Skip this step; no completion event yet.

If the project doesn't have the project-init files, skip this step silently. Don't prompt to run `project-init` mid-finish.

### Step 6: Cleanup Worktree

**For Options 1, 2, 4:**

Check if in worktree:
```bash
git worktree list | grep $(git branch --show-current)
```

If yes:
```bash
git worktree remove <worktree-path>
```

**For Option 3:** Keep worktree.

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Branch |
|--------|-------|------|---------------|----------------|
| 1. Merge locally | ✓ | - | - | ✓ |
| 2. Create PR | - | ✓ | ✓ | - |
| 3. Keep as-is | - | - | ✓ | - |
| 4. Discard | - | - | - | ✓ (force) |

## Common Mistakes

**Skipping test verification**
- **Problem:** Merge broken code, create failing PR
- **Fix:** Always verify tests before offering options

**Open-ended questions**
- **Problem:** "What should I do next?" → ambiguous
- **Fix:** Present exactly 4 structured options

**Automatic worktree cleanup**
- **Problem:** Remove worktree when might need it (Option 2, 3)
- **Fix:** Only cleanup for Options 1 and 4

**No confirmation for discard**
- **Problem:** Accidentally delete work
- **Fix:** Require typed "discard" confirmation

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "Tests passed on the branch — no need to re-run after merge" | Merge can introduce new failures (conflicts, env drift, transitive deps). Verify the merged result. |
| "User said 'we're done' — I'll just merge and skip the options menu" | The 4-option menu is the contract. "We're done" is intent, not instruction. Show the options. |
| "Tests are flaky — I'll proceed anyway" | Flaky tests are still failing tests. Stop. Investigate or get explicit permission to proceed. |
| "No need for typed 'discard' confirmation — user clearly wants Option 4" | The typed gate is what prevents accidental data loss. Get the typed confirmation every time. |
| "I'll just force-push — it's faster than resolving the conflict" | Force-push is not in the skill's option set. If asked to do it, get explicit confirmation first. |
| "The branch was clean — I can clean up the worktree even on Option 2 (PR)" | Worktree cleanup is only for Options 1 and 4. Option 2 (PR) and Option 3 keep the worktree. |
| "Open-ended 'what's next?' is friendlier than the 4 options" | The 4 options exist because open-ended produces ambiguous next steps. Use them. |

## Red Flags

**Never:**
- Proceed with failing tests
- Merge without verifying tests on result
- Delete work without confirmation
- Force-push without explicit request

**Always:**
- Verify tests before offering options
- Present exactly 4 options
- Get typed confirmation for Option 4
- Clean up worktree for Options 1 & 4 only

## Integration

**Called by:**
- **globalcoder-workflow:subagent-driven-development** (Step 7) - After all tasks complete
- **globalcoder-workflow:executing-plans** (Step 5) - After all batches complete

**Pairs with:**
- **globalcoder-workflow:using-git-worktrees** - Cleans up worktree created by that skill
