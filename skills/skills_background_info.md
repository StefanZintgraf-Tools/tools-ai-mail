# Handoff — background for `skills/create_skills.md` (AIUP guardrail skills)

**Date:** 2026-06-03 · **Repo:** `c:\PROJ\ai-mail` (branch `master`) · planning only, **no code/skills built**.

This document captures the *discussion and reasoning* behind [`skills/create_skills.md`](create_skills.md). It does
**not** repeat that plan — `skills/create_skills.md` is the authoritative, self-contained build spec. Read the
plan first; read this only for the "why we landed here" and what was considered and rejected.

## What this session produced

1. Rewrote the skill strategy from the old **"bridge skills"** framing (see prior handoff +
   `todo.md` history) into the current **two-family** design, and wrote it up self-contained in
   [`skills/create_skills.md`](create_skills.md).
2. Added the post-`trace-check` continuation guidance to [`todo.md`](../todo.md) (first `- [ ]`
   section) and a one-line call-order under the `skills/create_skills.md` pointer.
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

## The second fork — `domain-requirements` (decided 2026-06-03, post-plan)

After the plan was written, a **second authoring fork** was approved: stock `requirements` →
`domain-requirements`. Why it is *not* a contradiction of "domain-model was the exception":

- **The asymmetry.** `entity-model`'s defects were **structural** (everything-becomes-a-table-with-an-`id`,
  forced `Long`/`Decimal` datatypes) — defects in the *generative act*, which no before/after lens can
  post-process. That forced a modified skill. Stock `requirements` has **no** structural defect: its
  FR/NFR/C catalog, user-story format, and quality checks are fine. Its *only* defect is **vocabulary
  input** — it reads only `vision.md`, never a glossary, so it coins terms and defaults to
  "User/Admin/System" actors.
- **Why a fork and not just the lens.** A lens (`ubiquitous-language-guard`) catches bad terms *after*
  generation; it cannot inject the right vocabulary *during* generation. Prevention-at-generation needs
  the glossary read *inside* the authoring skill — exactly the one change `domain-model` already carries
  (its item 3). So `domain-requirements` = stock `requirements` + "consume the glossary," and nothing
  else. Enforcement/evolution stays the lens.
- **The contingency that makes it worth the maintenance.** A glossary-aware requirements skill is
  worthless on pass one if the glossary doesn't exist yet — which, in the *old* sequence, it didn't
  (`CONTEXT.md` was born at grill-with-docs, *after* requirements). The fork is justified only because
  the **workflow was reordered** to seed the glossary *before* requirements (see
  [`workflow.md`](workflow.md)). The sequencing fix is upstream of the fork decision, not parallel to it.

| Authoring fork | Replaces | Fixes | Glossary role |
| -------------- | -------- | ----- | ------------- |
| `domain-model` | `entity-model` | *structural* (datatypes, surrogate-`id`, Entity/VO/Aggregate) **+** vocabulary-input | consumes, doesn't maintain |
| `domain-requirements` | `requirements` | *vocabulary-input only* (terms + actors verbatim) | consumes, doesn't maintain |

Both **consume** the glossary; **neither maintains** it — that stays `ubiquitous-language-guard`. The
two forks are the domain-language-aware authoring skills; the five lenses wrap around them.

## State of play

- **Done:** decisions resolved (naming `domain-model`, output stays `docs/entity_model.md`,
  glossary-as-arg, no orchestrator yet, etc. — all in `skills/create_skills.md` §Decisions). Nothing open in
  the plan.
- **Not done:** **zero skills built.** The next session builds them, starting with
  `ubiquitous-language-guard`, strictly from `skills/create_skills.md` (it lists every source path + per-skill
  spec).
- **Open placement detail:** the "port back to coding" mechanism is still TBD (noted in the plan).

## Key references (do not re-derive)

- [`skills/create_skills.md`](create_skills.md) — **the spec.** Source materials, per-skill build specs, build order,
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
  job. Build it **by hand** per `skills/create_skills.md` §"How to build a skill here" + §"Per-skill build
  specs" #1. Do **not** use `/make-skill` (user's explicit choice for now).
- **`write-a-skill`** (matt_pocock) — optional reference for SKILL.md structure/progressive
  disclosure while authoring the new skills by hand.
- **`grill-with-docs`** — if the next session wants to stress-test the plan itself before building.
- **Later (post spec-spine, not now):** `prototype` (recommended next after `trace-check`), then
  `to-issues` / `tdd` — see the after-`trace-check` block in `todo.md`.

## Appendix — the superseded "bridge skills" design (history)

This appendix folds in the still-useful detail from the **original "bridge skills" plan** (now in
`plan/archive/todo_archive.md`, superseded 2026-06-03). It is kept here so the *evidence* and the
*rejected design* aren't lost. **None of the `prep-*` orchestrators below were built** — they were
dropped in favour of compose-by-convention (see `create_skills.md` §Composition model, Decision 6).
The empirical gap analysis, however, is **still valid** and is the load-bearing justification for the
whole skill family.

