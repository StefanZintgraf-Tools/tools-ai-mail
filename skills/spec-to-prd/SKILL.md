---
name: spec-to-prd
description: >
  Projects an existing spec spine (requirements, use cases, entity model,
  vision, ADRs, postponed-decisions log) onto the issue tracker as a THIN,
  milestone-scoped PRD — linking FR/UC/BR/ADR IDs and restating nothing,
  authoring fresh only the module decomposition and Testing Decisions. Falls
  back to codebase-driven authoring only for spine sections that are missing or
  thin (brownfield graceful degradation), making it a superset of the vanilla
  conversation-authoring to-prd. Use when the user wants to "create a PRD",
  "generate a PRD", "write a PRD", "publish a PRD to the tracker", "draft a
  milestone PRD", "make a thin PRD", "project the spec spine onto the tracker",
  "turn the requirements into a PRD", "publish a PRD with ready-for-agent", or
  "produce a PRD that links FR/UC IDs". One thin PRD per milestone.
---

# Spec to PRD

A **transform/projection** skill, not an origin. Where a project already carries
a spec spine (the requirements catalogue, use cases, entity model, vision, ADRs,
and a postponed-decisions log), the requirements artifact *is* that spine — not
the PRD. This skill projects the **in-scope** slice of that spine onto the issue
tracker as **one thin PRD per milestone**: it **links** the spine's stable IDs
(`FR-###` / `UC-###` / `BR-###` / `ADR-####` / `NFR-###`) and **restates none of
their content**, authoring fresh **only** the two things the spine genuinely
lacks — the **module decomposition** and the **Testing Decisions** section.

It is a **superset** of the vanilla conversation-authoring `to-prd`: for any
spine artifact that is **missing or thin** (typical in brownfield), it degrades
gracefully and falls back to codebase-driven authoring **for that section only**.

It does NOT author requirements, model entities, maintain the glossary, gate
ADRs, write the testing strategy, or slice issues — those are other skills. It
**consumes** the glossary verbatim (read side), **respects/flags** ADRs, and
honors the anti-duplication rule (`gr_documentation` **Doc5** — link to the
authoritative source, never copy it).

## Guardrail basis

- **`gr_documentation` Doc5** — no duplication of authoritative sources. The
  spine is authoritative; the PRD links its IDs and restates nothing.
- **`gr_domain_language` L1** — consume the glossary verbatim (read side only);
  use defined terms exactly in the freshly-authored prose. This skill never
  evolves or writes back to the glossary.
- **`gr_adr`** — respect ADRs in the area being touched; link them in
  Implementation Decisions. Surface any module/interface decision that crosses
  the ADR threshold via the `adr-threshold-gate` lens (this skill proposes, the
  gate drafts, the human accepts — never auto-author an ADR here).
- **AIUP-native traceability** — carry `FR/UC/BR/ADR` IDs onto the tracker so
  the published PRD stays linked to the in-repo spine (repo ↔ tracker chain).

## Inputs

### Scope marker (the milestone) — resolve in this order

1. **Argument** — an explicit scope marker (milestone) passed by the caller.
2. **The requirements doc's declared milestone / Status scope split** — if the
   requirements catalogue declares a single milestone, or its `Status` column
   delimits exactly one in-scope set (e.g. `Open` vs `Deferred`), use that.
3. **Ask the human** — only if **genuinely ambiguous** (multiple undelimited
   milestones with no scope split to disambiguate). Do not interrogate when the
   marker is unambiguous.

### Spine (AIUP-chain defaults — overridable by an optional manifest arg)

Read the spine from these default paths. An optional **manifest** argument may
remap any of them for non-standard (e.g. brownfield) layouts — if a manifest is
supplied, it wins; otherwise use the defaults.

