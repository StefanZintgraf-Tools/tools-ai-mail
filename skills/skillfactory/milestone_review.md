# Milestone — term analysis & workflow placement

**Date:** 2026-06-07
**Question:** What is a "milestone" in ai-mail? `M#` are modules, not milestones — so where are
milestones defined, what *is* one, and is there a missing workflow step? Should issues and artifacts
be milestone-scoped, and how?
**Method:** grep of `milestone` across the repo, the skills layer, and the matt_pocock plugin; read of
`workflow.md`, `01-foundation.md`, `CONTEXT.md`, `requirements.md`, the Family-A skills
(`spec-to-prd`, `testing-strategy`, `tracker-trace-check`), the pocock `to-prd` / `to-issues`, and
`plan/to-prd-review.md`.

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

### Recommended placement of an explicit step
Add a lightweight **"declare milestones"** step at the **end of Phase 3** (after `trace-check`, before
the Phase-4 PRD loop), because by then the in-scope FR/UC set is stable and traced:

> **Phase 3 → 3.5 · Declare milestones (HITL).** From the stabilized `requirements.md` `Status` split
> and the [01-foundation.md](01-foundation.md) build order, write an explicit, ordered milestone list
> into **one canonical place** (recommended: a short `## Milestones` section at the top of
> `requirements.md`, since that is the doc whose `Status` column already carries scope). Each milestone
> entry: name (e.g. `M2 · Attachment Auto-Router`), the FR/UC IDs it commits to, and its predecessor.
> The Phase-4 loop then *reads* this list instead of re-deriving scope each iteration.

This keeps the skills generic (they still resolve the marker via the `Status`/scope chain — the new
section just makes that chain unambiguous and explicit) while giving the project a single authoritative
answer to "what are our milestones and in what order."

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
2. **Workflow** — insert **Phase 3.5 · Declare milestones (HITL)** into
   [skills/workflow.md](../skills/workflow.md) (§3): write an ordered `## Milestones` section into
   `requirements.md` from the `Status` split + [01-foundation.md](01-foundation.md) build order.
3. **Tracker convention** — add the **GitHub native Milestone** convention to
   [docs/agents/issue-tracker.md](../docs/agents/issue-tracker.md) (§4): PRD + its slice issues all
   assigned to a Milestone named after the scope marker.
4. **No spine fork** — record the decision **not** to create per-milestone folders (§5); optionally add
   a thin, link-only `docs/milestones/<name>.md` index if navigation is wanted.
5. *(Optional)* This term-introduction + the GitHub-Milestone mapping may be **ADR-worthy**
   (hard-to-reverse vocabulary + tracker-structure decision) — consider running `adr-threshold-gate` on
   this review.

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
