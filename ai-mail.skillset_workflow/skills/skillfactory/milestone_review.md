# Milestone — term analysis & workflow placement

**Date:** 2026-06-07
**Question:** What is a "milestone" in ai-mail? `M#` are modules, not milestones — so where are
milestones defined, what *is* one, and is there a missing workflow step? Should issues and artifacts
be milestone-scoped, and how?
**Method:** grep of `milestone` across the repo, the skills layer, and the matt_pocock plugin; read of
`workflow.md`, `01-foundation.md`, `CONTEXT.md`, `requirements.md`, the Family-A skills
(`spec-to-prd`, `testing-strategy`, `tracker-trace-check`), the pocock `to-prd` / `to-issues`, and
`plan/to-prd-review.md`.

> **Note (2026-06-09).** §3.5 (added later) supersedes the original §3 recommendation: the milestone is
> bound at **Phase 1** (the vision is already milestone-scoped), so it must be **declared up front by a
> `declare-milestone` skill that feeds the vision** — not split out late at Phase 3.5. Cross-referenced
> from [`skill_genericity_review.md`](skill_genericity_review.md).

---

## TL;DR

1. **"Milestone" is an undefined, silently-invented term.** It is **not** in the glossary
   ([docs/CONTEXT.md](../docs/CONTEXT.md)) and **not** in the matt_pocock skills at all (zero hits).
   It was introduced only by the **AIUP custom skill layer** as a loose synonym for **"scope marker"**
   — "the boundary that defines *now*."
