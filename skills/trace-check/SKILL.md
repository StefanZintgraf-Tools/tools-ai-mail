---
name: trace-check
description: >
  Verifies cross-artifact consistency and traceability across AIUP artifacts:
  every use case traces to at least one functional requirement, every entity
  named in a spec exists in the entity model, every actor matches the glossary
  verbatim, and every business rule (BR-###) maps to a domain-model invariant.
  Use when the user asks to "trace check", "check traceability", "verify
  consistency", "find traceability gaps", "check UC to FR coverage", "audit
  cross-artifact consistency", "find orphan use cases", "check that entities
  exist in the entity model", "verify actors against the glossary", "check
  business rules map to invariants", or whenever requirements, use case
  diagram, use-case specs, and entity model may have drifted apart. Produces a
  consistency report (pass / list of breaks) and HITL-fixes the offending
  artifact only with explicit human approval. Step-agnostic: usable at
  use-case-diagram, use-case-spec, or any time artifacts drift.
---

# Trace Check

A cross-cutting lens that protects traceability: every downstream artifact must
trace back to something upstream, and every cross-reference must resolve. This
skill reads the AIUP artifact set, runs four consistency checks, produces a
single consistency report (pass or a list of breaks), and — only with explicit
human approval — loops a fix back into the offending artifact. It does NOT
author requirements, model entities, maintain the glossary, gate ADRs, or cut
scope; those are other skills.

## Inputs

1. **Requirements** (default `docs/requirements.md`) — the functional
   requirement (FR) catalog that use cases must trace to. Accept an override
   path.
2. **Use case diagram** (default `docs/use_cases.puml`) — the PlantUML diagram
   declaring actors and use cases. Accept an override path.
3. **Use-case specs** (default `docs/use_cases/*.md`) — per-use-case
   specification documents containing actors, scenarios, named entities, and
   business rules (BR-###). Accept an override glob.
4. **Entity model** (default `docs/entity_model.md`) — the domain model with
   entities and their invariants/validation rules. Accept an override path.
5. **Glossary** (optional argument) — path to the project's ubiquitous-language
   file. Resolve in this order:
   1. The explicit path the user passed, if any.
   2. `docs/CONTEXT.md`
   3. `docs/glossary.md`
   4. If none exists: **warn the user** that no glossary was found and proceed
      in report-only mode for the actor check (Check C) — you can still flag
      actors that are inconsistent across artifacts, but verbatim glossary
      matching is limited without a glossary.

   NEVER hard-code a single glossary filename — always run the fallback chain.

If any non-glossary input is missing, **warn** and run whichever checks the
available artifacts allow (the skill is step-agnostic and must not crash on a
not-yet-created artifact). Report which checks were skipped and why.

## Instructions

Read every available artifact first, then run the four checks below in order,
accumulating findings into a single **consistency report**. Do not write any fix
until the HITL gate is satisfied.

### Check A — Every UC traces to ≥1 FR

Enumerate every use case (from the use case diagram and/or the use-case specs).
For each use case, confirm it traces to **at least one** functional requirement
in the requirements catalog. A trace is an explicit reference — an FR id (e.g.
`FR-012`) cited in the spec, a `Requirements:` / `Traces to:` line, or a
documented mapping. A use case that traces to **zero** FRs is an **orphan
use case** — flag it. Also note any FR ids cited by a use case that do **not**
exist in the requirements catalog (dangling FR reference).

### Check B — Every entity named in a spec exists in the entity model

Extract every domain entity named in the use-case specs (and, where relevant,
in the requirements). For each, confirm an entity of that name exists in the
entity model (`docs/entity_model.md` by default). A named entity with **no**
corresponding entry in the entity model is a **missing entity** — flag it with
the spec location that names it. Match on the canonical entity name; near-name
mismatches (singular/plural, casing) are breaks, not silent passes — list them.

### Check C — Every actor matches the glossary (L1)

Apply `gr_domain_language` rule **L1 — use defined terms exactly**. Collect
every actor named in the use case diagram and use-case specs. For each actor,
confirm the name appears **verbatim** in the glossary (the resolved glossary
file). Flag any actor that is a casual variation, abbreviation, pluralization
drift, casing change, or translation of a glossary term, and name the canonical
form. Flag any actor that has no glossary entry at all as an unknown actor
(propose adding it via the glossary skill — do NOT add it here). If no glossary
was resolved, report this check as report-only and cross-check actor names for
consistency **across** the diagram and specs instead.

### Check D — Every business rule (BR-###) maps to a domain-model invariant

Enumerate every business rule (ids of the form `BR-###`) across the use-case
specs. For each BR, confirm it maps to a **domain-model invariant** in the
entity model — a validation rule, constraint, or multi-column constraint that
enforces the same rule. A `BR-###` with **no** corresponding invariant is an
**unenforced business rule** — flag it with the rule text and the entity it
should constrain. Also note any entity-model invariant that contradicts a BR
(conflict), and any duplicate/contradictory BR ids.

## DO NOT

- Do NOT author or edit requirements, FRs, or NFRs (that is `requirements`).
- Do NOT model entities, define attributes, or draw ER diagrams (that is
  `entity-model` / `domain-model`).
- Do NOT add, define, or rename glossary terms (that is the ubiquitous-language
  skill) — propose, do not write, glossary changes.
- Do NOT gate or author ADRs, and do NOT cut or prioritize scope.
- Do NOT hard-code a single glossary filename — always run the resolution
  fallback chain.
- Do NOT write any fix into an artifact without explicit per-change human
  approval (see HITL gate).
- Do NOT silently invent traces, rename entities/actors, or "fix" a break by
  guessing — flag it and let the human decide.
- Do NOT crash or stop when an input artifact is missing — warn, skip the
  affected check, and continue.
- Do NOT bake any one project's domain specifics into your judgments — apply the
  checks generically.

## Workflow

1. **Resolve inputs.** Resolve each artifact path (defaults above, honoring any
   overrides). Resolve the glossary via the fallback chain
   (passed path → `docs/CONTEXT.md` → `docs/glossary.md` → warn). State which
   files you are using and which are missing.
2. **Read all available artifacts.** Extract: FR ids from requirements; actors
   and use cases from the diagram; per-spec actors, named entities, and BR-###
   rules; entity names and invariants from the entity model; canonical terms
   from the glossary.
3. **Run the four checks**, accumulating findings into the consistency report:
   - A — every UC traces to ≥1 FR (flag orphan UCs + dangling FR refs).
   - B — every spec-named entity exists in the entity model (flag missing).
   - C — every actor matches the glossary verbatim, L1 (flag deviations /
     unknown actors).
   - D — every BR-### maps to a domain-model invariant (flag unenforced /
     conflicting).
4. **Assemble the consistency report.** If no break is found in any run check,
   report **PASS**. Otherwise list every break, grouped by check, with the
   offending artifact and location.
5. **HITL fix loop (gate).** For each break the human wants fixed: identify the
   **offending artifact** (the one that should change), show the **exact
   proposed change** (precise before/after diff or new line), and ask for
   explicit approval ("approve / edit / skip"). Apply only approved changes to
   that artifact, preserving its structure. Re-run the affected check to confirm
   the break is resolved. Never write without approval.
6. **Deliver.** Output the final consistency report and a summary of which
   breaks were fixed (and into which artifact) and which remain.

## Consistency Report Template

```markdown
# Trace Check — Consistency Report

Requirements: <path | MISSING>
Use case diagram: <path | MISSING>
Use-case specs: <glob → N files | MISSING>
Entity model: <path | MISSING>
Glossary: <resolved path | NONE (Check C report-only)>

Result: <PASS | BREAKS FOUND (N)>

## Check A — UC → ≥1 FR
| Use case | Traces to FR(s) | Status |
|----------|-----------------|--------|
<rows; orphan UCs and dangling FR refs flagged>

## Check B — Entity-in-spec → entity_model.md
| Entity named in spec | Spec location | In entity model? |
|----------------------|---------------|------------------|
<rows; missing entities flagged>

## Check C — Actor ↔ glossary (L1)
| Actor used | Source artifact | Canonical glossary term | Status |
|------------|-----------------|-------------------------|--------|
<rows; deviations and unknown actors flagged>

## Check D — BR-### → domain-model invariant
| BR id | Rule (short) | Mapped invariant in entity model | Status |
|-------|--------------|----------------------------------|--------|
<rows; unenforced and conflicting BRs flagged>

## Proposed fixes (await per-change approval)
- <offending artifact> — <before/after diff or new line>
```
