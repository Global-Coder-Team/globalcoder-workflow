---
name: customer-personas
description: Use when you need to define target buyers - builds detailed personas with pain points, goals, channels, and objections grounded in market research
---

# Customer Personas

## Overview

Build detailed buyer personas grounded in market research. Produces persona profiles that downstream skills (positioning-strategy, campaign-builder) reference for targeted messaging.

**Announce at start:** "I'm using the customer-personas skill to build buyer profiles."

## Process

**Step 1: Context gathering**
- Read `docs/marketing/market-research.md` if it exists (use findings as input)
- Works standalone if no research exists - will gather context through conversation
- Ask the output mode question (minimal vs full)

**Step 2: Scope the personas**
- Ask: How many distinct buyer types exist? (Recommend 2-3. Push back above 4 - YAGNI.)
- For each persona, guided exploration one question at a time:

1. What's their role/title and demographic context?
2. What are their top 3 pain points or frustrations?
3. What are their goals and desired outcomes?
4. Where do they spend time online? (communities, platforms, publications)
5. What objections would they raise about this product?
6. What triggers them to look for a solution?

**Step 3: Present personas**
- Present each persona individually for validation (200-300 words each)
- Include: name/archetype, demographics, pain points, goals, channels, objections, triggers
- Revise based on feedback before moving to next persona

**Step 4: Write output**
- Write `docs/marketing/customer-personas.md`
- **Full mode adds:** personas as structured JSON, user story templates per persona

**Step 5: Handoff**
- Suggest `globalcoder-marketing:brand-identity` or `globalcoder-marketing:positioning-strategy`

## Key Principles

- **2-3 personas max** - each must be distinct and actionable
- **Ground in research** - reference market research findings when available
- **Specificity over generality** - "VP of Engineering at 50-200 person SaaS company" not "technical decision maker"
- **Validate individually** - don't present all personas at once
