---
name: database-migration
description: Use when adding, modifying, or removing database tables, columns, indexes, views, functions, or RLS policies — any schema change targeting a shared or production database
---

# Database Migration

## Overview

Disciplined approach to schema changes that protects data and prevents downtime.

**Core principle:** Migrations are one-way doors in production. Every migration must be planned for rollback BEFORE it's written.

**Violating the letter of this process is violating the spirit of safe migrations.**

## The Iron Laws

```
NO MIGRATION WITHOUT A ROLLBACK PLAN FIRST
NO DATA-DESTRUCTIVE CHANGES WITHOUT EXPLICIT USER CONFIRMATION
NO MIGRATION THAT BREAKS RUNNING CODE
NEVER MODIFY A DEPLOYED MIGRATION — create a new one
```

## When to Use

**Use for:**
- Adding, modifying, or removing tables, columns, indexes
- Changing views, functions, triggers, or RLS policies
- Any schema change applied to shared or production databases
- Data migrations (backfills, type conversions)

**Don't use for:**
- Local-only development databases you can freely reset
- Seed data changes (no schema impact)

## The Five Phases

### Phase 1: Plan the Change

1. **State what's changing and why** in one sentence
2. **List everything affected:** tables, columns, indexes, views, functions, policies
3. **Classify the change:**

| Type | Examples | Risk |
|------|----------|------|
| **Additive** | New table, new nullable column, new index | Safe — backward compatible |
| **Modifying** | Rename column, change type, alter constraint | Risky — needs compatibility plan |
| **Destructive** | Drop table, drop column, remove data | Dangerous — needs confirmation |

4. **Hard gate: DESTRUCTIVE CHANGES REQUIRE USER CONFIRMATION BEFORE PROCEEDING**

### Phase 2: Write the Rollback First

1. Write the down/rollback migration BEFORE the up migration
2. Verify rollback can execute cleanly against the post-migration state
3. For data-modifying migrations: document what data is lost on rollback (if any)
4. **Hard gate: NO UP MIGRATION WITHOUT A CORRESPONDING ROLLBACK**

### Phase 3: Write the Migration

1. Use `IF NOT EXISTS` / `IF EXISTS` guards on all DDL
2. One logical change per migration file
3. Descriptive naming: `YYYYMMDDHHMMSS_add_user_preferences_table.sql`
4. Include RLS policies in same migration as table creation
5. Comments explain WHY, not WHAT (the SQL says what)

### Phase 4: Test Locally

1. Apply migration to clean local database
2. Run the full application against migrated schema
3. Run full test suite
4. Apply the rollback migration
5. Run full test suite again post-rollback
6. **Hard gate: MIGRATION AND ROLLBACK MUST BOTH PASS ALL TESTS**

### Phase 5: Deploy Safely

| Change Type | Deploy Order |
|-------------|-------------|
| **Additive** | Apply migration → deploy new code |
| **Destructive** | Deploy code without dependency → apply migration |

- Monitor for errors after migration
- Keep rollback ready for backward compatibility window (minimum 1 deploy cycle)

## Backward Compatibility Patterns

| Change | Safe Pattern |
|--------|-------------|
| **Add column** | Add with DEFAULT or NULL. Old code ignores it. |
| **Rename column** | Add new → backfill → update code → drop old (3 migrations) |
| **Change type** | Add new column with new type → backfill → update code → drop old |
| **Drop column** | Remove all code references → deploy → drop column |
| **Drop table** | Remove all code references → deploy → drop table |
| **Add NOT NULL** | Add nullable → backfill → add constraint (2 migrations) |

## Rationalization Table

| Thought | Reality |
|---------|---------|
| "I'll write the rollback later" | You won't. And you'll need it at 2am on a Saturday. |
| "This is just adding a column, no rollback needed" | Additive changes still need rollbacks. What if the name is wrong? |
| "I'll just modify the existing migration" | If it's deployed, you've rewritten history. Create a new one. |
| "I can drop and recreate in one migration" | Old code runs during migration. It will break between drop and recreate. |
| "Nobody uses this table anyway" | Prove it. Check queries, RLS policies, Edge Functions, and views. |
| "I'll test in staging" | Test locally first. Staging failures slow everyone down. |

## Red Flags — STOP

- Writing an up migration without a rollback plan
- Modifying a migration that's already been deployed
- Dropping columns without removing code references first
- Skipping local test cycle (apply → test → rollback → test)
- Destructive changes without user confirmation
- Bundling unrelated schema changes in one migration

**All of these mean: STOP. Plan the rollback. Test locally. Then proceed.**

## Stack-Specific Appendix

### Supabase
- Create migrations: `npx supabase migration new <name>`
- Test cycle: `npx supabase db reset` (applies all from scratch)
- RLS: always in same migration as table creation, use `auth.uid()` for row ownership
- Views: update when underlying tables change
- Edge Functions: check if any reference the changed schema
- Realtime: verify changes don't break subscriptions
- Storage: verify bucket policies after storage-related changes
- Types: run `npx supabase gen types typescript` after migration

### Django/Python
- `python manage.py makemigrations` — don't write by hand unless necessary
- `python manage.py migrate --plan` to preview
- `RunPython` needs `reverse_code` for rollback
- Separate data migrations from schema migrations

### Rails/Ruby
- `rails generate migration <name>`
- `rails db:migrate:status` to check state
- Define both `up` and `down` (not just `change`)
- `rails db:rollback STEP=1` to test rollback

### General
- Back up database before production migrations
- Run during low-traffic windows
- Monitor error rates for 15 minutes after
- Keep a runbook: what to do if migration fails mid-way

## Integration

**Pairs with:**
- **globalcoder-development:security-review** — New tables need RLS policy review
- **globalcoder-development:test-driven-development** — Write tests for new schema before migrating
- **globalcoder-development:verification-before-completion** — Verify migration + rollback both work

## Quick Reference

| Phase | Gate | Key Action |
|-------|------|------------|
| 1. Plan | Destructive changes confirmed by user | Classify change type, list affected objects |
| 2. Rollback First | Rollback written before up migration | Document data loss on rollback |
| 3. Write Migration | IF EXISTS guards, one change per file | Include RLS with table creation |
| 4. Test Locally | Migration + rollback both pass tests | Full cycle: apply → test → rollback → test |
| 5. Deploy | Correct order for change type | Monitor errors, keep rollback ready |
