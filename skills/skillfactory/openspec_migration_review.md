# OpenSpec 1.4.1 — migration & re-use review

**Date:** 2026-06-09
**Question:** Can the ai-mail workflow/skillset (`skills/`) be **adjusted to / re-used in** OpenSpec
1.4.1, rather than reinvented? It is partly derived from `matt_pocock_skills`, the `aiup-core`
skillset, and the guardrails in `coding/gr/*.md`. The goal is to **keep the best ideas** from those
sources and host them on OpenSpec where OpenSpec earns its keep.
**Basis:** read of `C:\PROJ\github\OpenSpec.1.4.1` v1.4.1 (`package.json` → `1.4.1`) — `README.md`,
`docs/opsx.md`, `docs/concepts.md`, `docs/customization.md`, `docs/migration-guide.md`,
`schemas/spec-driven/schema.yaml` + templates, `src/core/templates/workflows/*.ts`; cross-read of
`skills/workflow.md`, `skills/skills_overview.md`, `skills/artifacts.md`, `skills/skillfactory/*`,
`skills/CLAUDE.md`, and `coding/gr/gr_*.md`.
**Scope:** this is an **exploratory architecture review + work-item plan**, not an execution order.
It does **not** start the migration (mirrors `skill_genericity_review.md`). It is a `skillfactory`
analysis doc, so — like `milestone_review.md` — it names ai-mail specifics; the *target schema content*
it prescribes still keeps every skill project-agnostic (`skills/CLAUDE.md`), with project values
arriving via OpenSpec's own `config.yaml`.

---

## TL;DR

1. **Feasible, and a genuinely strong fit for the authoring spine.** OpenSpec's OPSX workflow *is* a
   schema-driven **artifact DAG** (`schema.yaml`: `artifacts: [{id, generates, template, instruction,
   requires}]`) driven by a CLI state machine and thin per-tool skills. The ai-mail **authoring chain**
   (`declare-milestone → vision → grill → requirements → entity-model → use-case diagram → use-case spec
   → testing → prd`) is *already* that exact shape — `workflow.md` is a hand-written topological sort of
   the same DAG. Re-housing it as a **custom OpenSpec schema** is a transcription, not a rewrite.
2. **The two halves of the skillset migrate very differently.**
   - **Authoring skills** (produce a chain artifact) → OpenSpec **schema artifacts** (`instruction` +
     `template` + `requires`). Clean 1:1.
   - **Lens skills** (step-agnostic, cross-cutting: `ubiquitous-language-guard`, `pareto-scope-cut`,
     `adr-threshold-gate`, `hidden-constraint-sweep`, `trace-check`, `tracker-trace-check`) have **no
     native OpenSpec equivalent** — OpenSpec has no "gate that runs on every artifact." Keep them as
     **portable Claude Code skills composed on top**, *referenced from* each artifact's `instruction`,
     plus one **`review` (verify-style) artifact** that makes the fail-closed coverage/trace gate
     schema-visible.
3. **Guardrails map onto OpenSpec's own injection points.** `gr_*.md` rule clusters → `config.yaml`
   **`context`** (the always-on digest) + per-artifact **`rules`** (`<rules>` blocks). The
   `skills_overview.md` "Relation to guardrail items" sections are *already written as per-artifact rule
   lists* — they transpose almost verbatim into `rules:`.
4. **`milestone` ≡ OpenSpec `change`.** This resolves the tension `milestone_review.md` wrestled with:
   OpenSpec already owns "one unit of in-scope work = one self-contained folder." `declare-milestone`
   becomes **change creation** (`/opsx:new`/`/opsx:propose`) + `.openspec.yaml` metadata. Milestone N+1
   becomes a **delta change** against the accumulated `openspec/specs/` — which is *better* than ai-mail's
   "re-run the whole chain," and is the single biggest thing OpenSpec gives ai-mail for free.
5. **Three real tensions, all surmountable, but they cost rigor unless compensated** — (a) OpenSpec is
   deliberately **fluid / "dependencies are enablers, not gates,"** whereas ai-mail's value is
   **fail-closed coverage + HITL between every step**; (b) OpenSpec specs use **named** `### Requirement:`
   blocks, ai-mail's traceability hinges on **stable `FR/NFR/UC/BR/ADR` IDs**; (c) OpenSpec is
   **delta/brownfield**-first, ai-mail is **greenfield-spine**-first. None is a blocker; each needs a
   deliberate decision (see §9).
6. **Recommendation: stage it as two migration milestones, and not yet.** Build a project-agnostic
   **custom schema** that hosts the ai-mail authoring chain on OpenSpec's engine, inject guardrails via
   `config.yaml`, keep the lenses as composed skills. **Milestone 1 (Basic) = Pure OpenSpec** — the spine
   runs fully in-repo (`tasks.md` + `/opsx:apply` + `/opsx:archive` merging deltas into `openspec/specs/`),
   no GitHub tracker; this proves the engine on the smallest surface. **Milestone 2 (Full) = Hybrid** —
   layer the GitHub execution bridge (`spec-to-prd`/`to-issues`/`tracker-trace-check`/`triage`) on the
   proven Basic spine. **Defer the build** until the in-flight genericity refactor
   (`skill_genericity_review.md`, `domain-requirements`, `declare-milestone`) settles — migrating a moving
   target doubles the work (§10). The two-milestone split is itself the Pareto / one-slice discipline the
   skillset preaches, applied to its own migration.

---

## 1 · What OpenSpec 1.4.1 actually is (and is not)

