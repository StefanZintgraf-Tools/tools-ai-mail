---
name: adr-threshold-gate
description: >
  Scans any artifact (pre or post: a plan, requirements doc, entity model,
  use-case spec, PRD / milestone PRD draft, diff, or design note) for decisions
  that cross the Architectural Decision Record threshold, then drafts and
  human-gates ADRs.
  Use when the user asks to "check for ADR-worthy decisions", "gate this for
  ADRs", "should this be an ADR", "draft an ADR", "find architectural
  decisions", "ADR threshold check", "review for missing ADRs", or whenever a
  design choice smells hard-to-reverse, surprising, or trade-off-heavy and you
  need to decide whether to capture it as a durable docs/adr record. Detects
  threshold-crossing decisions, asks the human "ADR-worthy?" per hit, drafts
  proposed ADRs in Context / Decision / Consequences / Alternatives Considered
  form, and flips proposed to accepted only on explicit human approval.
  Step-agnostic.
---

# ADR Threshold Gate

A cross-cutting lens that protects the *why* of decisions. Single responsibility:
detect decisions that cross the ADR threshold, draft one `proposed` ADR per qualifier,
and gate every write and status change behind explicit human approval. It captures
the **rationale** of a crossing decision — it does NOT model entities, maintain the
glossary, cut scope, or sweep constraints (those are sibling skills).

## Inputs

1. **The artifact** under review (required) — any one pre-decision artifact (a plan,
   `requirements.md`, an entity model, a `use_cases/*.md` spec, a PRD / milestone PRD
   draft, a design note) or post-decision artifact (a diff). Named by the user or the
   file in focus. If no artifact is named, ask which one to gate before proceeding — do
   not guess.
2. **`docs/adr/*`** (read for numbering *and* coverage) — the existing ADR files,
   scanned to (a) derive the next zero-padded monotonic `NNNN` and (b) skip decisions
   an existing ADR already covers (Adr10 dedup). If `docs/adr/` is empty or absent,
   numbering starts at `0001` and nothing is already covered.

## Procedure

1. **Resolve inputs** — read the artifact; list `docs/adr/*` (note the next free `NNNN`
   and read enough of each existing ADR to know what decision it already captures).
2. **Extract every distinct design decision** — a choice of direction with downstream
   consequences, not a routine style or wording choice. **Granularity:** treat one
   decision as one *independently reversible* choice with its own rationale. Split a
   bundle into separate decisions when the parts could be reversed independently (e.g.
   "use Postgres" and "partition by tenant" are two); merge restatements of the same
   choice into one.
3. **Dedup against existing ADRs (Adr10)** — for each extracted decision, check whether
   an existing `docs/adr/*` already captures it. If so, skip it with a one-line
   "already captured: NNNN" note; do not re-draft.
4. **Apply the three-part AND threshold** (below) to each remaining decision.
5. **For each threshold-crossing decision**, run the HITL "ADR-worthy?" ask (below),
   naming all three criteria, before drafting anything.
   - On **yes** → draft a `proposed` ADR using the required template, assign the next
     `NNNN`, present the full draft, and get explicit approval to write. Only then write
     `docs/adr/NNNN-<kebab-slug>.md` at `Status: proposed`; increment `NNNN` for the next
     qualifier.
   - On **no** → record the one-line "no-ADR, why" note for that decision and stop.
6. **For each sub-threshold decision**, record a one-line "no-ADR, why" note naming the
   single failed criterion. Write no file.
7. **Leave every new ADR at `proposed`.** Do NOT flip to `accepted` — that is a
   human-only action, taken only on explicit acceptance, never silently.
8. **Report** — the ADR files written (paths, all `proposed`), the "already captured"
   skips, and the list of no-ADR notes with reasons.

## The Three-Part AND Threshold

Write an ADR **only when all three hold**. If any one fails, no ADR.

| # | Criterion | Test |
|---|-----------|------|
| 1 | **Hard to reverse** | Undoing it needs migration, a breaking change, or significant rework. |
| 2 | **Surprising without context** | A future reader (human or agent) would ask "why this way?" and not find the answer in the code or glossary/context doc. |
| 3 | **Real trade-off** | Alternatives were considered and have non-trivial consequences. |

