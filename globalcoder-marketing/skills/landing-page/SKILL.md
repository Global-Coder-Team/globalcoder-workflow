---
name: landing-page
description: Use when creating a landing page - guides copy, page structure, CTA strategy, and optionally generates code using the project's UI framework
---

# Landing Page

## Overview

Create landing page copy, structure, and CTA strategy. In full mode, generates actual code using the project's existing UI framework.

**Announce at start:** "I'm using the landing-page skill to build the page."

## Process

**Step 1: Context gathering**
- Read `docs/marketing/positioning-strategy.md` (primary input - value prop, messaging matrix)
- Read personas and brand identity if available
- Ask the output mode question (minimal vs full)

**Step 2: Scoping questions (one at a time)**

1. What's the single conversion action? (sign up / join waitlist / buy / book demo / download)
2. What page structure? (hero + features / long-form story / comparison / minimal waitlist)
3. What social proof is available? (testimonials / customer logos / metrics / press mentions / none yet)
4. What objections should the FAQ address? (pull from persona objections if available)

**Step 3: Draft section by section**

Present each section for validation before moving to next:

1. **Hero** - headline (from value prop), subhead, primary CTA, supporting visual direction
2. **Problem/solution** - the pain point narrative leading to the product
3. **Features/benefits** - tied to differentiators from positioning, benefit-led not feature-led
4. **Social proof** - whatever's available. If nothing exists, suggest how to collect it and leave placeholder.
5. **FAQ / objection handling** - drawn from persona objections
6. **Final CTA** - reinforcement of primary conversion action

**Step 4: Write output**
- Write `docs/marketing/landing-page.md` with all copy blocks and page structure
- **Full mode adds:**
  - React component using detected project framework (Shadcn/Tailwind if present)
  - SEO meta tags (title, description, OG tags)
  - OG image text suggestions

**Step 5: Handoff**
- Suggest `globalcoder-marketing:campaign-builder` to drive traffic to the page

## Key Principles

- **Never fabricate social proof** - no fake testimonials, no made-up metrics. Suggest how to collect real proof.
- **One CTA** - every section drives toward the same conversion action
- **Benefits over features** - "Save 4 hours a week" not "Automated scheduling engine"
- **Validate copy carefully** - iterate on headlines and CTAs, they make or break conversion
- **Detect the framework** - in full mode, check package.json / project structure before generating code
