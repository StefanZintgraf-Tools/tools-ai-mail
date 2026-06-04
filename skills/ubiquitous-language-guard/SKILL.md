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
   file. Resolve in this order, taking the first that exists (match the filename
   case-insensitively):
   1. The explicit path the user passed, if any.
   2. `docs/CONTEXT.md`.
   3. `docs/glossary.md`.
   4. If none exists: **warn the user** that no glossary was found and drop to
      **report-only mode** — run **L4 only** (storage-shaped names need no
      glossary). L1, L2, L6, and L8 write-back cannot run without a glossary;
      say so explicitly and recommend creating `docs/CONTEXT.md`.

   NEVER hard-code a single glossary filename — always run the resolution chain
   above (`docs/CONTEXT.md` → `docs/glossary.md`).

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
"synonyms to avoid" / "do not use" entries) and flag any forbidden synonym that
appears in the artifact for the same concept, naming the canonical term that
should replace it.

**If the glossary has no `_Avoid_` list (the common case), do not stop — fall
back to judgment.** Scan for plausible synonyms of canonical terms used for the
same concept (the classic cases: `User`/`Customer`/`Account`,
`Purchase`/`Transaction`/`Order`, `Cancel`/`Void`, `Delete`/`Remove`) and flag
them as *candidate* synonyms for human confirmation. A never-flag-when-empty L2
that reports a clean table is a false negative; an empty `_Avoid_` list means
"use judgment," not "nothing to check." A synonym is acceptable only if the
glossary defines it as a **different** concept — then do not flag, note the
distinction.

### L3 — Separate domain terms from technical terms (layer-aware)

A domain concept (`Invoice`) must not be named after a technical artifact
(`InvoiceDTO`, `InvoiceRow`) **in the domain layer**. Technical suffixes belong
to technical layers only. Because this skill audits conceptual AIUP artifacts
(requirements, domain model, use cases) — which are domain-layer by nature — a
technical-suffixed name appearing in them is a violation; flag it and propose
the plain domain name. Do **not** flag a name that the artifact explicitly
scopes to a technical/infrastructure layer (e.g. a persistence note that names
`InvoiceRow` as the storage representation) — that is legitimate per L3.

### L4 — Naming reflects behavior, not storage

Flag names that describe how a concept is stored or transported rather than what
it means in the domain. Storage/transport-shaped smells include suffixes and
fragments such as `Table`, `Row`, `Record`, `DTO`, `Entity` (as a suffix),
`Blob`, `Json`, `Payload`, `Flag`, `Col`, `Field`, `Tbl`, and the like, when
used as the domain name itself. Propose the behavior-oriented domain name
instead. (L4 is the one check that runs without a glossary.)

### L6 — Introduce new terms explicitly (no silent invention)

Identify every **domain-significant** term in the artifact that is **not** in
the glossary. A term is domain-significant if it is any of:

- an **actor / role** (a human or system that initiates or receives an action);
- an **entity or aggregate** (a thing the domain tracks);
- a **status / state value** (e.g. `Pending`, `Archived`);
- a **domain operation / event** (e.g. `Reconcile`, `OrderShipped`); or
- a **capitalized or multi-word domain noun** that carries business meaning.

Exclude generic English, common verbs, and infrastructure/tech vocabulary.
For each domain-significant term not in the glossary, do not silently accept it
and do not silently rename it: either (a) propose a definition to add to the
glossary, or (b) route it through the near-match gate below if it looks like an
existing term.

### Near-match gate — HALT and ask: same / refinement / new

When a candidate term is a **lexical or semantic near-match** to an existing
glossary term (e.g. `Customer` vs `Client`, `Cancel` vs `Void`, `Shipment` vs
`Delivery`), do not guess. **Halt and ask the human** to classify it as exactly
one of:

- **same** — it is the existing term; replace the artifact usage with the
  canonical term. **Record this as an L1/L2 fix and add the row to the L1
  (verbatim) or L2 (synonym) report table** — do not leave it only in the
  near-match log, or the report under-counts.
- **refinement** — it sharpens or narrows the existing term; update the existing
  glossary definition (a change, not an addition). Note that a refinement is a
  rename of meaning and may need to propagate (rule L5) — surface this to the
  human.
- **new** — it is a genuinely distinct concept; add a new glossary entry, and
  (per L7) note the boundary against the term it resembles.

**Batch the gate.** Collect all near-matches first and present them as one
numbered list with the three options each, so the human answers in a single
pass rather than one interrupt per term. **Non-interactive / AFK runs:** if no
human is available to answer, do **not** guess — record every unresolved
near-match as `decision: UNRESOLVED — needs human` in the report, make no
glossary change for it, and surface the list for a later interactive pass.

### L7 — Match language across bounded contexts deliberately

The same word may legitimately mean different things in different bounded
contexts; never unify them by accident. This skill audits an artifact against a
single glossary (`docs/CONTEXT.md`, fallback `docs/glossary.md`). If that
glossary defines a term in more than one bounded context, audit the artifact
against the context it belongs to, and flag any term that collides with a
same-spelled term defined for *another* context as a cross-context collision —
do not merge the definitions. The near-match gate covers intra-context
look-alikes; this rule covers the same-word-different-context case.

### L8 — HITL write-back to the glossary