Out of scope (do NOT draft an ADR): interchangeable choices ("library X over
equally good Y"), easily-reversible refactors, and routine style choices. ADR
noise dilutes signal.

## What an ADR Captures (and what it does not)

- **The chosen road, not the rejected one (Adr3).** An ADR documents the *chosen*
  non-obvious decision and its rationale. A rejected option is NOT its own ADR —
  rejected options live in the alignment transcript (Aln15) and appear only inside this
  ADR's **Alternatives Considered** section. When you see "we considered X but went with
  Y," the ADR is about Y; X is one line under Alternatives Considered.
- **The *why*, not the *what* (Adr4).** An ADR explains *why* a surprising choice was
  made. *What* was decided belongs in the PRD/plan. Do not draft a fat ADR that merely
  restates the decision — capture the forces and the trade-off, not a summary of scope.

## HITL "ADR-worthy?" Ask (per qualifying hit)

For each decision that crosses the threshold, ask the human before drafting,
naming all three criteria explicitly. Use this shape:

> Decision: `<one-line summary of the decision>`
> This appears ADR-worthy:
> - Hard to reverse — `<why>`
> - Surprising without context — `<why>`
> - Real trade-off — `<why, with the alternative(s) seen>`
>
> Is this ADR-worthy? (yes → I draft a proposed ADR / no → I record a one-line no-ADR note)

Only proceed to draft on an affirmative answer.

## ADR Draft Template (required sections, in order)

Every drafted ADR has these sections in this order:

```markdown
# NNNN. <one-line summary>

## Status

<!-- legal values: proposed | accepted | superseded by NNNN | deprecated.
     This skill only ever writes `proposed`; the rest are human-managed. -->
proposed

## Context

<What forces are in play; what constraint led to needing this decision.>

## Decision

<The chosen direction, stated imperatively — the *why*, not a restatement of scope.>

## Consequences

<What becomes easier, harder, or impossible; observable downstream effects.>

## Alternatives Considered

<At least one rejected alternative with a one-line reason it lost. Without this,
the trade-off claim is unverifiable.>
```

Keep it short — typically under one page. A draft missing **Alternatives Considered** is
invalid (the trade-off claim becomes unverifiable).

## Output

- One new `docs/adr/NNNN-<kebab-slug>.md` file at `Status: proposed` per qualifying
  decision (after human approval to write). The slug is built from the decision's
  one-line summary so the filename is greppable.
- One-line "already captured: NNNN" note per decision an existing ADR already covers
  (no file written).
- One-line "no-ADR, why" note per sub-threshold decision, naming the failed criterion
  (no file written).

## DO NOT

- Write an ADR file before the human approves the draft.
- Flip `proposed` → `accepted` yourself. That status change is **human-only**, done only
  on explicit acceptance. Silent commits of `accepted` ADRs are forbidden.
- Draft an ADR for a sub-threshold decision (interchangeable choice, easily-reversible
  refactor, routine style) or one an existing ADR already covers.
- Draft an ADR *about a rejected option* (Adr3) — the ADR is about the road taken; the
  rejected option goes under Alternatives Considered.
- Draft an ADR without an `Alternatives Considered` section.
- Number ADRs by date (`2026-05-21-foo.md`). Use a zero-padded monotonic integer
  (`0001`, `0002`, …).
- Delete or silently retire an ADR. ADRs are durable: an ADR persists as long as its
  decision is in force and is *superseded* (a new ADR + status flip on the original),
  never deleted (Adr2/Adr7). Supersession itself is out of this skill's scope.
- Edit an already-`accepted` ADR's body.
- Model entities, edit the glossary/context doc, cut scope, or sweep constraints — out
  of this skill's responsibility.

## Numbering

Derive the next `NNNN` by scanning existing `docs/adr/*` for the highest zero-padded
integer prefix and adding one. If `docs/adr/` is empty or absent, start at `0001`.
Build a `<kebab-slug>` from the decision's one-line summary so the filename is greppable.
