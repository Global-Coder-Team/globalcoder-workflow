# globalcoder-marketing

A Claude Code plugin providing a product and brand launch toolkit with market research, positioning, go-to-market planning, and campaign execution.

## Installation

```bash
# Register the marketplace
claude plugin marketplace add /path/to/globalcoder-marketing

# Install the plugin
claude plugin install globalcoder-marketing@globalcoder-marketing-marketplace
```

Then enable it in `~/.claude/settings.json`:

```json
{
  "enabledPlugins": ["globalcoder-marketing@globalcoder-marketing-marketplace"]
}
```

## Skills

### Entry Point

| Skill | Description |
|-------|-------------|
| **using-globalcoder-marketing** | Routes to the correct marketing skill based on the task |

### Research & Strategy

| Skill | Description |
|-------|-------------|
| **market-research** | Competitor analysis, target audience identification, market sizing, and opportunity mapping |
| **customer-personas** | Detailed personas with pain points, goals, channels, and objections |
| **brand-identity** | Naming, voice and tone, brand story, visual direction, and brand principles |
| **positioning-strategy** | Value proposition, differentiators, messaging matrix, competitive positioning, and elevator pitches |

### Planning & Execution

| Skill | Description |
|-------|-------------|
| **launch-plan** | Phased timeline with channels, milestones, owners, and KPIs |
| **content-strategy** | Content pillars, formats, calendar, distribution plan, and repurposing strategy |
| **landing-page** | Copy, page structure, CTA strategy, and optional code generation using the project's UI framework |
| **campaign-builder** | Email sequences, social media posts, and ad copy with platform-specific formatting |

### Review

| Skill | Description |
|-------|-------------|
| **launch-retrospective** | Post-launch analysis of metrics, what worked, what didn't, and next actions |

### Full Workflow

| Skill | Description |
|-------|-------------|
| **full-launch** | Guided workflow through all marketing phases from research to launch |

## Recommended Workflow

```
Market Research -> Customer Personas -> Brand Identity -> Positioning Strategy
    -> Launch Plan -> Content Strategy -> Landing Page / Campaign Builder
    -> Launch Retrospective
```

Each skill can be used independently or as part of the **full-launch** orchestrated workflow. Every skill supports two output modes:

- **Minimal** - documentation and strategy artifacts only
- **Full** - documentation plus code templates and ready-to-use assets

## Project Structure

```
globalcoder-marketing/
├── .claude-plugin/
│   ├── plugin.json          # Plugin metadata (name, version, description)
│   └── marketplace.json     # Marketplace registration
├── commands/
│   ├── brand-identity.md    # Slash command definitions
│   ├── campaign-builder.md
│   ├── content-strategy.md
│   ├── customer-personas.md
│   ├── full-launch.md
│   ├── landing-page.md
│   ├── launch-plan.md
│   ├── launch-retrospective.md
│   ├── market-research.md
│   ├── positioning-strategy.md
│   └── using-globalcoder-marketing.md
├── skills/
│   └── <skill-name>/
│       └── SKILL.md          # Skill definition (frontmatter + instructions)
└── LICENSE
```

## Companion Plugin

[globalcoder-workflow](https://github.com/globalcoder/globalcoder-workflow) provides development workflow skills (TDD, debugging, agent teams, parallel execution) that complement this marketing plugin. The **writing-plans** skill in globalcoder-workflow is a natural handoff point after producing strategy documents here. No hard dependency - the two plugins can be used independently.

## License

MIT
