# Workflow — AIUP sequence for ai-mail (with guardrail skills)

The end-to-end order in which to run the AIUP steps and the guardrail skills. Skill *behaviour* lives
in [`create_skills.md`](../skills/create_skills.md) and the rationale in
[`skills_background_info.md`](../skills/skills_background_info.md); **this file is the authoritative sequence.**

**Legend** — **authoring** = an AIUP step that produces a chain artifact · **lens** = cross-cutting
Family-A guardrail skill · **external** = matt_pocock plugin skill · **HITL** = human-in-the-loop /
brainstorming.

## The load-bearing ordering rule

`docs/CONTEXT.md` (the glossary / ubiquitous language) is **seeded by `/grill-with-docs` BEFORE the
requirements step**, not after it. In the original flow the glossary was born *downstream* of
`requirements`, so terms were coined with nothing to anchor them and had to be retrofitted. Seeding it
first is the whole reason `domain-requirements` can consume a real glossary on pass one. Everything
else follows from this.

## Phase 1 · Inception → vision

| # | Step | Type | In → Out |
|---|------|------|----------|
| 1 | General brainstorming (AI-recommended method, Pareto) | HITL | — → `painlist.md`, `ideas.md`, `00-foundation.md` |
| 2 | Generate the vision from the inception files (AIUP vision template) | authoring | inception files → `docs/vision.md` |
| 3 | Brainstorm vision goals (Assumption Reversal) | HITL | `docs/vision.md` → `01-foundation.md` (replaces `00-foundation.md`) |

## Phase 2 · Glossary → requirements  ← the sequencing fix lives here

| # | Step | Type | In → Out |
|---|------|------|----------|
| 4 | `/grill-with-docs` — sharpen terms & decisions | external | `docs/vision.md`, `01-foundation.md` → **`docs/CONTEXT.md`** + `docs/adr/####-*.md` |
| 5 | `domain-requirements` — author the catalog **from the glossary** | authoring | `docs/CONTEXT.md`, `docs/vision.md` → `docs/requirements.md` |
| 6 | Human review of `docs/requirements.md` | HITL | — |
| 7 | Challenge the `FR-###` items with a strong thinking model; apply Pareto (defer features to later milestones) | HITL | `docs/requirements.md` (edited) |
| 8 | If the changes are significant: re-grill **only the diff** | external | see command below |

Re-grill command for step 8:

    /grill-with-docs Grill me ONLY about the change set in `git diff HEAD~1 HEAD`. Treat that diff as
    the entire plan; read other files only to check consistency, never as new grill subjects.

## Phase 3 · Model + spec spine

Run in this order (the `todo.md` call-order). Lenses gate/annotate; they produce no artifact of their
own. Review between every step (AIUP's edit-between-steps discipline).

1. `ubiquitous-language-guard` — **lens** · enforce the glossary on `requirements.md`; write approved new/changed terms back into `CONTEXT.md` (HITL).
2. `pareto-scope-cut` — **lens** · cut imagined/future scope (ai-mail: defer M2b/M3/M4); append a Postponed-decisions log.
3. `domain-model` — **authoring** · produce the conceptual model (glossary-aware, VO/aggregate-aware) → `docs/entity_model.md`.
4. `adr-threshold-gate` — **lens** · gate **`docs/entity_model.md`** (the just-produced model; `docs/adr/*` read for numbering + dedup) for irreversible modelling decisions → `docs/adr/####-*.md` (proposed; HITL to accept).
5. `hidden-constraint-sweep` — **lens** · gate **`docs/entity_model.md`** (the just-produced model; the 8-class sweep (retention / concurrency / PII / …) the model implies.
   if issues found: 
   5a:  PROMPT: 
        create a plan/hidden_constraints.md file with the missing findings (the gaps). It should list all gaps and also contain suggestions, how to handle the gaps (missing findings).
        This file will later be used in separate sessions to resolve the missing items.
   5b: for each gap (new session): let's work on Gap ### out of these findings. Goal: update the related planning artifacts of the current project (located in plan and docs folders).
   5c: when the gap is handled, handoff the chat into plan/gap###_close_log.md
   5d: if requirements.md was updated: re-run /domain-model 
   5e: re-run /hidden-constraint-sweep docs/entity_model.md. If a previously closed gap is re-detected, show the plan/gap###_close.log.md to check if it is still a gap
   5f: archive the artifacts used for closing the gaps into plan/archive
6. `/usecase-diag` — **authoring** + lenses · → `docs/use_cases.puml`; guarantees **forward** FR→UC coverage (every in-scope FR realised by ≥1 use case or recorded as a spec-level detail).
7. `/usecase-spec` — **authoring** + lenses · → `docs/use_cases/*.md`; emits a per-spec `Requirements covered (FR-###)` trace line and enforces **fail-closed reverse** coverage (every in-scope FR cited by ≥1 spec).
8. `trace-check` — **lens** · cross-artifact consistency (UC→FR, entity-in-spec, actor↔glossary, BR↔invariant). The per-spec trace line makes the UC→FR convention present at authoring time, so Check A now **runs** instead of reporting "no trace convention."

> The use-case steps run the **authoring skills + composed lenses**. The authoring skills own
> **completeness** (FR↔UC coverage, both directions) at authoring time — the one gap the step-agnostic
> lenses cannot add after the fact; the lenses still cover the rest (fabricated actors →
> `ubiquitous-language-guard`, weak scope → `pareto-scope-cut`, thin alt-flows →
> `hidden-constraint-sweep`, unforced surface decisions → `adr-threshold-gate`). Adding a reverse FR→UC
> check to `trace-check` is **optional drift-insurance**, not load-bearing.

## Phase 4 · Post-spec — leave AIUP

The AIUP spec spine ends at `trace-check`. AIUP's Construction skills are Vaadin/jOOQ-locked and
unusable for ai-mail's stack, so continue with matt_pocock skills:

| # | Step | Type | Note |
|---|------|------|------|
| 1 | `prototype` *(optional)* | external | resolve the #1 open unknown (interaction surface + plan/apply state machine) before committing. |
| 2 | `to-prd` | external | turn the spec into a PRD. |
| 3 | `to-issues` | external | break the PRD into tracer-bullet vertical-slice issues. |
| 4 | `tdd` | external | implement issues red-green-refactor. |

## Notes

- Skills are built and run **as ai-mail project skills** (`skills/<name>/`), by hand — see
  `skills/create_skills.md` §Placement. ai-mail is the sandbox; port proven skills back to the coding project
  later.
- `domain-requirements` is the **one skill not yet built** (build spec #7 in `skills/create_skills.md`).
