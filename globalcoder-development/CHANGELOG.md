# Changelog

All notable changes to this plugin are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-05-13

### BREAKING — Plugin renamed: `globalcoder-workflow` → `globalcoder-development`

The plugin's name shadowed the repo name (`Global-Coder-Team/globalcoder-workflow`), which is a monorepo housing this plugin alongside `globalcoder-marketing`. The plugin is now `globalcoder-development` to match what it actually does (encode development process discipline) and to distinguish it from the repo. The repo name is unchanged.

#### What changed

- Plugin name in `plugin.json` and `marketplace.json`: `globalcoder-workflow` → `globalcoder-development`
- Plugin directory in the monorepo: `globalcoder-workflow/` → `globalcoder-development/`
- All skill cross-references: `globalcoder-workflow:<skill-name>` → `globalcoder-development:<skill-name>` (e.g., `globalcoder-development:brainstorming`)
- Entry-point skill renamed: `using-globalcoder-workflow` → `using-globalcoder-development` (its directory under `skills/` and the `name:` in its frontmatter)
- User-config paths in `using-git-worktrees` and `subagent-driven-development` example: `~/.config/globalcoder-workflow/` → `~/.config/globalcoder-development/`
- Install spec: `globalcoder-workflow@globalcoder-marketplace` → `globalcoder-development@globalcoder-marketplace`

#### Migration for users

In `~/.claude/settings.json`, update the enabled-plugins key:

```diff
 {
   "enabledPlugins": {
-    "globalcoder-workflow@globalcoder-marketplace": true
+    "globalcoder-development@globalcoder-marketplace": true
   }
 }
```

Update every `Skill(globalcoder-workflow:...)` permission entry to use the new prefix:

```diff
-"Skill(globalcoder-workflow:brainstorming)"
+"Skill(globalcoder-development:brainstorming)"
```

Reinstall to refresh the marketplace cache:

```bash
claude plugin marketplace add ~/Projects/globalcoder-development
claude plugin install globalcoder-development@globalcoder-marketplace
```

If you previously used `using-git-worktrees` to create worktrees under `~/.config/globalcoder-workflow/worktrees/`, those worktrees still exist on disk. Either move them to `~/.config/globalcoder-development/worktrees/` to match the new path, or update your local CLAUDE.md to override the path back to the old location.

Historical CHANGELOG entries below (v1.x) keep the old `globalcoder-workflow:` prefix as a faithful record of what was shipped at that time.

## [1.9.0] - 2026-05-13

### Added
- **`preparing-a-release` skill** — coordinates the release ritual end-to-end: enumerates every version-bearing manifest (grep), batch-edits them to the new version, runs `git log` between tags to populate the CHANGELOG entry (no "from memory"), commits, annotates the tag, pushes with `--follow-tags`, and suggests a reinstall command. Codifies what was previously done manually six times during the v1.3.0–v1.8.0 series.
- **`/finish-branch` slash command** — invokes `finishing-a-development-branch`. Closes the obvious gap left by the v1.2.0 audit (the other three lifecycle stages all had shortcuts).
- **`/review` slash command** — invokes `requesting-code-review`. Useful mid-feature, not just at PR time.
- **`Skill Discipline Types`** section in `REFERENCE.md` now classifies all 23 skills as Rigid or Flexible (was 8 of 22 — partial since the v1.2.0 audit).

### Changed
- **Cross-skill integration with `project-init` files** — the six foundational MD files are now a living spine instead of write-once artifacts:
  - `writing-plans` adds a Step 0: read `tech_stack.md` and `style_guide.md` for constraints; check `backlog.md` for the task and move it to "In Progress" when planning begins.
  - `finishing-a-development-branch` adds a Step 5 before worktree cleanup: prompt to move completed work to `backlog.md`'s "Done" and propose a `memory.md` entry for any architectural decision made during the work.
  - `brainstorming` now explicitly names `memory.md`, `tech_stack.md`, `backlog.md`, etc. as canonical context sources (was a generic "check current project state").
  - `systematic-debugging` Phase 4 adds a "Capture Institutional Knowledge" step: propose a one-line `memory.md` entry under "To Remember Across Sessions" when a non-obvious bug is resolved.
  - `executing-plans` and `subagent-driven-development` prompt for `tech_stack.md` updates when a batch / task adds a dependency.
  - `project-init`'s CLAUDE.md template now references `DESIGN.md` conditionally for UI projects.
- **`writing-skills` Deployment checklist** now includes an explicit "update indexes" step (REFERENCE.md skill count, All Skills table, Skill Discipline Types row, README.md Skills sub-table, slash commands tables, CHANGELOG entry). Drift here is what caused `Skill Discipline Types` to fall out of sync since v1.2.0.

## [1.8.0] - 2026-05-13

