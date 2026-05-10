---
name: ui-design-bootstrap
description: Use when starting UI/visual work in any project — landing pages, dashboards, marketing sites, design-system-heavy components, or anything where visual consistency matters. Triggers on signals like "polished," "intentional," "high-end," "design system," "investor-ready," "brand," or fresh frontend scaffolds without an existing design contract.
---

# UI Design Bootstrap

## Overview

**Stop. Before you write a single component, you need a design contract.**

Without a contract, agents pick colors from memory ("Linear-clone polished," "near-black + indigo"), drop arbitrary Tailwind classes across files, and produce UIs that look fine in isolation but drift visually as the project grows. The cost is invisible at component #1 and brutal at component #20.

This skill codifies a fast (5–10 min) bootstrap: extract design decisions into a `DESIGN.md` file at the repo root using the `@google/design.md` format, then lint it. Subsequent component work references the tokens — no more guessing colors.

**REQUIRED BACKGROUND:** If a UI/Design exploration phase from `globalcoder-workflow:brainstorming` already ran for this work, read its output first — those decisions feed directly into DESIGN.md.

## The Iron Law

**No component code in a fresh UI project until DESIGN.md exists and lints clean.**

- Adding CSS variables to `globals.css` instead is not equivalent. Tokens scattered across CSS files lose the *rationale* that makes them stick. DESIGN.md is one file, machine-readable, with prose explaining *why*.
- Yes, even on a one-week deadline. Especially on a one-week deadline. Bootstrap is 5–10 minutes; drift correction at the end of the week is hours.
- Yes, even when the user said "just get going." Bootstrap *is* getting going. Running ahead with arbitrary colors is creating debt.

## When to Use

**Use when:**
- Fresh project (no `DESIGN.md`) starting any UI work
- Existing project where visual consistency is degrading or being audited
- User mentions polished, intentional, high-end, design system, investor-ready, brand, consistent
- Brainstorming UI exploration phase produced design decisions that need codifying

**Skip when:**
- Pure backend / API / library / CLI work
- One-off internal tool where consistency truly doesn't matter (be honest — most "internal tools" still benefit)
- DESIGN.md already exists and lints clean — read it, reference its tokens, don't rewrite

## Process

### 1. Detect existing context

Before creating anything, check:
- Is there already a `DESIGN.md` at the repo root? Read it and stop here — go reference its tokens.
- Is there a UI library in `package.json` (shadcn/ui, Radix, MUI, Chakra)? Note its tokens — DESIGN.md should align with the library, not fight it.
- Is there a Tailwind config with custom theme tokens, or CSS variables in `globals.css`? Inventory them — DESIGN.md will absorb and supersede them.
- Is there an existing brand site, Figma, or design doc the user can point to? Pull anchors from it.

### 2. Gather decisions (skip if brainstorming already did this)

If `globalcoder-workflow:brainstorming`'s UI/Design exploration phase already ran, you have the decisions. Pull them.

Otherwise, ask the user — one question at a time, multiple choice preferred:

1. **Mood/feel** — polished and serious, warm and approachable, playful, technical, etc. + light/dark/both
2. **Color anchor** — primary brand color (or "pick one for me, here's the mood")
3. **Type pairing** — sans-only or sans + serif/mono, system or custom (Inter, Geist, etc.)
4. **Density** — tight (Linear, Notion) or generous (Stripe, Cal.com)
5. **Motion** — subtle, expressive, or minimal/none

Five questions, ~3 minutes. Don't expand without reason.

### 3. Load the format spec

Run this to dump the current `@google/design.md` format spec into your context:

```bash
npx @google/design.md spec --rules
```

Use it as the authoritative format reference. The spec evolves; the CLI emits the current version, so prefer this over inlined examples that may go stale.

### 4. Write DESIGN.md

Use the format from step 3: YAML frontmatter with tokens (`colors`, `typography`, `rounded`, `spacing`, `components`) + markdown prose explaining each choice. The prose is not optional — it is what makes tokens *stick* across sessions. Without rationale, future-you will second-guess and override.

### 5. Lint

```bash
npx @google/design.md lint
```

This validates structure, checks WCAG contrast on color pairs, finds broken token references, and flags orphaned tokens. **Do not skip — this is where you catch the visual mistakes that would otherwise reach the browser.** Common catches:
- Foreground-on-background contrast under 4.5:1
- Token referenced but never defined
- Defined token never referenced (probably a typo — fix it, don't delete)

Fix and re-lint until clean.

### 6. Hand off

Subsequent component work pulls colors/spacing/radius from DESIGN.md tokens, not from memory or arbitrary Tailwind classes. Optional: `npx @google/design.md export --tailwind` emits a Tailwind theme config from DESIGN.md so JSX can reference semantic class names (`bg-background`, `text-muted-foreground`) backed by the contract.

For ongoing consistency, run `npx @google/design.md diff <ref1> <ref2>` between commits to catch drift in PR review.

## What This Replaces

| Without this skill | With this skill |
|---|---|
| "Near-black, off-white, indigo accent" (from memory) | Tokens defined once in DESIGN.md, referenced everywhere |
| `bg-zinc-900` and `bg-neutral-950` mixed across files | One canonical `bg-background` token |
| Eyeball-validate in browser | `lint` validates contrast + structure programmatically |
| Drift discovered at component #20 | Drift caught by `diff` between commits |
| "I'll add CSS variables to globals.css instead" | DESIGN.md is the source; `globals.css` derives from it |

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "A separate spec file is theater on a tight deadline" | Bootstrap is 5–10 min. Drift correction at week-end is hours. |
| "I'll add CSS variables to globals.css instead" | CSS variables without rationale rot. DESIGN.md persists the *why*. |
| "I know the visual direction — I'll just code" | Memory-based design is how you end up with three near-blacks. |
| "The user said 'just get going'" | Bootstrap *is* getting going. Arbitrary colors is debt. |
| "Contrast is fine, I can tell by eye" | Run the linter. WCAG ratios are not visual intuition. |
| "We'll codify the design after the first version" | After-the-fact codification means refactoring 20 components. |
| "The UI library already gives me tokens" | The library's defaults are not your brand. DESIGN.md is the *override layer* with rationale. |

## Red Flags — STOP

- About to write a component file before DESIGN.md exists → STOP. Bootstrap first.
- About to hardcode a color, spacing, or radius value in JSX → STOP. Add the token to DESIGN.md, reference it.
- Skipping `lint` because "it'll probably be fine" → STOP. Run it.
- About to deviate from DESIGN.md tokens "just for this one component" → STOP. Either update DESIGN.md (with rationale) or don't deviate.

## Tool Reference

| Command | Purpose |
|---|---|
| `npx @google/design.md spec --rules` | Dump current format spec into your context |
| `npx @google/design.md lint` | Validate structure, contrast, token references |
| `npx @google/design.md diff <ref1> <ref2>` | Regression check between versions |
| `npx @google/design.md export --tailwind` | Emit Tailwind theme config from DESIGN.md |

Full CLI: https://github.com/google-labs-code/design.md

## Hand-Offs

- **Before this skill:** `globalcoder-workflow:brainstorming` UI exploration phase produces decisions to feed in. Run brainstorming first if you don't yet have visual decisions.
- **After this skill:** `globalcoder-workflow:writing-plans` should reference DESIGN.md as a constraint artifact for any UI plan.
- **Code review:** `globalcoder-workflow:requesting-code-review` checks that components reference DESIGN.md tokens, not raw values.