OpenSpec is an **npm CLI + a generated skill layer**, not a framework you import. Its current ("OPSX")
workflow has four moving parts:

| Part | What it is | Where it lives |
|---|---|---|
| **Schema** | A DAG of *artifacts*: `{id, generates (file/glob), template, instruction, requires[]}` + an `apply:` block. Defines the whole workflow. | `openspec/schemas/<name>/schema.yaml` (project-local, version-controlled) or `~/.local/share/openspec/schemas/` (global) |
| **Templates** | Markdown skeletons (section headers + HTML-comment guidance) injected when an artifact is created. | `openspec/schemas/<name>/templates/*.md` |
| **Project config** | `context:` (prepended to **all** artifact instructions, `<context>` tags) + `rules:` (per-artifact, `<rules>` tags) + default `schema:`. 50 KB context cap. | `openspec/config.yaml` |
| **Generated skills/commands** | Thin, schema-agnostic drivers (`/opsx:propose|explore|new|continue|ff|apply|verify|sync|archive`). They call `openspec status --json` / `openspec instructions <artifact> --json`, read the returned `template`/`instruction`/`context`/`rules`/`dependencies`, then create **one** artifact. | `.claude/skills/openspec-*/SKILL.md` (regenerated by `openspec init` / `update`) |

Two storage areas (`docs/concepts.md`):

- **`openspec/specs/`** — the **source of truth**: how the system *currently* behaves, as
  `### Requirement:` / `#### Scenario:` (RFC-2119 SHALL/MUST, Given/When/Then).
- **`openspec/changes/<change>/`** — a **self-contained change folder** (`proposal.md`, `design.md`,
  `tasks.md`, `.openspec.yaml`, and **delta specs** `specs/<cap>/spec.md` as `ADDED`/`MODIFIED`/`REMOVED`).
  **Archive** merges the deltas into `openspec/specs/` and moves the folder to `changes/archive/`.

Design philosophy (`README.md`, `docs/concepts.md`): *fluid not rigid · iterative not waterfall · easy
not complex · brownfield-first.* Explicitly: **"dependencies are enablers, not gates."** `requires`
controls *ordering*, never a *quality gate* and never a *human-review* gate.

The closest thing to an ai-mail "lens" is the **`verify`** workflow (`verify-change.ts`): a
completeness/correctness/coherence report (`CRITICAL`/`WARNING`/`SUGGESTION`) — but it checks
**implementation vs. artifacts**, not **artifact-internal quality** (no language audit, no scope cut, no
ADR gate, no FR↔UC coverage). So the lenses are net-new value OpenSpec does not have.

**Customization path is first-class:** `openspec schema fork spec-driven <name>` /
`openspec schema init <name>` / `openspec schema validate <name>` / `openspec schema which`. The whole
point of OPSX over legacy OpenSpec was to move the workflow *out of TypeScript* into editable
YAML+Markdown (`docs/opsx.md` "Why This Exists"). That is exactly the seam a migration needs.

## 2 · The ai-mail skillset, classified by how it migrates

| Class | Skills | Produces | Migration target |
|---|---|---|---|
| **Authoring** | `declare-milestone`, vision step, `domain-requirements`, `domain-model`, `usecase-diag`, `usecase-spec`, `testing-strategy`, `spec-to-prd` | a fixed-name chain artifact | **schema `artifact`** (`instruction`+`template`+`requires`) |
| **Lens** (step-agnostic) | `ubiquitous-language-guard`, `pareto-scope-cut`, `adr-threshold-gate`, `hidden-constraint-sweep`, `trace-check`, `tracker-trace-check` | a report + HITL write-back | **composed portable skill** + one `review` artifact (§4) |
| **External** (matt_pocock) | `bmad-brainstorming`, `grill-with-docs`, `prototype`, `to-issues`, `tdd` | inception / glossary / issues / code | mostly **unchanged**; `apply`/tasks bridge (§8) |
| **Meta** | `review-skills`, `refactor-skills` | skill-maintenance worklists | **unchanged** — orthogonal to OpenSpec |
| **Rule source** | `coding/gr/gr_*.md` (L/G/D/A/Adr/Aln/Rev/Gov/Doc…) | the discipline each skill operationalizes | **`config.yaml` `context` + per-artifact `rules`** (§5) |

The load-bearing observation: **`workflow.md` and `create_skills.md` already *are* OpenSpec's engine,
hand-rolled.** `workflow.md` is the topological sort; `create_skills.md`'s orchestration rule (one cold
sub-agent per unit, strict order, flip the checkbox on POST) is a bespoke `openspec status` + `instructions`
+ `continue` loop. Migration is mostly *letting OpenSpec's CLI own the state/ordering you currently
maintain by hand.*

## 3 · The core mapping — authoring chain → custom schema

Each authoring step becomes one artifact node. The `requires:` edges are read straight off `workflow.md`.

