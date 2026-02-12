---
name: brand-identity
description: Use when creating or refining a brand - guides naming, voice and tone, brand story, visual direction, and brand principles
---

# Brand Identity

## Overview

Define the brand's name, voice, tone, story, and visual direction. Produces a brand guide that downstream skills reference for consistent messaging.

**Announce at start:** "I'm using the brand-identity skill to define the brand."

## Process

**Step 1: Context gathering**
- Read existing docs: `docs/marketing/market-research.md`, `docs/marketing/customer-personas.md`
- Ask the output mode question (minimal vs full)

**Step 2: Five areas, one at a time**

Present and validate each area before moving to the next:

**Naming** (skip if product already has a name)
- Brainstorm 5-7 name options with rationale
- Narrow to top 3, ask user to pick
- Consider: memorability, domain availability, cultural connotations

**Brand story**
- Ask: What's the origin? Why does this exist? What change does it want to make?
- Draft a short narrative (150-200 words) for validation

**Voice & tone**
- Establish 3-4 voice attributes
- Each attribute gets a do/don't example pair
- Example: "Confident but not arrogant" → DO: "We built this to solve X" / DON'T: "Unlike inferior alternatives..."

**Visual direction**
- Color palette: 3-5 colors with hex codes and usage (primary, secondary, accent)
- Typography: 1-2 font recommendations with reasoning
- Imagery style: what kind of photos/illustrations fit the brand
- Not a full design system - just enough to guide decisions

**Brand principles**
- 3-5 core principles that guide all marketing decisions
- Each principle: name + one-sentence explanation

**Step 3: Write output**
- Write `docs/marketing/brand-identity.md`
- **Full mode adds:** brand guidelines as YAML (colors, fonts, voice attributes), sample tagline variations, style tokens file

**Step 4: Handoff**
- Suggest `globalcoder-marketing:positioning-strategy`

## Key Principles

- **Validate each area separately** - brand decisions are subjective, iterate tightly
- **Show don't tell** - do/don't examples for voice, hex codes for colors
- **Keep it actionable** - enough to guide decisions, not a 50-page brand book