### Carried forward vs dropped (bridge plan → built skills)

| Bridge-plan item | Status today | Where it landed |
| ---------------- | ------------ | --------------- |
| 4 Layer-1 **lenses** + their gr-clusters (`ubiquitous-language-guard` L1,L2,L4,L6,L8,L9+G7; `hidden-constraint-sweep` Aln6+B5; `adr-threshold-gate` Adr1,5,8; `pareto-scope-cut` G1,3,5,9,10) | ✅ **Built as-is** — gr-clusters identical | `create_skills.md` Family A; built under `skills/` |
| Per-lens **WHY** rationale + the empirical **gap analysis** | ✅ **Still valid** | This appendix (was missing from the body) |
| "bridge / quarantine around an untouched `aiup-core`" framing | ❌ **Superseded** | Pivot 1 → generic peer skills |
| Layer-2 **`prep-*` orchestrators** (`prep-entity-model`, `prep-use-case-diagram`, `prep-use-case-spec`) + the PRE/POST per-step model | ❌ **Dropped / deferred** | Compose by convention (`create_skills.md` §Composition model, Decision 6, G5) |
| `entity-model` *wrapped* by a prep | ❌ **Superseded** | → *modified* `domain-model` skill (Family B) |
| `trace-check` | ➕ **New** — absent from the bridge plan | `create_skills.md` §6 |
| Built via the `/make-skill` toolchain | ❌ **Changed** | Built by hand as ai-mail project skills |

### The gap — why stock `aiup-core` is not enough (confirmed by reading the bodies, 2026-06-03)

The stock `aiup-core` skills are thin and storage/CRUD-flavoured, carrying zero domain discipline:

- **`entity-model`** reads **only** `requirements.md` — **not** the glossary (`CONTEXT.md`). It makes
  every term an entity-with-an-`id` (no value-object / aggregate concept) and invents DB datatypes
  (`Long` / `Decimal` / `Sequence`). This collides with `gr_ddd` D5/D2/D3 and `gr_domain_language`
  L4/L8. → Fixed at source by the modified **`domain-model`** skill (Family B).
- **`use-case-diagram` / `use-case-spec`** read requirements (+ puml) only: they invent generic
  actors, enforce no ubiquitous language, run no hidden-constraint sweep, apply no ADR threshold, and
  have no Pareto/scope discipline. → Covered by composing the step-agnostic Family-A lenses
  (`ubiquitous-language-guard`, `hidden-constraint-sweep`, `adr-threshold-gate`, `pareto-scope-cut`)
  + `trace-check`, rather than by modified skills (Pivot 3).

### Per-lens rationale (carried forward verbatim from the bridge plan)

These WHYs still describe why each lens exists; the lenses themselves were built unchanged (same
gr-clusters):

- **`ubiquitous-language-guard`** [`gr_domain_language` L1,L2,L4,L6,L8,L9 + `gr_greenfield` G7] — the
  single highest-value lens: stock skills ignore the glossary, so this re-injects it as ground truth
  and keeps it current. Fixes the "entity-model never reads the glossary" gap.
- **`hidden-constraint-sweep`** [`gr_algn` Aln6 + B5] — stock skills never surface the commonly-missed
  NFR/edge classes (security/PII, permissions, retention, migrations, observability, public-API-compat,
  concurrency, out-of-scope); this makes the 8-class checklist explicit.
- **`adr-threshold-gate`** [`gr_adr` Adr1,5,8] — hard-to-reverse modelling/design decisions otherwise
  get buried in an ERD cell or a UC step; this gates them.
- **`pareto-scope-cut`** [`gr_greenfield` G1,3,5,9,10] — the project's Pareto floor; stops stock skills
  modelling future/imagined scope (e.g. the M2b terms).

### The rejected Layer-2 — `prep-*` orchestrators (NOT built)

The original plan wrapped each stock skill in a per-step **PREP orchestrator** that ran PRE (challenge
source docs, hand the stock skill a constrained brief) and POST (verify the artifact against its gr
cluster, loop fixes back). Three were specified — `prep-entity-model`, `prep-use-case-diagram`,
`prep-use-case-spec` — mirroring `coding_plan`'s B-cross-cutting + A-per-phase split.

**Why dropped:** once the guardrails became generic *peer* skills (Pivot 1) and the modelling skill was
*modified* rather than *wrapped* (→ `domain-model`), the PRE/POST wrapper layer lost its purpose. The
lenses are step-agnostic and composed by convention; a thin `prep-*` orchestrator is deferred until
hand-sequencing the lenses proves annoying across ≥2 steps (`gr_greenfield` G5, Decision 6). The
`trace-check` lens replaced the only genuinely-new POST concern the preps would have carried
(cross-artifact consistency).
