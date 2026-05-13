---
name: preparing-a-release
description: Use when shipping a release — version bump, CHANGELOG entry, tag, push, suggested reinstall. Especially when the project has multiple manifest files that must stay version-synced (e.g., plugin.json + marketplace.json, package.json + Cargo.toml in workspaces, version.txt + setup.py). Triggers on "ship it," "cut a release," "tag v…," "bump version."
---

# Preparing a Release

## Overview

A release looks like a single change but is actually a multi-file ritual: bump versions across every manifest that holds one, write a CHANGELOG entry from the real commit history (not memory), commit the manifest+CHANGELOG changes together, tag annotated, push commits and tag in one operation, suggest a reinstall path for users.

Each step is small. Missing one creates a release where users see one version in some places and another in others — `plugin.json` was at 1.1.0 while `marketplace.json` sat at 1.0.0 for an entire release cycle in this plugin's own history. The skill exists to prevent that.

## The Iron Law

**Every place the version lives must change in the same commit. No exceptions.**

A release where `plugin.json` says 1.6.0, `marketplace.json` says 1.5.0, and `CHANGELOG.md` says "1.5.0 — added X" is a broken release even if every individual step succeeded. The only safe protocol: enumerate every version location *before* editing, change them all in one batch, grep to confirm zero stragglers.

## When to Use

**Use when:**
- About to tag a new version of a plugin, library, or service
- User says "ship it," "cut a release," "tag v…," "bump version," "prepare v1.X"
- A logical milestone has been reached (feature complete, bug-batch fixed, audit cleanup done)

**Skip when:**
- Mid-feature — wait until the work is at a stopping point
- Docs-only update with no behavior change — no version bump warranted
- The "release" is just `git push` — that's not a release

## Process

### 1. Determine the version bump

Run `git log $(git describe --tags --abbrev=0)..HEAD --oneline` to list commits since the last tag. Classify each:

| Commit type | Bump |
|---|---|
| Removed / renamed public API, changed user-facing defaults | MAJOR |
| New feature, new skill, new command, new capability path | MINOR |
| Bug fix, doc update, internal cleanup, behavior unchanged | PATCH |

If mixed, take the highest. New feature + bug fix = MINOR.

Propose to the user: "Since v1.5.0: <bullet list of commits>. Recommend v1.6.0 (MINOR — adds new X). Confirm or override?" Accept the user's override; don't argue.

### 2. Enumerate every version location

Before editing, grep:

```bash
grep -rn '"version"\|^version\|Version:' --include='*.json' --include='*.toml' --include='*.md' . | grep -v 'node_modules\|.git\|CHANGELOG'
```

Common locations (do not assume — confirm with grep):

| Project type | Version-bearing files |
|---|---|
| Claude Code plugin | `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` (two places in one file: `metadata.version` and `plugins[*].version`), `REFERENCE.md` header, `README.md` header |
| Node package | `package.json`, possibly `package-lock.json` (do NOT hand-edit — run `npm version`) |
| Rust crate | `Cargo.toml`, possibly workspace members |
| Python | `pyproject.toml`, possibly `setup.py`, `__init__.py` |
| Go module | `go.mod` (no version), but version strings in `version.go` or similar |

**List every detected location to the user before editing.** "Found the version in: <paths>. Apply X.Y.Z to all of these?" Wait for confirmation — the user knows about locations grep didn't catch (e.g., a hardcoded string in a hook script).

### 3. Edit every manifest in one batch

Apply the new version to every file from Step 2. After editing, re-grep to confirm zero stragglers at the old version:

```bash
grep -rn 'OLD_VERSION' . | grep -v 'node_modules\|.git\|CHANGELOG'
```

The CHANGELOG keeps the old version intact (it's history). Everything else must be on the new version. If grep returns anything else, you missed a location — fix and re-grep.

### 4. Write the CHANGELOG entry

Format under [Keep a Changelog](https://keepachangelog.com/) conventions. Group entries under: **Added / Changed / Fixed / Removed / Deprecated**.

Use the commit list from Step 1 as input — read the actual commit messages, don't write from memory. Each CHANGELOG line should describe the *user-visible* change, not the implementation detail. ("Added `/project-init` slash command" is user-visible; "Refactored frontmatter parsing into separate function" is not.)

Place the new entry at the top of `CHANGELOG.md`, above the previous version's entry. Include the date in ISO format.

### 5. Commit

Stage the manifest changes + CHANGELOG:

```bash
git add <every-file-from-step-2> CHANGELOG.md
git status   # confirm only the intended files are staged
git commit -m "<type>: <summary> (vX.Y.Z)"
```

Commit message type matches semver: `feat:` (MINOR), `fix:` (PATCH), `feat!:` or `refactor!:` (MAJOR — note the `!`). Body should reference CHANGELOG.md for details rather than duplicating its contents.

### 6. Tag

Annotated tag, not lightweight (annotated tags carry metadata; lightweight tags don't):

```bash
git tag -a vX.Y.Z -m "vX.Y.Z: <one-line summary>

See CHANGELOG.md for details."
```

### 7. Push commits and tag together

```bash
git push <remote> <branch> --follow-tags
```

`--follow-tags` pushes annotated tags reachable from the pushed commits in the same operation. Pushing the branch and the tag separately creates a window where they're out of sync.

### 8. Report and suggest reinstall

```
Released vX.Y.Z to <remote>. Commit <sha>, tag pushed.

If users installed via a marketplace cache, suggest:
  claude plugin install <plugin>@<marketplace>
to refresh.
```

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "I'll update `marketplace.json` later" | "Later" is when users install the stale version. Update in the same commit. |
| "The CHANGELOG can wait until tomorrow" | The commits are cold by tomorrow. Write the entry now, while context is fresh. |
| "It's a small change, no version bump needed" | If you're tagging, you're bumping. Pick the right level (often PATCH) but don't skip. |
| "I'll push without the tag, tag later" | Tagless commits create a phantom release — users on `latest` get the new behavior but version markers say otherwise. Always `--follow-tags`. |
| "I'll skip the grep, I know every version location" | The whole reason this skill exists is that someone (often the same person) missed `marketplace.json` once already. Always grep. |
| "It's a minor visible change — patch is fine" | Adding a new feature is MINOR regardless of size. Renaming a flag users have written into their settings is MAJOR. Be honest about the impact. |
| "I'll write the CHANGELOG entry from memory" | You'll miss commits. Read `git log` between the tags. |

## Red Flags — STOP

- About to edit only one manifest when grep showed the version lives in multiple files → STOP. Edit them all in one batch.
- About to push commits without the corresponding tag → STOP. Use `--follow-tags`, or push the tag explicitly in the same operation.
- About to write a CHANGELOG entry without running `git log <last-tag>..HEAD --oneline` first → STOP. Read the actual commits.
- About to bump only the patch number for a release that added new user-visible functionality → STOP. That's a MINOR bump.
- About to commit and tag without re-running the grep to confirm zero stragglers at the old version → STOP. Grep is the safety check.
- About to use a lightweight tag (`git tag vX.Y.Z`) instead of annotated (`git tag -a`) → STOP. Annotated carries the release message.

## After Release

- Suggest the user verify the tag is on the remote: `git ls-remote --tags <remote>`
- If the release fixes a security issue, suggest a security advisory follow-up (not handled by this skill)
- If the project uses an installable cache (Claude Code marketplace, npm, PyPI), report the reinstall command and any cache TTL caveats
