---
name: performance-profiling
description: Use when the app is slow, a specific operation takes too long, bundle size is too large, or you need to optimize resource usage — requires a measurable problem, not premature optimization
---

# Performance Profiling

## Overview

Systematic approach to finding and fixing performance bottlenecks.

**Core principle:** Measure before you cut. Never optimize based on intuition.

## Boundary Rules

```
NO OPTIMIZATION WITHOUT A BASELINE MEASUREMENT FIRST
NO "DONE" CLAIM WITHOUT BEFORE/AFTER COMPARISON
ONE BOTTLENECK AT A TIME — don't shotgun optimize
```

## When to Use

**Use for:**
- App is slow (user-reported or measured)
- Specific operation takes too long
- Bundle size is too large
- Memory usage growing over time
- API response times degraded

**Don't use for:**
- Premature optimization ("this might be slow someday")
- Micro-optimizations with no measurable impact
- Theoretical concerns without evidence

## The Three Phases

### Phase 1: Define & Measure

1. **State the problem clearly:** What's slow, for whom, how slow?
2. **Define the target metric:** Load time, response time, bundle size, memory, query time
3. **Establish baseline** with exact numbers (not "it feels slow")
4. **Set a concrete goal:** "Reduce X from 3s to under 1s" — not "make it faster"

### Phase 2: Investigate & Identify

Profile to find the actual bottleneck. **Don't guess.**

Work top-down: start at the entry point, follow the hot path.

**Investigation patterns** (use whichever fits):

| Problem Type | Investigation |
|-------------|---------------|
| Slow renders | Are components re-rendering unnecessarily? |
| Network | Requests waterfalling? Too many? Payloads too large? |
| Computation | O(n²) loop? Expensive calculation on every render? |
| Bundle | Which dependencies dominate? Tree-shakeable? |
| Database | Slow queries? Missing indexes? N+1? |
| Memory | Growing over time? Uncleared listeners? |

**Identify the single biggest bottleneck.** This is your target.

### Phase 3: Optimize & Verify

1. Fix the bottleneck with the **simplest possible change**
2. Measure again with the **same method** as baseline
3. Compare before/after:
   - **Improved?** Commit with measurement in message: `perf: reduce dashboard load from 3.2s to 0.8s`
   - **Not improved?** Revert. Re-investigate. Your diagnosis was wrong.
4. Repeat Phase 2-3 if further optimization needed

## Rationalization Table

| Thought | Reality |
|---------|---------|
| "I can see the problem, no need to measure" | Your eyes lie. The profiler doesn't. |
| "Let me optimize this while I'm in here" | That's premature optimization. Is it actually slow? |
| "This optimization is obviously better" | Prove it with numbers or revert it. |
| "I'll measure after I fix everything" | You won't know which fix helped. One at a time. |
| "It feels faster" | Feelings aren't metrics. Show the numbers. |
| "Everyone knows X is slow" | Measure it. Common knowledge is often wrong. |

## Red Flags — STOP

- Optimizing without a baseline measurement
- Fixing multiple bottlenecks at once
- Claiming "faster" without before/after numbers
- Optimizing code that isn't the bottleneck
- Premature optimization of code that works fine

## Stack-Specific Appendix

### React/Vite/TypeScript
- **Bundle analysis:** `npx vite-bundle-visualizer`
- **Component profiling:** React DevTools → Profiler tab → record interaction
- **Code splitting:** `React.lazy()` + `Suspense` for route-level splitting
- **Re-render detection:** Profile in production build, not dev (StrictMode double-renders in dev)
- **Common wins:** virtualize long lists (`react-window`), debounce search inputs, lazy-load images

### Supabase
- **Slow queries:** Supabase Dashboard → SQL Editor → `EXPLAIN ANALYZE`
- **Missing indexes:** Check query patterns against existing indexes
- **N+1:** Replace multiple `.eq()` calls with `.in()` or use views/functions
- **Realtime:** Excessive subscriptions degrade client performance — audit active channels
- **Edge Functions:** Cold start overhead — consider response caching

### General
- Always profile the **production build**, not dev mode
- Network: check for uncompressed responses, missing cache headers
- Database: log slow queries (>100ms) and add indexes for frequent patterns
- Memory: if it grows over time → leak. Take two heap snapshots and diff.

## Investigation Toolkit

| Problem | Tools |
|---------|-------|
| Slow renders | React DevTools Profiler, `React.memo` audit |
| Large bundle | `npx vite-bundle-visualizer`, import analysis |
| Slow API | Network tab waterfall, `EXPLAIN ANALYZE` |
| Memory leaks | Heap snapshots, subscription audit |
| Slow tests | `--reporter=verbose` for timing |

## Integration

**Pairs with:**
- **globalcoder-workflow:systematic-debugging** — If performance issue has a root cause bug
- **globalcoder-workflow:verification-before-completion** — Verify improvement with numbers before claiming done

## Quick Reference

| Phase | Gate | Key Action |
|-------|------|------------|
| 1. Define & Measure | Baseline number exists | Set concrete target metric |
| 2. Investigate & Identify | Single bottleneck identified | Profile, don't guess |
| 3. Optimize & Verify | Before/after comparison shows improvement | Simplest fix, measure again |
