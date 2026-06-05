---
name: usecase-spec
description: >
  Creates or updates per-use-case specification documents (docs/use_cases/*.md)
  with actors, preconditions, main and alternative scenarios, postconditions, and
  business rules — and enforces that every in-scope functional requirement is
  covered by at least one spec (fail-closed). Each spec carries an explicit
  "Requirements covered (FR-###)" trace line. Use when the user asks to "write a
  use case", "specify a use case", "document system behavior", "define
  scenarios", "write a functional spec", "check use-case coverage", or mentions
  use case specification, acceptance criteria, or user scenarios.
---

# Use Case Specification (coverage-guaranteed fork)

A fork of the stock AIUP `use-case-spec` skill. It writes the same per-use-case
documents, but adds two guarantees stock spec lacks:

1. **A trace line.** Each spec records `Requirements covered (FR-###)` in its
   Overview — establishing the UC→FR trace convention that `trace-check` Check A
   is gated on (without it, Check A can only report "no trace convention found").
2. **A fail-closed reverse-coverage gate.** Every *in-scope* functional
   requirement must be cited by at least one spec — as a covered-requirement, a
   main/alternative flow step, or a business rule. An in-scope FR cited nowhere
   is a coverage gap that blocks completion. This is the FR→UC direction that no
   downstream lens can add after the fact.

It **consumes** the glossary (actors verbatim) and the entity model (to ground
business rules in invariants); it does **not** enforce the glossary, cut scope,
or author invariants/entities — those stay `ubiquitous-language-guard`,
`pareto-scope-cut`, and `domain-model`.

## Inputs

1. **Requirements catalog** (default `docs/requirements.md`) — the FR catalog and
   any Scope split / Status column. **Required**; if absent, STOP.
2. **Use case diagram** (default `docs/use_cases.puml`) — the use-case set and the
   FR id(s) each use case carries. If absent, **warn** and derive the use cases
   from the in-scope FR set.
3. **Scope marker** (optional argument) — resolve the **in-scope FR set** as in
   `usecase-diag` (Scope split / Status; non-`Deferred` otherwise). Never
   hard-code milestone names; **ask** if scope is ambiguous.
4. **Entity model** (optional, default `docs/entity_model.md`) — each business
   rule should correspond to a domain-model **invariant**; cite it. If the model
   lacks it, **flag** the missing/contradicting invariant — do **not** invent it
   (that is `domain-model`'s job).
5. **Glossary** (optional argument), resolved by a fallback chain — never a
   hard-coded filename: explicit path → `docs/CONTEXT.md` → `docs/glossary.md` →
   none found: **warn and continue**. Actors and domain terms used **verbatim**
   (L1, read side only).
6. **`$ARGUMENTS`** — the specific use case(s) to (re)write; default to **all**
   use cases in the diagram.

## DO NOT

- Do NOT write vague or incomplete scenarios; do NOT skip numbering steps in the
  Main Success Scenario; do NOT omit alternative flows for error conditions; do
  NOT leave postconditions undefined; do NOT mix multiple use cases in one
  document; do NOT use implementation details in flow steps. *(stock rules)*
- Do NOT omit the `Requirements covered (FR-###)` line — it is the trace
  convention downstream skills read.
- Do NOT finish with an in-scope FR cited by no spec — the reverse-coverage gate
  is fail-closed.
- Do NOT invent actors (glossary verbatim; flag unknowns) or pull in deferred /
  out-of-scope FRs.
- Do NOT author or rename domain invariants/entities (that is `domain-model`);
  only **cite** an existing invariant or **flag** a missing one.

## Template

Use the stock `use-case.md` structure — **Overview** (Use Case ID, Use Case
Name, Primary Actor, Goal, Status) extended with a **`Requirements covered:`**
line, then **Preconditions**, **Main Success Scenario** (numbered),
**Alternative Flows** (triggered, for error / optional / exceptional paths),
**Postconditions** (success + failure), and **Business Rules** (`BR-###`).

```markdown
# Use Case: <Name>

## Overview
**Use Case ID:** UC-001
**Use Case Name:** <Name>
**Primary Actor:** <glossary actor, verbatim>
**Goal:** <user goal>
**Status:** Draft
**Requirements covered:** FR-00X, FR-00Y

## Preconditions
- …

## Main Success Scenario
1. …

## Alternative Flows
### A1: <name>
**Trigger:** … (step N)
**Flow:** …

## Postconditions
### Success Postconditions
- …
### Failure Postconditions
- …

## Business Rules
### BR-001: <name>
<rule> — enforces domain-model invariant <name> (or: **FLAG** — no invariant in entity_model).
```

## Reverse-coverage gate (the fork's job)

After the specs are written, build the **FR → spec coverage map**: every
in-scope FR must appear in at least one spec's `Requirements covered` line, flow
step, or business rule. Deferred / out-of-scope FRs are excluded. Any in-scope
FR cited nowhere is a **coverage gap** — surface it and do **not** report the
spec set complete. (Fine-grained FRs marked *spec-level* by `usecase-diag` are
satisfied here as alternative flows or business rules.)

## Workflow

1. **Resolve inputs** and the in-scope FR set (ask if ambiguous); state the files
   and scope marker used.
2. **For each target use case**, write: Overview (with `Requirements covered`),
   preconditions, the numbered Main Success Scenario, alternative flows (error /
   optional / exceptional), postconditions (success + failure), and business
   rules.
3. **Ground each business rule** in a domain-model invariant — cite it, or
   **flag** a missing / contradicting invariant for `domain-model` /
   `trace-check`. Do not author it here.
4. **Build the FR → spec coverage map**; resolve every in-scope FR (via a
   covered-line, a flow step, or a BR).
5. **Validate (fail-closed):**
   - every in-scope FR is cited by ≥1 spec (no coverage gap);
   - every spec carries `Requirements covered` with FR ids that **exist** in the
     catalog (no dangling reference);
   - exactly one use case per file; actors appear in the glossary verbatim (flag
     unknowns); no deferred / out-of-scope FR pulled in;
   - each business rule cites an invariant or is flagged.
6. **Output** the specs and the coverage map; list any gaps or flags that block
   completion.

## Coverage map template

```markdown
## FR → spec coverage (against <scope marker>)

| In-scope FR | Covered by spec (file)     | via (covered-line / flow step / BR) | Status   |
|-------------|----------------------------|-------------------------------------|----------|
| FR-00X      | docs/use_cases/uc-001.md   | Requirements covered                | covered  |
| FR-00Y      | docs/use_cases/uc-001.md   | A2 alternative flow                 | covered  |
| FR-00Z      | —                          | —                                   | **GAP**  |
```
