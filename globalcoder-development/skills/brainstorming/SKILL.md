---
name: brainstorming
description: Use when starting creative work — adding features, building components, adding functionality, modifying existing behavior, or any time the user describes a new idea or capability they want to build.
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## The Process

**Understanding the idea:**
- Check the current project state first. If the repo has the project-init files at root, read them — they're the canonical source of context:
  - `CLAUDE.md` — workflow contract and project overview
  - `memory.md` — active work, key decisions, things to remember across sessions
  - `tech_stack.md` — frameworks, data, infra, tooling (shapes which approaches are realistic)
  - `style_guide.md` — conventions the design must respect
  - `backlog.md` — is this idea already in "Next Up" or "Later"? Move it forward or note it as a new item
  - `tech_docs.md` — external APIs and library constraints relevant to this work
- If the files don't exist, fall back to a quick scan of files, docs, and recent commits.
- Ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

**UI/Design exploration (UI-facing features only):**

Skip this for pure backend, API, or library work. For anything with a visible interface:

- First, scan the project for existing design context — CSS framework config, UI library in package.json, theme/token files, color variables, animation libraries
- If found, present what exists and ask: follow, extend, or diverge?
- Then explore four dimensions, one question at a time, multiple choice preferred:
  1. **Visual feel & color** — mood, palette direction, light/dark mode
  2. **Layout & responsive** — layout pattern, responsive priority, content hierarchy
  3. **Component style** — UI library, icon style, density (skip if existing library dictates)
  4. **Animation & motion** — philosophy (subtle/expressive/minimal), key interactions, reduce-motion
- Skip questions when prior answers make them obvious
- Design direction informs the approach options that follow

**Exploring approaches:**
- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why
- For UI-facing features, approaches should reflect the design direction established above

**Presenting the design:**
- Once you believe you understand what you're building, present the design
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- For UI-facing features, include a **UI Direction** section before architecture covering: visual feel, layout, components, motion, and existing context decisions
- Be ready to go back and clarify if something doesn't make sense

## After the Design

**Documentation:**
- Write the validated design to `docs/plans/YYYY-MM-DD-<topic>-design.md`
- Use elements-of-style:writing-clearly-and-concisely skill if the plugin is installed (optional — skip if unavailable)
- Commit the design document to git

**UI design (if applicable):**
- If the design involves UI/visual decisions, hand off to globalcoder-development:ui-design-bootstrap to codify the visual direction into a `DESIGN.md` token contract *before* component code is written. Pass along the visual decisions gathered in the UI/Design exploration phase above so they don't have to be re-elicited.

**Implementation (if continuing):**
- Ask: "Ready to set up for implementation?"
- Use globalcoder-development:using-git-worktrees to create isolated workspace
- Use globalcoder-development:writing-plans to create detailed implementation plan

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense
