---
name: project-init
description: Use when establishing the foundational MD files for a project — CLAUDE.md (workflow contract), memory.md, tech_stack.md, style_guide.md, backlog.md, tech_docs.md. Works for both empty directories (interview from scratch) and existing codebases (scan first, then ask only the gaps). Triggers on "set up a new project," "scaffold project docs," "init project context," "bootstrap project," "add the workflow files to this repo."
---

# Project Init

## Overview

**A project starts with a workflow contract, not a hero component.**

Without an upfront workflow lock, projects drift into ad-hoc patterns: features get coded before they're designed, decisions get lost between sessions, the tech stack lives only in `package.json`, style is enforced inconsistently. This skill writes six foundational markdown files at repo root that prevent the drift, and locks the development workflow to brainstorming-first via the CLAUDE.md it produces.

The skill handles two scenarios:
- **Empty directory** — interviews from scratch (project name, purpose, optional sections one question at a time)
- **Existing codebase** — scans the repo first, proposes detected values for the user to confirm, then asks only about the gaps

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

### 2. Detect scenario: empty directory or existing codebase

After confirming none of the six target files exist, check whether the repo has any other content:

```bash
# Any non-hidden files/dirs besides .git?
ls -A | grep -v '^\.git$' | head -1
```

- **No output** → empty directory. Go to Step 3a (interview from scratch).
- **Has content** → existing codebase. Go to Step 3b (scan first, then ask gaps).

### 3a. Interview from scratch (empty directory)

Conduct a brief interview to populate the templates with **real** content the user knows now. Empty scaffolding is the fallback, not the goal — the value comes from capturing what's known at project start.

Follow brainstorming-style discipline:
- **One question at a time.** Never batch questions in a single message.
- **Prefer multiple-choice** presentation when the option space is well-known (frameworks, formatters, language). Use whatever multi-choice mechanism your environment provides (e.g., `AskUserQuestion` in Claude Code).
- **Accept "skip" / "TBD" / "I don't know"** for any individual question — write that value as-is.

**Required questions (always ask, in order):**

1. **Project name** — one short word or kebab-case (e.g., `acme-portal`). Interpolated into `CLAUDE.md` and `memory.md`.
2. **One-line purpose** — what does this project do, in a sentence. Goes into `CLAUDE.md`.

**Optional section gate:** Ask which optional sections to fill in now (multi-select):
- Tech stack
- Style guide
- Initial backlog
- Tech docs

For each picked section, run the sub-questions below. Sections the user skips get the empty template as-is.

