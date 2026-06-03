---
name: ubiquitous-language-guard
description: >
  Guards the ubiquitous language of any software project by auditing AIUP
  artifacts against the domain glossary. Use when the user asks to "check the
  ubiquitous language", "guard domain language", "audit terminology",
  "check the glossary", "review terms", "find forbidden synonyms", "catch
  invented terms", "enforce naming consistency", or wants to verify that a
  requirements doc, entity model, PlantUML use case diagram, or use-case spec
  uses canonical domain terms verbatim. Flags forbidden synonyms, storage-shaped
  names, and silently-invented terms; halts on near-matches to ask same /
  refinement / new; and writes human-approved term changes back into the
  glossary. Step-agnostic: works at requirements, domain-model,
  use-case-diagram, and use-case-spec stages.
---

# Ubiquitous Language Guard

A cross-cutting lens that protects meaning: the same concept must have exactly
one name everywhere — in requirements, models, diagrams, specs, code, and UI.
This skill audits a single AIUP artifact against the project glossary, produces
a term-diff report, and — only with explicit human approval — evolves the
glossary itself. It does NOT model entities, cut scope, or gate ADRs; those are
other skills.

## Inputs

1. **Artifact** (required) — the AIUP artifact under review: a requirements
   document, an entity model, a `*.puml` use case diagram, or a `use_cases/*.md`
   spec. The user names it or it is the file currently in focus.
2. **Glossary** (optional argument) — path to the project's ubiquitous-language
   file. Resolve in this order:
   1. The explicit path the user passed, if any.
   2. `docs/CONTEXT.md`
   3. `docs/glossary.md`
   4. If none exists: **warn the user** that no glossary was found, proceed in
      report-only mode (you can still flag storage-shaped and inconsistent
      names), and note that L8 write-back and L1 verbatim checks are limited
      without a glossary.

   NEVER hard-code a single glossary filename — always run the fallback chain.

## Instructions

Work through the checks below in order. Build a single **term-diff report** as
you go. Do not write to the glossary until the HITL gate (L8) is satisfied.

### L1 — Use defined terms exactly (verbatim)

For every domain term that appears in the glossary, confirm it appears in the
artifact **verbatim** wherever that concept is referenced. Flag any casual
variation, abbreviation, pluralization drift, casing change, or translation
(e.g. glossary says `Order` but artifact uses `order record`, `Orders table`,
`Ord`, or a localized word). List each deviation with the canonical form.

### L2 — No forbidden synonyms

For each glossary term, check its **`_Avoid_`** list (or equivalent
"synonyms to avoid" / "do not use" entries). If any forbidden synonym appears
in the artifact for the same concept, flag it and name the canonical term that
should replace it. A synonym is only acceptable if the glossary defines it as a
**different** concept — in that case, do not flag, but note the distinction.

### L4 — Naming reflects behavior, not storage

Flag names that describe how a concept is stored or transported rather than what
it means in the domain. Storage/transport-shaped smells include suffixes and
fragments such as `Table`, `Row`, `Record`, `DTO`, `Entity` (as a suffix),
`Blob`, `Json`, `Payload`, `Flag`, `Col`, `Field`, `Tbl`, and the like, when
used as the domain name itself. Propose the behavior-oriented domain name
instead.

### L6 — Introduce new terms explicitly (no silent invention)

Identify every domain-significant term in the artifact that is **not** in the
glossary. Do not silently accept it and do not silently rename it. For each,
either (a) propose a definition to add to the glossary, or (b) route it through
the near-match gate below if it looks like an existing term.

### Near-match gate — HALT and ask: same / refinement / new

When a candidate term is a **lexical or semantic near-match** to an existing
glossary term (e.g. `Customer` vs `Client`, `Cancel` vs `Void`, `Shipment` vs
`Delivery`), do not guess. **Halt and ask the human** to classify it as exactly
one of:

- **same** — it is the existing term; replace the artifact usage with the
  canonical term (an L1/L2 fix, no glossary change).
- **refinement** — it sharpens or narrows the existing term; update the existing
  glossary definition (a change, not an addition).
- **new** — it is a genuinely distinct concept; add a new glossary entry, and
  (per L7) note the boundary against the term it resembles.

Present the near-match, the existing term, and these three options. Wait for the
human's choice before proceeding for that term.

### G7 — Record initial vocabulary as it emerges

