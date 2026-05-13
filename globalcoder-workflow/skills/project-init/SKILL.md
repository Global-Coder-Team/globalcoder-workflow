---
name: project-init
description: Use when starting a new project from scratch and the foundational MD files need to be established — CLAUDE.md (workflow contract), memory.md, tech_stack.md, style_guide.md, backlog.md, tech_docs.md. Triggers on "set up a new project," "scaffold project docs," "init project context," "bootstrap project," or any time the user is in a fresh repo with no existing CLAUDE.md and needs the workflow locked.
---

# Project Init

## Overview

**A new project starts with a workflow contract, not a hero component.**

Without an upfront workflow lock, projects drift into ad-hoc patterns: features get coded before they're designed, decisions get lost between sessions, the tech stack lives only in `package.json`, style is enforced inconsistently. This skill writes six foundational markdown files at repo root that prevent the drift, and locks the development workflow to brainstorming-first via the CLAUDE.md it produces.

| File | Purpose |
|---|---|
| `CLAUDE.md` | Workflow contract — locks development to brainstorming → plan → execute → verify → finish |
| `memory.md` | Continuity log — active work, decisions, what to remember across sessions |
| `tech_stack.md` | Architecture — languages, frameworks, infrastructure |
| `style_guide.md` | Convention — naming, code style, patterns to follow and avoid |
| `backlog.md` | Tasks — in progress, next up, later, done |
| `tech_docs.md` | Reference — external APIs, library constraints, complex logic |

All six live at repo root, alongside (not inside) `.git/`.

## The Iron Law

**Never overwrite existing files. If any of the six already exist, refuse and exit.**

The intended scenario is "fresh project, no docs yet." The corruption scenario is "user runs project-init in a mature repo and loses CLAUDE.md, backlog history, or decision logs." Refuse-and-exit is the only safe default. The user must explicitly delete or rename existing files to proceed — that friction is the safety.

## When to Use

**Use when:**
- Fresh repo or fresh project with no `CLAUDE.md` at root
- User says "set up a new project," "scaffold docs," "init project context," "bootstrap project"
- After `git init` on a new directory, before any feature work

**Skip when:**
- `CLAUDE.md` already exists — read it instead, don't rewrite
- Existing project with established workflow — don't disrupt
- User only needs one of the six files — edit that file directly instead

## Process

### 1. Detect existing files

Before asking anything or writing anything, check all six target paths at repo root:

```bash
for f in CLAUDE.md memory.md tech_stack.md style_guide.md backlog.md tech_docs.md; do
  [ -e "$f" ] && echo "EXISTS: $f"
done
```

**If any exist, refuse and exit:**

```
Cannot run project-init: the following files already exist at repo root:
  - <list>

This skill refuses to overwrite existing docs to prevent data loss. To proceed:
  (a) Delete or rename the existing files, then re-run this skill, OR
  (b) Skip this skill and edit the existing files directly.
```

Stop. Do not proceed. Do not offer to merge.

### 2. Interview the user

Conduct a brief interview to populate the templates with **real** content the user knows now. Empty scaffolding is the fallback, not the goal — the value of this skill comes from capturing what's known at project start, before it gets forgotten.

Follow brainstorming-style discipline:
- **One question at a time.** Never batch questions in a single message.
- **Prefer multiple-choice** presentation when the option space is well-known (frameworks, formatters, language). Use whatever multi-choice mechanism your environment provides (e.g., `AskUserQuestion` in Claude Code).
- **Accept "skip" / "TBD" / "I don't know"** for any individual question — write that value as-is. The point is to capture what's known *now*, not extract perfection.

**Required questions (always ask, in order):**

1. **Project name** — one short word or kebab-case (e.g., `acme-portal`). Interpolated into `CLAUDE.md` and `memory.md`.
2. **One-line purpose** — what does this project do, in a sentence. Goes into `CLAUDE.md`.

**Optional section gate:**

Ask the user which optional sections to fill in now (offer as a multi-select):
- Tech stack
- Style guide
- Initial backlog
- Tech docs

For each section the user picks, run the sub-questions below. Sections the user skips get the empty template as-is.

