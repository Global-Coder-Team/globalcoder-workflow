# globalcoder-workflow

A Claude Code plugin providing a full development workflow with agent team support, TDD enforcement, parallel execution, and systematic debugging.

## Installation

```bash
# Register the marketplace
claude plugin marketplace add /path/to/globalcoder-workflow

# Install the plugin
claude plugin install globalcoder-workflow@globalcoder-marketplace
```

Then enable it in `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "globalcoder-workflow@globalcoder-marketplace": true
  }
}
```

## Getting Started

In any new or existing project, run:

```
/project-init
```

This is the first command to invoke in a repo. It scaffolds six foundational markdown files at the repo root and locks the development workflow to **brainstorming-first** via the `CLAUDE.md` it produces.

### What it creates

| File | Role |
|---|---|
| `CLAUDE.md` | Workflow contract — establishes the brainstorm → plan → execute → verify → finish loop and is auto-loaded by Claude Code on every session |
| `memory.md` | Continuity log — active work, key decisions, what to remember across sessions |
| `tech_stack.md` | Architecture — languages, frameworks, data layer, infrastructure, tooling |
| `style_guide.md` | Convention — naming, code style, patterns to follow and avoid |
| `backlog.md` | Tasks — in progress, next up, later, done |
| `tech_docs.md` | Reference — external APIs, library constraints, complex logic notes |

### Two modes

`/project-init` adapts to the repo state:

