# Workflow — AIUP sequence for ai-mail (with guardrail skills)

The end-to-end order in which to run the AIUP steps and the guardrail skills. Skill *behaviour* lives
in [`create_skills.md`](../skills/create_skills.md) and the rationale in
[`skills_background_info.md`](../skills/skills_background_info.md); **this file is the authoritative sequence.**

**Legend** — **stock** = upstream `aiup-core` skill, unmodified · **fork** = modified authoring skill
in this repo (`domain-requirements`, `domain-model`) · **lens** = cross-cutting Family-A guardrail
skill · **external** = matt_pocock plugin skill · **HITL** = human-in-the-loop / brainstorming.

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
| 2 | Generate the vision from the inception files (AIUP vision template) | stock | inception files → `docs/vision.md` |
| 3 | Brainstorm vision goals (Assumption Reversal) | HITL | `docs/vision.md` → `01-foundation.md` (replaces `00-foundation.md`) |

## Phase 2 · Glossary → requirements  ← the sequencing fix lives here

| # | Step | Type | In → Out |
|---|------|------|----------|
| 4 | `/grill-with-docs` — sharpen terms & decisions | external | `docs/vision.md`, `01-foundation.md` → **`docs/CONTEXT.md`** + `docs/adr/####-*.md` |
| 5 | `domain-requirements` — author the catalog **from the glossary** | fork | `docs/CONTEXT.md`, `docs/vision.md` → `docs/requirements.md` |
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
3. `domain-model` — **fork** · produce the conceptual model (glossary-aware, VO/aggregate-aware) → `docs/entity_model.md`.
4. `adr-threshold-gate` — **lens** · catch any irreversible modelling decision → `docs/adr/####-*.md` (proposed; HITL to accept).
5. `hidden-constraint-sweep` — **lens** · the 8-class sweep (retention / concurrency / PII / …) the model implies.
6. `/use-case-diagram` — **stock** + lenses · → `docs/use_cases.puml`.
7. `/use-case-spec` — **stock** + lenses · → `docs/use_cases/*.md`.
8. `trace-check` — **lens** · cross-artifact consistency (UC→FR, entity-in-spec, actor↔glossary, BR↔invariant).

> The use-case steps run **stock + composed lenses** (no fork): the step-agnostic lenses cover the
> stock gaps (fabricated actors, weak scope, thin alt-flows, unforced surface decisions). Build a
> modified `use-case-spec` **only reactively** if BR↔invariant linkage breaks. See `skills/create_skills.md`
> §"Build order".

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
