---
name: security-review
description: Use when merging features that handle user input, authentication, authorization, payments, or sensitive data, or for periodic security audits and vulnerability reports
---

# Security Review

## Overview

Systematic security sweep to find what you missed, not confirm what you did right.

**Core principle:** Assume breach, verify everything. Approach your own code as an attacker would.

## Boundary Rules

```
NO "LOOKS SECURE" WITHOUT CHECKING EACH APPLICABLE AREA
NO SECURITY BY OBSCURITY
EVERY FINDING GETS A SEVERITY — Critical, High, Medium, Low
```

## When to Use

**Use for:**
- Before merging features handling user input, auth, payments, or sensitive data
- Periodic security audits
- After a vulnerability report
- New tables or API endpoints with access control
- Any code handling secrets, tokens, or PII

**Don't use for:**
- Pure UI changes with no data handling
- Internal tooling with no user-facing surface

## The Process

### Phase 1: Threat Surface Mapping

1. **Identify scope:** What's being reviewed (feature, module, full app)?
2. **Map trust boundaries:** Where does user input enter? Where does data leave?
3. **List assets at risk:** User data, auth tokens, payment info, admin access
4. **Identify threat actors:** Unauthenticated users, authenticated users, admins, other services

### Phase 2: Sweep the Checklist

Work through each area. **Skip areas that don't apply — but document WHY you skipped them.**

#### Authentication & Session Management
- [ ] Passwords hashed with strong algorithm (bcrypt/argon2, not MD5/SHA1)
- [ ] Session tokens unpredictable, rotated on privilege change
- [ ] Login rate-limited or uses CAPTCHA
- [ ] Logout invalidates session server-side
- [ ] Password reset tokens single-use and time-limited

#### Authorization & Access Control
- [ ] Every endpoint checks authorization (not just authentication)
- [ ] Users cannot access others' data by changing IDs in URLs/requests
- [ ] Admin functions protected by role check, not just hidden UI
- [ ] File uploads restricted by type and size
- [ ] API rate limiting on sensitive endpoints

#### Input Validation & Injection
- [ ] All user input validated server-side (client validation is UX, not security)
- [ ] SQL injection prevented (parameterized queries or ORM)
- [ ] XSS prevented (output encoding, CSP headers)
- [ ] No `eval()`, `dangerouslySetInnerHTML`, or dynamic code execution with user input
- [ ] File paths validated — no path traversal

#### Data Protection
- [ ] Sensitive data encrypted at rest and in transit (HTTPS enforced)
- [ ] API keys, secrets, credentials NOT in client code or git history
- [ ] PII minimized — only collect what's needed
- [ ] Logs don't contain passwords, tokens, or PII
- [ ] Error messages don't leak internal details (stack traces, SQL errors)

#### Dependency & Infrastructure
- [ ] Dependencies audited (`npm audit`, `cargo audit`)
- [ ] No dependencies from untrusted sources
- [ ] CORS configured restrictively (not `*`)
- [ ] Security headers present (CSP, X-Frame-Options, X-Content-Type-Options)

## Severity Classification

| Severity | Definition | Action |
|----------|-----------|--------|
| **Critical** | Exploitable now, data exposure or auth bypass | Block merge. Fix immediately. |
| **High** | Exploitable with moderate effort | Fix before merge. |
| **Medium** | Requires specific conditions to exploit | Fix within current sprint. |
| **Low** | Defense-in-depth improvement | Track and fix when convenient. |

## Output Format

Write findings to a structured report:

```markdown
## Security Review: [feature/module name]
Date: YYYY-MM-DD
Scope: [what was reviewed]
Skipped areas: [what was skipped and why]

### Findings
1. [CRITICAL] Title — description, location, remediation
2. [HIGH] Title — description, location, remediation

### Summary
X findings: N critical, N high, N medium, N low
Recommendation: [BLOCK / FIX BEFORE MERGE / APPROVE WITH NOTES]
```

## Red Flags — STOP

- Claiming "looks secure" without checking each area
- Skipping an area without documenting why
- Accepting security by obscurity ("nobody would try that")
- Not assigning severity to findings
- Approving with unresolved Critical findings

## Stack-Specific Appendix

### React/TypeScript
- Check for `dangerouslySetInnerHTML` — every instance needs justification and sanitization (DOMPurify)
- Verify sensitive routes wrapped in auth guards, not just hidden from navigation
- API keys in `.env`: `VITE_` prefix means **exposed to client** — only for truly public values
- No tokens or PII in `localStorage` (use httpOnly cookies or Supabase session)

### Supabase
- **RLS is your primary defense** — every table MUST have RLS enabled
- `service_role` key NEVER in client code — only in Edge Functions
- RLS policies use `auth.uid()` not client-provided user IDs
- Storage buckets: verify policies prevent users overwriting others' files
- Edge Functions: validate all inputs, don't trust JWT payload without verification
- `USING (true)` on sensitive tables = red flag

### General
- `git log --all -p -- '*.env*'` — check if secrets were ever committed
- CI/CD: check for leaked environment variables
- Development/debug endpoints disabled in production
- Test with unauthenticated request to every API endpoint — what happens?

## Integration

**Pairs with:**
- **globalcoder-development:requesting-code-review** — Security review can complement code review
- **globalcoder-development:verification-before-completion** — Verify security fixes before claiming done
- **globalcoder-development:database-migration** — New tables need RLS policies reviewed

## Quick Reference

| Phase | Key Action |
|-------|------------|
| 1. Threat Surface | Map boundaries, assets, actors |
| 2. Sweep Checklist | Check each area, document skips |
| 3. Classify Findings | Assign severity to every finding |
| 4. Report | Structured output with recommendation |