### Changed
- `project-init` tech-docs interview now uses the same ask + recommend + assume pattern as style_guide (1.5.0), tech_stack (1.6.0), and backlog (1.7.0). External APIs question presents a project-type-aware multi-select (SaaS / marketing site / internal tool / mobile-API / DevOps-CLI variants) instead of open-ended; default is the SaaS set (Stripe, auth provider, email, analytics, error tracking) which covers the broadest case. Library quirks question surfaces stack-aware hints (Next.js App Router caching, SQLAlchemy async sessions, Prisma <5 migration drift, etc.) to prime the user's memory; still accepts open-ended.
- Scan mode now harvests external-API candidates from SDK imports (`stripe`, `@sendgrid/mail`, `resend`, `@aws-sdk/*`, `posthog`, `@sentry/*`, `boto3`, etc.), env-var keys in `.env.example` / `.env` (often the strongest signal — `STRIPE_API_KEY`, `RESEND_API_KEY`, `SENTRY_DSN`, etc.), and README "Integrations" / "Dependencies" sections. Reconciles imports + env vars by service with confidence weighting; surfaces env-only signals (e.g., `NEXTAUTH_SECRET` without an SDK import) as candidates rather than dropping them.
- Scan also flags known-quirky pinned versions (Prisma <5, Pydantic v1, SQLAlchemy 1.x) as library-constraint candidates with brief notes for the user to expand on.

## [1.7.0] - 2026-05-13

### Changed
- `project-init` backlog interview no longer asks open-ended "what are your starter tasks?". Empty-directory mode offers a **stack-aware multi-select** of recommended starter tasks (e.g., for TS+Next.js: auth, DB schema, core CRUD, first e2e feature, deploy pipeline; for Go: server scaffolding, DB, auth middleware, logging, deploy). User picks any subset, then adds custom items in one follow-up.
- Scan mode now harvests backlog candidates from the codebase: `TODO`/`FIXME`/`XXX` comments via grep, README "Roadmap"/"Future"/"Planned" sections, WIP/TODO commit subjects, and open GitHub issues (when `gh` is available). Findings are presented as a single multi-select grouped by source; the user picks which to seed under "Next Up". Falls back to stack-aware starter tasks only when the scan returns nothing.
- Provenance is preserved on imported items (file:line annotations, issue numbers, "roadmap" tags) so each task is traceable back to its origin.

## [1.6.0] - 2026-05-13

### Changed
- `project-init` tech-stack sub-interview now uses **cascading recommendations**. Each question's recommended default depends on prior answers: picking TypeScript narrows the framework recommendation to Next.js / Remix / Hono / Express; picking Hono narrows the data layer recommendation to Postgres + Drizzle; etc. Reference tables in the skill cover TypeScript, JavaScript, Python, Rust, Go, and Ruby across language → framework → data layer → infrastructure → tooling.
- Tooling is now asked as **one bundled question** (package manager + test runner + formatter + linter + type checker) instead of five separate prompts, with a single recommendation per language (e.g., "pnpm + Vitest + Prettier + ESLint + tsc" for TypeScript).
- Accepted recommendations are written as concrete values in `tech_stack.md` — italic `_e.g., ..._` placeholders are now only left in place when the user explicitly says "skip" for that field. Same behavior as the style-guide upgrade in 1.5.0.
- Scan-mode (existing-codebase path) now also uses cascading recommendations for the rare cases where it detects the language but not the framework / data layer / hosting (e.g., monorepo subdirectories or pre-deployment repos).

## [1.5.0] - 2026-05-13

### Changed
- `project-init` style-guide sub-interview now **proposes recommendations** for every question instead of asking open-ended. Each question takes the form "Q? Recommended: X. Accept, customize, or skip." Recommendations are stack-aware (TypeScript+Next.js, Python, Go, Rust, Ruby, etc.) via a new Stack Recommendations reference table; falls back to generic best practices when no stack is chosen.
- Accepted recommendations are written as actual values in `style_guide.md` — italic `_e.g., ..._` placeholders are now only left in place when the user explicitly says "skip" for that field. Previously, undetected/unanswered fields were left as placeholders, leaving the file half-empty.
- `project-init` codebase scan now infers more style information automatically: file-naming convention (samples 10–20 source files for case style), branch-naming convention (`git branch -a`), and code-style hints (indentation, semicolons, quotes from a representative source file).
- Scan-mode gap questions for style-guide fields use the same "Recommended: X" format so users always have a default to accept rather than invent.

## [1.4.1] - 2026-05-13

### Fixed
- All four slash commands (`/project-init`, `/brainstorm`, `/write-plan`, `/execute-plan`) had `disable-model-invocation: true` in their frontmatter, which conflicted with their bodies' instruction to invoke the linked skill via the `Skill` tool. Running any of them produced `Error: Skill ... cannot be used with Skill tool due to disable-model-invocation`. Removed the flag — slash commands now work as designed.

