# Brainstorming UI/Design Exploration

**Goal:** Add a conditional UI/design exploration phase to the brainstorming skill so that UI-facing features get visual direction established before architecture decisions.

**Approach:** Extend the existing `skills/brainstorming/SKILL.md` with a new conditional section.

---

## Trigger Condition

The UI exploration phase activates only for UI-facing work — web apps, mobile, CLI with styled output. It is skipped for pure backend, API, or library work. The skill determines this naturally during the "Understanding the idea" phase.

## Updated Flow

```
Understanding the idea (existing)
  ↓
Is this UI-facing? ── No ──→ Skip to Approaches
  │ Yes
  ↓
Detect existing design context
  ↓
UI/Design Exploration (one question at a time)
  ↓
Exploring approaches (existing, now informed by design direction)
  ↓
Presenting the design (existing, now includes UI Direction section)
```

## UI Detection Step

Before asking UI questions, scan the project for existing design infrastructure:

- CSS framework config (tailwind.config.*, postcss.config.*)
- UI library imports in package.json (shadcn, MUI, Chakra, Radix, etc.)
- Design tokens/variables (theme files, CSS custom properties, tokens.json)
- Color definitions (palette constants, CSS variable blocks)
- Animation libraries (Framer Motion, GSAP, Spring, auto-animate)

If found, present a summary and ask whether to follow, extend, or diverge from existing patterns. If nothing found (greenfield), proceed directly to UI direction questions.

## Four Exploration Dimensions

Each dimension explored with one question at a time, multiple choice preferred. Skip questions when answers are obvious from prior context.

**1. Visual feel & color direction**
- Mood: minimal/clean, bold/vibrant, warm/organic, dark/technical
- Color approach: follow brand, derive from existing palette, start fresh
- Light/dark mode preference

**2. Layout & responsive approach**
- Layout pattern: sidebar+content, top nav+cards, single column, dashboard grid
- Responsive priority: mobile-first, desktop-first, target device
- Content hierarchy and primary action

**3. Component style & library choice**
- Existing UI library vs. custom components
- Icon style, form style, density
- Skip if existing library already dictates these

**4. Animation & interaction patterns**
- Motion philosophy: subtle/functional, expressive/delightful, minimal/none
- Key interactions: transitions, hover, loading states, scroll-driven
- Performance/accessibility: reduce-motion support

## Design Document Addition

UI-facing designs include a **UI Direction** section before architecture:

```markdown
## UI Direction

**Visual Feel:** [mood and color approach]
**Layout:** [pattern, responsive strategy]
**Components:** [library, icon style, density]
**Motion:** [philosophy, key interactions]
**Existing Context:** [what was detected, decision to follow/extend/diverge]
```

Intentionally brief — direction, not specification.

## Constraints

- Skill stays under 500 words (token efficiency target)
- One question per message rule preserved
- Multiple choice preferred rule preserved
- YAGNI: direction only, no full design specs
- Existing non-UI brainstorming flow unchanged