The glossary (`docs/CONTEXT.md`, fallback `docs/glossary.md`) is the durable source of truth for terms; this skill
may update it — but **only after explicit human approval**. New and refined
terms confirmed at the near-match gate (and any vocabulary that surfaced during
greenfield work) flow here so the glossary stays current and does not drift.

- Collect all proposed glossary changes (new entries, refined definitions,
  added `_Avoid_` synonyms) from the checks above.
- For each, **show the exact proposed text** — the full entry or the precise
  before/after diff of an existing entry.
- **Ask for explicit approval** ("approve / edit / skip") for each proposed
  change. Do NOT write anything the human has not approved verbatim.
- Apply only approved changes to the resolved glossary file. Preserve its
  existing structure and ordering.
- If no glossary file exists, you cannot write back — report the proposed
  entries and recommend creating `docs/CONTEXT.md` first.

### L9 — CLAUDE.md still points at the glossary

**Only when a glossary (`docs/CONTEXT.md` / `docs/glossary.md`) exists**, verify the
project's `CLAUDE.md` (or equivalent agent-instruction file) contains an
explicit pointer to the resolved glossary path with the canonical one-line role
description:

> Domain glossary; read before any planning or implementation; update in-session when terms emerge or shift.

If the pointer is missing, outdated, or points at the wrong path, flag it in the
report and propose the corrected pointer line. Do not edit CLAUDE.md as part of
this skill's auto-write — surface the fix and let the human apply it (CLAUDE.md
ownership belongs to the human / project setup). Skip the L9 check entirely on
projects that legitimately have no glossary.

## DO NOT

- Do NOT model entities, define attributes, or draw ER diagrams (that is
  `domain-model` / `entity-model`).
- Do NOT cut scope or prioritize features (that is `pareto-scope-cut`).
- Do NOT gate or author ADRs (that is `adr-threshold-gate`).
- Do NOT hard-code a single glossary filename — always run the resolution
  fallback chain (`docs/CONTEXT.md` → `docs/glossary.md`).
- Do NOT report an empty L2 table as "clean" when there is no `_Avoid_` list —
  fall back to judgment.
- Do NOT write to the glossary without explicit per-change human approval.
- Do NOT silently rename, invent, or unify terms; do NOT guess a near-match
  classification when no human is available — mark it UNRESOLVED.
- Do NOT auto-edit CLAUDE.md; propose the pointer fix instead.
- Do NOT bake any one project's specifics into your judgments — apply the rules
  generically.

## Workflow

1. **Resolve inputs.** Identify the target artifact. Resolve the glossary via
   the Inputs resolution chain (`docs/CONTEXT.md` → `docs/glossary.md` →
   report-only). State which glossary you are using (or that none was found and
   you are in report-only / L4-only mode).
2. **Read both.** Read the artifact and the glossary. Extract the canonical
   term list and any `_Avoid_` / synonym lists from the glossary.
3. **Run checks L1–L7 in order**, accumulating findings into the term-diff
   report. (The per-check definitions above are authoritative — do not restate
   them here.)
4. **Near-match gate.** Batch all near-matches and ask the human
   same / refinement / new in one pass; record each decision and fold
   `same`-decisions into the L1/L2 tables. Mark unresolved ones in AFK runs.
5. **Assemble the term-diff report** using the template below.
6. **HITL write-back (L8).** Show each proposed glossary change as exact text /
   diff. Get explicit approval per change. Apply only approved changes to the
   resolved glossary file.
7. **CLAUDE.md pointer check (L9).** Only if a glossary exists: confirm
   `CLAUDE.md` points at it with path + the canonical role line; otherwise
   propose the corrected pointer in the report (do not auto-edit).
8. **Deliver the report.** Output the term-diff report and a summary of what was
   written back (or that nothing was, and why).

## Term-Diff Report Template

```markdown
# Ubiquitous Language Guard — Term-Diff Report

Artifact: <path>
Glossary: <resolved path | NONE (report-only, L4 only)>
Bounded context: <name | single>

## L1 — Verbatim violations
| Artifact usage | Canonical term | Location |
|----------------|----------------|----------|

## L2 — Forbidden / candidate synonyms
| Synonym used | Canonical term | Source (_Avoid_ list / judgment) | Location |
|--------------|----------------|----------------------------------|----------|

## L3 — Technical names in the domain layer
| Name used | Why it is technical-shaped | Proposed domain name |
|-----------|----------------------------|----------------------|

## L4 — Storage-shaped names
| Name used | Why it is storage-shaped | Proposed domain name |
|-----------|--------------------------|----------------------|

## L6 — New / unknown terms
| Term | Why domain-significant | Proposed disposition |
|------|------------------------|----------------------|

## L7 — Cross-context collisions
| Term | This context's meaning | Other context's meaning |
|------|------------------------|-------------------------|

## Near-match decisions
| Candidate | Resembles | Decision (same/refinement/new/UNRESOLVED) |
|-----------|-----------|-------------------------------------------|

## Proposed glossary changes (await approval)
- <new entry text OR before/after diff>

## L9 — CLAUDE.md pointer
Status: <present & correct | missing | wrong path | N/A (no glossary)>
Proposed pointer line (if needed): <path — "Domain glossary; read before any planning or implementation; update in-session when terms emerge or shift">
```