| ai-mail step (artifact) | OpenSpec artifact `id` | `requires` | Notes |
|---|---|---|---|
| `declare-milestone` | *(change creation)* | — | Not an artifact — it is **creating the change** + `.openspec.yaml`. Milestone ≡ change (§6). |
| vision (`vision_template.md` → `vision.md`) | `vision` | `[]` | Root node — plays the role `proposal` plays in `spec-driven`. |
| `grill-with-docs` → `CONTEXT.md` + ADRs | `glossary` (+ ADRs as decisions) | `[vision]` | Seeds the ubiquitous language **before** requirements (the load-bearing ordering rule in `workflow.md`). |
| `domain-requirements` → `requirements.md` | `requirements` | `[vision, glossary]` | The FR/NFR/C/OOS catalog. Template carries `FR-###` etc. (§7). |
| `domain-model` → `entity_model.md` | `entity-model` | `[requirements]` | Conceptual model + invariants. |
| `usecase-diag` → `use_cases.puml` | `use-cases-diagram` | `[requirements, entity-model]` | `generates: use_cases.puml`. Forward FR→UC coverage. |
| `usecase-spec` → `use_cases/*.md` | `use-cases-spec` | `[use-cases-diagram]` | `generates: 'use_cases/**/*.md'` (glob). Reverse FR→spec coverage + `BR-###`. |
| FR + UC scenarios → behaviour contract | `specs` | `[use-cases-spec, entity-model]` | `generates: 'specs/**/*.md'`. Delta specs (`### Requirement: FR-### …` / `#### Scenario`) that accrete into `openspec/specs/` on archive — **DEC4 adopt** (§6, §7). |
| `testing-strategy` → `testing/<m>.md` | `testing` | `[requirements]` | One per change. |
| `spec-to-prd` → tracker PRD | `prd` *(GitHub bridge)* | `[requirements, use-cases-spec, testing]` | **Milestone 2 only** — the GitHub projection (§8). |
| — *(new)* coverage/trace gate | `review` | `[specs, use-cases-spec, entity-model]` | A `verify`-style artifact hosting `trace-check`'s A–D + FR↔UC coverage (§4). |

The matt_pocock spine (`to-issues` → `tdd`) maps onto OpenSpec's terminal artifacts/actions: `tasks`
(generated from the PRD/spine) + `apply:` (`tracks: tasks.md`) is exactly the `to-issues`→`tdd` loop.

What an artifact node looks like (sketch — generic; project values come from `config.yaml`):

```yaml
- id: requirements
  generates: requirements.md
  template: requirements.md
  instruction: |
    Author the requirements catalog from the vision and glossary (read both deps).
    Emit FR (user-story), NFR (measurable), Constraints, and Out-of-Scope tables, each row
    with a stable ID and a filled Status. Use glossary terms VERBATIM (L1). Flag — never coin
    — new terms (L6). Carry the vision's non-goals into Out-of-Scope (Aln15).
    AFTER writing, run the composed lenses: ubiquitous-language-guard, pareto-scope-cut,
    hidden-constraint-sweep. Resolve or record their findings before this artifact is "done".
  requires: [vision, glossary]
```

## 4 · The lenses — the one part OpenSpec has no slot for

Lenses are **step-agnostic** (one lens runs on requirements *and* the entity model *and* the use-case
spec *and* the PRD draft) and **HITL** (write-back only on approval). OpenSpec artifacts are
**single-position DAG nodes**. So a lens is the wrong shape for an artifact node. Three options, ranked:

1. **Composed portable skills, referenced from `instruction`/`rules` (recommended).** The lenses stay in
   `skills/` exactly as they are (portable, generic, already gr-mapped). Every artifact's `instruction`
   ends with *"after writing, run `ubiquitous-language-guard` + `hidden-constraint-sweep` …"*. OpenSpec
   owns the DAG + state; the lenses stay independent. **Keeps the genericity investment, doesn't fight the
   "no gates" grain, zero rewrite.**
2. **One `review` (verify-style) artifact** for the checks that *must* be a visible gate — `trace-check`
   A–D + the fail-closed FR↔UC coverage. This is the only lens that benefits from being a schema node
   (it depends on the *whole* spine being present), and it gives the migration a place to re-introduce
   the **fail-closed** behaviour OpenSpec's philosophy otherwise drops. Model it on `verify-change.ts`'s
   report structure, but check *artifact-internal* coverage, not implementation.
3. ✗ **One lens = one artifact** — rejected. You'd need N copies of each lens (one per position) and you'd
   distort a cross-cutting check into a node, losing exactly what makes it step-agnostic.

Net: **lenses 1–5 stay as skills (option 1); `trace-check` additionally gets a `review` node (option 2);
`tracker-trace-check` survives only if the GitHub tracker survives (§8).**

## 5 · Guardrails → `config.yaml` (the cleanest mapping in the whole exercise)

`gr_*.md` is *content*, and OpenSpec has two injection points purpose-built for it:

- **`context:`** — a tight digest of the always-on discipline (ubiquitous language L1/L6, greenfield
  Pareto G1/G3/G9/G10, "infrastructure out of the domain" A9/A10). Injected into **every** artifact.
  50 KB cap → digest, don't paste the gr files. Mirror of the `project.md → config.yaml` migration the
  OpenSpec guide itself prescribes (`docs/migration-guide.md`).
- **`rules:`** keyed by artifact `id` — the *per-artifact* gr subset. The `skills_overview.md` "Relation
  to guardrail items" sections are already exactly this list:

```yaml
rules:
  requirements: [ "Use glossary terms verbatim (L1)", "Flag, never coin, new terms (L6)",
                  "Carry non-goals into Out-of-Scope (Aln15)", "requirements.md SUMMARIZES alignment (Aln13)" ]
  entity-model: [ "Classify every term Entity/VO/Aggregate (D1/D2/D5)", "No surrogate ids / infra in conceptual mode (A9)" ]
  specs:        [ "RFC-2119 SHALL/MUST", "Given/When/Then scenarios", "≥1 scenario per requirement" ]
```

This is the single highest-leverage, lowest-risk piece of the migration and is reversible.

## 6 · `milestone` ≡ `change` — the conceptual bridge

