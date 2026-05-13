# Changelog

All notable changes to this plugin are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