**If "tech stack" picked, ask in sequence (one per turn):**
- Primary language (with version if known, e.g., TypeScript 5.4)
- Framework, if any (Next.js, FastAPI, etc.)
- Data layer (database, cache, object storage)
- Infrastructure / hosting (Vercel, Fly.io, AWS, etc.)
- Tooling (package manager, formatter, linter, test runner)

**If "style guide" picked, ask in sequence:**
- Formatter / linter preference (Prettier, Ruff, Biome, ESLint, etc.)
- File and branch naming conventions
- Commit message format (Conventional Commits, free-form, etc.)

**If "initial backlog" picked, ask:**
- 1–3 starter tasks to put under "Next Up"

**If "tech docs" picked, ask:**
- External APIs to document upfront (name + 1-line context for each)
- Known library quirks or version-pin constraints

### 3. Write all six files

Write each of the six files at repo root using the templates in the "File Templates" section below.

- **Interpolation:** Replace `{PROJECT_NAME}` and `{PROJECT_PURPOSE}` with the answers from Step 2.
- **Filled sections:** For each section the user provided answers for, replace the italic `_e.g., ..._` placeholder with their actual answer. Keep the section header.
- **Skipped sections:** Leave the italic placeholder as-is. It serves as a prompt for the user when they come back to fill it later.

Write all six files — never skip a file because "the user didn't fill it in." The empty template is still the scaffolding.

### 4. Report and hand off

```
Scaffolded 6 docs at repo root:
  CLAUDE.md           Workflow contract (locks brainstorming-first)
  memory.md           Continuity log
  tech_stack.md       Architecture
  style_guide.md      Conventions
  backlog.md          Tasks
  tech_docs.md        Reference

<note any sections left as empty templates so the user knows what's still TBD>

Next: for the first feature, invoke globalcoder-workflow:brainstorming.
```

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "Just write the templates — interview is overkill for the user" | The point of the skill is to capture what's known *now*. Empty templates with "_e.g., ..._" placeholders are the fallback for what the user explicitly skips, not the default for everything. |
| "I'll batch all the interview questions in one message" | One question at a time. Batching mixes signals and produces sloppier answers. |
| "Most of these files will be empty — I'll skip the empty ones" | Empty templates with headers ARE the scaffolding. They prompt the right entries when info arrives. Skip = friction later. |
| "CLAUDE.md exists from `/init` — I'll just add the other 5" | Mixed states cause confusion. Refuse, tell the user to delete the existing CLAUDE.md, then re-run. |
| "User said 'set up docs' — README.md + CONTRIBUTING.md is enough" | The six files have specific roles. README.md is for humans browsing the repo; these six are for Claude's working context. Don't substitute. |
| "Templates are overkill — I'll write 1-line files" | The section headers (`## Active Work`, `## Key Decisions`) are what direct future updates to the right place. Don't strip them. |
| "I'll put them under `docs/` to keep root clean" | All six live at repo root. Keeping them at root means Claude reads them without path-guessing. |
| "User wants me to start coding now — the docs can wait" | The docs ARE starting. CLAUDE.md locks the workflow that prevents the next-three-hours-of-rework problem. |

## Red Flags — STOP

- About to write any of the six files before completing the interview → STOP. Interview first.
- About to ask multiple interview questions in a single message → STOP. One at a time.
- About to write `CLAUDE.md` and it already exists → STOP. Refuse and exit.
- About to skip one of the six files because "it's not relevant yet" → STOP. Write the empty template.
- About to write files in `docs/` or `.claude/` or anywhere other than repo root → STOP. Root is the spec.
- About to invent new file names (e.g., `tasks.md` instead of `backlog.md`, `ADR.md` instead of `memory.md`) → STOP. Use the canonical names.
- About to start coding the first feature before the user has confirmed the scaffolding → STOP. Hand off to brainstorming first.

## File Templates

### CLAUDE.md

````markdown
# {PROJECT_NAME}

{PROJECT_PURPOSE}

## Workflow Discipline

This project uses the **globalcoder-workflow** plugin. All creative work follows this sequence, in order:

