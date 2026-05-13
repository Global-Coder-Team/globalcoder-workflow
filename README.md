# GlobalCoder Plugins

Claude Code plugins for structured development workflows and product launch marketing.

## Plugins

### [globalcoder-development](./globalcoder-development/) (v2.0.0)

Full development workflow with agent team support, TDD enforcement, parallel execution, and systematic debugging. **23 skills, 6 slash commands, 1 agent** covering the complete development lifecycle:

- **Workflow**: project-init, brainstorming, ui-design-bootstrap, writing-plans, executing-plans
- **Execution**: subagent-driven-development, agent-team-development, dispatching-parallel-agents, tmux-parallel-development
- **Quality**: test-driven-development, verification-before-completion, requesting-code-review, receiving-code-review
- **Debugging**: systematic-debugging, performance-profiling
- **Code Changes**: refactoring, database-migration, security-review
- **Git**: using-git-worktrees, finishing-a-development-branch
- **Meta**: using-globalcoder-development, writing-skills, preparing-a-release

**Slash commands**: `/project-init`, `/brainstorm`, `/write-plan`, `/execute-plan`, `/review`, `/finish-branch`

> **Note (v2.0.0):** This plugin was previously named `globalcoder-workflow` (matching the repo name, which was confusing). It was renamed to `globalcoder-development` to distinguish it from the repo. See [`globalcoder-development/CHANGELOG.md`](./globalcoder-development/CHANGELOG.md#200---2026-05-13) for the migration path if you're upgrading.

### [globalcoder-marketing](./globalcoder-marketing/) (v1.0.0)

Product and brand launch toolkit with market research, positioning, go-to-market planning, and campaign execution. 11 skills covering the full marketing lifecycle:

- **Research & Strategy**: market-research, customer-personas, brand-identity, positioning-strategy
- **Planning & Execution**: launch-plan, content-strategy, landing-page, campaign-builder
- **Review**: launch-retrospective
- **Orchestration**: full-launch, using-globalcoder-marketing

## Installation

```bash
# Register each plugin's marketplace and install
claude plugin marketplace add /path/to/globalcoder-development
claude plugin install globalcoder-development@globalcoder-marketplace

claude plugin marketplace add /path/to/globalcoder-marketing
claude plugin install globalcoder-marketing@globalcoder-marketing-marketplace
```

Enable in `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "globalcoder-development@globalcoder-marketplace": true,
    "globalcoder-marketing@globalcoder-marketing-marketplace": true
  }
}
```

## How They Work Together

The two plugins are independent but complementary:

```
Marketing                          Development
─────────                          ───────────
market-research ─┐
customer-personas │                project-init
brand-identity    ├─► strategy     brainstorming
positioning       │   documents    writing-plans ─► execute ─► verify ─► finish
launch-plan ──────┘                (subagent / agent-team / tmux)
```

Use **globalcoder-marketing** to produce strategy and positioning documents, then hand off to **globalcoder-development**'s `writing-plans` skill to turn them into implementation tasks. The handoff is loose — there's no hard dependency between the plugins.

## License

MIT