`milestone_review.md` concluded a milestone is "the in-scope slice one PRD-loop iteration ships," declared
up front by `declare-milestone`, feeding a milestone-bound vision, **without forking the spine**. OpenSpec
*is built around exactly this unit*: a **change** is "one planned piece of work … a self-contained folder."
So:

- `declare-milestone` ≈ `/opsx:new <change>` (scaffold) + `.openspec.yaml` (record the committed
  capability/`F`-set + predecessor as metadata). The Pareto/dependency/shipped-state selection logic stays
  — it just writes a change folder instead of a `## Milestones` register line.
- **The milestone-N+1 loop-back is where OpenSpec pays off.** Today ai-mail re-runs the whole chain per
  milestone. OpenSpec instead opens a **new change** whose `specs/` are **deltas** (`ADDED`/`MODIFIED`/
  `REMOVED`) against the accumulated `openspec/specs/`, and **archive** merges them. The spine is *not*
  forked (satisfying `milestone_review.md` §5); the source of truth **accretes**. This is strictly better
  than the status-column reconstruction for N≥2.

## 7 · Stable IDs & traceability vs. named requirements

OpenSpec specs use `### Requirement: <name>` (no numeric IDs); ai-mail's `trace-check`,
`tracker-trace-check`, `usecase-spec`, and `spec-to-prd` hinge on `FR/NFR/UC/BR/ADR-###` IDs. Two paths:

- **(A, recommended) Keep ai-mail IDs *inside* OpenSpec templates.** Templates are fully user-owned, so
  `### Requirement: FR-001 — <name>` is legal and free. Crucially, the ai-mail lenses already **discover
  id patterns from the files** (`trace-check` "discovers conventions rather than assuming them"), so they
  keep working against OpenSpec-housed artifacts with **no change**. Cost: near-zero.
- **(B) Adopt named requirements, rebuild traceability around names.** Aligns with vanilla OpenSpec and
  its `verify`, but throws away the ID-based traceability the whole AIUP chain is built on. Cost: high.

Take (A). The FR→Requirement and UC-scenario→Scenario shapes line up so well that ai-mail's use-case
scenarios *are* OpenSpec scenarios with IDs bolted on.

## 8 · The tracker boundary — keep GitHub, or go in-repo?

ai-mail Phase 4 projects the spine onto **GitHub issues** (`spec-to-prd` → `to-issues` → `triage`, audited
by `tracker-trace-check`). OpenSpec has **no tracker** — "done" = `archive` merges deltas into
`openspec/specs/`. Two models:

- **Hybrid (recommended).** OpenSpec owns *planning + spec evolution* (the spine, `specs/`, archive).
  `spec-to-prd`/`to-issues` stay as the **bridge to GitHub** for AFK-agent *execution*; `tdd` ≈ `apply`.
  `tracker-trace-check` becomes the `openspec/specs ↔ tracker` drift audit. You keep the AFK-agent issue
  flow ai-mail already invested in, and gain OpenSpec's spec accretion.
- **Pure OpenSpec.** Drop the GitHub projection; execute via `tasks.md` + `/opsx:apply`. Simpler, but
  loses the issue-tracker/triage machinery and the `ready-for-agent` AFK loop. Only worth it if the
  GitHub tracker is not actually load-bearing.

**Resolution (DEC2): sequenced, not chosen.** **Milestone 1 (Basic) adopts Pure** (smallest surface — the
spine on OpenSpec, in-repo, no tracker; `spec-to-prd`/`to-issues`/`tracker-trace-check`/`triage` are out of
scope). **Milestone 2 (Full) adds the Hybrid GitHub bridge** on top of the proven Basic spine. So Pure is
not a rejected option — it is the first slice; Hybrid is the second. The two-milestone work-item plan below
is organised this way.

## 9 · The honest tensions (what the migration costs)

1. **Rigor vs. fluidity.** ai-mail's worth is *fail-closed coverage + HITL between every step*. OpenSpec
   removes gates by design. `requires` gives ordering, not gates. **Mitigation:** the lenses (§4 option 1)
   + the `review` node (§4 option 2) + HITL phrasing in `instruction`s re-introduce the gates as
   *discipline*, not *engine-enforced*. Accept that some rigor moves from "the tool blocks you" to "the
   instruction tells you to block yourself."
2. **Delta model reshaping.** To get the §6 payoff you must express the behaviour-contract layer (FRs +
   use-case scenarios) as `openspec/specs/<cap>/spec.md`. The upstream reasoning artifacts (vision,
   entity model, ADRs, testing) stay as plain planning artifacts. That reshaping is real work for the
   *requirements + use-case* artifacts specifically.
3. **Two engines, one job.** Adopting OpenSpec means **retiring or subordinating** `workflow.md` as the
   orchestrator and letting `openspec` own state. Half-adopting (OpenSpec for some steps, hand-rolled for
   others) is the worst outcome — two sources of truth for "what's next." → flagged HITL (§D-DEC1).
4. **WIP target.** The skillset is mid-refactor (`todo.md`: `declare-milestone` just built,
   `domain-requirements` being made generic, `skill_genericity_review.md` open). Migrating now means
   re-transcribing every artifact again after the refactor lands.

## 10 · Recommendation

**Yes — host the ai-mail authoring chain on OpenSpec as a custom schema, keeping the lenses as composed
skills, staged as two migration milestones (Basic/Pure → Full/Hybrid) and sequenced after the genericity
refactor.**

Target architecture:

