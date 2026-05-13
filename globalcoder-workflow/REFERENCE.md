# globalcoder-workflow Plugin Reference

**Version:** 1.6.0 | **License:** MIT | **22 skills, 1 agent, 4 commands**

## Quick Start

### Installation

```bash
# Register the local marketplace
claude plugin marketplace add ~/Projects/globalcoder-workflow

# Install the plugin
claude plugin install globalcoder-workflow@globalcoder-marketplace
```

### Enable in settings

Add to `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "globalcoder-workflow@globalcoder-marketplace": true
  }
}
```

For agent team support, also add:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

### Permissions

Each skill in this plugin requires explicit permission to invoke. Add the skills you use most to `settings.json` or `settings.local.json`. A reasonable starting set covering the core workflow:

```json
{
  "permissions": {
    "allow": [
      "Skill(globalcoder-workflow:using-globalcoder-workflow)",
      "Skill(globalcoder-workflow:brainstorming)",
      "Skill(globalcoder-workflow:ui-design-bootstrap)",
      "Skill(globalcoder-workflow:writing-plans)",
      "Skill(globalcoder-workflow:executing-plans)",
      "Skill(globalcoder-workflow:subagent-driven-development)",
      "Skill(globalcoder-workflow:test-driven-development)",
      "Skill(globalcoder-workflow:systematic-debugging)",
      "Skill(globalcoder-workflow:verification-before-completion)",
      "Skill(globalcoder-workflow:requesting-code-review)",
      "Skill(globalcoder-workflow:finishing-a-development-branch)",
      "Task(code-reviewer)"
    ]
  }
}
```