In greenfield work, terms surface continuously. Treat every newly confirmed
domain term as something to **record** in the glossary so the vocabulary does
not drift. New and refined terms accepted at the gate above feed the L8
write-back so the glossary stays current from the start.

### L8 — HITL write-back to the glossary

The glossary is the durable source of truth for terms; this skill is allowed to
update it — but **only after explicit human approval**.

- Collect all proposed glossary changes (new entries, refined definitions,
  added `_Avoid_` synonyms) from the checks above.
- For each, **show the exact proposed text** — the full entry or the precise
  before/after diff of an existing entry.
- **Ask for explicit approval** ("approve / edit / skip") for each proposed
  change. Do NOT write anything the human has not approved verbatim.
- Apply only approved changes to the resolved glossary file. Preserve its
  existing structure and ordering.
- If no glossary file exists, you cannot write back — report the proposed
  entries and recommend creating the glossary file first.

### L9 — CLAUDE.md still points at the glossary

After any glossary write (and as a final check even when nothing changed),
verify the project's `CLAUDE.md` (or equivalent agent-instruction file) contains
an explicit pointer to the resolved glossary path with a one-line role
description. If the pointer is missing, outdated, or points at the wrong path,
flag it in the report and propose the corrected pointer line. Do not edit
CLAUDE.md as part of this skill's auto-write — surface the fix and let the human
apply it (CLAUDE.md ownership belongs to the human / project setup).

## DO NOT

- Do NOT model entities, define attributes, or draw ER diagrams (that is
  `domain-model` / `entity-model`).
- Do NOT cut scope or prioritize features (that is `pareto-scope-cut`).
- Do NOT gate or author ADRs (that is `adr-threshold-gate`).
- Do NOT hard-code a single glossary filename — always run the resolution
  fallback chain.
- Do NOT write to the glossary without explicit per-change human approval.
- Do NOT silently rename, invent, or unify terms.
- Do NOT auto-edit CLAUDE.md; propose the pointer fix instead.
- Do NOT bake any one project's specifics into your judgments — apply the rules
  generically.

## Workflow

1. **Resolve inputs.** Identify the target artifact. Resolve the glossary via
   the fallback chain (passed path → `docs/CONTEXT.md` → `docs/glossary.md` →
   warn). State which glossary you are using (or that none was found).
2. **Read both.** Read the artifact and the glossary. Extract the canonical
   term list and any `_Avoid_` / synonym lists from the glossary.
3. **Run checks**, accumulating findings into the term-diff report:
   - L1 — every glossary term appears verbatim where used.
   - L2 — no forbidden `_Avoid_` synonyms appear.
   - L4 — no storage/transport-shaped domain names.
   - L6 — list domain-significant terms not in the glossary.
4. **Near-match gate.** For each near-match, HALT and ask the human:
   same / refinement / new. Record the decision.
5. **Assemble the term-diff report.** Sections: Verbatim violations (L1),
   Forbidden synonyms (L2), Storage-shaped names (L4), New / unknown terms (L6),
   Near-match decisions, Proposed glossary changes.
6. **HITL write-back (L8).** Show each proposed glossary change as exact text /
   diff. Get explicit approval per change. Apply only approved changes to the
   resolved glossary file.
7. **CLAUDE.md pointer check (L9).** Confirm `CLAUDE.md` points at the resolved
   glossary with path + one-line role. If not, propose the corrected pointer
   line in the report (do not auto-edit).
8. **Deliver the report.** Output the term-diff report and a summary of what was
   written back (or that nothing was, and why).

## Term-Diff Report Template

```markdown
# Ubiquitous Language Guard — Term-Diff Report

Artifact: <path>
Glossary: <resolved path | NONE (report-only)>

## L1 — Verbatim violations
| Artifact usage | Canonical term | Location |
|----------------|----------------|----------|

## L2 — Forbidden synonyms (_Avoid_)
| Synonym used | Canonical term | Location |
|--------------|----------------|----------|

## L4 — Storage-shaped names
| Name used | Why it is storage-shaped | Proposed domain name |
|-----------|--------------------------|----------------------|

## L6 — New / unknown terms
| Term | Domain-significant? | Proposed disposition |
|------|---------------------|----------------------|

## Near-match decisions
| Candidate | Resembles | Decision (same/refinement/new) |
|-----------|-----------|--------------------------------|

## Proposed glossary changes (await approval)
- <new entry text OR before/after diff>

## L9 — CLAUDE.md pointer
Status: <present & correct | missing | wrong path>
Proposed pointer line (if needed): <path — one-line role>
```