- A project-agnostic custom schema (generic name, e.g. `spec-spine`) = the §3 artifact DAG.
- `config.yaml` = guardrail digest (`context`) + per-artifact gr subsets (`rules`), §5.
- Lenses = unchanged portable skills, referenced from `instruction`s; `trace-check` also a `review` node, §4.
- `milestone` ≡ `change`; N+1 via delta specs + archive, §6. Stable IDs kept in templates, §7.
- GitHub execution tracker (`spec-to-prd`/`to-issues`) is **Milestone 2 (Full)** only; **Milestone 1
  (Basic)** executes in-repo via `tasks.md` + `/opsx:apply`. OpenSpec owns the spine throughout, §8.
- `review-skills`/`refactor-skills` untouched (they maintain the *skills*, which now also includes the
  schema/templates — a small extension, not a rewrite).

**Why this honours "don't reinvent":**

- **From OpenSpec** ← the DAG engine + CLI state machine (`status`/`instructions`/`apply`/`archive`), the
  change-folder + delta-spec + archive→specs accretion, `config.yaml` injection, cross-editor skill
  generation. *Replaces* the hand-rolled `workflow.md`/`create_skills.md` orchestration and the
  per-milestone "re-run the chain."
- **From aiup/ai-mail** ← the *content*: authoring instructions, the gr rule-mappings, the lenses, the
  stable-ID traceability, `declare-milestone`, `testing-strategy`. *Becomes* `instruction`/`template`/
  `rules` + composed skills.
- **From matt_pocock** ← `spec-to-prd`/`to-issues` (GitHub bridge) + `tdd` (≈ `apply`) + `prototype`/
  `bmad-brainstorming`/`grill-with-docs` for inception.
- **From the guardrails** ← `context` digest + per-artifact `rules`.

**Why not yet:** the build (the two-milestone Part A/B below) is ~1–2 focused sessions of transcription that must be redone
if the artifacts shift. Do the genericity refactor first; this plan is written so it can be picked up
unchanged when that lands. A cheap, reversible **first taste** is available immediately (§A0): `config.yaml`
context/rules against the *default* `spec-driven` schema — no schema authoring, proves the guardrail
injection, throwaway.

---

## Evidence index

- `package.json`:version → **1.4.1**.
- `docs/opsx.md`:55–58,592–606,624–645 — schema DAG (`id/generates/requires/template/instruction`),
  `schema fork/init/validate/which`, "dependencies are enablers, not gates."
- `docs/concepts.md`:196–344,490–549,646–700 — specs vs. changes, delta specs (ADDED/MODIFIED/REMOVED),
  archive→specs merge, `### Requirement:`/`#### Scenario:` format.
- `docs/customization.md`:60–80,150–200,340–351 — `context`/`rules` injection (`<context>`/`<rules>`),
  schema fields, community-schema distribution model.
- `docs/migration-guide.md`:160–256 — `project.md → config.yaml` (the guardrail-injection precedent).
- `schemas/spec-driven/schema.yaml` — the canonical artifact-DAG + `apply:` block this plan forks.
- `src/core/templates/workflows/{continue,verify}-change.ts` — generated skills are thin CLI drivers
  (`openspec status/instructions --json`); `verify` is impl-vs-spec, not artifact-internal (the lens gap).
- `skills/workflow.md` — the existing hand-rolled DAG (= the schema, pre-transcription).
- `skills/skills_overview.md` "Relation to guardrail items" per skill — = the per-artifact `rules:` lists.
- `skills/skillfactory/milestone_review.md` §2–§6 — milestone ≡ change; "no per-milestone spine fork."
- `coding/gr/gr_*.md` — the rule clusters that become `context` + `rules`.

---

## Work items — orchestrated migration plan (2 milestones)

> Staged as **Milestone 1 — Basic (Pure OpenSpec)** then **Milestone 2 — Full (Hybrid + GitHub bridge)**
> (DEC2). In a fresh session, tell the agent: *"apply the Milestone 1 Part A build in
> `skills/skillfactory/openspec_migration_review.md` using sub-agents."* Each Part A is
> documentation/config only and self-contained. **Do not start Milestone 1 until D-DEC3/D-DEC4/D-DEC5 are
> settled with the human** (D-DEC1/D-DEC2 are decided) — they fix Milestone 1's schema shape. **Milestone 2
> starts only after Milestone 1 is proven (M1-B1).**

### Orchestration rule (same as `milestone_review.md` §8 / `create_skills.md`)

Carried out by a single **driver session** that spawns **one cold sub-agent per unit**, runs them
**strictly sequentially in number order, never in parallel**, and flips each `- [ ]` to `- [x]` **only
after** that sub-agent reports its POST self-check passed. On a blocker the driver leaves the box `- [ ]`,
appends `> blocked: <reason>` after the heading, continues with the rest, and surfaces all blockers at the
end. Each unit is self-contained: the driver hands its sub-agent the matching unit block **plus** §1–§10 of
this review **plus** the named target files — nothing else.

**Ordering:** within each milestone, **`*-A1` produces the schema skeleton the later `*-A#` fill**, so A1
completes first; **Part B (validate) runs after Part A**; **Milestone 2 runs only after Milestone 1's B1
proves the spine.** The still-open D-DEC3/D-DEC4/D-DEC5 fix Milestone 1's schema shape and must be settled
first. **No skill is *run* in any Part A** (it authors schema/config *text*), so no run-time HITL gate
fires; a sub-agent hitting a genuinely unspecified choice **stops and records `> blocked:`** rather than
guessing.

