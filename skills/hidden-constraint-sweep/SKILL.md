---
name: hidden-constraint-sweep
description: >
  Runs an 8-class hidden-constraint sweep over a requirements doc, use-case
  spec, domain model, or PRD draft, forcing an explicit covered / not-applicable
  / missing verdict for each class — security & PII, permissions, data-retention,
  migrations, observability, public-API-compat, concurrency, out-of-scope. Use
  when the user asks to "run the hidden-constraint sweep", "check for hidden
  constraints", "find missing constraints", "do the constraint checklist", "what
  did we forget", "sweep for security/PII/retention/observability gaps", or wants
  to pressure-test a spec against the cross-cutting concerns stakeholders
  commonly miss before alignment, a use case, or a domain model is considered
  complete. Step-agnostic: works at requirements, use-case-spec, domain-model,
  and PRD-draft (the pre-publish `spec-to-prd` Phase-4 projection) stages.
---

# Hidden-Constraint Sweep

A cross-cutting lens that fires the 8-class hidden-constraint checklist over a
spec and produces a per-class table. The checklist's value is that it **defeats
agent judgment about which classes apply**: every class is examined every time,
regardless of whether the input plausibly touches it. Silent omission of a class
is forbidden.

This is the **shared checklist for both phases** of the lifecycle: it is the
alignment-close sweep (`gr_algn.md` Aln6) and the review-time coverage check
(`gr_rev.md` Rev7 / Rev11). The same 8 classes run at grilling close, at
requirements, at a use-case spec, and at a domain model.

**`blocked` is the expected, valuable outcome — not a failure.** A sweep that
finds real gaps and reports `blocked` did its job. A `clean` verdict on a spec
that has genuine gaps is the only true failure. Do not optimise for a clean
verdict; optimise for finding what was missed. Never downgrade a real gap to
`not-applicable` to avoid a `blocked` result.

This skill writes nothing — it is a **pure report**. It surfaces gaps and names
concrete follow-ups; it does not author the FR/NFR, add the alt-flow, or enact
the deferral. The human (or a sibling skill — `domain-requirements` for a new
FR/NFR, `use-case-spec` for an alt-flow, `pareto-scope-cut` for a deferral) acts
on the follow-ups. A `blocked` verdict signals to the human that the artifact is
not yet complete; the human resolves the listed gaps and re-runs the sweep.

## Instructions

1. **Resolve the input.** The target is the requirements doc, use-case spec,
   domain/entity model, *or a PRD draft* (the pre-publish `spec-to-prd` Phase-4
   projection — provided as in-session/inline content, not necessarily a file on
   disk) the user names (or the one in context). If none is named, ask which
   artifact to sweep before proceeding.