- **Empty directory** (only `.git/` present) — interviews from scratch: project name, one-line purpose, then a multi-select gate for the four optional sections (tech stack, style guide, initial backlog, tech docs). Each picked section runs a one-question-at-a-time sub-interview with stack-aware recommendations (see below).
- **Existing codebase** — scans first (`package.json`, `tsconfig.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, lockfiles, formatter/linter configs, ORM schemas, `Dockerfile`/`vercel.json`/`fly.toml`, `.github/workflows/`, `README.md`, recent commits, source-file naming patterns, env-var keys, SDK imports, TODO/FIXME comments, open GitHub issues), presents the detection summary for confirmation, then asks **only the gaps** — with the same stack-aware recommendations as a default.

In both modes the skill **refuses to overwrite** any of the six target files if they already exist — no merge, no silent overwrite.

After scaffolding, the skill hands off to `/brainstorm` for the first feature.

### Smart defaults per section

Every optional section uses the same pattern: **ask** with a concrete recommendation, **recommend** based on the stack (or project-type), **assume** from the codebase when one exists. Accepted recommendations write as concrete values in the output files — italic `_e.g., ..._` placeholders only remain for fields the user explicitly says "skip" to.

| Section | What's recommended |
|---|---|
| `tech_stack.md` | **Cascading**: language → framework → data layer → infrastructure → tooling (one bundled question, not five). Tables cover TypeScript, JavaScript, Python, Rust, Go, Ruby. Pick TS → Hono → Postgres + Drizzle → Fly.io → pnpm + Vitest + Prettier + ESLint + tsc, etc. |
| `style_guide.md` | Stack-aware formatter/linter, file naming, branch naming, commit format. Defaults to Conventional Commits + kebab-case for TS+Next.js, snake_case + Ruff for Python, etc. |
| `backlog.md` | 5-item starter-task multi-select per stack (auth, DB schema, core CRUD, deploy pipeline for TS+Next.js; server scaffolding, DB, auth, logging, deploy for Go; etc.). |
| `tech_docs.md` | Project-type-aware multi-select for **External APIs** (SaaS default: Stripe, auth, email, analytics, error tracking; marketing-site default: CMS, email, analytics, search, image CDN). Library quirks get stack-aware hints (Next.js caching, SQLAlchemy async, Prisma <5 migration drift, etc.). |

### Codebase signals (existing-codebase mode)

Beyond detecting the stack from manifests and configs, the scan harvests:

- **Backlog candidates** — `TODO` / `FIXME` / `XXX` comments via grep; README "Roadmap" / "Future" / "Planned" sections; WIP/TODO commit subjects; open GitHub issues (when `gh` is available and authenticated)
- **External API integrations** — SDK imports (`stripe`, `@sendgrid/mail`, `resend`, `@sentry/*`, `posthog`, `boto3`, etc.); env-var keys in `.env.example` / `.env` (often the strongest signal — `STRIPE_API_KEY`, `RESEND_API_KEY`, `SENTRY_DSN`, etc.); README integration sections
- **Style hints** — file naming case from a 10–20 file sample; branch naming from `git branch -a`; indentation, quotes, semicolons from a representative source file
- **Library quirks** — known-quirky pinned versions (Prisma <5 migration drift, Pydantic v1 → v2 migration, SQLAlchemy 1.x async, etc.)

Detected items are presented as multi-selects for the user to confirm; gaps fall through to the stack-aware recommendations rather than blank prompts.

## Slash Commands

| Command | Purpose |
|---|---|
| `/project-init` | Scaffold the six foundational MD files + lock workflow (run first in any repo) |
| `/brainstorm` | Explore intent, requirements, design before writing code |
| `/write-plan` | Convert a design into a bite-sized implementation plan |
| `/execute-plan` | Execute a plan in batches with review checkpoints |

## Skills

### Entry Point

| Skill | Description |
|-------|-------------|
| **using-globalcoder-workflow** | Starting point for any conversation - establishes how to find and use skills |

### Workflow (use in order)

| Skill | Description |
|-------|-------------|
| **project-init** | Scaffolds CLAUDE.md + 5 context files at repo root and locks the workflow to brainstorming-first; interviews on empty dirs, scans + asks gaps on existing codebases |
| **brainstorming** | Explores user intent, requirements, and design before implementation |
| **ui-design-bootstrap** | Establishes a DESIGN.md design-token contract before component code (UI/visual work) |
| **writing-plans** | Creates detailed implementation plans from specs or requirements |
| **executing-plans** | Executes a written plan in a separate session with review checkpoints |

### Execution Strategies

| Skill | Description |
|-------|-------------|
| **subagent-driven-development** | Sequential plan execution via Task tool subagents (lower token cost) |
| **agent-team-development** | Parallel plan execution via agent teams for 4+ independent tasks (higher throughput) |
| **dispatching-parallel-agents** | Runs 2+ independent tasks in parallel without shared state |
| **tmux-parallel-development** | Parallel execution via tmux without requiring experimental agent teams |

### Quality & Testing

| Skill | Description |
|-------|-------------|
| **test-driven-development** | Enforces writing tests before implementation code |
| **verification-before-completion** | Requires running verification commands before claiming work is done |
| **requesting-code-review** | Guides code review requests before merging |
| **receiving-code-review** | Applies technical rigor when processing review feedback |

### Debugging & Performance

| Skill | Description |
|-------|-------------|
| **systematic-debugging** | Structured approach to bugs, test failures, and unexpected behavior |
| **performance-profiling** | Guides optimization for measurable performance problems |

### Code Changes

| Skill | Description |
|-------|-------------|
| **refactoring** | Guides multi-file refactoring with safety checks |
| **database-migration** | Manages schema changes targeting shared or production databases |
| **security-review** | Reviews features handling user input, auth, payments, or sensitive data |

### Git & Environment

| Skill | Description |
|-------|-------------|
| **using-git-worktrees** | Creates isolated git worktrees for feature work |
| **finishing-a-development-branch** | Guides branch completion with merge, PR, or cleanup options |

### Meta

| Skill | Description |
|-------|-------------|
| **writing-skills** | Guides creating, editing, and testing new skills |

## Recommended Workflow

```
Project Init -> Brainstorm -> Design Doc -> Writing Plans -> Execute -> Verify -> Finish Branch
```

1. **Project Init** (once per repo) — `/project-init` scaffolds CLAUDE.md + 5 context files at root, locking the workflow for every future session
2. **Brainstorm** the feature to explore requirements and produce a design document
3. **Write a plan** with bite-sized implementation tasks
4. **Execute** the plan using subagent-driven (sequential) or agent-team (parallel) development
5. **Verify** all tests pass and the build succeeds
6. **Finish the branch** by merging, creating a PR, or cleaning up

## Project Structure

```
globalcoder-workflow/
├── .claude-plugin/
│   ├── plugin.json          # Plugin metadata (name, version, description)
│   └── marketplace.json     # Marketplace registration
├── agents/
│   └── code-reviewer.md     # Agent definition for code review
├── commands/
│   ├── brainstorm.md        # Slash command definitions
│   ├── execute-plan.md
│   ├── project-init.md
│   └── write-plan.md
├── hooks/
│   ├── hooks.json           # Hook configuration
│   ├── run-hook.cmd          # Windows hook runner
│   └── session-start.sh     # Session startup hook
├── skills/
│   └── <skill-name>/
│       └── SKILL.md          # Skill definition (frontmatter + instructions)
├── LICENSE
└── REFERENCE.md
```

## Companion Plugin

[globalcoder-marketing](https://github.com/globalcoder/globalcoder-marketing) provides product launch, branding, and go-to-market skills that complement this workflow plugin. No hard dependency - the two plugins can be used independently.

## License

MIT