> **Not autonomous — flagged HITL (prerequisites, excluded from the autonomous run).** These are
> product/architecture forks the skillset gates on a human, and each is **ADR-worthy**. They must be
> decided (and ideally captured as ADRs via `adr-threshold-gate`) **before** Part A:
>
> - **D-DEC1 · Orchestrator — ✅ DECIDED (2026-06-09): OpenSpec replaces `workflow.md` as the single
>   authoritative orchestrator.** `schema.yaml` becomes the one source of "what's next"; `workflow.md`'s
>   content is **harvested, not duplicated** — Job A (ordering) → `requires` edges; Jobs B & C
>   (between-step HITL reviews + operational sub-procedures like the 5a–5f gap loop) → node `instruction`s
>   + the `review` node. **Enable the EXPANDED profile** (`/opsx:continue` one-artifact-at-a-time — *not*
>   core `/opsx:propose`, which generates the whole spine in one shot and would destroy
>   review-between-every-step). **Gate handling:** the mechanical coverage/trace gate is a **fail-closed
>   `review` node** (sub-fork option 2); the soft "human, look at this" reviews are the
>   stop-after-each-`/opsx:continue` pauses + instruction-tail prompts (option 1). **Lenses are relocated,
>   not removed** — their SKILL.md files stay portable; only their standalone workflow lines disappear,
>   moving into node `instruction`s (+ lightweight `config.yaml` reminders), with `trace-check` promoted to
>   the `review` node. `workflow.md` is **retired-but-kept** as an annotated "harvested-from" source map
>   until B1 proves the schema, then archived. Phase-0 setup folds into `openspec init` + `config.yaml` +
>   the kept `/setup-matt-pocock-skills`.
> - **D-DEC2 · Tracker boundary — ✅ DECIDED (2026-06-09): sequenced, not chosen.** **Milestone 1
>   (Basic) = Pure** (in-repo; `spec-to-prd`/`to-issues`/`tracker-trace-check`/`triage` out of scope);
>   **Milestone 2 (Full) = Hybrid** (adds the GitHub bridge on the proven Basic spine). §8.
> - **D-DEC3 · ID convention — ✅ DECIDED (2026-06-09): keep stable IDs.** `FR/NFR/UC/BR/ADR-###` IDs are
>   carried verbatim in the templates (`### Requirement: FR-### — <name>`); the lenses discover ID patterns
>   so traceability keeps working unchanged. §7.
> - **D-DEC4 · Delta adoption — ✅ DECIDED (2026-06-09): adopt (10-node Basic).** The behaviour-contract
>   layer is a `specs` node generating `specs/**/*.md` delta specs that accrete into `openspec/specs/` on
>   archive (the §6 N+1 payoff). This makes Milestone 1 a **10-node** schema (adds `specs` between
>   `use-cases-spec` and `review`). §6, §9.2.
> - **D-DEC5 · Timing — partly resolved.** The Basic→Full split *is* the sequencing answer. Open part:
>   start **Milestone 1** now, or after the genericity refactor settles? (Recommend after — §10.)

## Milestone 1 — Basic (Pure OpenSpec; in-repo, no tracker)

**Goal.** The full ai-mail authoring spine running end-to-end on OpenSpec, entirely in-repo. Execution is
`tasks.md` + `/opsx:apply`; "done" is `/opsx:archive` merging the change's delta specs into
`openspec/specs/`. **Out of scope (→ Milestone 2):** `spec-to-prd`, `to-issues`, `triage`,
`tracker-trace-check`.
**Nodes (10):** `vision`, `glossary`, `requirements`, `entity-model`, `use-cases-diagram`,
`use-cases-spec`, `specs` (behaviour-contract deltas → `openspec/specs/`), `review`, `testing`, `tasks`
(no `prd` node — Pure mode ends the planning DAG at `tasks`; DEC4 = adopt).
**Lenses:** language-guard, scope-cut, adr-gate, constraint-sweep (composed into nodes) + trace-check (the
`review` node). **Not** tracker-trace-check.

### Milestone 1 · Part A — author schema, templates & config (documentation/config-only)

**- [ ] M1-A0 · Reversible smoke test — `config.yaml` on the default schema (no schema authoring)**
- **Files:** a throwaway `openspec/config.yaml` (+ `openspec init` in a scratch dir, or the repo if safe).
- **Change:** write only `schema: spec-driven` + a tight guardrail `context:` digest + one `rules:` entry,
  run `/opsx:propose` on a trivial idea, confirm the `<context>`/`<rules>` injection lands in the produced
  artifact. Prove the §5 mechanism end-to-end before committing to the full schema.
- **POST:** an `openspec` change was produced whose generation visibly honoured the injected context/rules;
  no custom schema authored yet; scratch artifacts discardable.

**- [ ] M1-A1 · Scaffold the Basic schema by forking `spec-driven`**
- **Files:** `openspec/schemas/<spine-name>/schema.yaml` + `templates/` (via `openspec schema fork spec-driven <spine-name>`).
- **Change:** fork, then lay down the **Basic node skeleton** — the 10 nodes above (incl. the `specs` delta-spec node, D-DEC4), `requires` per §3, and
  the `apply:` block tracking `tasks.md`. **No `prd` node.** Node `id`s, `generates`, `requires` only
  (instructions/templates filled by M1-A2/A3). Keep the schema name and every node body **generic**
  (`skills/CLAUDE.md`); no ai-mail term. Run `openspec schema validate`.
- **Idempotent:** if the schema folder exists, verify it matches §3 rather than re-forking.
- **POST:** `openspec schema validate <spine-name>` passes; node set = the 10 Basic nodes (no prd/tracker
  nodes); `requires` edges match §3; no project-specific identifiers.