2. **Resolve optional context.** If a glossary/context file is given as an arg,
   use it. Otherwise resolve in order: `docs/CONTEXT.md`, then `docs/glossary.md`.
   If neither exists, warn ("no glossary/context found; proceeding without term
   grounding") and continue — never hard-code a single context filename, never
   block on its absence.
3. **Read the artifact** (and context, if present).
4. **Track the 8 classes with TodoWrite.** Create one todo task per class (8
   tasks). This is the anti-skip mechanism — an omitted class shows as a visibly
   incomplete todo. Mark each complete only after it has a verdict with evidence.
5. **Examine all 8 classes — always, in order.** Do not skip a class because the
   spec "obviously" doesn't touch it; that judgment is exactly what this sweep
   exists to override. Assign each class one verdict per the **Verdicts** table
   below: `covered` (needs a pointer), `not-applicable` (needs a concrete-fact
   reason), or `missing` (needs a routed follow-up; blocks).
6. **Route every `missing` to a follow-up** per the **Routing** table below.
7. **Emit the per-class table** plus the follow-up list, then state the sweep
   verdict: `clean` (no missing) or `blocked` (one or more missing, listed).

### Pointer-class adaptation (stated, not silent)

Aln6's `covered` pointer cites "the relevant transcript entry or `context.md`
term" because it runs inside a live grilling session. This skill runs on a
**document**, so it re-maps that evidence to an artifact-resident pointer: an
FR/NFR id, section heading, use-case flow, or glossary term. This is a
deliberate step-agnostic adaptation, not a weakening of the verdict — the
evidence bar (a concrete pointer, no bare assertion) is identical.

### Quality bar on `not-applicable`

`not-applicable` is the loophole this sweep must close: on a document with no
human in the loop, a plausible-sounding reason can wave away any class. So a
`not-applicable` reason **must cite a concrete fact in the artifact or context**
— not a generic assertion. "Concurrency: N/A — single-user request" is too
generic; "Concurrency: N/A — FR-03 states the import is a one-shot CLI command
with no shared state" is grounded. If you cannot point to a concrete fact that
makes the class inapplicable, the class is `covered` or `missing`, not
`not-applicable`.

## DO NOT

- Skip or silently drop any of the 8 classes — examine all of them every run.
- Let the agent decide a class is irrelevant and omit it; downgrade to
  `not-applicable` **with a concrete-fact reason** instead.
- Record `covered` without a concrete pointer, or `not-applicable` with a
  generic assertion that cites no fact in the artifact/context.
- Downgrade a real gap to `not-applicable` to dodge a `blocked` verdict —
  `blocked` is the correct, useful result when gaps exist.
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

This table is the canonical definition of the three verdicts.

| Verdict | Meaning | Mandatory evidence | Effect |
|---------|---------|--------------------|--------|
| `covered` | Concern addressed in the spec | Pointer: FR/NFR id, section, flow, or glossary term (no pointer ⇒ not `covered`) | Passes |
| `not-applicable` | Concern genuinely does not apply | Reason citing a **concrete fact** in the artifact/context (generic assertion ⇒ not allowed) | Passes |
| `missing` | Real gap | Routed follow-up (see Routing) | **Blocks** — sweep cannot report complete |

## Routing `missing` Classes

The follow-up *kind* varies by the stage being swept; the pointer/follow-up must
land in an artifact the next skill can act on.

| Follow-up type | When to use | Example at this stage |
|----------------|-------------|-----------------------|
| New FR | Missing behaviour the system must do. | requirements: "only the mailbox owner may delete a thread" |
| New NFR | Missing measurable quality. | requirements: a retention window or audit-log requirement |
| Use-case alternative flow | Missing branch in an existing use case. | use-case-spec: an unauthorized-access flow |
| New invariant / Constraints note | Missing rule the model must enforce. | domain-model: a Constraints line on the owning aggregate (e.g. "a Message cannot be both archived and pinned") |
| Deferral | Concern acknowledged but intentionally out of this iteration. | any stage: surface as a deferral candidate and hand to the scope-cut skill — do **not** enact the cut here |
| PRD-draft follow-up | Missing concern found while sweeping a PRD draft. | PRD-draft: route to a new FR/NFR in the spine (via `domain-requirements`) or a use-case alt-flow in the spine (via `usecase-spec`), **or** into the PRD's freshly-authored module/testing decisions — **NEVER** patched into the published PRD body (Doc5: the PRD restates nothing, it only links the spine). |

At the **domain-model** stage, a `covered` pointer is an entity name, an
attribute's Validation Rules cell, or an aggregate's Constraints note (rather
than an FR/NFR id), and a `missing` follow-up is a new invariant/Constraints
note (rather than an FR or alt-flow).

At the **PRD-draft** stage, a `covered` pointer is a linked spine id (an
`FR/NFR/UC` id the PRD already carries) or the PRD's module/testing-decision
subsection (rather than a raw FR/NFR id authored into the PRD), and a `missing`
follow-up routes to the spine (a new FR/NFR via `domain-requirements`, or a
use-case alt-flow via `usecase-spec`) or into the PRD's freshly-authored
module/testing decisions — never into the published PRD body (Doc5: the PRD
restates nothing).

## Output Format

```markdown
## Hidden-Constraint Sweep — <artifact name>

Context source: <resolved context file | "none — proceeded without grounding">

| # | Class | Verdict | Pointer / Reason / Follow-up |
|---|-------|---------|------------------------------|
| 1 | Security / PII | covered | NFR-04 (encryption at rest) |
| 2 | Permissions / authorization | missing | New FR: only the mailbox owner may delete a thread |
| 3 | Data retention | not-applicable | Section 2 states no data is persisted; the request is stateless |
| 4 | Migrations | not-applicable | Section 1 declares a greenfield system; no existing schema |
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

When this sweep feeds a `gr_rev.md` Rev11 review block, map the sweep verdict
onto the Rev11 verdict vocabulary: `clean` → **approve** (or
**approve-with-comments** when a `not-applicable` rests on a borderline judgment
call), and `blocked` → **request-changes** (or **block** when a `missing` class
is a hard safety gap, e.g. Security/PII or Permissions). The per-class table is
already in the shape Rev11's "Hidden-constraint coverage" line requires.

## Notes

- **Step-agnostic.** This is the same checklist whether run at alignment close,
  on a requirements doc, on a use-case spec, on a domain model, or on a PRD
  draft (the pre-publish `spec-to-prd` Phase-4 projection — in-session/inline
  content, not necessarily a file on disk). Only the kind of pointer/follow-up
  varies (FR/NFR at requirements, alt-flow at use-case, invariant/Constraints at
  domain-model, and at the PRD-draft stage a linked `FR/NFR/UC` id or the
  module/testing-decision subsection — see Routing).
- **Source rules.** `gr_algn.md` Aln6 — the alignment-close sweep: fires always
  at close, the three outcomes, `missing` blocks close, "no silent passes, no
  'documented gap' closes." `gr_rev.md` Rev7 / Rev11 — the review-side mirror:
  Rev7's "a 'not applicable' verdict is stated, not assumed" is the concrete-fact
  bar above; Rev11 is the reviewer output format this table feeds. (`gr_algn.md`:
  "Aln6 feeds gr_rev.md Rev7 — what was checked during grilling becomes the
  review checklist.")
- **Reconciliation (8 vs 7 classes).** Aln6 enumerates **8** classes (the set
  used here, including out-of-scope and counting retention and migrations
  separately). Rev7 lists **7** — it omits out-of-scope and pairs
  retention+migrations on one line. This skill follows the Aln6 8-class set; the
  difference is presentational, not a conflict in intent.