**If "tech stack" picked**, ask the questions below in sequence — but recommendations **cascade** (each answer narrows the next question's defaults). Use the same prompt format as the style guide: "Q? Recommended: X. Accept, customize, or skip." If the user accepts, write the recommended value into `tech_stack.md` — do not leave the placeholder. Only leave the placeholder when the user explicitly says "skip" for that field.

**1. Primary language.** No single recommendation — offer the common choices as a multiple-choice prompt:

> "Primary language? Common choices: TypeScript, JavaScript, Python, Rust, Go, Ruby, Java, C#. Pick one, type a custom answer, or skip."

The language answer drives every subsequent recommendation. If the user skips, run the rest of the questions open-ended.

**2. Framework.** Recommendation depends on the language picked:

| Language | Framework recommendation |
|---|---|
| TypeScript / JavaScript | Web app: **Next.js** (or Remix). API only: **Hono** or Express. Frontend only: **Vite + React**. |
| Python | API: **FastAPI**. Full-stack: **Django**. Lightweight: Flask. |
| Rust | Web/API: **Axum**. CLI: **clap**. |
| Go | API: standard **net/http** (or Echo / Chi for more structure). |
| Ruby | **Rails**. |

**3. Data layer.** Recommendation depends on language + framework:

| Language + framework | Data layer recommendation |
|---|---|
| TS + Next.js / Remix / Hono | **Postgres + Prisma** (or Drizzle for type-safe alt) |
| TS + Node API | **Postgres + Drizzle** (or Prisma) |
| Python + FastAPI | **Postgres + SQLAlchemy (async)** or asyncpg directly |
| Python + Django | **Postgres + Django ORM** |
| Rust + Axum | **Postgres + sqlx** |
| Go | **Postgres + pgx + sqlc** |
| Ruby + Rails | **Postgres + ActiveRecord** |

For caching/object storage, recommend **Redis** for cache and **S3 / Cloudflare R2** for object storage if the user signals they need it; otherwise omit and don't ask separately.

**4. Infrastructure / hosting.** Recommendation depends on language + framework:

| Language + framework | Hosting recommendation |
|---|---|
| TS + Next.js | **Vercel** (best fit). Alternatives: Fly.io, Railway, Render. |
| TS + Node API | **Fly.io** or **Railway**. Render also fine. |
| Python | **Fly.io** or **Railway** (long-running). **AWS Lambda** for serverless. |
| Rust | **Fly.io**, **Railway**, or **shuttle.rs**. |
| Go | **Fly.io**, **Railway**, or **Cloud Run**. |
| Ruby + Rails | **Fly.io** or **Render**. Heroku still works. |

**5. Tooling** (package manager, test runner, formatter, linter, type-checker — one bundle question). Recommendation depends on language:

| Language | Tooling recommendation |
|---|---|
| TypeScript | **pnpm + Vitest + Prettier + ESLint + tsc** |
| JavaScript | **pnpm + Vitest + Prettier + ESLint** |
| Python | **uv + pytest + Ruff + mypy** |
| Rust | **cargo + rustfmt + clippy** (built-in test runner) |
| Go | **go modules + go test + gofmt + golangci-lint** |
| Ruby | **bundler + rspec + Rubocop** |

Present the tooling bundle as one prompt ("Tooling? Recommended: pnpm + Vitest + Prettier + ESLint + tsc. Accept, customize, or skip.") rather than asking five separate sub-questions — agents-of-decision-fatigue is real.

**If "style guide" picked**, ask the questions below in sequence — but for each, **propose a recommended default** based on the tech stack the user established above (or generic best practices if no stack was chosen). Format each prompt as:

> "Q? Recommended: X. Accept, customize, or skip."

If the user accepts, write the **recommended value** into `style_guide.md` — do *not* leave the italic placeholder. Only leave the placeholder when the user explicitly says "skip."

Use the Stack Recommendations table (below) to pick the default per question:

**Stack Recommendations:**

| Stack | Formatter / Linter | File naming | Branch naming | Commit format |
|---|---|---|---|---|
| TypeScript + Next.js / Remix | Prettier + ESLint | kebab-case routes, PascalCase components, camelCase utils | `feature/`, `fix/`, `chore/` + kebab-case | Conventional Commits |
| TypeScript + Node / Express | Prettier + ESLint | camelCase files, PascalCase types | `feature/`, `fix/`, `chore/` | Conventional Commits |
| Python + FastAPI / Django / Flask | Ruff + Black | snake_case throughout | `feature/`, `fix/`, `chore/` | Conventional Commits |
| Rust | rustfmt + clippy | snake_case files, PascalCase types | `feature/`, `fix/` | Conventional Commits |
| Go | gofmt + golangci-lint | snake_case files, PascalCase exported | `feature/`, `fix/` | Conventional Commits |
| Ruby + Rails | Rubocop + Standard | snake_case throughout | `feature/`, `fix/` | Free-form or Conventional |
| (no stack chosen) | Project-language formatter | kebab-case | `feature/`, `fix/`, `chore/` | Conventional Commits |

**Ask in sequence (one per turn):**
1. Formatter / linter preference — recommend from table
2. File and variable naming convention — recommend from table
3. Branch naming convention — recommend from table
4. Commit message format — recommend from table
5. **Patterns to follow** — if a stack was chosen, offer stack-specific suggestions to seed (e.g., for Next.js: "Server Components by default, Server Actions for mutations, route handlers in `app/api/`"). For unknown stack, ask the user or skip.
6. **Patterns to avoid** — same: stack-specific anti-patterns if known (e.g., for Next.js: "no client-side state for server data, no `useEffect` for data fetching"). Otherwise ask or skip.

**If "initial backlog" picked**, do not ask open-ended. Offer **stack-aware starter tasks** as a multi-select first, then collect any custom additions. Format the multi-select as:

> "Common starter tasks for {stack}: \n  a) ... \n  b) ... \n  c) ... \n  d) ... \n  e) ...\nPick any to seed under 'Next Up' (multi-select). Add custom items after, or 'skip all'."

Use the table below to pick the candidate set:

| Stack | Recommended starter tasks (5 candidates) |
|---|---|
| TypeScript + Next.js / Remix | Auth (NextAuth/Clerk); DB schema + migrations (Prisma/Drizzle); Core data-model CRUD; First end-to-end feature; Deploy pipeline |
| TypeScript + Node API | API scaffolding + first endpoint; DB schema + migrations; Auth middleware; Error handling + logging; Deploy + smoke test |
| Python + FastAPI | Auth (JWT/OAuth2); DB models + Alembic; Core resource CRUD; Background tasks (Celery/arq); Deploy + healthcheck |
| Python + Django | User model + auth; First app + model; Admin panel; First public view; Deploy + collectstatic |
| Rust + Axum | Server scaffolding + first route; DB + sqlx setup; Core handler + types; Error handling + tracing; Deploy |
| Go | Server scaffolding + first route; DB + migrations; Auth middleware; Logging + observability; Deploy |
| Ruby + Rails | Auth (Devise or custom); First resource (model+controller+views); Background jobs (Sidekiq); Test scaffolding; Deploy |
| (no stack chosen) | Set up CI; Pre-commit formatter+linter hook; First integration test; Deploy preview env; README usage docs |

After the user picks (or skips), ask **one** follow-up: "Any custom starter tasks to add? (1–3, or 'skip')."

Write the combined selection (picked + custom) under "Next Up" in `backlog.md`. Leave "In Progress" and "Done" as italic placeholders — those fill in naturally as work proceeds.

**If "tech docs" picked**, run three sub-questions in sequence. For external APIs (Q1), present a stack-aware multi-select rather than asking open-ended. For Q2 and Q3, ask with a stack-aware *hint* of common quirks but accept open-ended answers.

**1. External APIs.** Infer the project type from the user's one-line purpose (SaaS / marketing site / internal tool / API backend / CLI). Default to the SaaS list when ambiguous — it covers the broadest case.

| Project type signal | Recommended API candidates |
|---|---|
| SaaS, subscription, marketplace, product (default) | Payment (Stripe / Paddle); Auth (NextAuth / Clerk / Auth0); Email (Resend / SendGrid / Postmark); Analytics (PostHog / Mixpanel); Error tracking (Sentry) |
| Marketing site, blog, landing, docs | CMS (Sanity / Contentful / Hygraph); Email collection (ConvertKit / Mailchimp); Analytics (Plausible / Fathom); Search (Algolia / typesense); Image CDN (Cloudinary / Imgix) |
| Internal tool, dashboard, admin | Auth (SSO / Okta); Telemetry source (Datadog / Grafana); Secret manager (Vault / AWS SM); Audit log destination; Database read replica |
| Mobile API backend | Push (FCM / APNs); Object storage (S3 / R2); CDN; Auth provider; Crash reporting (Sentry / Bugsnag) |
| DevOps / CLI tool | Cloud SDK (AWS / GCP / Azure); GitHub API; OpenTelemetry; Update checker; Telemetry endpoint |

Prompt: "Common external APIs for {project type}: a)... b)... c)... d)... e)... Pick which you're planning to use (multi-select), plus any custom APIs (name + 1-line context per custom). Or 'skip'."

**2. Library quirks.** Ask with stack-aware examples to prime the user's memory; accept open-ended.

Hint examples to surface (pick the one matching the user's stack):
- TS + Next.js: App Router caching behavior, Server Actions error handling, Edge runtime limits
- TS + Prisma: migration drift between dev/prod, JSON field types, transaction batching
- Python + SQLAlchemy: async session management, eager vs lazy loading in async contexts
- Python + Pydantic: v1 → v2 migration gotchas, model_config quirks
- Rust + sqlx: compile-time query checking, offline mode for CI
- Go: context cancellation, goroutine leaks
- Ruby + Rails: ActiveRecord N+1, callback ordering

Prompt: "Any known library quirks worth flagging upfront? Common for {stack}: {1-3 hints from above}. List any (description + 1-line context per item), or 'skip'."

**3. Complex internal logic.** Usually empty at init.

Prompt: "Any non-obvious internal logic to document upfront — algorithms, multi-step flows, invariants? (Most projects skip at init and fill in as it arises.) List any, or 'skip'."

### 3b. Scan-and-confirm (existing codebase)

Don't ask the user questions you can answer by reading the repo. Scan first, propose detected values, then ask only about the gaps.

**Read these sources (whichever exist) and extract what you can:**

| Source | Fields it informs |
|---|---|
| `package.json` | Project name (`name` field), language (Node/TS), framework (from deps: next, remix, express, fastify, vite, etc.), test runner (vitest, jest, mocha), package manager (from `packageManager` or lockfile), ORM (prisma, drizzle, kysely), formatter (prettier dep), linter (eslint, biome) |
| `tsconfig.json` | TypeScript usage + version (from `typescript` dep) |
| `pyproject.toml`, `requirements.txt`, `Pipfile`, `setup.py` | Python version, framework (fastapi, django, flask), tooling (ruff, black, mypy, pytest), dependencies |
| `Cargo.toml` | Rust + framework (axum, actix), dependencies |
| `go.mod` | Go version, module path, dependencies |
| `Gemfile`, `*.gemspec` | Ruby + framework (rails, sinatra) |
| `.prettierrc*`, `.eslintrc*`, `biome.json`, `ruff.toml`, `.rubocop.yml`, `.editorconfig` | Formatter, linter rules |
| Sample of 10–20 source files (e.g., `find src -type f \| head -20`) | **File naming convention** — infer dominant case (kebab, camel, snake, Pascal) by inspecting actual filenames |
| One or two representative source files (read full content) | **Code style hints** — indentation (tabs vs spaces, 2 vs 4), trailing semicolons (TS), single/double quotes, brace style |
| `git branch -a \| head -20` | **Branch naming convention** — infer prefix pattern (`feature/`, `fix/`, etc.) from existing branches |
| `grep -rn 'TODO\\|FIXME\\|XXX' --include='*.{ts,tsx,js,py,rs,go,rb,md}' . \| head -20` | **Backlog candidates** — pending work the team has flagged inline |
| README.md "TODO", "Roadmap", "Future", "Planned" sections | **Backlog candidates** from explicit roadmap text |
| `git log --oneline -30 \| grep -iE 'wip\|todo'` | **Backlog candidates** from WIP/TODO commit subjects |
| `gh issue list --limit 20` (if `gh` is available and authenticated) | **Backlog candidates** from open GitHub issues |
| Imports of known service SDKs (`stripe`, `@sendgrid/mail`, `resend`, `@aws-sdk/*`, `posthog`, `@sentry/*`, `boto3`, etc.) | **External APIs in use** — for tech_docs External APIs section |
| Env var keys in `.env.example` / `.env` (e.g., `STRIPE_API_KEY`, `RESEND_API_KEY`, `AWS_REGION`, `SENTRY_DSN`) | **External APIs in use** (often the most reliable signal) |
| README "Integrations", "Dependencies", "External Services" sections | **External APIs in use** from explicit docs |
| Known-quirky library versions in lockfiles / manifests (e.g., Prisma <5, Pydantic v1, SQLAlchemy 1.x) | **Library constraints** worth flagging upfront |
| `prisma/schema.prisma`, `drizzle.config.*`, `alembic.ini`, `schema.rb` | Data layer + ORM |
| `Dockerfile`, `docker-compose.*`, `fly.toml`, `vercel.json`, `wrangler.toml`, `netlify.toml`, `railway.json` | Infra / hosting |
| `.github/workflows/*.yml`, `.gitlab-ci.yml`, `.circleci/config.yml` | CI / build / test commands |
| `README.md` | Project purpose (extract title and first paragraph) |
| `git log -20 --pretty=format:'%s'` | Commit convention (Conventional Commits if prefixes like `feat:` / `fix:` dominate) |
| Directory listing (`ls`, `tree -L 2`) | Repo layout hints |

**Present the detection summary to the user, then ask for confirmation in one turn:**

```
I scanned the codebase. Here's what I detected:

  Project name:    invoice-pilot (from package.json)
  Purpose:         <from README.md title/first paragraph, or "(not detected)">
  Language:        TypeScript 5.4
  Framework:       Next.js 14.2.3
  Data layer:      Prisma + PostgreSQL
  Infrastructure:  Vercel (vercel.json present)
  Tooling:         pnpm, Vitest, Prettier, ESLint
  Commit format:   Conventional Commits (detected from recent commits)

Confirm all, or list corrections (e.g., "data layer is actually Drizzle, infra is Fly.io").
```

After confirmation, ask **only the gaps** — the fields the scan couldn't determine. Common gaps:

- **Purpose** (if no README.md or README has no clear purpose line) — ask "One-line purpose?"
- **Project name** (if no `package.json` / `Cargo.toml`) — ask, defaulting to the repo directory name
- **Initial backlog** — ask if there are 1–3 starter tasks to record (or skip)
- **Tech docs** — ask if there are external APIs / library quirks worth documenting up front (or skip)
- **Style guide gaps** — when naming convention or branch naming is ambiguous (mixed signals in the repo) or absent (only one branch, no source files yet), ask **with a recommendation** from the Stack Recommendations table — don't leave it open-ended.
- **Tech stack gaps** — when the scan detects the language but not the framework / data layer / hosting (rare but happens in monorepo subdirs or pre-deployment repos), use the **cascading recommendations** from Step 3a's tech-stack tables. Format: "I couldn't detect your hosting. Recommended for {detected stack}: {X}. Accept, customize, or skip."
- **Backlog seeding** — when the scan turned up TODO/FIXME comments, README roadmap items, WIP commits, or open issues, present them as a multi-select: "Found {N} candidate backlog items in this repo. Pick which to seed under 'Next Up' (multi-select), or 'skip all'." If the scan found nothing, fall back to stack-aware starter tasks (see Step 3a backlog table).
- **Tech docs seeding** — when the scan detected SDK imports or env vars pointing at external services, present them as a multi-select: "Detected integrations: Stripe, Resend, Sentry. Pick which to document under External APIs (multi-select), or 'skip all'." If nothing detected, fall back to the stack-aware External API recommendations (see Step 3a tech-docs table). For library constraints, surface any known-quirky pinned versions with a brief note for the user to expand on.
- **Patterns to follow / avoid** — these almost never come from a scan. Offer stack-specific recommendations (see Step 3a) and let the user accept/customize/skip.

Use the same one-question-at-a-time discipline as Step 3a for gap questions, and the same "Recommended: X. Accept, customize, or skip." format so the user always has a default to fall back on.

### 4. Write all six files

Write each of the six files at repo root using the templates in the "File Templates" section below.

- **Interpolation:** Replace `{PROJECT_NAME}` and `{PROJECT_PURPOSE}` with the answers / detected values.
- **Filled sections:** Replace each italic `_e.g., ..._` placeholder with the actual value (from scan, user answer, or accepted recommendation). Keep the section header.
- **Skipped sections:** Leave the italic placeholder as-is *only* when the user explicitly said "skip" for that field. If the user accepted a recommendation, write the recommendation as the value.
- **Undetected fields in scan mode**: if the scan couldn't determine a field and the user hasn't been asked yet, use a stack-aware recommendation from the Stack Recommendations table rather than leaving the placeholder.

Write all six files — never skip a file because "the user didn't fill it in." The empty template is still the scaffolding.

### 5. Report and hand off

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
| "Repo has files — I'll skip the scan and just interview the user" | If `package.json` exists, asking the user "what's your framework?" wastes their time. Scan first; ask only the gaps. |
| "Scan is good enough — I'll write everything without confirming" | Detection is heuristic and can be wrong (e.g., Prisma listed as devDep that's been replaced by Drizzle). Always show the detection summary and let the user correct before writing. |
| "User said 'skip' early in the style-guide flow — I'll just leave the placeholder" | Only if the user said skip *for that specific question*. If they're still answering, propose the stack-aware recommendation rather than leaving sections empty. |
| "There's no clear best practice — I'll ask open-ended" | Open-ended questions force the user to invent answers under pressure. Propose a recommendation; let them override if they have one. The recommendation tables cover the common cases for both style and tech-stack questions. |
| "I asked the language; now I'll ask the framework open-ended" | Recommendations *cascade*. Once the language is known, the framework / data layer / hosting / tooling recommendations narrow accordingly. Use them. |
| "Let me ask separately about package manager, test runner, formatter, linter, type-checker" | One question for the tooling bundle, not five. Decision fatigue erodes the value of every additional prompt. |
| "Backlog is the user's job — I'll just leave it empty" | For an existing codebase, scan TODOs / FIXMEs / README roadmaps / open issues — that's the user's existing backlog the project just hasn't surfaced yet. For empty dirs, offer stack-aware starter tasks. Empty backlog is the last resort. |
| "Asking open-ended 'what are your starter tasks?' is fine" | Open-ended invites blank-page paralysis. Offer the stack's recommended starter set as multi-select; let the user pick a subset, then optionally add custom items. |
| "External APIs are too project-specific to recommend" | They're more predictable than they seem. SaaS projects almost always need payment + auth + email + analytics + error tracking. Offer the common set as multi-select; let the user pick what applies and add custom. |
| "I scanned the repo and found a `STRIPE_API_KEY` env var — but I won't surface it as a tech-docs candidate" | Env vars naming external services are one of the strongest signals there is. Surface them as candidates. |
| "Most of these files will be empty — I'll skip the empty ones" | Empty templates with headers ARE the scaffolding. They prompt the right entries when info arrives. Skip = friction later. |
| "CLAUDE.md exists from `/init` — I'll just add the other 5" | Mixed states cause confusion. Refuse, tell the user to delete the existing CLAUDE.md, then re-run. |
| "User said 'set up docs' — README.md + CONTRIBUTING.md is enough" | The six files have specific roles. README.md is for humans browsing the repo; these six are for Claude's working context. Don't substitute. |
| "Templates are overkill — I'll write 1-line files" | The section headers (`## Active Work`, `## Key Decisions`) are what direct future updates to the right place. Don't strip them. |
| "I'll put them under `docs/` to keep root clean" | All six live at repo root. Keeping them at root means Claude reads them without path-guessing. |
| "User wants me to start coding now — the docs can wait" | The docs ARE starting. CLAUDE.md locks the workflow that prevents the next-three-hours-of-rework problem. |

## Red Flags — STOP

- About to write any of the six files before completing the interview or scan-confirm → STOP. Gather first.
- About to ask the user questions about an existing codebase without scanning it first → STOP. Scan, then ask only the gaps.
- About to write files from a scan without confirming with the user → STOP. Always show detected values for confirmation.
- About to ask multiple interview questions in a single message → STOP. One at a time.
- About to write `CLAUDE.md` and it already exists → STOP. Refuse and exit.
- About to skip one of the six files because "it's not relevant yet" → STOP. Write the empty template.
- About to write files in `docs/` or `.claude/` or anywhere other than repo root → STOP. Root is the spec.
- About to invent new file names (e.g., `tasks.md` instead of `backlog.md`, `ADR.md` instead of `memory.md`) → STOP. Use the canonical names.
- About to start coding the first feature before the user has confirmed the scaffolding → STOP. Hand off to brainstorming first.
- About to ask a style-guide or tech-stack question without a recommended default → STOP. Use the recommendation tables (Step 3a) or generic best-practice defaults if no stack is yet known.
- About to leave a `style_guide.md` or `tech_stack.md` section empty when the user accepted the recommendation → STOP. Write the recommended value as the actual content.
- About to ask a tech-stack question without cascading from the previous answer → STOP. Each question's recommendation depends on the language (and framework) already chosen — narrow accordingly.
- About to ask "what are your starter tasks?" open-ended → STOP. Offer the stack's recommended starter set as multi-select; collect custom additions in a follow-up.
- About to skip the backlog scan in an existing codebase → STOP. TODOs, FIXMEs, README roadmaps, and open issues are the user's existing backlog — surface them.
- About to ask "what external APIs do you use?" open-ended → STOP. Offer the project-type recommended set (or scan-detected SDKs/env vars) as multi-select.
- About to ignore a `STRIPE_API_KEY` / `RESEND_API_KEY` / `SENTRY_DSN` style env var while building tech_docs candidates → STOP. Surface every detected service.

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
