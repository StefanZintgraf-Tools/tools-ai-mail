# artifacts


## artifacts created in Phase 1..3

### Production Sequence

| Artifact                         | Phase | Produced by                     |
| -------------------------------- | ----- | ------------------------------- |
| `plan/painlist_*.md`             | 1     | bmad brainstorming              |
| `plan/archive/00-foundation.md`  | 1     | bmad brainstorming              |
| `docs/vision.md`                 | 1     | vision authoring                |
| `plan/01-foundation.md`          | 1     | bmad brainstorming vision goals |
| `docs/CONTEXT.md`                | 2     | `/grill-with-docs`              |
| `docs/adr/####-*.md` (initial)   | 2     | `/grill-with-docs`              |
| `docs/requirements.md` (initial) | 2     | `domain-requirements`           |
| `docs/requirements.md` (update)  | 2     | human review + AI challenge     |
| `docs/entity_model.md`           | 3     | `domain-model`                  |
| `docs/adr/####-*.md` (modelling) | 3     | `adr-threshold-gate`            |
| `docs/use_cases.puml`            | 3     | `/usecase-diag`                 |
| `docs/use_cases/*.md`            | 3     | `/usecase-spec` + manual review |
| `## Postponed decisions` section | 1–3   | `pareto-scope-cut`              |

### Content

| Artifact                         | Phase | Content                                                                                        |
| -------------------------------- | ----- | ---------------------------------------------------------------------------------------------- |
| `plan/painlist_*.md`             | 1     | Catalogued pains per stakeholder group with `P##`/`A##` IDs and priority flags                 |
| `plan/01-foundation.md`          | 1     | Capability matrix (`M#`/`F##`), reach scores, build-order decision                             |
| `docs/vision.md`                 | 1     | Mission, target user, dogfood context, golden-path scenario, out-of-scope list                 |
| `docs/CONTEXT.md`                | 2     | Canonical term definitions (ubiquitous language) + avoid-list per term                         |
| `docs/requirements.md`           | 2     | `FR-###` functional requirements + `NFR-###` + `C-###` constraints, scoped by milestone        |
| `docs/entity_model.md`           | 3     | Aggregates, value objects, relationships, invariants — glossary-aligned                        |
| `docs/adr/####-*.md` (modelling) | 3     | One irreversible modelling decision per file (same format as initial ADRs)                     |
| `docs/use_cases.puml`            | 3     | PlantUML actor/use-case diagram; every in-scope FR maps to ≥1 use case                         |
| `docs/use_cases/*.md`            | 3     | Per-use-case: actors, preconditions, main flow, alt flows, FR-### trace line                   |
| `## Postponed decisions` section | 1–3   | One-line G9 deferral records (what was cut, reason citing G1/G3/G5/G6/G10, revisit trigger).   |
|                                  |       | Location: a `## Postponed decisions` section appended to the END of each artifact              |
|                                  |       | `pareto-scope-cut` scope-cut (requirements, entity model, a use-case spec, …) NOT a standalone |
|                                  |       | file. Consumed by `spec-to-prd` (Out of Scope projection) and `tracker-trace-check`.           |


### Delta Information

| Artifact                         | Phase | New information (not present in input artifacts)                                                            |
| -------------------------------- | ----- | ---------------------------------------------------------------------------------------------------------- |
| `plan/painlist_*.md`             | 1     | First artifact — introduces the pain catalogue and the stable `P##`/`A##` ID space                         |
| `plan/01-foundation.md`          | 1     | Capability matrix (`M#`/`F##`) mapping pains to capabilities, reach scores, scope boundary, "build M2 first" decision |
| `docs/vision.md`                 | 1     | Names the system; mission, target user, dogfood context, and the golden-path scenario                      |
| `docs/CONTEXT.md`                | 2     | Canonical definitions + avoid-lists per term — the first authoritative vocabulary                          |
| `docs/requirements.md`           | 2     | Stable `FR-###`/`NFR-###`/`C-###` IDs and the authoritative what-must-be-built list, milestone-scoped      |
| `docs/entity_model.md`           | 3     | Aggregates, value objects, relationships, and entity-level invariants — the data structure behind the FRs  |
| `docs/adr/####-*.md` (modelling) | 3     | Records the design forks taken during entity modelling that the model alone leaves implicit                |
| `docs/use_cases.puml`            | 3     | The use cases themselves and the forward `FR→UC` mapping — proof every in-scope FR is realised             |
| `docs/use_cases/*.md`            | 3     | Per-use-case scenarios (pre/postconditions, main + alt flows, `BR-###`) and the reverse `UC→FR` traceability |


