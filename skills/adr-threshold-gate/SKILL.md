---
name: adr-threshold-gate
description: >
  Scans any artifact (pre or post: a plan, requirements doc, entity model,
  use-case spec, diff, or design note) for decisions that cross the
  Architectural Decision Record threshold, then drafts and human-gates ADRs.
  Use when the user asks to "check for ADR-worthy decisions", "gate this for
  ADRs", "should this be an ADR", "draft an ADR", "find architectural
  decisions", "ADR threshold check", "review for missing ADRs", or whenever a
  design choice smells hard-to-reverse, surprising, or trade-off-heavy and you
  need to decide whether to capture it as a durable docs/adr record. Detects
  threshold-crossing decisions, asks the human "ADR-worthy?" per hit, drafts
  proposed ADRs in Context / Decision / Consequences / Alternatives form, and
  flips proposed to accepted only on explicit human approval. Step-agnostic.
---

# ADR Threshold Gate

Single responsibility: detect decisions that cross the ADR threshold, draft an
ADR for each qualifier, and gate every write and status change behind explicit
human approval. This skill does NOT model entities, maintain the glossary, cut
scope, or sweep constraints — it only finds threshold-crossing decisions and
drafts/gates ADRs.

## Instructions

Given any artifact (pre-decision plan or post-decision diff/doc) plus the
existing `docs/adr/*` files:

1. Read the artifact and extract every distinct **design decision** in it — a
   choice of direction with downstream consequences, not a routine style or
   wording choice.
2. Apply the **three-part AND threshold** (below) to each decision.
3. For each decision that crosses the threshold, run the **HITL "ADR-worthy?"**
   ask, naming all three criteria, before drafting anything.
4. For each approved qualifier, draft a `proposed` ADR using the required
   section template and present it; write the file only after explicit human
   approval.
5. For each decision that does NOT cross the threshold, emit a one-line
   "no-ADR, why" note (which of the three criteria failed). Do not write a file.

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

proposed

## Context

<What forces are in play; what constraint led to needing this decision.>

## Decision

<The chosen direction, stated imperatively.>

## Consequences

<What becomes easier, harder, or impossible; observable downstream effects.>

## Alternatives

<At least one rejected alternative with a one-line reason it lost. Without this,
the trade-off claim is unverifiable.>
```

Keep it short — typically under one page. A draft missing **Alternatives** is
invalid (the trade-off claim becomes unverifiable).

## Output

- One new `docs/adr/NNNN-<kebab-slug>.md` file with `Status: proposed` per
  qualifying decision (after human approval to write).
- One-line "no-ADR, why" note per sub-threshold decision — naming the failed
  criterion. No file is written for these.

## DO NOT

- Write an ADR file before the human approves the draft.
- Flip `proposed` → `accepted` yourself. That status change is **human-only**;
  do it only on explicit human acceptance. Silent commits of `accepted` ADRs are
  forbidden.
- Draft an ADR for an interchangeable choice, an easily-reversible refactor, or
  a routine style choice (a criterion failed → no ADR).
- Draft an ADR without an `Alternatives` section.
- Number ADRs by date (`2026-05-21-foo.md`). Use a zero-padded monotonic
  integer (`0001`, `0002`, …).
- Model entities, edit the glossary/context doc, cut scope, or sweep
  constraints — that is out of this skill's responsibility.
- Edit an already-`accepted` ADR's body. (Supersession, not mutation, is the
  rule for reversing a decision — out of scope here.)

## Numbering

Derive the next `NNNN` by scanning existing `docs/adr/*` for the highest
zero-padded integer prefix and adding one. If `docs/adr/` is empty or absent,
start at `0001`. Build a `<kebab-slug>` from the decision's one-line summary, so
the filename is greppable.

## Workflow

1. Read the input artifact and list `docs/adr/*` (note the next free `NNNN`).
2. Extract each distinct design decision from the artifact.
3. For each decision, apply the three-part AND threshold (table above).
4. For each threshold-crossing decision:
   a. Run the HITL "ADR-worthy?" ask, naming all three criteria.
   b. If the human says no → record a one-line "no-ADR, why" note; stop for this
      decision.
   c. If yes → draft a `proposed` ADR using the required template, assign the
      next `NNNN`, and present the full draft to the human.
   d. Get explicit approval to write. Only then write
      `docs/adr/NNNN-<kebab-slug>.md` with `Status: proposed`. Increment `NNNN`
      for the next qualifier.
5. For each sub-threshold decision, record the one-line "no-ADR, why" note
   naming the failed criterion. Write no file.
6. Leave every new ADR at `proposed`. Do NOT flip to `accepted` — that is a
   human-only action taken on explicit acceptance (never silently).
7. Report: the ADR files written (paths, all `proposed`), and the list of
   no-ADR notes with reasons.
