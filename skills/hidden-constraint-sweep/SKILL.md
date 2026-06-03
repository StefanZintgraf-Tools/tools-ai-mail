---
name: hidden-constraint-sweep
description: >
  Runs an 8-class hidden-constraint sweep over a requirements doc or use-case
  spec, forcing an explicit covered / not-applicable / missing verdict for each
  class — security & PII, permissions, data-retention, migrations,
  observability, public-API-compat, concurrency, out-of-scope. Use when the user
  asks to "run the hidden-constraint sweep", "check for hidden constraints",
  "find missing constraints", "do the constraint checklist", "what did we
  forget", "sweep for security/PII/retention/observability gaps", or wants to
  pressure-test a spec against the cross-cutting concerns stakeholders commonly
  miss before alignment, a use case, or a domain model is considered complete.
  Step-agnostic: works at requirements, use-case-spec, and domain-model stages.
---

# Hidden-Constraint Sweep

A cross-cutting lens that fires the 8-class hidden-constraint checklist over a
spec and produces a per-class table. The checklist's value is that it **defeats
agent judgment about which classes apply**: every class is examined every time,
regardless of whether the input plausibly touches it. Silent omission of a class
is forbidden.

## Instructions

1. **Resolve the input.** The target is the requirements doc or use-case spec
   the user names (or the one in context). If none is named, ask which artifact
   to sweep before proceeding.