### Redundancies

| Artifact                         | Phase | Redundant information (restates content from upstream input artifacts)                                                             |
| -------------------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `plan/painlist_*.md`             | 1     | N/A — first artifact, no inputs                                                                                                   |
| `plan/01-foundation.md`          | 1     | N/A — references `plan/painlist_*.md` `P##`/`A##` IDs only, restates no content                                                  |
| `docs/vision.md`                 | 1     | Out-of-scope list overlaps with `plan/01-foundation.md`'s deferred-capability set                                                 |
| `docs/CONTEXT.md`                | 2     | N/A — canonical term definitions; downstream ADRs restate its context, not vice-versa                                            |
| `docs/requirements.md`           | 2     | Scope split echoes `plan/01-foundation.md`'s M2-first scope decision                                                              |
| `docs/entity_model.md`           | 3     | Invariants overlap with `C-###`/`NFR-###` in `docs/requirements.md`                                                               |
| `docs/adr/####-*.md` (modelling) | 3     | Design rationale is partly implicit in `docs/entity_model.md` structure                                                           |
| `docs/use_cases.puml`            | 3     | Actor list restates roles already defined in the `docs/CONTEXT.md` glossary                                                       |
| `docs/use_cases/*.md`            | 3     | Actor reference (`Primary Actor: User`) resolves against the `docs/CONTEXT.md` glossary; FR→UC mapping duplicates `docs/use_cases.puml` |


## artifacts created in Phase 4

> **Settled decisions (artifact-facing):**
> - **One `testing.md` per milestone**, at path `docs/testing/<milestone>.md` (mirrors how `docs/use_cases/*.md` fans out).
> - **The thin PRD is a thin projection, not an authored origin** — it lives on the tracker (not a repo file), **links** spine IDs (`FR/UC/BR/ADR`) and duplicates **no** spine content; it authors fresh only the module-decomposition and testing-decisions sections. **One PRD per milestone.**

### Production Sequence

| Artifact                       | Phase | Produced by                     |
| ------------------------------ | ----- | ------------------------------- |
| `docs/testing/<milestone>.md`  | 4     | `testing-strategy`              |
| thin PRD (lives on the tracker)| 4     | `spec-to-prd`                   |

### Content

| Artifact                       | Phase | Content                                                                                                                                  |
| ------------------------------ | ----- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `docs/testing/<milestone>.md`  | 4     | Project-specific testing strategy (module/test-surface priorities, test-double policy at the real boundaries, prior art); each entry opens `Re: NFR-###` / `Re: C-###` (references thresholds, never restates them); references the `tdd` skill for universal philosophy. One file per milestone. |
| thin PRD (lives on the tracker)| 4     | The vanilla 7-section PRD template (Problem Statement · Solution · User Stories · Implementation Decisions · Testing Decisions · Out of Scope · Further Notes); **links** spine IDs and duplicates no spine content — only module + testing decisions authored fresh. One PRD per milestone. |

### Delta Information

| Artifact                       | Phase | New information (not present in input artifacts)                                                                                          |
| ------------------------------ | ----- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `docs/testing/<milestone>.md`  | 4     | The project-specific *how* of verification — module/test-surface picks, test-double policy at the real boundaries, prior art — none of which exists upstream (thresholds live in the NFRs; universal philosophy lives in `tdd`) |
| thin PRD (lives on the tracker)| 4     | Authors fresh only the module-decomposition and testing-decisions sections; everything else is a projection of the existing spine        |

### Redundancies

| Artifact                       | Phase | Redundant information (restates content from upstream input artifacts)                                                                    |
| ------------------------------ | ----- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `docs/testing/<milestone>.md`  | 4     | N/A — references `NFR-###`/`C-###` thresholds by ID, never restates them; references the `tdd` skill for universal philosophy rather than copying it |
| thin PRD (lives on the tracker)| 4     | Deliberately duplicates **nothing** — it **links** spine IDs (`FR/UC/BR/ADR`) instead of restating their content                          |