**- [ ] M1-A2 · Fill each authoring node's `instruction` from its SKILL.md (+ composed-lens lines)**
- **Files:** `openspec/schemas/<spine-name>/schema.yaml`.
- **Change:** for each authoring node, distill the matching SKILL.md's *process + POST self-check* into the
  node `instruction`, and append the composed-lens invocation line (§4 option 1: language-guard,
  scope-cut, adr-gate, constraint-sweep as the node calls for). Generic; project values via `config.yaml`.
  Carry stable IDs per D-DEC3. **The `specs` node has no 1:1 SKILL.md** — its `instruction` is the
  FR + use-case-scenario → delta-spec projection (D-DEC4): one `### Requirement: FR-### — <name>` per
  in-scope FR, `#### Scenario` blocks from the use-case flows, IDs carried into the headings.
- **POST:** every authoring node's `instruction` is traceable to its SKILL.md; lens invocations present
  where the SKILL.md composed them; no project specifics.

**- [ ] M1-A3 · Author the `templates/*.md`**
- **Files:** `openspec/schemas/<spine-name>/templates/*.md` (one per node).
- **Change:** transcribe each artifact's output skeleton (vision, FR/NFR/C/OOS tables, entity-table
  layout, PlantUML skeleton, use-case-spec layout, testing-entry layout, tasks checklist) into a template
  with HTML-comment guidance, **carrying stable-ID placeholders** per D-DEC3. For the behaviour-contract
  layer, use OpenSpec's `### Requirement:`/`#### Scenario:` shape per D-DEC4.
- **POST:** one template per node; ID placeholders present; behaviour-contract templates use the
  Requirement/Scenario shape; generic.

**- [ ] M1-A4 · Write `config.yaml` — guardrail `context` + per-artifact `rules`**
- **Files:** `openspec/config.yaml`.
- **Change:** distill the always-on gr discipline into a ≤50 KB `context:` digest; transpose each
  `skills_overview.md` "Relation to guardrail items" list into `rules:` keyed by the node `id` (§5).
- **POST:** `context` under cap; every `rules:` key is a real Basic-node `id` (`openspec schemas --json`
  clean); rule lists trace to the overview.

**- [ ] M1-A5 · Add the `review` (verify-style) fail-closed gate node**
- **Files:** `schema.yaml` (`review` node) + `templates/review.md`.
- **Change:** add a `review` node `requires: [specs, use-cases-spec, entity-model]` whose `instruction` runs
  `trace-check`'s Check 0 + A–D and the fail-closed FR↔UC coverage, emitting a PASS/PARTIAL/BREAKS report
  (model on `verify-change.ts` structure, but artifact-internal). This is where the §9.1 rigor lost to
  "no gates" is re-introduced.
- **POST:** `review` node validates; its instruction enumerates Check 0/A–D + FR↔UC coverage; fail-closed
  wording present; generic.

**- [ ] M1-A6 · Keep/adapt the `tasks` node + `apply:` block (Pure-mode execution)**
- **Files:** `schema.yaml` (`tasks` node + `apply:`), `templates/tasks.md`.
- **Change:** the `tasks` node (`requires: [use-cases-spec, testing]`) generates the implementation
  checklist **directly from the spine** — this replaces the tracker projection in Pure mode. Confirm
  `apply.tracks: tasks.md`; reference the `tdd` skill's discipline from the `apply` instruction.
- **POST:** `tasks` node + `apply:` validate; tasks derive from the spine; `/opsx:apply` can track them.

**- [ ] M1-A7 · Update the skillfactory docs (Basic scope)**
- **Files:** `skills/workflow.md`, `skills/skills_overview.md`, `skills/artifacts.md`.
- **Change:** `workflow.md` → mark it **retired-but-kept** as the "harvested-from" source map and name
  `schema.yaml` the authoritative sequence (D-DEC1); `skills_overview.md` → note each authoring skill's
  node `id` and each lens's composed/`review` role; `artifacts.md` → add the
  `docs/* → openspec/changes/<change>/ → openspec/specs/` location mapping (Basic). Annotate, don't delete.
- **POST:** the three docs cross-reference the schema; the authoritative orchestrator is stated once,
  unambiguously; no contradictory "what's next" sources remain.

### Milestone 1 · Part B — wire & validate (runs the CLI)

**- [ ] M1-B1 · End-to-end dry run + archive on a throwaway change**
- **Change:** `openspec schema validate`, then drive `/opsx:new` → `/opsx:continue` through the full DAG
  on a trivial scratch idea (each node reads its `dependencies`, honours `context`/`rules`); confirm the
  `review` node **blocks on a seeded coverage gap**; run `/opsx:apply` over `tasks.md`; run `/opsx:archive`
  and confirm the delta specs merge into `openspec/specs/`. Discard the scratch change.
- **POST:** every node creatable in order; `review` demonstrably fail-closed on a planted gap; archive
  merges deltas → `openspec/specs/`; no schema errors. **This is the gate Milestone 2 depends on.**

**- [ ] M1-B2 · Bridge `declare-milestone` ↔ change creation + the N+1 delta loop (no tracker)**
- **Change:** document how `declare-milestone` maps to `/opsx:new <change>` + `.openspec.yaml` metadata
  (committed `F`-set + predecessor), and how milestone N+1 opens a **delta** change against accumulated
  `openspec/specs/` with `archive` merging it. No GitHub hand-off in Basic.
- **POST:** a written milestone↔change bridge exists; N+1 delta loop described; `declare-milestone`'s
  selection logic preserved (only its output location moved).

---