2. **`M#` are modules/capabilities, not milestones** — confirmed by
   [01-foundation.md](01-foundation.md) ("M1–M6, M2b — capabilities") and
   [CONTEXT.md](../docs/CONTEXT.md) ("a suite of mailbox-assistance modules (M1–M6)… M2 is the first
   module"). They decompose *functionality*, not *delivery*.
3. **The de-facto current milestone *is* a single module: M2 (= v1).** It is never named "milestone"
   anywhere; it is *reconstructed* at Phase 4 from the `requirements.md` `Status` column (`Open` = M2,
   `Deferred` = M2b/M3/M4). So today milestone ≡ module purely by the build strategy
   ("ship one module at a time"), not by definition.
4. **There is a real workflow gap:** no step *declares* the milestones and their order. The milestone
   is only ever *resolved as a side effect* of `pareto-scope-cut` + the `Status` column. That is the
   "missing step" the question senses.
5. **Recommendation:** keep the word "milestone," **define it once in the glossary**, distinguish it
   crisply from "module," add an explicit "declare the milestone" step, and map it to **GitHub's native
   Milestone** for tracker grouping. **Do *not* fork the spine into per-milestone folders** — that
   breaks the single-source-of-truth / ubiquitous-language invariant the whole AIUP chain exists to
   protect.

---

## 1 · Where the term lives (evidence)

### 1a · It is NOT in the matt_pocock plugin
`grep -i milestone` over `matt_pocock_skills/` → **0 hits.** The pocock chain has no milestone concept:

- `to-prd` produces **one PRD per conversation/feature** (synthesize current context, sketch modules,
  publish). No scope-marker, no milestone.
- `to-issues` breaks a plan into **vertical-slice / tracer-bullet issues**. No milestone grouping —
  issues relate to each other via **"Blocked by"** only.

So "milestone" is a **pure AIUP-layer addition**, layered on top of pocock's PRD→issues flow to bound
each PRD-loop iteration.

### 1b · It IS in the AIUP custom layer — as "scope marker"
Every Family-A use is a synonym for **scope marker = "the boundary that defines now"**:

| File | Use of "milestone" |
|---|---|
| [skills/workflow.md](../skills/workflow.md):100,116 | "Loop the whole chain once **per in-scope milestone** — one PRD per milestone" |
| [skills/skills_overview.md](../skills/skills_overview.md):169 | scope marker = "typically a **milestone/phase marker** named in a planning doc… NEVER guessed, names never hard-coded" |
| [skills/spec-to-prd/SKILL.md](../skills/spec-to-prd/SKILL.md):54 | "**Scope marker (the milestone)** — resolve in this order: arg → requirements `Status` split → ask" |
| [skills/testing-strategy/SKILL.md](../skills/testing-strategy/SKILL.md):97 | identical scope-marker resolution; output `docs/testing/<milestone>.md` |
| [skills/tracker-trace-check/SKILL.md](../skills/tracker-trace-check/SKILL.md) | scope marker = "the milestone whose in-scope set defines what *must* be on the tracker" |
| `pareto-scope-cut`, `adr-threshold-gate`, `usecase-spec`, `usecase-diag` | reference "milestone/phase marker" as the scope boundary |

**Crucial design intent:** the skills deliberately treat "milestone" **generically** — "no milestone
names hard-coded… the marker is read generically" ([skills_overview.md](../skills/skills_overview.md):169).
The skills are correct to stay generic. The gap is **downstream**: the *project* never pins down what its
own milestones actually are.

### 1c · The other skill that uses it (answering the question directly)
The question asks "testing-strategy uses milestones — which skill *also* does?" Answer: **almost the
whole Phase-3/Phase-4 chain.** The shared scope-marker resolution is used verbatim by
**`spec-to-prd`, `testing-strategy`, `tracker-trace-check`, `pareto-scope-cut`, `usecase-diag`,
`usecase-spec`, and `adr-threshold-gate`** (see [to-prd-review.md](to-prd-review.md):609 "the Phase-4
and use-case skills share one scope-marker resolution chain"). `testing-strategy` is just the most
*visible* user of it because it bakes the milestone into a **filename** (`docs/testing/<milestone>.md`).

---

## 2 · What a milestone actually *is* (proposed definition)

The skills conflate three things that are worth separating:

| Concept | What it is | ai-mail today |
|---|---|---|
| **Module** (`M#`) | a unit of **functionality decomposition** — a deep, testable capability composed of `F##` primitives | M1–M6, M2b |
| **Scope marker** | the **mechanism** the skills use to resolve "what's in scope now" (arg → `Status` split → ask) | the `Open` vs `Deferred` split in `requirements.md` |
| **Milestone** | the **unit of delivery**: the in-scope slice shipped by *one* PRD-loop iteration | **v1 = M2** (the `Open` set) |

> **Proposed glossary definition.**
> **Milestone** — the in-scope slice of the spec spine delivered by one iteration of the Phase-4 PRD
> loop (one thin PRD + one `docs/testing/<milestone>.md` + its tracer-bullet issues). Resolved via the
> **scope marker** (the `requirements.md` `Status`/scope split). A milestone *may* coincide with a
> single **module** (in v1 it is M2) but is **not** the same concept: a milestone is a delivery
> boundary, a module is a functionality boundary. One milestone can bundle several modules, or split
> one module across iterations.
> *Avoid:* using "milestone" and "module" interchangeably; using "M#" to mean a milestone.

**Why milestone ≠ module even though they coincide now:**
- M2 → M2b is explicitly *"M2 must ship first"* ([01-foundation.md](01-foundation.md):126) — two
  deliveries, where M2b *extends* M2's substrate. That is two milestones over a module family.
- M2 itself routes **by Sender only**; type-classification (FR-003) is deferred. A future split could
  make "M2 phase 2" a milestone without being a new module.
- The substrate primitives (F02/F04/F06/F22) are **reused across M1/M2b/M3/M4** — so the entity model
  is inherently cross-milestone and must **not** be forked per milestone (see §5).

---

## 3 · Where milestones are *defined* today (and the missing step)

Currently a milestone is **never declared** — it is **reconstructed** from three scattered signals:

1. [workflow.md](../skills/workflow.md):46 — Phase 2 step 7: *"apply Pareto (defer features to later
   milestones)"* — first mention; defers features but names no milestone.
2. [workflow.md](../skills/workflow.md):61 — Phase 3 step 2: `pareto-scope-cut` → "defer M2b/M3/M4" +
   appends a **Postponed-decisions log**.
3. [requirements.md](../docs/requirements.md):13-26 — the **`Status` column** (`Open` = in scope for
   v1/M2, `Deferred` = M2b/M3/M4). FR-003 literally reads *"Deferred to M2b."*

The build **order** decision ("start with M2, then M2b…", 2026-05-30) lives in
[01-foundation.md](01-foundation.md):246 — a *plan* doc the skills treat as **background only**
([to-prd-review.md](to-prd-review.md):153 "Capability/build-order plan → Background only").

**=> The missing step.** There is no workflow step named *"declare the milestones and their order."*
The milestone is an emergent property of the `Status` column, resolved opportunistically at Phase 4.
For a single-module v1 this works (the `Open`/`Deferred` split is unambiguous). It will **break** the
moment there are 3+ deliverable slices with no single `Open`/`Deferred` line to separate them — exactly
the case `spec-to-prd` handles by **"ask the human… only if genuinely ambiguous"**
([spec-to-prd/SKILL.md](../skills/spec-to-prd/SKILL.md):60). That "ask" is a symptom of the missing
declaration, not a feature.

→ The fix is **not** a late Phase-3.5 step. The milestone is in fact chosen far earlier — **the vision
is already milestone-bound** — so it must be *declared* at Phase 1, before the vision. §3.5 is the
recommendation.

---

## 3.5 · Recommendation — declare the milestone at Phase 1, before the vision

### Evidence: the vision is already milestone-bound

[`docs/vision.md`](../../docs/vision.md) is titled **"Vision: M2 · Attachment Auto-Router"** and its
Scope section explicitly excludes the other capabilities: *"M1 / M3 / M4 / M5 / M6 capabilities — out
of scope for this product."* So the product was narrowed to **one capability (M2)** at the **vision**
step, and [`docs/requirements.md`](../../docs/requirements.md) merely **inherits** that scope — it
covers 1 of 7 capabilities and ~5 of ~32 `F##` primitives from [01-foundation.md](01-foundation.md),
*by design, not omission*.

### Consequence: a late split is the wrong fix

A late "declare milestones" step would assume `requirements.md` is a **product-wide, multi-milestone**
catalog needing splitting. It is not — it is single-capability **before Phase 3 begins**, because the
vision already chose. Such a step is therefore nearly **vacuous**: there is only ever one milestone in
scope, the one the vision picked. The real decision lives **upstream of the vision**.

### Three nested scope levels (where each narrowing actually happens)

| Level | Narrowing | Where it happens today | Owned by a skill? |
|---|---|---|---|
| **1 · product → capability/module** | "ship M2 first, not M1/M3/…" | **Phase 1** — `01-foundation.md` reach/squeeze prose (*"start with M2"*) + the **free-style vision-generation prompt** that inherits it | **No** |
| **2 · capability → milestone slice** | the `M2`-vs-`M2b` `Open`/`Deferred` cut inside `requirements.md` | **Phase 3** — `pareto-scope-cut`'s `## Scope split` | Yes (`pareto-scope-cut`) |
| **3 · within-milestone** | per-iteration build order | Phase 4 loop | n/a |

Level 1 — the most consequential scope decision in the whole chain — is the orphan. It is made by a
template + a hand-written prompt (the [`workflow.md`](../workflow.md) Phase-1 step *"Generate the
vision … according to `vision_template.md`"*), with **no skill, no guardrails, and no durable record**
beyond a dated prose line at the bottom of `01-foundation.md`. This is also the deepest form of the
*"no next-milestone handling"* gap the original `todo.md` sensed: when M2 ships, **nothing** drives
selecting and scoping M2b — its vision would be hand-prompted exactly as M2's was.

### Recommendation: a Phase-1 `declare-milestone` skill that feeds the vision

Add a skill (working name **`declare-milestone`**; naming is a detail — cf. `select-milestone`) that
runs **between Phase 1 step 1 (foundation) and step 2 (vision)**:

- **In:** the project's capability/build-order map (generic — capabilities, reach/effort,
  **dependencies**, build order; **no `M#`/`F##` hard-coding**, per [`skills/CLAUDE.md`](../CLAUDE.md)),
  plus what has already shipped.
- **Does:** select the **next** milestone respecting dependencies (e.g. *"M2's substrate must exist
  before M2b"*), Pareto (one slice at a time), and shipped state; record it durably — the glossary
  **Milestone** definition (§2) + a one-line milestone register (name, the capability/`F`-set it commits
  to, predecessor).
- **Out:** a **declared milestone** that becomes the **scope-defining input to the vision template** —
  so the vision is bound to a *declared* milestone, not an implicit one.

**The next-milestone loop-back this creates:** when milestone *N* ships, re-run `declare-milestone` → it
picks *N+1* (now-unlocked capabilities included) → a fresh vision for *N+1* → the spine chain repeats.
This makes **milestone ≡ one vision ≡ one PRD** clean end-to-end, matching the *"one PRD per milestone"*
settled decision downstream.

### What changes in the workflow

1. **Insert a Phase-1 step** before vision generation: `declare-milestone` → declare the milestone +
   record it.
2. **Reword the vision step** ([`workflow.md`](../workflow.md) Phase 1 step 2) from *"Generate the
   vision … according to `vision_template.md`"* to *"Generate the vision **for the declared milestone**
   …"* — making the milestone an explicit input, not a free-style inheritance.
3. **No late split step is needed** — the milestone is declared and recorded at Phase 1, so the
   `Status`-column reconstruction §3 diagnoses is no longer the only signal.

> **Still consistent with §5 (no spine fork) and §4 (GitHub Milestone).** `declare-milestone` records a
> milestone; it does **not** fork `requirements.md` / `entity_model.md` / `use_cases/` per milestone
> (§5 stands), and the recorded milestone name is what maps onto the GitHub native Milestone at publish
> time (§4 stands). It only adds the **up-front declaration**; the spine stays single.

---

## 4 · Are issues related to a milestone?

**Today: only indirectly, and not on the tracker.** The chain is:

```
milestone (scope marker)  →  one thin PRD (the "milestone index")  →  to-issues  →  tracer-bullet issues
```

[to-prd-review.md](to-prd-review.md):299 says it outright: *"using the PRD as the **milestone index**."*
So issues descend from a per-milestone PRD and are therefore milestone-scoped **by lineage** — but
nothing on the GitHub tracker records that grouping. The PRD is one issue; its slices are other issues;
they are linked only by "Blocked by" / "Parent" prose, not by a milestone field.

**Recommendation — use GitHub's native Milestone object.** The tracker is GitHub
([docs/agents/issue-tracker.md](../docs/agents/issue-tracker.md)), which has a first-class **Milestone**
(groups issues, progress bar, optional due date). Map the AIUP milestone onto it:

- When `spec-to-prd` publishes the PRD, create/assign a GitHub Milestone named after the scope marker
  (e.g. `M2 · Attachment Auto-Router`) and attach the PRD issue to it.
- When `to-issues` publishes the slices, assign each to the same Milestone.
- `tracker-trace-check`'s **forward-coverage** check then has a concrete tracker-side set to audit
  (every in-scope FR appears on an issue **within this milestone**), instead of inferring the grouping.

This needs a one-line convention added to [issue-tracker.md](../docs/agents/issue-tracker.md)
(`gh issue create … --milestone "<name>"`; `gh api` to create the milestone) — it does **not** require
changing the generic skills, which already speak of "the milestone whose in-scope set defines what must
be on the tracker."

---

## 5 · Should there be a milestone *folder* with artifacts beneath it?

**Question:** e.g. `milestones/M2/{requirements,use_cases,entity_model,testing,prd}.md`?

**Recommendation: NO — do not fork the spine per milestone.** Keep the current **artifact-typed**
layout with **in-file scoping**.

### Why the current layout is right
The AIUP chain's core invariant is **one evolving, ID-stable, glossary-anchored spine** — that is the
entire reason `spec-to-prd` is a *thin projection* and `trace-check`/`tracker-trace-check` can audit
traceability. Today only the artifacts that **genuinely differ per delivery** fan out per milestone:

| Artifact | Per-milestone? | Why |
|---|---|---|
| `docs/requirements.md` | **No** — single file, `Status` column scopes it | one ID space (`FR-###`), one ubiquitous language |
| `docs/entity_model.md` | **No** | substrate (F02/F04/F06/F22) is **shared** across M1/M2b/M3/M4 — forking it would duplicate & drift |
| `docs/use_cases/*.md`, `docs/use_cases.puml` | **No** | trace back to the single FR set |
| `docs/CONTEXT.md` (glossary) | **No** | one ubiquitous language for the whole product |
| **`docs/testing/<milestone>.md`** | **Yes** | depends on the *ephemeral module sketch* + chosen stack, which only exist at PRD time ([testing-strategy/SKILL.md](../skills/testing-strategy/SKILL.md):311) |
| **thin PRD** (on tracker) | **Yes** | the per-milestone projection of the spine |

### What a milestone folder would cost
Forking `requirements.md` / `entity_model.md` / `use_cases/` under `milestones/M2/` would:
- **fork the ubiquitous language** (two glossaries drift — the exact failure `ubiquitous-language-guard`
  exists to prevent),
- **duplicate the shared substrate** (F02/F04/F06/F22 live in M2 but are reused by M2b/M3/M4 — which
  folder owns them?),
- **break `trace-check`** (it audits one spine; N spines means N audits + cross-spine drift),
- contradict the **"thin PRD, duplicate nothing"** settled decision
  ([to-prd-review.md](to-prd-review.md):278).

### The middle ground (recommended)
**Keep one spine; fan out only the two delivery artifacts that already do, and add a tracker-side
grouping.** Concretely the "everything for M2 in one place" need is already met *without* a folder:

- **The PRD is the milestone index** (one place that links all of M2's in-scope FR/UC IDs).
- **`docs/testing/M2.md`** is the milestone's test plan.
- **GitHub Milestone `M2 · …`** groups the issues (§4).
- The `## Milestones` section in `requirements.md` (§3) is the ordered list.

If a per-milestone *landing page* is still wanted for navigation, make it a **thin index file**
(`docs/milestones/M2.md`) that **links** the PRD, `testing/M2.md`, the GitHub Milestone, and the
in-scope FR IDs — **never copies** them (Doc5). That is additive and cheap; a folder that re-homes the
spine is not.

---

## 6 · Alternative approaches considered

| Option | Verdict |
|---|---|
| **(A) Keep "milestone"; define it in the glossary; add the declare-milestones step; map to GitHub Milestone; one spine.** | **Recommended.** Minimal change, fixes the real gaps (undefined term + missing declaration + no tracker grouping) without touching the generic skills or forking the spine. |
| (B) Drop "milestone"; standardize on **"scope marker."** | Rejected — "scope marker" is a *mechanism*, awkward as the noun for "the thing we deliver"; and GitHub's object is literally called Milestone. |
| (C) Rename to "increment" / "release" / "epic." | Rejected — "milestone" is conventional, matches GitHub native, and is already pervasive in the skills. A rename is churn with no payoff. |
| (D) Make milestone ≡ module by definition (hard-bind `M#` = milestone). | Rejected — false in the M2→M2b case and whenever a module is split; would re-introduce the very conflation this review untangles. |
| (E) Milestone folder re-homing the spine (`milestones/M2/...`). | Rejected — forks the ubiquitous language + shared substrate, breaks `trace-check`, contradicts thin-PRD. See §5. |

---

## 7 · Concrete action list

1. **Glossary** — add the **Milestone** definition (§2) to [docs/CONTEXT.md](../docs/CONTEXT.md), with
   the "module vs milestone" distinction and an avoid-list entry. *(ubiquitous-language-guard would flag
   "milestone" as a silently-invented term today — this closes that.)*
2. **Workflow** — add a **Phase-1 `declare-milestone` skill** (§3.5) that runs before vision generation
   and feeds the vision its scope; reword the [workflow.md](../skills/workflow.md) Phase-1 vision step to
   *"for the declared milestone."* The milestone is declared up front, not re-derived from the `Status`
   column.
3. **Tracker convention** — add the **GitHub native Milestone** convention to
   [docs/agents/issue-tracker.md](../docs/agents/issue-tracker.md) (§4): PRD + its slice issues all
   assigned to a Milestone named after the scope marker.
4. **No spine fork** — record the decision **not** to create per-milestone folders (§5); optionally add
   a thin, link-only `docs/milestones/<name>.md` index if navigation is wanted.
5. *(Optional)* This term-introduction + the GitHub-Milestone mapping may be **ADR-worthy**
   (hard-to-reverse vocabulary + tracker-structure decision) — consider running `adr-threshold-gate` on
   this review.

---

## 8 · Autonomous build — apply the `declare-milestone` recommendation (D1–D5)

> In a fresh session, tell the agent: *"apply the D1–D5 build in
> `skills/skillfactory/milestone_review.md` using sub-agents."* This block is the complete,
> self-contained spec for that run. Every design choice is resolved in §2–§3.5 (the definition, the
> Phase-1 placement, the generic I/O, the next-milestone loop-back) so the run — driver **and**
> sub-agents — needs **no user interaction**.

### Orchestration rule (same as `to-prd-review.md` Part A / `create_skills.md`)

Carried out **autonomously, by the `create_skills.md` orchestration rule**: a single **driver session**
spawns **one cold sub-agent per unit**, runs them **strictly sequentially in number order (D1 → D2 → D3
→ D4 → D5), never in parallel** — and flips each `- [ ]` to `- [x]` **only after** that sub-agent
reports its POST self-check passed. On a blocker the driver leaves the box `- [ ]`, appends
`> blocked: <reason>` after the heading, continues with the rest, and surfaces all blockers at the end.

**Ordering across parts:** D1 appends the build spec that D5 consumes, so **all of Part A (D1–D4) must
complete before D5 runs** (mirrors `to-prd-review.md` A4 → Part B). Each unit is **self-contained**: the
driver hands its sub-agent the matching `D#` block, **plus** §2–§3.5 of this review (the source of every
change), **plus** the named target file — nothing else.

**No user interaction.** D1–D4 edit skillset *text*; D5 hand-authors a generic SKILL.md. None *run* a
skill, so no run-time HITL gate fires. If a sub-agent hits a genuinely unspecified choice it **stops and
records `> blocked:`** — it never asks the user and never guesses.

> **Not autonomous — flagged HITL (excluded from this run).** §7 items **1** (the `docs/CONTEXT.md`
> **Milestone** glossary definition) and **3** (the `docs/agents/issue-tracker.md` GitHub-Milestone
> convention) are **project-doc + vocabulary/tracker-structure decisions** that the skillset gates on a
> human: term introduction runs through `ubiquitous-language-guard`, and both are **ADR-worthy** (§7.5).
> They are **prerequisites done with a human**, not units here. `declare-milestone` functions without
> them (it records a milestone generically); they only make the ai-mail docs reflect it.

### Part A — adjust the skillset (documentation-only)

**- [x] D1 · `skills/skillfactory/create_skills.md` — append build spec #11 `declare-milestone`**
- **File:** [`skills/skillfactory/create_skills.md`](create_skills.md).
- **Change:** append a `### - [ ] 11 · `declare-milestone`` block in the existing `gr / In / Does / Out /
  POST` format, continuing the numbering (current max is #10). Content:
  - **Decision/rationale:** this review's §2–§3.5.
  - **gr:** stays **generic** — no `M#`/`F##`/project specifics in the SKILL.md (skills/CLAUDE.md);
    Pareto/one-slice (gr_greenfield) framing for "pick the next milestone."
  - **In:** the project's capability/build-order plan (arg → a conventional plan path → ask), plus
    already-shipped state; resolved by a fallback chain mirroring the glossary's.
  - **Does:** select the **next** milestone honouring build-order **dependencies** + Pareto + shipped
    state; record it durably (name, the capability/`F`-set it commits to, predecessor) in a
    project-designated location; HITL-confirm the choice.
  - **Out:** a **declared milestone** that becomes the scope-defining input to the vision step.
  - **POST:** one milestone declared (not many); dependencies respected; recorded with name/commitment/
    predecessor; no project-specific identifiers baked into the SKILL.md body.
- **Idempotent:** if #11 already exists, verify it matches this format rather than re-appending.
- **POST:** spec #11 exists as a `### - [ ] 11 · `declare-milestone`` block, numbering continuous from
  #10, carrying gr/In/Does/Out/POST; no duplicate block.

**- [x] D2 · `skills/workflow.md` — insert the Phase-1 `declare-milestone` step + reword the vision step**
- **File:** [`skills/workflow.md`](../skills/workflow.md).
- **Change:** in **Phase 1**, insert a step *before* vision generation: `declare-milestone` — declare +
  record the milestone from the capability/build-order plan. Reword the existing vision step from
  *"Generate the vision … according to `vision_template.md`"* to *"Generate the vision **for the declared
  milestone** …"*. Add a one-line note that the milestone is declared up front (no late `Status`-split
  reconstruction). Do **not** re-introduce a Phase-3.5 declare step.
- **POST:** Phase 1 names `declare-milestone` before the vision step; the vision step reads "for the
  declared milestone"; no Phase-3.5 declare step present.

**- [x] D3 · `skills/skills_overview.md` — add the `declare-milestone` entry**
- **File:** [`skills/skills_overview.md`](../skills_overview.md).
- **Change:** add a `## declare-milestone — authoring` entry (purpose / input artifacts / outputs / gr
  relation) consistent with D1's spec and the other entries; add it to the Contents list in run order
  (Phase 1, before the vision/requirements entries).
- **POST:** entry present with purpose/inputs/outputs/gr; listed in Contents; states it emits a declared
  milestone consumed by the vision step; no project specifics.

**- [x] D4 · `skills/artifacts.md` — add the milestone-register artifact row**
- **File:** [`skills/artifacts.md`](../skills/artifacts.md).
- **Change:** add a Phase-1 row for the **declared-milestone record** — **produced by**
  `declare-milestone`; **location** = the project-designated register (e.g. a `## Milestones` section in
  a planning doc, *not* a spine fork — see §5); **consumed by** the vision step and the Phase-4 PRD loop.
- **POST:** the row is present naming producer/location/consumer; it does **not** imply a per-milestone
  spine fork (consistent with §5).

### Part B — create the skill

**- [x] D5 · `skills/declare-milestone/SKILL.md` — hand-author the generic skill**
- **File:** new `skills/declare-milestone/SKILL.md` + the `.claude/skills/declare-milestone` junction.
- **Change:** hand-author per `create_skills.md` "How to build a skill here" (**not** `/make-skill`),
  building from spec #11 (D1) and §2–§3.5. **Generic body — no `M#`/`F##`/project terms** (skills/CLAUDE.md);
  project values arrive via args / fallback chains. Frontmatter `name` + trigger-rich `description`
  ("declare the next milestone", "select the milestone", "what ships next"). Process: resolve the
  capability/build-order plan → list candidate next milestones honouring dependencies + shipped state →
  pick the Pareto-minimal next slice → **HITL-confirm** → record (name, capability/`F`-set, predecessor)
  in the project-designated register → emit it as the vision step's scope input.
- **POST:** SKILL.md is generic (genericity self-check passes); declares exactly one milestone per run;
  honours dependencies; records name/commitment/predecessor; junction created.

---

## Appendix · Evidence index

- `grep -i milestone` (repo): 17 files — all in `skills/`, `plan/`, `todo.md`; **none** in `docs/*`
  except via skill-generated paths.
- `grep -i milestone` (`matt_pocock_skills/`): **0 hits.**
- [01-foundation.md](01-foundation.md):18-22,246 — `M#` = capabilities/modules; "build M2 first."
- [docs/CONTEXT.md](../docs/CONTEXT.md):3-6 — "modules (M1–M6)… M2 is the first module"; no "milestone."
- [docs/requirements.md](../docs/requirements.md):11-26 — `Status` column `Open`/`Deferred`; FR-003
  "Deferred to M2b."
- [skills/workflow.md](../skills/workflow.md):99-101,116-117 — "one PRD per milestone";
  `docs/testing/<milestone>.md`.
- [plan/to-prd-review.md](to-prd-review.md):257-299,609 — milestone-scoped PRDs; "PRD as the milestone
  index"; shared scope-marker resolution chain.
- matt_pocock `to-prd` / `to-issues` — PRD-per-feature + vertical-slice issues; no milestone.