## [1.4.0] - 2026-05-13

### Added
- `project-init` now handles existing codebases via a scan-and-confirm path. Reads `package.json`, `tsconfig.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, lockfiles, formatter/linter configs, ORM/DB schemas, infra files (`vercel.json`, `fly.toml`, `Dockerfile`), CI workflows, README.md, and recent commit history; proposes detected values for the user to confirm; then asks only the actual gaps. The empty-directory interview path from 1.3.1 is preserved.
- Red flags expanded: refuses to ask questions before scanning an existing codebase, refuses to write from a scan without user confirmation.

## [1.3.1] - 2026-05-13

### Changed
- `project-init` now conducts a brainstorming-style interview before writing files — asks project name and one-line purpose (required), then offers a multi-select gate for optional sections (tech stack, style guide, initial backlog, tech docs). Each picked section runs its own one-question-at-a-time sub-interview. Skipped sections leave italic `_e.g., ..._` placeholders intact as prompts for later.
- CLAUDE.md template now includes the one-line project purpose under the project name.

## [1.3.0] - 2026-05-13

### Added
- `project-init` skill — scaffolds six foundational MD files at repo root (`CLAUDE.md`, `memory.md`, `tech_stack.md`, `style_guide.md`, `backlog.md`, `tech_docs.md`) and locks the workflow to brainstorming-first via the CLAUDE.md template. Refuses-and-exits if any of the six already exist to prevent data loss in mature repos.
- `/project-init` slash command — invokes the new skill.
- `project-init` entries added to README workflow table, REFERENCE All Skills, and REFERENCE Slash Commands.

## [1.2.0] - 2026-05-10

### Added
- `ui-design-bootstrap` skill — gates UI work behind a `DESIGN.md` design-token contract using the `@google/design.md` format, preventing memory-based color/spacing decisions and visual drift across components.
- "Self-Contained Format Specifications" section in `writing-skills` — codifies the rule that skills producing or consuming non-trivial formats must embed the format spec inline, with two exceptions: large specs (link to a committed file) and CLI-emitted specs (`mytool spec --rules`).
- `brainstorming` → `ui-design-bootstrap` handoff so visual decisions from the UI exploration phase get codified into `DESIGN.md` before component code is written.
- `CHANGELOG.md` (this file).

### Changed
- Sharpened descriptions of the four parallel-execution skills (`subagent-driven-development`, `agent-team-development`, `tmux-parallel-development`, `dispatching-parallel-agents`) so Claude can pick deterministically; `dispatching-parallel-agents` is now explicitly for investigations, not plan execution.
- Rewrote `brainstorming`, `tmux-parallel-development`, and `receiving-code-review` descriptions to comply with `writing-skills` CSO rules — third person, "Use when..." triggers only, no workflow summaries.
- Aligned `agents/code-reviewer.md` with the rubric and rules in `requesting-code-review` (was using a contradicting Critical/Important/Suggestions split vs the skill's Critical/Important/Minor).
- Hardened `hooks/run-hook.cmd` to find bash via standard Git for Windows locations and `PATH` instead of hardcoding `C:\Program Files\Git\bin\bash.exe`.
- Expanded the permissions example in `REFERENCE.md` from 5 skills to a representative core-workflow set, plus the `code-reviewer` agent.
- Normalized "your human partner" capitalization at sentence starts and section headings across multiple skills.

### Fixed
- **Install bug**: `README.md`'s `enabledPlugins` example used the JSON-array form, which silently failed to enable the plugin. Claude Code requires the object form.
- `marketplace.json` version was out of sync with `plugin.json` (1.0.0 vs 1.1.0).
- `hooks/session-start.sh` swallowed stderr into the success path, injecting `"Error reading using-globalcoder-workflow skill"` literal into Claude's context if the file was missing.
- Replaced fictitious cross-skill references (`frontend-design`, `mcp-builder`, `designing-before-coding`) with real plugin skills.
- `writing-plans` contradicted `writing-skills` on `@`-syntax usage; fixed and added missing `globalcoder-workflow:` namespace prefix on one cross-reference.
- Broken section heading `## your human partner's Signals You're Doing It Wrong` in `systematic-debugging` → `## Signals You're Doing It Wrong`.
- Stripped maintainer-name leak ("Per Jesse's rule") and dated narrative example ("From debugging session 2025-10-03") from skill files.

### Removed
- `lib/skills-core.js` and the `lib/` directory — dead code from the `superpowers` ancestor with zero callers; skill discovery is handled by Claude Code's harness natively.

## [1.1.0] - earlier

- UI/design exploration phase added to the `brainstorming` skill.

## [1.0.0] - earlier

- Initial commit with `globalcoder-workflow` and `globalcoder-marketing` plugins.
