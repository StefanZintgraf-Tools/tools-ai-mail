# Handoff — background for `plan/skills.md` (AIUP guardrail skills)

**Date:** 2026-06-03 · **Repo:** `c:\PROJ\ai-mail` (branch `master`) · planning only, **no code/skills built**.

This document captures the *discussion and reasoning* behind [`plan/skills.md`](skills.md). It does
**not** repeat that plan — `plan/skills.md` is the authoritative, self-contained build spec. Read the
plan first; read this only for the "why we landed here" and what was considered and rejected.

## What this session produced

1. Rewrote the skill strategy from the old **"bridge skills"** framing (see prior handoff +
   `todo.md` history) into the current **two-family** design, and wrote it up self-contained in
   [`plan/skills.md`](skills.md).
2. Added the post-`trace-check` continuation guidance to [`todo.md`](../todo.md) (first `- [ ]`
   section) and a one-line call-order under the `plan/skills.md` pointer.
3. Marked the old detailed plan **superseded** (it now lives in `plan/archive/todo_archive.md`, moved
   by the user; do not resurrect it).

## The reasoning arc (what's NOT in the plan)

These are the *decisions and the pivots* that produced the plan — kept here so they aren't
re-litigated:

- **Pivot 1 — "bridges" → "generic peer skills".** The earlier plan treated the `gr_*.md` guardrails
  as the user's private, fast-changing methodology that had to be *quarantined* into wrapper/bridge
  skills around an untouched `aiup-core`. **The user overturned this:** the guardrails are *generic
  and stable* (DDD, domain language, ADR, Pareto/greenfield = universal good practice), the **same
  kind of thing** as `entity-model`. So they become first-class generic skills, and `entity-model` is
  **modified, not wrapped**. This is the load-bearing decision; everything else follows.
- **Pivot 2 — the false dichotomy.** "Adjust entity-model" vs. "build bridges" are not alternatives:
  a *generic* skill cannot carry the discipline, so you need both layers. The real question was only
  *what the modeling skill underneath should be* → a genericized successor, `domain-model`.
- **Boundary rule** (the one design line to protect): `domain-model` owns *modeling-intrinsic*
  concerns (glossary as input, Entity/VO/Aggregate classification, invariants→validation,
  conceptual-first/no forced datatypes); the **cross-cutting lenses** (ADR gate, constraint sweep,
  Pareto cut, glossary maintenance) stay separate and reusable. Keeps each skill non-monstrous.
- **Pivot 3 — downstream needs no new modified skills.** Because the lenses are *step-agnostic*, the
  use-case steps run as **stock `aiup-core` + lenses + `trace-check`**. The only genuinely-new
  downstream concern was cross-artifact consistency → the new `trace-check` lens. A modified
  `use-case-spec` is **reactive only** (build it iff BR↔invariant linkage breaks). `domain-model` was
  the *exception*, not the pattern.
- **After `trace-check` = leave AIUP.** The spec spine ends there; AIUP Construction skills are
  Vaadin/jOOQ-locked and unusable for ai-mail's stack. Recommended next is the matt_pocock
  **`prototype`** skill to resolve ai-mail's #1 open unknown (interaction surface + plan/apply state
  machine) — see the rationale block in [`todo.md`](../todo.md) first section.
- **Working mode:** skills are built **by hand as ai-mail project skills** (`.claude/skills/<name>/`),
  **not** via the coding repo's `/make-skill`. ai-mail is a sandbox; port back to the coding project
  later. Upstream `aiup-core` is never forked.

## State of play

- **Done:** decisions resolved (naming `domain-model`, output stays `docs/entity_model.md`,
  glossary-as-arg, no orchestrator yet, etc. — all in `plan/skills.md` §Decisions). Nothing open in
  the plan.
- **Not done:** **zero skills built.** The next session builds them, starting with
  `ubiquitous-language-guard`, strictly from `plan/skills.md` (it lists every source path + per-skill
  spec).
- **Open placement detail:** the "port back to coding" mechanism is still TBD (noted in the plan).

## Key references (do not re-derive)

- [`plan/skills.md`](skills.md) — **the spec.** Source materials, per-skill build specs, build order,
  decisions. Self-contained.
- [`todo.md`](../todo.md) — first `- [ ]` section: the call-order + the after-`trace-check` guidance.
- Prior handoff: `…\AppData\Local\Temp\handoff-aiup-bridge-skills.md` — the *superseded* bridge
  framing; useful only as history.
- Guardrails: `c:\PROJ\ai-knowhow\coding\gr\*.md` (item IDs cited per-skill in the plan).
- AIUP stock skills + workflow: `c:\PROJ\github\aiup\marketplace\` (README, `aiup-core/skills/*`).
- ai-mail domain artifacts: `docs/CONTEXT.md`, `docs/requirements.md`, `docs/vision.md`, `docs/adr/*`,
  `plan/01-foundation.md`.
- matt_pocock skills (for the post-spec phase): `c:\PROJ\ai-knowhow\skills-plugins\matt_pocock_skills\`
  (`prototype`, `to-prd`, `to-issues`, `tdd`, `improve-codebase-architecture`) — active via plugin.

## CLAUDE.md constraints (must obey)

- **Off-limits — never read/search/reference:** `plan/archive/`, `outlook-RAG/`, `todo_ideas.md`.
- Read `todo.md`; current task = topmost unchecked `- [ ]`.
- **Pareto is a hard project value:** minimum work, maximum result; defer aggressively.

## Suggested skills for the next session

- **None of the new skills exist yet** — building the *first* one (`ubiquitous-language-guard`) is the
  job. Build it **by hand** per `plan/skills.md` §"How to build a skill here" + §"Per-skill build
  specs" #1. Do **not** use `/make-skill` (user's explicit choice for now).
- **`write-a-skill`** (matt_pocock) — optional reference for SKILL.md structure/progressive
  disclosure while authoring the new skills by hand.
- **`grill-with-docs`** — if the next session wants to stress-test the plan itself before building.
- **Later (post spec-spine, not now):** `prototype` (recommended next after `trace-check`), then
  `to-issues` / `tdd` — see the after-`trace-check` block in `todo.md`.