| Spine artifact | Default path |
|----------------|--------------|
| Requirements catalogue (FR/NFR/C/OOS) | `docs/requirements.md` |
| Use-case specs | `docs/use_cases/*.md` |
| Use-case diagram | `docs/use_cases.puml` |
| Entity / domain model | `docs/entity_model.md` |
| Vision | `docs/vision.md` |
| ADRs | `docs/adr/*` |
| Postponed-decisions log | the `## Postponed decisions` section(s) `pareto-scope-cut` appends to the END of each spine artifact it scope-cut — scan the spine artifacts (requirements, entity model, use-case specs) for that exact heading and collect its lines (no standalone file) |
| Testing strategy (per milestone) | `docs/testing/<milestone>.md` |

### Glossary (resolved by a fallback chain — never a hard-coded filename)

1. an explicit glossary path passed as an argument → 2. `docs/CONTEXT.md` →
3. `docs/glossary.md` → 4. **none found** → **WARN** ("no glossary found;
proceeding without verbatim term verification") and continue. Always try the
resolution order; NEVER hard-code a single glossary filename.

### Tracker wiring (referenced abstractly, never baked in)

Publish via the project's tracker wiring (`docs/agents/issue-tracker.md`); apply
labels per the project's label vocabulary (`docs/agents/triage-labels.md`). Do
not bake in any one tracker or label string — read the wiring docs at run time.

If any spine input is missing or thin, **warn**, take the brownfield branch for
that section (below), and continue — never crash on a not-yet-created artifact.

## Resolve the in-scope set

At the scope marker, resolve the **in-scope FR/UC set**: the requirements that
are **non-deferred** (in scope at this milestone per Status/scope) **and
non-out-of-scope** (not in the requirements OOS list, and not listed under any
`## Postponed decisions` section `pareto-scope-cut` appended to a spine artifact
— scan the spine artifacts for that exact heading and collect its lines).
Deferred FRs, OOS items, and postponed decisions feed
the **Out of Scope** section by reference — they are not user stories. This
in-scope set is the **forward-coverage contract**: every member must reach the
tracker linked by its ID (asserted in the POST self-check).

## Brownfield graceful degradation

`spec-to-prd` is a **superset** of vanilla `to-prd`, not a replacement that
assumes a complete spine. For **each** spine artifact independently:

- **Present and rich** → project it (link IDs, restate nothing).
- **Missing or thin** → fall back to **codebase-driven authoring** (vanilla
  `to-prd` behavior) **for that section only** — explore the relevant code,
  synthesize the section from code + conversation, and note in the PRD that the
  section was authored (not projected) because the spine artifact was absent.

Degrade per-section, never wholesale: a project with a rich requirements
catalogue but no entity model projects User Stories by ID and authors the
schema/module part of Implementation Decisions from the code.

## Section → source projection (link IDs, never restate)

The PRD uses the vanilla 7-section template. Spine-derived sections **link** the
listed IDs/artifacts; only the **bold "authored fresh"** rows are written anew.
Internal IDs (`P##`/`A##` pains, `M#`/`F##` capabilities) inform synthesis but
are **NEVER quoted into the published PRD** — they leak internal planning vocab.

| PRD section | Projected from (link, never restate) | Authored fresh? |
|-------------|--------------------------------------|-----------------|
| **Problem Statement** | `docs/vision.md` + the pain catalogue (background context only — `P##`/`A##` inform, never quoted) | No — projection |
| **Solution** | `docs/vision.md` golden-path | No — projection |
| **User Stories** | `docs/requirements.md` FRs **carried with their `FR-###` IDs** + `UC-###` refs | No — projection |
| **Implementation Decisions** | ADRs (**linked** `ADR-####`) + `docs/entity_model.md` (aggregates / invariants) | **Yes — the interactive module sketch is authored fresh** |
| **Testing Decisions** | `docs/testing/<milestone>.md` (**linked**) + NFRs by `NFR-###` | **Yes — authored fresh; links the testing strategy artifact** |
| **Out of Scope** | requirements OOS + the `## Postponed decisions` section(s) `pareto-scope-cut` appends to the spine artifacts (scan the spine for that exact heading; carry the revisit triggers) | No — projection |
| **Further Notes** | free | As needed |

## DO NOT

- Do NOT **restate spine content** — link `FR/UC/BR/NFR/ADR` IDs and reference
  artifacts; copying authoritative content violates `gr_documentation` Doc5.
- Do NOT **re-author user stories from the conversation** when the requirements
  catalogue exists — project the FRs with their IDs. (Re-author only the
  brownfield-thin sections, per-section.)
- Do NOT **invent or vary domain terms** — consume the glossary verbatim
  (`gr_domain_language` L1, read side); do not evolve or write back to it.
- Do NOT **publish without HITL approval** — the PRD publish is a shared/outward
  write; show the full draft, get explicit human approval, then publish. The
  interactive module sketch is also HITL.
- Do NOT **quote internal IDs** (`P##` / `A##` / `M#` / `F##`) into the published
  PRD — they inform synthesis but stay out of the tracker artifact.
- Do NOT **hard-code a tracker** or a **glossary filename** — read the tracker
  wiring (`docs/agents/issue-tracker.md`) and labels
  (`docs/agents/triage-labels.md`) at run time; resolve the glossary by the
  fallback chain.
- Do NOT **assume a complete spine** — degrade gracefully, per-section, to
  codebase authoring for any missing/thin artifact.
- Do NOT **author ADRs, model entities, write the testing strategy, or slice
  issues** here — invoke / defer to the owning skills (`adr-threshold-gate`,
  `domain-model`, `testing-strategy`, `to-issues`).
- Do NOT **bake ai-mail (or any one project's) specifics** into the PRD —
  paths/milestones/tracker arrive via args or the AIUP-chain defaults.
- Do NOT **crash on a missing input** — warn, branch to brownfield for that
  section, and continue.

## Workflow

1. **Resolve the scope marker** — arg → the requirements doc's declared
   milestone / Status scope split → ask only if genuinely ambiguous. State the
   resolved milestone.

2. **Read the spine** from the AIUP-chain defaults (or the manifest arg if
   supplied); resolve the glossary by its fallback chain; read the tracker
   wiring and label vocab. State which artifacts you found, which are
   missing/thin, and the resolved glossary path (or the no-glossary warning).
   **Resolve the in-scope FR/UC set** at the marker (non-deferred,
   non-out-of-scope).

3. **Brownfield branch** — for each missing/thin spine artifact, mark its
   section for codebase-driven authoring; for present artifacts, mark for
   projection (link IDs). Record the per-section disposition.

4. **Interactive deep-module sketch (HITL)** — sketch the major modules to
   build/modify, grounded in the entity model + use cases (+ the codebase in
   brownfield). Actively look for **deep modules** (simple interface, deep
   implementation, testable in isolation). **Confirm with the human** that the
   modules match expectations, and **ask which modules want tests**. This is the
   one part of Implementation Decisions that is authored fresh.

5. **Invoke `testing-strategy` in-session** — right after the module sketch, so
   it sees the just-decided (ephemeral) modules. It authors / updates
   `docs/testing/<milestone>.md` (project-specific *how*, each entry referencing
   `NFR-###` thresholds, never restating them). The PRD's Testing Decisions will
   **link** that artifact.

6. **Draft the thin PRD** on the 7-section template (below). For spine-derived
   sections, **link `FR/UC/BR/NFR/ADR` IDs and reference artifacts — restate
   nothing**. Author fresh **only** the module decisions (from step 4) and the
   Testing Decisions section (linking `docs/testing/<milestone>.md` + `NFR-###`
   refs from step 5). Keep internal IDs (`P##/A##/M#/F##`) out of the body.

7. **Run the composed lenses on the draft** (before publish): the
   ubiquitous-language guard (drift in the freshly-authored prose), the
   hidden-constraint sweep (did the synthesis drop a cross-cutting class?), and
   the ADR-threshold gate (did a module/interface decision cross the ADR
   threshold?). Fold their findings back into the draft.

8. **Publish — one PRD per milestone, HITL-gated.** Show the final draft and the
   forward-coverage check (every in-scope requirement linked by ID). On explicit
   human approval, publish via the tracker wiring
   (`docs/agents/issue-tracker.md`) with the `ready-for-agent` label (per
   `docs/agents/triage-labels.md`), carrying the traceability refs. If multiple
   in-scope milestones were requested, loop once per milestone.

## PRD template (vanilla 7 sections — thin projection)

```markdown
## Problem Statement
<Link / reference vision.md; pain catalogue as background only — no P##/A## quoted.>

## Solution
<Reference the vision golden-path. Do not restate it.>

## User Stories
<The in-scope FRs, each carried WITH its FR-### id and any UC-### ref.
 Example: "FR-012 (UC-004) — <title>". Link, do not re-author.>

## Implementation Decisions
- ADRs governing this area: <linked ADR-#### ids>
- Domain types / invariants: <reference entity_model.md aggregates>
- Module decomposition (authored fresh — HITL-confirmed):
  - <Module> — <simple interface; deep, testable implementation; tested? Y/N>
<No file paths or code snippets, per the vanilla rule — except an inline
 decision-encoding snippet from a prototype, trimmed to the decision-rich bits.>

## Testing Decisions
- Strategy: links docs/testing/<milestone>.md (authored by testing-strategy).
- Coverage targets: <NFR-### refs — link thresholds, do not restate them>.
- Which modules are tested: <from the module sketch>.

## Out of Scope
<Requirements OOS items (by OOS id) + the lines from the `## Postponed decisions`
 section(s) pareto-scope-cut appends to the spine artifacts — scan the spine for
 that exact heading (with their revisit triggers). Link / reference; do not restate.>

## Further Notes
<Anything else. Note any section authored from code (brownfield) vs projected.>
```

## POST self-check

Before reporting done, verify each item (PASS / explain):

1. **No spine restatement** — the PRD links IDs / references artifacts and
   restates no spine content (Doc5). Only module + testing decisions are fresh.
2. **Forward coverage** — every in-scope requirement is linked by its ID **and**
   present on the tracker. Name any gap.
3. **Scope marker honored** — only in-scope (non-deferred, non-OOS) requirements
   appear as user stories; deferred/OOS/postponed are in Out of Scope.
4. **Lenses ran** — ubiquitous-language guard, hidden-constraint sweep, and
   ADR-threshold gate all ran on the draft; findings folded in.
5. **Generic body** — no hard-coded project paths beyond the AIUP-chain defaults;
   no baked-in tracker or glossary filename; no ai-mail specifics.
6. **No internal-ID leak** — no `P##` / `A##` / `M#` / `F##` quoted into the
   published PRD.
7. **HITL gates honored** — module sketch confirmed with the human; PRD not
   published without explicit approval.

## Notes

- **Relation to vanilla `to-prd`.** This skill **supersedes** the external
  conversation-authoring `to-prd` in this skillset. Where vanilla re-derives
  every section from conversation + codebase (discarding stable IDs and risking
  duplication), `spec-to-prd` projects the spine and authors fresh only the two
  sections the spine genuinely lacks. It keeps the vanilla "synthesize what you
  already know, don't interview" stance — but "what you know" now lives in files,
  so it **reads** them.
- **Repo ↔ tracker drift** is *not* this skill's job beyond the publish-time
  forward-coverage assertion. Post-publish divergence (edited issues, spine
  changed after publish) belongs to the separate tracker-aware drift-audit skill.
- **Step-agnostic on completeness** — a partial spine degrades to per-section
  brownfield authoring rather than blocking.
