# GlobalCoder Plugins

Claude Code plugins for structured development workflows and product launch marketing.

## Plugins

### [globalcoder-workflow](./globalcoder-workflow/) (v1.1.0)

Full development workflow with agent team support, TDD enforcement, parallel execution, and systematic debugging. 20 skills covering the complete development lifecycle:

- **Workflow**: brainstorming, writing-plans, executing-plans
- **Execution**: subagent-driven-development, agent-team-development, dispatching-parallel-agents, tmux-parallel-development
- **Quality**: test-driven-development, verification-before-completion, requesting-code-review, receiving-code-review
- **Debugging**: systematic-debugging, performance-profiling
- **Code Changes**: refactoring, database-migration, security-review
- **Git**: using-git-worktrees, finishing-a-development-branch
- **Meta**: using-globalcoder-workflow, writing-skills

### [globalcoder-marketing](./globalcoder-marketing/) (v1.0.0)

Product and brand launch toolkit with market research, positioning, go-to-market planning, and campaign execution. 11 skills covering the full marketing lifecycle:

- **Research & Strategy**: market-research, customer-personas, brand-identity, positioning-strategy
- **Planning & Execution**: launch-plan, content-strategy, landing-page, campaign-builder
- **Review**: launch-retrospective
- **Orchestration**: full-launch, using-globalcoder-marketing

## Installation

```bash
# Register the marketplace and install each plugin
claude plugin marketplace add /path/to/globalcoder-workflow
claude plugin install globalcoder-workflow@globalcoder-marketplace

claude plugin marketplace add /path/to/globalcoder-marketing
claude plugin install globalcoder-marketing@globalcoder-marketing-marketplace
```

Enable in `~/.claude/settings.json`:

```json
{
  "enabledPlugins": [
    "globalcoder-workflow@globalcoder-marketplace",
    "globalcoder-marketing@globalcoder-marketing-marketplace"
  ]
}
```

## How They Work Together

The two plugins are independent but complementary:

```
Marketing                          Workflow
────────                          ────────
market-research ─┐
customer-personas │                brainstorming
brand-identity    ├─► strategy     writing-plans ─► execute ─► verify ─► finish
positioning       │   documents    (subagent / agent-team / tmux)
launch-plan ──────┘
```

Use **globalcoder-marketing** to produce strategy and positioning documents, then hand off to **globalcoder-workflow**'s writing-plans skill to turn them into implementation tasks.

## License

MIT
