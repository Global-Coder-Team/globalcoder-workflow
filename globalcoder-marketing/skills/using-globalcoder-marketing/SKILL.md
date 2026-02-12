---
name: using-globalcoder-marketing
description: Use when starting any conversation involving marketing, branding, product launches, positioning, content creation, or go-to-market strategy - routes to the correct marketing skill
---

# Using globalcoder-marketing

## Overview

Entry point for the globalcoder-marketing plugin. Routes to the correct skill based on user intent.

**Invoke relevant marketing skills BEFORE any response.** If the user's task involves marketing, branding, launching, positioning, or content - check this routing table.

## Skill Routing

```dot
digraph routing {
    rankdir=LR;
    "User intent" [shape=doublecircle];
    "Audience / market" [shape=box, label="market-research"];
    "Buyer profiles" [shape=box, label="customer-personas"];
    "Name / voice / brand" [shape=box, label="brand-identity"];
    "Messaging / value prop" [shape=box, label="positioning-strategy"];
    "Launch timeline / GTM" [shape=box, label="launch-plan"];
    "Content planning" [shape=box, label="content-strategy"];
    "Landing page" [shape=box, label="landing-page"];
    "Email / social / ads" [shape=box, label="campaign-builder"];
    "Post-launch review" [shape=box, label="launch-retrospective"];

    "User intent" -> "Audience / market" [label="who's the market?"];
    "User intent" -> "Buyer profiles" [label="who are we selling to?"];
    "User intent" -> "Name / voice / brand" [label="what's our brand?"];
    "User intent" -> "Messaging / value prop" [label="how do we position?"];
    "User intent" -> "Launch timeline / GTM" [label="plan the launch"];
    "User intent" -> "Content planning" [label="what content?"];
    "User intent" -> "Landing page" [label="build landing page"];
    "User intent" -> "Email / social / ads" [label="create campaigns"];
    "User intent" -> "Post-launch review" [label="how did it go?"];
}
```

## Recommended Full-Launch Flow

market-research → customer-personas → brand-identity → positioning-strategy → launch-plan → content-strategy → landing-page / campaign-builder → launch-retrospective

All skills also work standalone. Each reads upstream docs from `docs/marketing/` if they exist.

## Output Mode

Every skill that produces artifacts asks at the start:

> **What output depth for this session?**
> 1. **Minimal** - Markdown documents only
> 2. **Full** - Markdown + code artifacts (structured data, templates, components)

## Companion Integration

This plugin works alongside globalcoder-workflow. Skills that produce actionable plans suggest:

> "Use `globalcoder-workflow:writing-plans` to break this into executable tasks."

No hard dependency. Suggestion only.