For any of the other skills listed in the [All Skills](#all-skills) section below, use the same `Skill(globalcoder-workflow:<name>)` pattern. Slash commands (`/brainstorm`, `/write-plan`, `/execute-plan`) inherit permissions from the skills they invoke — no separate command permission needed.

---

## Core Workflow

The standard development workflow follows this sequence:

```
Brainstorm → Design Doc → Write Plan → Execute → Finish Branch
```

1. **Brainstorm** — Explore the idea, ask clarifying questions, write a design document
2. **Write Plan** — Create a detailed implementation plan with bite-sized TDD tasks
3. **Execute** — Implement the plan using one of four execution modes
4. **Finish** — Verify, commit, and integrate the work

---

## Slash Commands

These are shortcuts that trigger the corresponding skill:

| Command | Triggers Skill | Purpose |
|---------|---------------|---------|
| `/project-init` | project-init | Scaffold foundational MD files + lock workflow (fresh projects) |
| `/brainstorm` | brainstorming | Explore idea before implementation |
| `/write-plan` | writing-plans | Create implementation plan |
| `/execute-plan` | executing-plans | Execute plan in batches with checkpoints |

---

## Execution Modes

After writing a plan, choose how to execute it:

| Mode | Best For | Parallelism | Token Cost |
|------|----------|-------------|------------|
| **Subagent-Driven** | <4 tasks or sequential dependencies | Sequential | Low |
| **Agent Team** | 4+ independent tasks, different files | Parallel | High |
| **tmux Parallel** | 2-6 independent tasks, visual monitoring | Parallel | Medium |
| **Parallel Session** | Manual control with human checkpoints | Manual batches | Low |

### Subagent-Driven Development
- Sequential execution in current session
- Fresh subagent per task via Task tool
- Two-stage review (spec + code quality) between tasks

### Agent Team Development
- Parallel implementers + async reviewers
- Shared task list with messaging
- Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- Team scaling: 2 implementers (4-8 tasks), 3 implementers (9+ tasks), cap at 3

### tmux Parallel Development
- Spawns `claude` CLI instances in separate tmux windows
- Two sub-modes: fire-and-forget (`claude -p`) or observable autopilot (interactive)
- Requires tmux installed
- Workers are fully isolated (no inter-worker messaging)

### Parallel Session
- Open a new session with executing-plans skill
- Batch execution with human review between batches

---

## All Skills

### Process Skills (use first — these determine HOW to approach work)

| Skill | When to Use |
|-------|-------------|
| `project-init` | Establishing CLAUDE.md + 5 context files at root and locking workflow to brainstorming-first; interviews on empty dirs, scans + asks gaps on existing codebases |
| `brainstorming` | Before any creative work — features, components, functionality, behavior changes |
| `ui-design-bootstrap` | Starting UI/visual work — establishes a DESIGN.md design-token contract before component code |
| `systematic-debugging` | Any bug, test failure, or unexpected behavior — before proposing fixes |
| `writing-plans` | Have a spec or requirements for a multi-step task, before touching code |

### Execution Skills (use second — these guide implementation)

| Skill | When to Use |
|-------|-------------|
| `executing-plans` | Have a written plan to execute in a separate session with review checkpoints |
| `subagent-driven-development` | Executing plans with independent tasks in the current session (sequential) |
| `agent-team-development` | Executing plans with 4+ independent tasks touching different files (parallel) |
| `tmux-parallel-development` | Executing plans with 2+ independent tasks via tmux (parallel, no experimental flags) |
| `dispatching-parallel-agents` | Facing 2+ independent tasks that can be worked on without shared state |
| `test-driven-development` | Implementing any feature or bugfix — before writing implementation code |

### Quality Skills

| Skill | When to Use |
|-------|-------------|
| `verification-before-completion` | About to claim work is complete — run verification commands first |
| `requesting-code-review` | Completing tasks, major features, or before merging |
| `receiving-code-review` | Receiving review feedback — verify before implementing suggestions |
| `refactoring` | Restructuring modules, renaming across files, extracting components, changing data flow |
| `performance-profiling` | App is slow, operation takes too long, bundle size too large — measurable problem required |
| `security-review` | Features handling user input, auth, payments, sensitive data, or periodic audits |
| `database-migration` | Adding, modifying, or removing tables, columns, indexes, views, functions, or RLS policies |

### Infrastructure Skills

| Skill | When to Use |
|-------|-------------|
| `using-git-worktrees` | Starting feature work needing isolation, or before executing plans |
| `finishing-a-development-branch` | Implementation complete, all tests pass — decide how to integrate |
| `writing-skills` | Creating new skills, editing existing skills, or verifying skills work |
| `using-globalcoder-workflow` | Auto-loaded on session start — establishes how to find and use skills |

---

## Agents

| Agent | Purpose |
|-------|---------|
| `code-reviewer` | Reviews completed major project steps against the plan and coding standards. Dispatched via the Task tool after a logical chunk of code is written. |

---

## Skill Discipline Types

Skills follow one of two discipline models:

**Rigid** (hard gates, mandatory checkpoints — follow exactly):
- test-driven-development
- refactoring
- database-migration
- systematic-debugging
- verification-before-completion

**Flexible** (exploratory with firm boundary rules — adapt to context):
- brainstorming
- performance-profiling
- security-review

---

## Hooks

The plugin includes a `SessionStart` hook that runs on startup, resume, clear, and compact. It automatically injects the `using-globalcoder-workflow` skill content into the session, establishing skill discovery behavior.

---

## Plugin Structure

```
globalcoder-workflow/
├── .claude-plugin/
│   ├── plugin.json          # Plugin metadata (name, version, description)
│   └── marketplace.json     # Local marketplace config
├── agents/
│   └── code-reviewer.md     # Code review agent prompt
├── commands/
│   ├── brainstorm.md        # /brainstorm slash command
│   ├── execute-plan.md      # /execute-plan slash command
│   └── write-plan.md        # /write-plan slash command
├── hooks/
│   ├── hooks.json           # Hook definitions
│   ├── run-hook.cmd         # Cross-platform hook runner
│   └── session-start.sh     # SessionStart hook script
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md          # Skill definition (frontmatter + content)
│       └── [supporting files] # Prompts, examples, scripts (some skills)
├── LICENSE
└── REFERENCE.md              # This file
```

### Skills with Supporting Files

Most skills contain only `SKILL.md`. These have additional files:

- **agent-team-development/** — `lead-prompt.md`, `implementer-prompt.md`, `spec-reviewer-prompt.md`, `code-quality-reviewer-prompt.md`
- **subagent-driven-development/** — `implementer-prompt.md`, `spec-reviewer-prompt.md`, `code-quality-reviewer-prompt.md`
- **tmux-parallel-development/** — `worker-system-prompt.md`, `worker-task-prompt.md`
- **requesting-code-review/** — `code-reviewer.md`
- **test-driven-development/** — `testing-anti-patterns.md`
- **writing-skills/** — `anthropic-best-practices.md`, `persuasion-principles.md`, `testing-skills-with-subagents.md`, `graphviz-conventions.dot`, `render-graphs.js`, `examples/`
- **systematic-debugging/** — `root-cause-tracing.md`, `defense-in-depth.md`, `condition-based-waiting.md`, `condition-based-waiting-example.ts`, `find-polluter.sh`, `CREATION-LOG.md`, test files

---

## Skill Authoring

To create new skills, use the `writing-skills` skill. Key conventions:

- **Directory:** `skills/<lowercase-kebab-case>/SKILL.md`
- **Frontmatter:** YAML with `name` and `description` only (max 1024 chars total)
- **Description:** Starts with "Use when..." — describes triggering conditions, not workflow summary
- **Cross-references:** Use `globalcoder-workflow:<skill-name>` format
- **Skill types:** Rigid (hard gates) or Flexible (boundary rules) — match the domain

---

## Updating the Plugin

After making changes to `~/Projects/globalcoder-workflow/`:

```bash
# Tag a new version
cd ~/Projects/globalcoder-workflow
git tag -a v1.x.x -m "v1.x.x: description"

# Reinstall to refresh the cache
claude plugin install globalcoder-workflow@globalcoder-marketplace
```

The plugin cache lives at `~/.claude/plugins/cache/globalcoder-marketplace/globalcoder-workflow/<version>/`.