2. **Resolve optional context.** If a glossary/context file is given as an arg,
   use it. Otherwise resolve in order: `docs/CONTEXT.md`, then `docs/glossary.md`.
   If neither exists, warn ("no glossary/context found; proceeding without term
   grounding") and continue — never hard-code a single context filename, never
   block on its absence.
3. **Examine all 8 classes — always.** Walk every class in the table below in
   order. Do not skip a class because the spec "obviously" doesn't touch it;
   that judgment is exactly what this sweep exists to override.
4. **Assign one of three verdicts per class:**
   - `covered` — the concern is addressed in the spec. **Requires a pointer**:
     cite the FR/NFR id, section heading, use-case flow, or context/glossary term
     that addresses it. A verdict with no pointer is not `covered`.
   - `not-applicable` — the concern genuinely does not apply. **Requires a
     recorded reason** stated in plain language. "N/A" without a reason is not
     allowed.
   - `missing` — a real gap. **`missing` blocks**: the sweep does not report
     "complete" while any class is `missing`. Each missing class must be routed
     to a concrete follow-up (next section). No silent passes, no deferring the
     gap to a later review phase as a "documented gap" that closes the sweep.
5. **Route every `missing` to a follow-up.** Each `missing` class becomes one of:
   a new functional requirement (FR), a new non-functional requirement (NFR), a
   use-case alternative flow, or a deferral. Name the concrete follow-up in the
   table.
6. **Emit the per-class table** plus the follow-up list, then state the sweep
   verdict: `clean` (no missing) or `blocked` (one or more missing, listed).

## DO NOT

- Skip or silently drop any of the 8 classes — examine all of them every run.
- Let the agent decide a class is irrelevant and omit it; downgrade to
  `not-applicable` **with a recorded reason** instead.
- Record `covered` without a concrete pointer, or `not-applicable` without a
  reason.
- Close the sweep as complete while any class is `missing`.
- Hard-code `CONTEXT.md` (or any single context filename) — resolve the chain
  and warn-and-proceed if absent.
- Model entities, edit the glossary, gate ADRs, or rewrite the spec — those are
  other skills. This skill only surfaces constraint gaps and names follow-ups.
- Perform the actual scope-cut/deferral mechanics. Surface the candidate; defer
  the deferral itself to the scope-cut skill (e.g. `pareto-scope-cut`).

## The 8 Classes

| # | Class | What to look for |
|---|-------|------------------|
| 1 | Security / PII | Auth, secrets handling, input validation, personally identifiable information capture/storage/transmission. |
| 2 | Permissions / authorization | Who is allowed to perform each action; who is explicitly not; role/scope boundaries. |
| 3 | Data retention | How long data is kept, where it lives, deletion and purge rules. |
| 4 | Migrations | Schema or data changes required; backfill, versioning, rollback. |
| 5 | Observability | Logs, metrics, and traces required to operate and debug this feature. |
| 6 | Public-API compatibility | Does this break an existing contract (API, event, file format, CLI)? |
| 7 | Concurrency | Multiple agents, users, or processes touching the same state; locking, races, idempotency. |
| 8 | Out-of-scope | What is deliberately **not** in this iteration (negative scope made explicit). |

## Verdicts

| Verdict | Meaning | Mandatory evidence | Effect |
|---------|---------|--------------------|--------|
| `covered` | Concern addressed in the spec | Pointer: FR/NFR id, section, flow, or glossary term | Passes |
| `not-applicable` | Concern genuinely does not apply | Recorded plain-language reason | Passes |
| `missing` | Real gap | Routed follow-up (see below) | **Blocks** — sweep cannot report complete |

## Routing `missing` Classes

| Follow-up type | When to use |
|----------------|-------------|
| New FR | Missing behaviour the system must do (e.g. an authorization check). |
| New NFR | Missing measurable quality (e.g. retention window, audit-log requirement). |
| Use-case alternative flow | Missing branch in an existing use case (e.g. unauthorized-access flow). |
| Deferral | Concern acknowledged but intentionally out of this iteration — surface as a deferral candidate and hand to the scope-cut skill; do not enact the cut here. |

## Output Format

```markdown
## Hidden-Constraint Sweep — <artifact name>

Context source: <resolved context file | "none — proceeded without grounding">

| # | Class | Verdict | Pointer / Reason / Follow-up |
|---|-------|---------|------------------------------|
| 1 | Security / PII | covered | NFR-04 (encryption at rest) |
| 2 | Permissions / authorization | missing | New FR: only the mailbox owner may delete a thread |
| 3 | Data retention | not-applicable | No data persisted; request is stateless |
| 4 | Migrations | not-applicable | Greenfield; no existing schema |
| 5 | Observability | missing | New NFR: emit structured audit log per write |
| 6 | Public-API compatibility | covered | Section 4.2 — additive endpoint only |
| 7 | Concurrency | missing | Alt-flow: two processes editing the same draft |
| 8 | Out-of-scope | covered | Section 6 — bulk import excluded this iteration |

### Follow-ups
- Permissions (missing) → new FR: only the mailbox owner may delete a thread.
- Observability (missing) → new NFR: structured audit log on every write op.
- Concurrency (missing) → use-case alt-flow: concurrent draft edit, last-write conflict.

### Sweep verdict
blocked — 3 classes missing (Permissions, Observability, Concurrency).
```

## Workflow

1. Resolve the input artifact (ask if unnamed).
2. Resolve the optional context file (arg → `docs/CONTEXT.md` → `docs/glossary.md`;
   warn and proceed if none).
3. Read the artifact (and context, if present).
4. Use TodoWrite to create one task per class (8 tasks).
5. For each class in order: assign `covered` (with pointer), `not-applicable`
   (with reason), or `missing` (with routed follow-up). Mark the todo complete.
6. Emit the per-class table in the output format above.
7. Emit the Follow-ups list — one line per `missing` class.
8. State the sweep verdict: `clean` if no class is `missing`; otherwise
   `blocked`, listing the missing classes. A `blocked` sweep must not be
   reported as complete.

## Notes

- This sweep is the same checklist whether run at alignment close, on a
  requirements doc, on a use-case spec, or on a domain model — it is
  step-agnostic. The only thing that varies is the kind of pointer or follow-up
  (FR/NFR at requirements, alt-flow at use-case, etc.).
- Source rules: gr_algn.md Aln6 (alignment-close sweep, three outcomes, `missing`
  blocks close) and coding_plan.md B5 (reusable checklist shared by alignment and
  review). Aln6 enumerates **8** classes (the set used here, including
  out-of-scope); the B5 summary line and gr_rev.md Rev7 list **7** (they omit
  out-of-scope and pair retention+migrations on one line). This skill follows the
  Aln6 8-class set per the build spec; the difference is presentational, not a
  conflict in intent.
```