## Milestone 2 — Full (Hybrid: + GitHub execution bridge)

**Goal.** Layer the GitHub tracker on the **proven** Basic spine, restoring the AFK-agent issue loop.
Adds the `prd` projection (`spec-to-prd`), `to-issues`, `triage`, and `tracker-trace-check`. "Done" is
**two-staged**: issues close on the tracker **and** the change archives into `openspec/specs/`.
**Prerequisite:** Milestone 1 complete and proven (M1-B1).

### Milestone 2 · Part A — add the bridge (documentation/config-only)

**- [ ] M2-A1 · Add the `prd` node (the `spec-to-prd` projection)**
- **Files:** `schema.yaml` (`prd` node) + `templates/prd.md`.
- **Change:** add `prd` `requires: [requirements, use-cases-spec, testing]` whose `instruction` is
  `spec-to-prd`'s projection — **links** the spine's `FR/UC/BR/ADR` IDs (restates no content; Doc5),
  authors fresh only the module + testing-decisions sections, publishes to the tracker reached abstractly
  via `docs/agents/issue-tracker.md`. Generic; tracker specifics never hard-coded.
- **POST:** `prd` node validates; instruction links IDs (no spine duplication); tracker reached abstractly.

**- [ ] M2-A2 · Wire `to-issues` as the post-`prd` step**
- **Files:** `schema.yaml` (terminal note / `apply` variant) + docs.
- **Change:** record that in Full mode the PRD is broken into tracer-bullet vertical-slice issues by the
  external `to-issues` skill. Decide and document whether this **supersedes** or **runs alongside** the
  Pure-mode `tasks` → `/opsx:apply` path, so there is one authoritative execution surface.
- **POST:** the `prd → to-issues → implement` path is documented; the Pure-mode `tasks` path's status in
  Full mode is stated explicitly (kept / superseded).

**- [ ] M2-A3 · Re-point `tracker-trace-check` at `openspec/specs ↔ GitHub`**
- **Files:** the inputs `tracker-trace-check` resolves (via its fallback chains — no hard paths).
- **Change:** the authoritative in-repo side is now `openspec/specs/` (+ the change folder), not `docs/`;
  the tracker side is the published PRD/issues. Confirm its convention-discovery still derives the ID
  families; run dangling-ref + forward-coverage + semantic-divergence.
- **POST:** `tracker-trace-check` resolves references against `openspec/specs/`; forward-coverage runs at
  the milestone marker; no hard-coded paths introduced.

**- [ ] M2-A4 · Confirm/keep the triage + issue-tracker wiring**
- **Files:** `docs/agents/{issue-tracker,triage-labels}.md` (read), docs.
- **Change:** verify the issue-tracker abstraction and the `ready-for-agent` / triage label vocabulary are
  still valid against the OpenSpec spine; the `triage` skill is unchanged.
- **POST:** tracker + triage wiring confirmed against the OpenSpec spine; no changes needed beyond docs, or
  the needed changes are listed.

**- [ ] M2-A5 · Update `config.yaml` + docs for Full/Hybrid**
- **Files:** `openspec/config.yaml`, `skills/{workflow,skills_overview,artifacts}.md`.
- **Change:** record the **two "done" surfaces**, the `milestone ≡ change ≡ (optional) GitHub-native
  Milestone` mapping (`milestone_review.md` §6), and the Full node set (adds `prd`). Switch the active
  config to Full.
- **POST:** docs describe the two-staged done + the milestone/change/GitHub-Milestone mapping; `prd` node
  present in the Full schema; `rules:` keys still valid.

### Milestone 2 · Part B — wire & validate

**- [ ] M2-B1 · End-to-end Hybrid dry run**
- **Change:** on a throwaway milestone, drive the spine → `prd` published → `to-issues` → run
  `tracker-trace-check`; confirm **forward coverage PASS** (every in-scope FR reached the tracker) and no
  dangling refs.
- **POST:** spine→PRD→issues path works; `tracker-trace-check` PASS (or its breaks are understood);
  scratch discarded.

**- [ ] M2-B2 · Document the two-staged "done" + milestone/GitHub-Milestone mapping**
- **Change:** write when issues close vs when the change archives, and how `tracker-trace-check` reconciles
  the tracker against `openspec/specs/` across the boundary.
- **POST:** a written "done" definition exists for Full mode; the reconciliation path is documented.

---

## Appendix · Quick mapping card

```
ai-mail                                   OpenSpec 1.4.1
─────────────────────────────────────     ─────────────────────────────────────
workflow.md (the sequence)            →    schema.yaml artifacts DAG
create_skills.md orchestration        →    openspec status/instructions/continue (CLI)
declare-milestone                     →    /opsx:new <change> + .openspec.yaml   (milestone ≡ change)
vision / requirements / entity-model  →    artifact nodes (instruction + template + requires)
  / use-cases / testing
FR/UC scenarios (behaviour contract)  →    openspec/specs/<cap>/spec.md  (### Requirement / #### Scenario)
milestone N+1                         →    delta change (ADDED/MODIFIED/REMOVED) + archive→specs
lenses (language/scope/adr/sweep)     →    composed portable skills (referenced from instructions)
trace-check (coverage/traceability)   →    a `review` (verify-style) artifact node
gr_*.md guardrails                    →    config.yaml: context (all) + rules (per-artifact)
spec-to-prd / to-issues / tdd         →    M1 Basic: tasks.md + /opsx:apply (pure) · M2 Full: + GitHub bridge
review-skills / refactor-skills       →    unchanged (skill maintenance, now incl. schema/templates)
```
