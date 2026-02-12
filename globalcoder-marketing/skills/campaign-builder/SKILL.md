---
name: campaign-builder
description: Use when building marketing campaigns - creates email sequences, social media post series, and ad copy with platform-specific formatting and constraints
---

# Campaign Builder

## Overview

Build multi-channel campaign sequences: email, social, and ads. Respects platform-specific constraints and formats.

**Announce at start:** "I'm using the campaign-builder skill to create the campaigns."

## Process

**Step 1: Context gathering**
- Read existing docs: content strategy, positioning, personas, launch plan
- Ask the output mode question (minimal vs full)

**Step 2: Select campaign types**

Ask which to build (can select multiple):
- Email sequence (welcome/nurture, launch announcement, post-launch follow-up)
- Social campaign (platform-specific post series)
- Ad copy (headlines, descriptions, CTAs for paid channels)

**Step 3: Build each selected campaign**

Present each campaign individually for validation.

### Email Sequences

1. Map the sequence: trigger → email 1 → wait period → email 2 → ...
2. Per email:
   - Subject line (+ A/B variant)
   - Preview text
   - Body copy (keep concise - emails are scanned, not read)
   - CTA (single, clear action)
3. Recommend sequence length (3-5 emails for launch, push back on longer)

### Social Campaigns

1. Ask which platforms (Twitter/X, LinkedIn, Instagram, etc.)
2. Per platform, respect constraints:
   - Twitter/X: 280 chars, thread format for longer content
   - LinkedIn: 3000 chars, professional tone, no hashtag overload
   - Instagram: caption + visual direction, hashtag strategy
3. Create post series tied to content calendar
4. Include posting schedule

### Ad Copy

1. Ask which ad platforms (Google, Meta, LinkedIn, etc.)
2. Per platform, respect character limits:
   - Google Ads: 30 char headlines, 90 char descriptions
   - Meta Ads: 40 char headline, 125 char primary text
   - LinkedIn Ads: 70 char headline, 150 char intro text
3. Create 3-5 headline/description variants per platform
4. Suggest audience targeting aligned to personas

**Step 4: Write output**
- Write to `docs/marketing/campaigns/` (one file per campaign type):
  - `email-launch-sequence.md`
  - `social-launch-campaign.md`
  - `ad-copy.md`
- **Full mode adds:** email templates as HTML, social posts as ready-to-copy text with character counts, ad copy as CSV

**Step 5: Handoff**
- If landing page exists, link campaigns to drive traffic there
- Suggest `globalcoder-marketing:launch-retrospective` after launch

## Key Principles

- **Platform constraints are non-negotiable** - respect character limits, format requirements
- **A/B variants** - always provide at least 2 subject lines and headlines
- **Concise over clever** - clear messaging outperforms creative wordplay
- **One CTA per piece** - don't split attention across multiple actions
