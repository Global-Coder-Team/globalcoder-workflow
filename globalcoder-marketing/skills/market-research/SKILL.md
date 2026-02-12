---
name: market-research
description: Use when launching a new product or entering a new market - guides competitor analysis, target audience identification, market sizing, and opportunity mapping
---

# Market Research

## Overview

Structured competitor analysis, target market identification, and opportunity mapping. Produces a research document that downstream skills (customer-personas, positioning-strategy) build on.

**Announce at start:** "I'm using the market-research skill to guide this analysis."

## Process

**Step 1: Context gathering**
- Read existing docs in `docs/marketing/` if any exist
- Ask what product/service is being launched
- Ask the output mode question (minimal vs full)

**Step 2: Guided exploration (one question at a time)**

1. What problem does this product solve? Who has this problem today?
2. Who are the known competitors? (Use web search to discover more)
3. What channels do competitors use to reach customers?
4. What's the estimated market size and growth trajectory?
5. What gaps exist that competitors aren't addressing?
6. What are the risks or barriers to entry?

Prefer multiple choice when possible. Open-ended for domain-specific questions.

**Step 3: Present findings**
- Break into sections (200-300 words each), validate each:
  - Market overview
  - Competitor matrix (name, positioning, strengths, weaknesses, pricing)
  - Opportunity gaps
  - Risk factors
- Use web search to fill knowledge gaps

**Step 4: Write output**
- Write `docs/marketing/market-research.md`
- **Full mode adds:** competitor comparison as JSON, SWOT analysis template

**Step 5: Handoff**
- Suggest `globalcoder-marketing:customer-personas` as next step

## Key Principles

- **Use web search** to supplement user knowledge with real data
- **YAGNI** - focus on actionable insights, not exhaustive reports
- **Validate in sections** - don't dump the whole analysis at once
- **Be honest about unknowns** - flag assumptions clearly