1. **Brainstorm** (`globalcoder-workflow:brainstorming`) — Explore intent, requirements, alternatives. Produce a design doc under `docs/plans/`.
2. **UI Design Bootstrap** (`globalcoder-workflow:ui-design-bootstrap`) — Only if the design has UI. Codify visual decisions into `DESIGN.md` before any component code.
3. **Write Plan** (`globalcoder-workflow:writing-plans`) — Convert the design into bite-sized TDD tasks.
4. **Execute** — Choose one of `subagent-driven-development`, `agent-team-development`, or `tmux-parallel-development`.
5. **Verify** (`globalcoder-workflow:verification-before-completion`) — Confirm tests pass and build succeeds.
6. **Finish** (`globalcoder-workflow:finishing-a-development-branch`) — Merge, PR, or cleanup.

**Iron rule: do not start coding before a plan exists. Brainstorming is the entry point for every feature.** If the user asks for code directly, ask "Should we brainstorm this first?" before starting.

## Project Context Files

These files live alongside this one at repo root. Read the relevant ones for the task at hand.

- **memory.md** — Active work, key decisions, what to remember across sessions
- **tech_stack.md** — Languages, frameworks, infrastructure
- **style_guide.md** — Naming, code style, patterns to follow and avoid
- **backlog.md** — In progress, next up, later, done
- **tech_docs.md** — External APIs, library constraints, complex logic notes

## When Starting Work

1. Read this file (already done by being here)
2. Read `memory.md` for current context
3. Check `backlog.md` if the user is asking "what's next"
4. Reference `tech_stack.md` and `style_guide.md` when writing code
5. Reference `tech_docs.md` when integrating external systems
````

### memory.md

````markdown
# Project Memory

Continuity log for {PROJECT_NAME}. Append entries when significant decisions are made, active work changes, or context worth surviving a session restart emerges.

## Active Work

_What is in flight right now. Update when starting or finishing work._

## Key Decisions

_Architectural or directional decisions worth remembering, with rationale (the "why" matters more than the "what")._

## To Remember Across Sessions

_Context that should survive a `/clear` or restart — pitfalls discovered, conventions established, things future-you would otherwise re-discover._
````

### tech_stack.md

````markdown
# Tech Stack

## Languages

_e.g., TypeScript 5.4, Python 3.12_

## Frameworks

_e.g., Next.js 14 (App Router), FastAPI, Remix_

## Data Layer

_e.g., PostgreSQL 16 via Prisma, Redis for caching, S3 for assets_

## Infrastructure

_e.g., Vercel for frontend, Fly.io for API, Cloudflare R2 for storage_

## Tooling

_Build tools, test runners, package managers, formatters, linters._
````

### style_guide.md

````markdown
# Style Guide

## Naming

_File names, function names, variable conventions, branch naming._

## Code Style

_Formatter (Prettier, Ruff, etc.), linter rules, language-specific conventions._

## Patterns to Follow

_Reusable conventions established in this codebase — file organization, error handling, state management._

## Patterns to Avoid

_Anti-patterns or rejected approaches, with the reasoning. Prevents re-litigation._

## Commit & PR Conventions

_Commit message format, PR title format, review expectations._
````

### backlog.md

````markdown
# Backlog

## In Progress

_Tasks currently being worked on. One ID or short description per line._

## Next Up

_Top of the queue. Ready to pull when current work finishes._

## Later

_Worth doing eventually. Not urgent. Don't let this list grow unbounded — prune monthly._

## Done

_Recently completed work worth keeping visible. Archive to git history when the list gets long._
````

### tech_docs.md

````markdown
# Technical Reference

## External APIs

_API docs, endpoints, auth flows, rate limits for services we depend on. Paste-in style — when an integration is non-obvious, the relevant excerpt lives here._

## Library Constraints

_Quirks, gotchas, or version-pin reasons for dependencies that affect implementation choices._

## Complex Logic

_Explanations of non-obvious internal logic worth preserving — algorithms, multi-step flows, invariants, edge cases._
````

## Hand-Offs

- **After this skill:** First feature work → `globalcoder-workflow:brainstorming`. The CLAUDE.md template you wrote enforces this.
- **Pairs with:** `globalcoder-workflow:using-git-worktrees` for isolating feature work once development begins.
- **Do not call:** `globalcoder-workflow:writing-plans` before `brainstorming` has produced a design doc. CLAUDE.md enforces this order.
