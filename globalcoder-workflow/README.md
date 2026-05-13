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

## Skills

### Entry Point

| Skill | Description |
|-------|-------------|
| **using-globalcoder-workflow** | Starting point for any conversation - establishes how to find and use skills |

### Workflow (use in order)

| Skill | Description |
|-------|-------------|
| **project-init** | Scaffolds CLAUDE.md + 5 context files at repo root and locks the workflow to brainstorming-first (fresh projects only) |
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
Brainstorm -> Design Doc -> Writing Plans -> Execute -> Verify -> Finish Branch
```

1. **Brainstorm** the feature to explore requirements and produce a design document
2. **Write a plan** with bite-sized implementation tasks
3. **Execute** the plan using subagent-driven (sequential) or agent-team (parallel) development
4. **Verify** all tests pass and the build succeeds
5. **Finish the branch** by merging, creating a PR, or cleaning up

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
