# PRD generation × the spec-spine skillset — integration review

**Question.** How should the vendored matt-pocock **`to-prd`** skill be used together with this
**spec-spine skillset** (the Family-A authoring + lens skills in `skills/`)? What is missing, what
overlaps, and should we adjust the artifacts, the skill, or both?

**Scope of this review.** The skillset is meant to be **portable**: ai-mail is only the **greenfield
pilot** where we shake it down. The same skills must later run on other projects, including **complex
brownfield** code. So the recommendations below are written to hold in both settings; ai-mail is used
only as a concrete *example*, and greenfield-vs-brownfield differences are called out where they
matter.

**Source material.** `c:\PROJ\ai-knowhow\skills-plugins\matt_pocock_skills\skills\engineering\to-prd\SKILL.md` (vanilla `to-prd`), the spec spine described in
[`skills/artifacts.md`](../skills/artifacts.md) and [`skills/skills_overview.md`](../skills/skills_overview.md),
the run order in [`skills/workflow.md`](../skills/workflow.md), the per-repo wiring in
[`docs/agents/`](../docs/agents/), and a spot-check of [`docs/requirements.md`](../docs/requirements.md).

**One-line conclusion.** The vanilla `to-prd` *authors* requirements **from a conversation**; the
spec-spine skillset has already produced those requirements as a **higher-fidelity, ID-stable,
milestone-scoped file spine**. The fix is therefore **not** to feed `to-prd` more conversation — it is
to **redirect its input to the existing spine and make it a thin projection/packaging step rather than
an authoring step**, preserving the existing IDs and authoring only the two things the spine genuinely
lacks (module decomposition and a testing strategy).

---

## Part A — What the vanilla `to-prd` consumes and produces

### Inputs (vanilla)

| Channel | What it reads |
| --- | --- |
| **Conversation context** | The primary source. "Do NOT interview the user — just synthesize what you already know." |
| **Codebase** | Light exploration; sketch modules to build/modify. (Load-bearing in **brownfield**, near-empty in greenfield.) |
| **Glossary** (`docs/CONTEXT.md`) | Vocabulary used throughout the PRD. |
| **ADRs** (`docs/adr/`) | Decisions in the area being touched — must be respected. |
| **Prototype snippet** *(optional)* | A decision-encoding snippet may be inlined. |

Out of the box the skill reads **only** the glossary + ADRs from disk. It does **not** read
`requirements.md`, `entity_model.md`, or `use_cases/*.md` — it expects the rest in the live conversation.

### Process (vanilla)

1. Explore repo; use glossary vocabulary; respect ADRs.
2. **Sketch the major modules**; extract **deep modules** (simple interface, deep implementation,
   testable in isolation). HITL: confirm modules; ask which want tests.
3. Write the PRD from the template; **publish to the issue tracker** with `ready-for-agent`.

### Output (vanilla)

One **PRD published as a tracker issue** (`ready-for-agent`), sections: Problem Statement · Solution ·
User Stories (`As an <actor>, I want <feature>, so that <benefit>`) · Implementation Decisions ·
Testing Decisions · Out of Scope · Further Notes.

Downstream, **`to-issues`** slices the PRD into vertical-slice issues and **`tdd`** implements them.
The PRD is the hinge between *spec* and *tracker*.

---

## Part B — What the spec-spine skillset produces, and where each piece lands in a PRD

By the time the workflow reaches `to-prd` (Phase 4), the earlier phases have produced a spine. The
table is generic; the *ai-mail column* is just the concrete instance.

| Spine artifact (role) | Stable IDs | ai-mail instance | Natural PRD destination |
| --- | --- | --- | --- |
| Vision | — | `docs/vision.md` | **Problem Statement** + **Solution** |
| Pain / opportunity catalogue | `P##`/`A##` | `plan/painlist_*.md` | **Problem Statement** (background, not quoted) |
| Capability / build-order plan | `M#`/`F##` | `plan/01-foundation.md` | Scope rationale / **Out of Scope** (background) |
| Glossary | — | `docs/CONTEXT.md` | Vocabulary (already a vanilla input) |
| Requirements catalogue | `FR-###`/`NFR-###`/`C-###`/OOS | `docs/requirements.md` | **User Stories**, **Testing Decisions** (NFRs), **Implementation Decisions** + **Out of Scope** |
| Domain / entity model | aggregates/VOs/invariants | `docs/entity_model.md` | **Implementation Decisions** (schema, invariants) |
| ADRs | `ADR-####` | `docs/adr/####-*.md` | **Implementation Decisions** (already a vanilla input) |
| Use-case diagram | `UC-###` | `docs/use_cases.puml` | **User Stories** / behavioral coverage |
| Use-case specs | `UC-###`, `BR-###` | `docs/use_cases/*.md` | **User Stories** + acceptance hints |
| Postponed-decisions log | `G9` lines | appended by `pareto-scope-cut` | **Out of Scope** (with revisit triggers) |

**Confirmed by spot-check (ai-mail).** Requirements are already in the exact to-prd format — e.g.
*"FR-001 … As a mailbox owner, I want the system to detect mails carrying at least one attachment …
so that I do not have to scan my inbox manually"* — carrying priority, status (`Open`/`Deferred`),
milestone scope, and inline ADR references. NFRs carry explicit pass/fail thresholds. The
traceability the PRD would otherwise invent **already exists in the files.**

> **Brownfield caveat.** In a brownfield project the spine may be **partial or absent** at first.
> The skillset then either builds it (`domain-requirements`, `domain-model`, `usecase-spec`) or
> recovers it (`reverse-engineer`). The new PRD skill must therefore **degrade gracefully**: project
> whatever spine exists, and fall back to codebase-driven authoring (vanilla behavior) for the parts
> that do not exist yet. It is a *superset* of the vanilla skill, not a replacement that assumes a
> full spine.

---

## Part C — The crux: overlap, not absence

Mapping the PRD template onto the spine, almost every section is **already authored upstream at higher
fidelity**:

| PRD section | Already in the spine? | Gap? |
| --- | --- | --- |
| Problem Statement | ✅ vision + pains | — |
| Solution | ✅ vision golden-path | — |
| User Stories | ✅✅ requirements (verbatim format, stable IDs) + use-case scenarios | — |
| Implementation Decisions | ✅ ADRs + entity model + constraints | ⚠️ **module decomposition** absent |
| Testing Decisions | ◯ NFRs are testable, but no strategy/prior-art | ⚠️ **testing strategy** absent |
| Out of Scope | ✅✅ requirements OOS + vision OOS + postponed-decisions | — |
| Further Notes | free | — |

Two consequences:

1. **Redundant regeneration risk.** Run vanilla `to-prd` as-is and it re-derives user stories,
   problem, solution, and scope from conversation + codebase — discarding the
   `FR-###`/`UC-###`/`BR-###` IDs, risking glossary drift, and **duplicating an authoritative source**
   (the anti-pattern `gr_documentation.md` Doc5 warns against). It also under-uses the spine, never
   reading `requirements.md`/`entity_model.md`/`use_cases/`.

2. **The PRD's role changes.** Where the spine exists, the requirements artifact is `requirements.md`,
   not the PRD. The PRD becomes a **tracker-facing projection** of the in-scope spine plus the two
   missing implementation-shaped sections. It is a *transform*, not an origin.

---

## Option 1 — What is missing in the spine for ideal `to-prd` input

Only two things; everything else is present and richer than the template needs.

1. **Module / deep-module decomposition.** `to-prd` step 2 wants the major modules with deep, isolated,
   testable interfaces. The spine carries a *conceptual* model (entities ≠ modules); nothing names the
   public interfaces, the surface/core split as code units, or the test surfaces.
   - *Greenfield:* this is genuinely new design work (little/no code to extract from).
   - *Brownfield:* this is real extraction work that **needs codebase exploration** — exactly what the
     vanilla skill's step 2 already does.
   In **both** cases the right home is an **interactive step at PRD time**, not a pre-baked upstream
   artifact (see Option 3).

2. **Testing strategy.** Nothing in the spine states "what makes a good test here / which modules to
   test / prior art." NFRs give measurable thresholds (good raw material) but not a strategy.
   `gr_greenfield.md` `G8` (initial testing strategy) is a rule no skill currently owns.

---

## Option 2 — Extra spine artifacts as `to-prd` input: which make sense (why / why not)

"Extra" = everything beyond the vanilla skill's glossary + ADRs + conversation.

| Artifact | Use as input? | Why / why not |
| --- | --- | --- |
| Requirements catalogue | **Yes — primary** | It *is* User Stories + measurable NFRs + scope, with stable IDs. The single highest-value input the vanilla skill ignores. |
| Use-case specs + diagram | **Yes — strong** | Scenarios, alt-flows, business rules map cleanly to acceptance criteria; a use case is itself a vertical-slice candidate for `to-issues`. |
| Domain / entity model | **Yes** | Feeds Implementation Decisions and grounds the module sketch in real domain types. |
| Vision | **Yes** | Cleanest source for Problem Statement + Solution. |
| Postponed-decisions log | **Yes** | Best source for Out of Scope — already carries revisit triggers. |
| Pain catalogue | **Background only** | Great for *why*, but internal IDs should not leak into a published PRD. |
| Capability / build-order plan | **Background only** | Explains *why this milestone now*; internal IDs. Feed reasoning, don't quote. |
| Archives / human-scratch | **No** | Off-limits / not authoritative. |

Net: spine artifacts are excellent PRD inputs; the planning artifacts (`plan/*`) are useful *context
for synthesis* but should not be quoted into the published PRD (internal-ID hygiene).

---

## Option 3 — Adjust the skillset to emit better-compatible input (why / why not)

Targets the two gaps from Option 1.

### Module decomposition — do **not** pre-bake an upstream artifact

- **Greenfield:** a pre-committed module/interface document is **premature architecture** — the exact
  failure mode `pareto-scope-cut` (`gr_greenfield.md` G1/G5/G6) exists to prevent. Boundaries chosen
  before the first slice tend to be wrong and sticky.
- **Brownfield:** module boundaries depend on the *current code*, which the PRD step explores anyway;
  a stale upstream module doc would fight the real structure.
- The conceptual model already supplies the domain types the sketch needs; a parallel "module model"
  would duplicate and drift.

→ Keep module decomposition **interactive inside the PRD skill** (step 2), fed by the entity model +
use cases (+ codebase in brownfield). Revisit a standing module artifact only once real code exists
(`improve-codebase-architecture` is the better long-term home).

### Testing strategy — should it be its own artifact (e.g. `testing.md`)?

This *is* genuinely new information (unlike the PRD), so a new artifact does not violate the
no-duplication rule **provided it references NFR/constraint IDs instead of restating their thresholds**.
Pros/cons, weighted for context usage and reproducible AI behavior:

| | Separate `docs/testing.md` | Folded into `requirements.md` (block by the NFRs) |
| --- | --- | --- |
| **Reproducibility** | ✅ Dedicated file at a known path → deterministic input; `tdd`/PRD skill read it directly, no sub-section parsing | ◯ Skill must locate a sub-section in a large doc; fuzzier, more variable |
| **Context usage** | ✅ Loadable on its own; a skill that needs only the test strategy doesn't pull all FRs | ❌ Any skill reading requirements now also loads the strategy |
| **Duplication risk** | ⚠️ Must **reference** NFR-###/C-### thresholds, never copy them, or it drifts | ✅ Co-located with NFRs; reference is trivial |
| **Separation of concerns** | ✅ "How to verify" kept distinct from "what to build" | ❌ Mixes the two; bloats requirements |
| **Brownfield fit** | ✅ Natural home for *prior art* (existing test patterns/conventions) | ◯ Awkward to grow prior-art lists inside requirements |
| **Overhead** | ❌ One more artifact to keep fresh (trace-check/freshness must consider it) | ✅ No new artifact |

**Decision (settled):** a **dedicated `testing.md`** (strategy + module/test-surface picks + prior
art). Key rules that keep it from duplicating anything:

- **Thresholds stay in the NFRs** (`requirements.md`); `testing.md` holds only the *how*. Each entry
  opens with `Re: NFR-###` and adds the method — it never restates the bar. *(Example — NFR-002:
  the NFR says "0 duplicate writes"; `testing.md` says "run the batch twice through the apply surface
  against a temp Routing Root + temp ledger; assert 0 new files, 1 new provenance link; real temp FS,
  fake mail source.")*
- **Universal test philosophy stays in the `tdd` skill** ("test behavior through public interfaces");
  `testing.md` references it and carries only the *project-specific* parts (module/surface priorities,
  test-double policy at the real boundaries, prior art).

Why a dedicated file wins decisively: the strategy depends on the **module decomposition** (decided
at PRD time) and the **chosen stack** (in ai-mail `C-006` is "Stack TBD") — neither exists at
requirements time, so folding it into `requirements.md` is a phase/timing mismatch, not just artifact
sprawl. Closes `gr_greenfield.md` G8.

**Ownership & lifecycle (settled — see Decision 2):** a **standalone `testing-strategy` skill** owns
it (not `domain-requirements`, which runs too early), invoked inside the Phase-4 PRD step **right
after the module sketch** so it can read the just-decided (ephemeral) modules from the same session.
**One `testing.md` per milestone**, defaulting to `docs/testing/<milestone>.md` (mirrors how
`docs/use_cases/*.md` fans out).

---

## Option 4 — Adjust `to-prd` to maximize use of the spine (recommended primary lever)

Redirect input and reframe as a **thin projection**:

1. **Change the input channel** — read the spine, not just the conversation: requirements (FR/NFR/C/OOS),
   use cases, entity model, vision, glossary, ADRs, postponed-decisions log, and `testing.md`. The
   "synthesize what you already know / don't interview" instruction stays — but "what you know" now
   lives in files, so it must *read* them.

2. **Project, don't re-author** — map each section to its source instead of regenerating:
   Problem ← vision + pains · Solution ← vision golden-path · User Stories ← requirements FRs **carried
   with their IDs** (and use-case refs) · Implementation Decisions ← ADRs (linked) + entity model + the
   interactive module sketch · Testing Decisions ← `testing.md` + NFRs · Out of Scope ←
   requirements OOS + postponed-decisions.

3. **Stay thin / no duplication** — the PRD **links** spine IDs rather than restating their content;
   it authors only the two genuinely-new sections (module + testing decisions). This honors the
   "new artifacts must not duplicate existing items" rule.

4. **Preserve traceability across repo↔tracker** — carry `FR-###`/`UC-###`/`BR-###`/`ADR-####` refs
   into the PRD and onto each issue, so the tracker stays linked to the in-repo spine.

5. **Already aligned — leave as-is** — glossary/ADR consumption and the tracker / `ready-for-agent`
   wiring come from the per-repo setup (`docs/agents/*`). The vanilla skill already says "use the
   glossary, respect ADRs." No change needed there.

**Why a new skill, not an in-place edit of the vendored one:** the matt-pocock skills are shared/plugin
code; heavy in-place edits make upstream updates painful, and the behavior genuinely diverges
(projection vs. conversation-authoring) enough to deserve a distinct, portable skill. The new skill
ships *with the skillset* so it travels to every future project.

---

## Option 5 — Other ways to streamline

1. **A "PRD source manifest"** — a tiny per-project map of *PRD section → artifact + IDs*. Keeps the
   skill decoupled from any one project's file layout (the skill reads the manifest; the manifest names
   the files) — important for portability to brownfield repos with different layouts.
2. **Milestone-scoped PRDs** — the skill takes a **scope marker** (as `pareto-scope-cut`/`usecase-diag`
   already do) and emits **one PRD per milestone**, pulling only in-scope, non-deferred requirements.
3. **Run the lenses on the drafted PRD before publishing** — it is a *new* artifact whose module/testing
   sections are freshly synthesized: `ubiquitous-language-guard` (drift in the new prose),
   `hidden-constraint-sweep` (did the synthesis drop a class?), `adr-threshold-gate` (did a module/
   interface decision cross the ADR threshold?). Extends Phase-3 gating across the Phase-4 boundary at
   near-zero cost.
4. **Repo↔tracker drift audit** — `trace-check` stays **offline/repo-only** (it must not gain a
   network/tracker dependency, which would break its determinism and portability). Instead:
   **forward coverage** (every in-scope requirement reached the tracker with its ID) is asserted by
   `spec-to-prd`'s POST self-check at publish time, and a **separate, tracker-aware drift-audit skill**
   catches *post-publish* divergence (edited issues, spine changed after publish). It reuses
   `trace-check`'s convention-discovery (id patterns, name normalization) rather than reinventing it.
   *(Settled: build this up front — see Decision 3.)*

---

## Settled decisions

- **Thin PRD — committed.** New artifacts must not duplicate existing spine content; the PRD links IDs
  and authors only module + testing decisions. (Consequence: `to-issues`/`tdd` must also read the
  spine, not the PRD alone — see next section.)
- **One PRD per milestone — agreed.** Matches the milestone-scoped spine, keeps each PRD shippable,
  bounds per-run context, and generalizes to brownfield (one PRD per milestone/epic).
- **New PRD skill name — `spec-to-prd`** (replaces vendored `to-prd` in this skillset; travels with it).
- **(D1) Testing strategy in a dedicated `testing.md`** — thresholds stay in the NFRs; universal
  philosophy stays in `tdd`; `testing.md` carries only the project-specific *how*, referencing both.
- **(D2) Standalone `testing-strategy` skill owns it**, invoked in the Phase-4 PRD step right after the
  module sketch; **one `testing.md` per milestone** (`docs/testing/<milestone>.md`).
- **(D3) Build the repo↔tracker drift audit up front** as a separate tracker-aware skill
  (working name `tracker-trace-check`); `trace-check` stays offline/repo-only; forward coverage lives
  in `spec-to-prd`'s POST check. First version: mechanical checks (dangling refs, forward coverage) as
  PASS/FAIL, semantic divergence as `needs-human-confirmation` (à la `trace-check` Check D).

---

## `to-issues` / `tdd` — forward note (handled later)

Detailed integration of these two is **out of scope here**; only the constraints the thin-PRD decision
imposes on them are recorded:

- Because the PRD is thin, **`to-issues` must read the spine** (use cases as slice candidates,
  requirements for IDs), using the PRD as the milestone index rather than the full content source.
- Both `to-issues` and `tdd` should **carry the traceability IDs** (`FR/UC/BR/ADR`) onto issues, tests,
  and commits so the chain survives end to end.
- `tdd` is the consumer of `testing.md` (Option 3) — another reason to keep that strategy in a stable,
  dedicated place.

---

## Implementation plan (step by step)

> New skill name: **`spec-to-prd`** (confirmed). It replaces the vendored `to-prd` in this skillset's
> Phase 4 and travels with the skillset to other projects.

### Part A — adjust the existing skillset

These are **documentation-only edits** to the skillset's shared planning docs (no `SKILL.md`
authoring — that is Part B). They are carried out **autonomously, by the same orchestration rule as
`create_skills.md`** ("Orchestration — single session, one sub-agent per skill"): a single **driver
session** spawns **one cold sub-agent per adjustment**, runs them **strictly sequentially in number
order (A1 → A2 → A3 → A4), never in parallel** — even though they touch different files and have no
dependency between them — and flips each `- [ ]` to `- [x]` **only after** that sub-agent reports its
POST self-check passed. On a blocker the driver leaves the box `- [ ]`, appends `> blocked: <reason>`
after the heading, continues with the rest, and surfaces all blockers at the end.

Each unit is **self-contained** so its sub-agent can run cold: the driver hands it the matching `A#`
block below, this review's `## Settled decisions` list + Parts B–C (the source of every change), and
the named target file — nothing else. Units edit distinct files, so there is no write conflict; the
sequential-in-order rule is kept anyway, mirroring `create_skills.md`. **Ordering across parts:** A4
appends the build specs Part B consumes, so **all of Part A must complete before Part B's driver
runs**.

> **Not a unit — `trace-check` stays untouched.** It remains offline/repo-only (Decision 4); the
> repo↔tracker audit is the *new* `tracker-trace-check` skill (Part B, build spec #10), which *reuses*
> `trace-check`'s convention-discovery. A sub-agent has nothing to write here, so this is recorded as
> a standing constraint, not an adjustment unit.

**- [x] A1 · `skills/workflow.md` — Phase-4 rewrite + record decisions**
- **File:** `skills/workflow.md`.
- **Change:** rewrite Phase 4 to the new sequence (Part C ordering) — the `to-prd` row becomes
  `spec-to-prd`; insert `testing-strategy` right after the module sketch; add "run the composed lenses
  on the draft before publish"; add `tracker-trace-check` after publish; "loop once per in-scope
  milestone." Record the settled decisions downstream Phase-4 steps must assume (thin PRD,
  one-PRD-per-milestone, `testing.md`, standalone `testing-strategy`, drift audit).
- **POST:** Phase 4 names `spec-to-prd` / `testing-strategy` / `tracker-trace-check` in run order; no
  bare `to-prd` left in Phase 4; the five decisions are captured.

**- [x] A2 · `skills/artifacts.md` — new artifact rows + record decisions**
- **File:** `skills/artifacts.md`.
- **Change:** add rows for `docs/testing/<milestone>.md` and the thin PRD (lives on the tracker),
  noting the PRD **links** spine IDs and duplicates no spine content; record the artifact-facing
  decisions (one `testing.md` per milestone; the PRD is a thin projection, not an authored origin).
- **POST:** both rows present; the "links IDs, duplicates nothing" note present; the per-milestone
  `testing.md` path recorded.

**- [x] A3 · `skills/skills_overview.md` — new skill entries**
- **File:** `skills/skills_overview.md`.
- **Change:** add entries for `spec-to-prd`, `testing-strategy`, and `tracker-trace-check` (purpose /
  inputs / outputs / gr relation); add the "run the composed lenses on the PRD draft" note; mark the
  vendored `to-prd` as **superseded by `spec-to-prd`** in this skillset.
- **POST:** three new entries present, each with purpose/inputs/outputs/gr; `to-prd` marked
  superseded; the lenses-on-PRD note present.

**- [x] A4 · `skills/create_skills.md` — append build specs #8–#10**
- **File:** `skills/create_skills.md`.
- **Change:** append the three per-skill build specs as `### - [ ] N · <skill>` blocks in the existing
  `gr / In / Does / Out / POST` format, continuing the current numbering (#8 `spec-to-prd`,
  #9 `testing-strategy`, #10 `tracker-trace-check`), so the skillset's checkbox-driven orchestration
  can build them cold (Part B). **Idempotent:** if #8–#10 already exist, verify they match this format
  and are complete rather than re-appending. The PRD source manifest (Option 5.1) is
  **optional/deferred** — `spec-to-prd` defaults to the AIUP chain filenames, so a manifest is only
  needed for non-standard layouts; note it as deferred, do **not** add it.
- **POST:** specs #8–#10 exist as `### - [ ] N · <skill>` blocks with numbering continuous from #7,
  each carrying gr/In/Does/Out/POST; no duplicate spec blocks; the manifest recorded as deferred.

### Part B — create the new skills

**B1 · `spec-to-prd`** — hand-author `skills/spec-to-prd/SKILL.md` (manual build per `create_skills.md`
"How to build a skill here"; **not** `/make-skill`), then junction `.claude/skills/spec-to-prd →
skills/spec-to-prd`. **Generic body — no ai-mail specifics**; project values arrive via args / fallback
chains. Family: authoring (replaces the external `to-prd`). gr: gr_documentation Doc5 (no duplication),
gr_domain_language L1 (consume glossary verbatim), gr_adr (respect/flag ADRs), AIUP-native traceability
(carry IDs). Frontmatter `name` + trigger-rich `description` ("create a PRD"; projects an existing spec
spine, falls back to authoring where the spine is thin). Process:
1. Resolve the **scope marker** (milestone): arg → the requirements doc's declared milestone / Status
   scope split → ask only if genuinely ambiguous (multiple undelimited milestones).
2. Read the spine from the **AIUP chain defaults** — `docs/requirements.md`, `docs/use_cases/*.md` +
   `docs/use_cases.puml`, `docs/entity_model.md`, `docs/vision.md`, glossary (`docs/CONTEXT.md` →
   `docs/glossary.md` → warn), `docs/adr/*`, postponed-decisions log — overridable by an optional
   manifest arg. Resolve the **in-scope FR/UC set** (non-deferred, non-out-of-scope at the marker).
3. **Brownfield branch:** for any missing/thin spine artifact, fall back to codebase-driven authoring
   (vanilla behavior) for that section only.
4. **Interactive module sketch** (vanilla step 2), grounded in entity model + use cases (+ codebase in
   brownfield); HITL-confirm modules and which want tests.
5. **Invoke `testing-strategy`** (B2) in-session so it sees the just-decided modules.
6. Draft a **thin PRD** using the vanilla `to-prd` 7-section template (Problem Statement · Solution ·
   User Stories · Implementation Decisions · Testing Decisions · Out of Scope · Further Notes): for the
   spine-derived sections **link `FR/UC/BR/ADR` IDs instead of restating**; author fresh only the
   Implementation/module decisions and Testing Decisions (the latter links `docs/testing/<milestone>.md`).
7. **Run the composed lenses** on the draft (ubiquitous-language-guard, hidden-constraint-sweep,
   adr-threshold-gate).
8. **Publish** to the tracker (abstractly, via `docs/agents/issue-tracker.md`) with `ready-for-agent`,
   **one PRD per milestone**, emitting traceability refs.
- **POST:** PRD duplicates no spine content; every in-scope requirement linked by ID; scope marker
  honored; lenses run; **forward coverage asserted** (every in-scope requirement reached the tracker).

**B2 · `testing-strategy`** — `skills/testing-strategy/SKILL.md`. Standalone authoring skill, invoked
by `spec-to-prd` right after the module sketch. Produces **one `docs/testing/<milestone>.md`** per
milestone: project-specific *how* only — module/test-surface priorities, test-double policy at the
real boundaries, prior art — each entry opening `Re: NFR-###` (references thresholds, never restates),
and referencing the `tdd` skill for universal philosophy. Closes `gr_greenfield.md` G8. POST: every
entry cites an NFR/constraint; no threshold restated; no universal philosophy duplicated.

**B3 · `tracker-trace-check`** — `skills/tracker-trace-check/SKILL.md`. Tracker-aware lens (the
repo↔tracker counterpart of `trace-check`). Inputs: the in-repo spine + the published PRD/issues for a
milestone (via `docs/agents/issue-tracker.md`) + scope marker. Checks: **dangling refs** (every ID
cited on the tracker resolves to a real spine artifact) and **forward coverage** (every in-scope
requirement is on the tracker) as mechanical PASS/FAIL; **semantic divergence** (a tracker item
contradicts its linked spine artifact) as `needs-human-confirmation` (à la `trace-check` Check D).
Reuses `trace-check`'s convention-discovery; emits a consistency report + HITL fix loop (tracker edits
proposed, never auto-applied).

### Part C — Phase-4 run order (after the change)

1. `spec-to-prd` → read spine, project, **interactive module sketch (HITL)**
2. `testing-strategy` → author `docs/testing/<milestone>.md` from the just-decided modules + NFRs + stack
3. `spec-to-prd` → draft thin PRD (Testing Decisions links `testing.md`), **run lenses**, publish (`ready-for-agent`)
4. `tracker-trace-check` → repo↔tracker drift audit
5. (later) `to-issues` → `tdd` — handled separately

### Part D — build conventions & autonomy

All three are built exactly as the existing skillset was, so the **build needs no human input**:

- **Manual, no toolchain.** Hand-author each `skills/<name>/SKILL.md` per `create_skills.md`
  "How to build a skill here"; create the `.claude/skills/<name>` junction; **do not** use `/make-skill`.
- **Generic bodies.** No ai-mail specifics in any SKILL.md — paths/milestones/tracker come via args or
  the AIUP chain defaults + fallback chains; ai-mail values appear only as the *test case* at run time.
- **Anatomy.** Mirror the existing skills: frontmatter (`name` + trigger-rich `description`) + body
  `## Instructions`, `## DO NOT`, `## Workflow`, + reference tables.
- **Orchestration.** With the three specs appended to `create_skills.md`, the existing driver spawns one
  cold sub-agent per skill, which writes the SKILL.md, runs the POST self-check, and flips its checkbox.
  They have no *build* dependency on one another (only a *runtime* invocation of `testing-strategy`
  from `spec-to-prd`), but per `create_skills.md`'s **Orchestration** rule the driver builds them **one
  at a time, in spec order (#8 → #9 → #10), never in parallel**.
- **Runtime HITL is unchanged (by design).** Build-time is fully autonomous; at *run* time the skills
  still gate shared-doc / tracker writes on human approval (testing.md write, PRD publish, tracker
  fixes) — load-bearing safety, consistent with the rest of the skillset. Making any of these run AFK is
  a separate decision (flagged, not assumed).

### Naming decision — **`spec-to-prd`** (confirmed)

Chosen because it mirrors the `to-prd`/`to-issues` lineage, signals "input = the spec spine, not a
conversation," is project-agnostic, and reads well in `workflow.md`. Alternatives considered and not
taken: `prd-from-spec` (same intent, different verb order), `publish-prd` (good for "thin," weaker on
"from the spine"), and a `to-prd` local override (drop-in but ambiguous provenance, hides the behavior
change).

---

## Decisions log (all resolved)

1. **Skill name** — `spec-to-prd`.
2. **Testing strategy home** — dedicated `testing.md` (thresholds stay in NFRs; philosophy stays in
   `tdd`; references both, restates neither).
3. **Owner of `testing.md`** — standalone `testing-strategy` skill (not `domain-requirements`),
   invoked in the Phase-4 PRD step right after the module sketch; **one `testing.md` per milestone**.
4. **Repo↔tracker traceability** — `trace-check` stays offline/repo-only; build the drift audit up
   front as a separate `tracker-trace-check` skill; forward coverage lives in `spec-to-prd`'s POST check.

### Finalized for an autonomous build (no human input required)

- **`testing.md` path** — `docs/testing/<milestone>.md` (milestone from the scope marker).
- **Drift-audit skill name** — `tracker-trace-check` (final).
- **PRD template** — the vanilla `to-prd` 7 sections; spine-derived sections link IDs, only module +
  testing decisions authored fresh.
- **Scope marker** — resolved arg → requirements milestone/Status; ask only if genuinely ambiguous.
- **Source manifest** — optional/deferred; `spec-to-prd` defaults to the AIUP chain filenames.
- **Build process** — manual per `create_skills.md`; generic bodies; junctions; checkbox orchestration.

All remaining human touchpoints are **run-time only** (the HITL approval gates), never build-time.

---

## Part E — Do the pre-existing skills need adaptation? (post-build review)

> Added after Parts A–B were carried out (`spec-to-prd`, `testing-strategy`,
> `tracker-trace-check` created; `workflow.md` / `artifacts.md` / `skills_overview.md` /
> `create_skills.md` updated). Question asked: now that the Phase-4 chain exists, do the
> **pre-existing** skills — the Family-A lenses and the Family-B authoring forks, which were
> *not* touched — need changes to stay aligned with it? Each skill below was re-read against
> the new chain. Findings are ranked by severity; concrete recommended edits are given.

### Summary

| # | Skill(s) affected | Finding | Severity | Change needed? |
| --- | --- | --- | --- | --- |
| E1 | `ubiquitous-language-guard`, `hidden-constraint-sweep` (and minor: `adr-threshold-gate`) | The PRD draft is not in their accepted-artifact lists, yet `spec-to-prd` step 7 runs them on it | **High** | Yes — widen inputs/step-agnostic claim |
| E2 | `tracker-trace-check` (+ overview) | Its documented convention-discovery covers FR/BR only; `tracker-trace-check` claims to "reuse" it for FR/UC/BR/ADR | **Medium** | Yes — soften the reuse claim (unit E2); `trace-check` untouched |
| E3 | `spec-to-prd`, `pareto-scope-cut`, `artifacts.md` | The "postponed-decisions log" has no canonical location; it is appended inline to whatever artifact was cut, but `spec-to-prd` reads it as a discrete input | **Medium** | Yes — `spec-to-prd` scan + contract note + `artifacts.md` row (unit E3) |
| E4 | `trace-check` (Check 0 chain) | Nothing checks `docs/testing/<milestone>.md` freshness against its upstream NFRs | **Low** | Optional — flagged decision |
| E5 | `pareto-scope-cut` | Scope-marker resolution differs from the chain the Phase-4 + use-case skills use | **Low** | Optional — consistency nudge |
| — | `domain-requirements`, `domain-model`, `usecase-diag`, `usecase-spec` | Already emit exactly what the new chain consumes | — | **No change** (recorded below) |

### E1 — The composed lenses do not list the PRD draft as an input *(High)*

`spec-to-prd` step 7 and `workflow.md` Phase 4 step 3 run three existing lenses **on the
PRD draft before publish**: `ubiquitous-language-guard`, `hidden-constraint-sweep`,
`adr-threshold-gate`. But two of the three enumerate a **closed** list of artifact types
that does not include a PRD:

- [`ubiquitous-language-guard/SKILL.md`](../skills/ubiquitous-language-guard/SKILL.md) — `description`,
  Inputs ("a requirements document, an entity model, a `*.puml` use case diagram, or a
  `use_cases/*.md` spec"), and the `Step-agnostic` line ("requirements, domain-model,
  use-case-diagram, and use-case-spec stages") all omit the PRD.
- [`hidden-constraint-sweep/SKILL.md`](../skills/hidden-constraint-sweep/SKILL.md) — same omission in
  `description`, Instruction 1 ("the requirements doc, use-case spec, or domain/entity
  model"), and the `Step-agnostic` note; additionally its **Routing** table has no
  PRD-stage row, so a `missing` class found while sweeping a PRD has no defined home.
- [`adr-threshold-gate/SKILL.md`](../skills/adr-threshold-gate/SKILL.md) — the most generic of the three
  ("any one pre-decision artifact (a plan, … a design note) or post-decision artifact (a
  diff)"); a PRD fits "a plan / design note", so it works *implicitly* — but the PRD is
  never named.

Today the composition relies on the agent stretching a closed list to cover an artifact the
skill never names — fragile. **Recommended edits:**

1. Add **"a PRD draft (the `spec-to-prd` Phase-4 projection, before publish)"** to the
   accepted-artifact list, the `description`, and the `Step-agnostic` stage list of both
   `ubiquitous-language-guard` and `hidden-constraint-sweep`.
2. For `hidden-constraint-sweep`, add a **PRD-stage Routing row**: a `missing` class found
   while sweeping the PRD routes **back into the spine** (new FR/NFR via `domain-requirements`,
   alt-flow via `usecase-spec`) or into the PRD's freshly-authored module/testing decisions —
   it is **not** patched into the published PRD directly (the PRD restates nothing; Doc5).
3. For `adr-threshold-gate`, add **"a PRD / milestone PRD draft"** as a named example in its
   Inputs list for symmetry (no behavioral change — it already accepts any artifact).

> Note for `skills_overview.md`: the three lens entries should gain the PRD as a stage in
> their "input artifacts" lines once the SKILL.md bodies are updated, so the overview's
> claimed coverage stays truthful (a `review-skills` audit compares the two).

### E2 — `trace-check`'s convention-discovery does not cover the id patterns `tracker-trace-check` says it "reuses" *(Medium)*

[`tracker-trace-check/SKILL.md`](../skills/tracker-trace-check/SKILL.md) states it
**"reuses `trace-check`'s convention-discovery (id patterns, name normalization)"** for the
full `FR/UC/BR/ADR` id space, and its DO-NOT forbids "diverging from" it. But
[`trace-check/SKILL.md`](../skills/trace-check/SKILL.md) §"Discover conventions first" only
discovers the **requirements id pattern** and the **BR id pattern** (plus name-normalization);
it never discovers a **UC** id pattern (it matches use cases by *name*) or an **ADR** id
pattern (it never reads ADRs). So the "reuse" is partly aspirational — `tracker-trace-check`
actually **extends** the discovery with two id families `trace-check` does not define.

This is a documentation/consistency mismatch, not a runtime break (each skill body is
self-contained), but exactly the kind of overclaim a `review-skills` pass on either skill
would flag.

**Decision (resolved — option (b)):** soften the claim; do **not** touch `trace-check`.
Rationale: `trace-check` does not need UC id patterns (it matches use cases by name) or ADR
patterns (it never reads ADRs), so generalizing its convention-discovery to those families would
bolt unused machinery onto `trace-check` purely to serve another skill — a single-responsibility
/ YAGNI violation, and it would disturb the file Part A deliberately froze. What is genuinely
shared is the *method* (derive id prefixes from the files, never hard-assume) and the
*name-normalization rule*; `tracker-trace-check` legitimately **extends** that method with the
UC/ADR families it alone needs. So restate the relationship honestly rather than expanding
`trace-check`. → Implemented by **unit E2** below.

### E3 — The postponed-decisions log has no canonical location `spec-to-prd` can read *(Medium)*

`spec-to-prd` treats **"the postponed-decisions log"** as a discrete, locatable input three
times: as a spine input row, in *Resolve the in-scope set* (in-scope excludes postponed
items), and in the **Out of Scope ← postponed-decisions log** projection. But
[`pareto-scope-cut/SKILL.md`](../skills/pareto-scope-cut/SKILL.md) emits it as a
**`## Postponed decisions` section appended to the END of whichever artifact it scope-cut**
(requirements.md, entity_model.md, a use-case spec, …) — potentially several artifacts, each
with its own appended section, and at **no canonical path**. [`artifacts.md`](../skills/artifacts.md)
does not list a postponed-decisions artifact at all.

So `spec-to-prd`'s input is under-specified against how the log is actually produced: there is
no single "postponed-decisions log" file to open.

**Decision (resolved — option (b), made bilateral):** keep `pareto-scope-cut`'s
append-to-each-artifact behavior; **sharpen `spec-to-prd`** to *scan the spine artifacts for the
`## Postponed decisions` section* `pareto-scope-cut` appends, treating that heading as the stable
contract token. Rationale: a forced canonical path (option (a)) fights `pareto-scope-cut`'s
step-agnostic design — it appends the section to *whichever* artifact it cut (requirements,
entity model, a use-case spec), so there is no single natural home, and redirecting the log
elsewhere would split it from the `## Scope split` it belongs with. Scanning matches reality and
needs no mechanism change to `pareto-scope-cut`. To make the contract bilateral and rename-safe,
also add a one-line **Contract note** to `pareto-scope-cut` that the `## Postponed decisions`
heading is a stable token consumed by `spec-to-prd` / `tracker-trace-check`, and add a
**postponed-decisions row to [`artifacts.md`](../skills/artifacts.md)** (producer, location,
consumer). → Implemented by **unit E3** below.

### E4 — No freshness coverage for `docs/testing/<milestone>.md` *(Low — flagged decision)*

`testing-strategy` derives `docs/testing/<milestone>.md` from the requirements **NFRs/constraints**
(referenced by ID) plus the ephemeral module sketch. If the NFRs change *after* `testing.md`
is authored, nothing flags `testing.md` as stale: `trace-check`'s **Check 0** freshness chain
stops at `entity_model` and was deliberately frozen (Decision 4), and `tracker-trace-check`
audits **repo↔tracker** drift, not recency. Because `testing.md` is a **repo** file, adding a
`requirements → docs/testing/<milestone>.md` pair to Check 0 would **respect** the
offline/repo-only constraint (it adds no tracker dependency).

This is genuinely optional: `testing.md` is regenerated per-milestone at PRD time, so the drift
window is short. **Recommended:** make it a conscious choice — either (a) accept the gap and
record it here, or (b) extend `trace-check`'s Check 0 chain with the testing-strategy pair.
Since Part A froze `trace-check`, treat any expansion as a deliberate amendment, not a silent
edit.

### E5 — `pareto-scope-cut` resolves the scope marker differently from the rest of the chain *(Low — consistency)*

The Phase-4 and use-case skills share one scope-marker resolution chain:
**arg → the requirements doc's declared milestone / `Status` scope split → ask only if
genuinely ambiguous** (`spec-to-prd`, `testing-strategy`, `tracker-trace-check`,
`usecase-diag`, `usecase-spec` all do this). [`pareto-scope-cut/SKILL.md`](../skills/pareto-scope-cut/SKILL.md)
instead resolves **arg → otherwise ask the user**, skipping the auto-derive-from-`Status` step.

**Recommended:** low priority, and possibly *intentional* — `pareto-scope-cut` is often the
skill that *creates* the `Status`/scope split, so deriving the marker from that split can be
circular. Either align it to the shared chain or add a one-line note that the difference is
deliberate. Flag, don't mandate.

### Already aligned — no change needed (recorded so this is not re-investigated)

- **`domain-requirements`** → produces `docs/requirements.md` with stable `FR-###`/`NFR-###`/
  `C-###` IDs, a `Status`/milestone scope split, and the **Out-of-Scope** section — exactly the
  fields `spec-to-prd` projects (User Stories, Testing Decisions by NFR-ID, Out of Scope) and
  `testing-strategy` references (`Re: NFR-###` / `Re: C-###`). No change.
- **`domain-model`** → emits `docs/entity_model.md` (aggregates, invariants) that `spec-to-prd`
  links in Implementation Decisions and that grounds the module sketch. No change.
- **`usecase-diag` / `usecase-spec`** → already emit `UC-###` ids with per-UC FR refs and the
  `Requirements covered (FR-###)` trace line plus `BR-###` ids — precisely what `spec-to-prd`
  links and what `tracker-trace-check`'s dangling-ref check resolves. No change.
- **`trace-check`** (core role) → correctly left offline/repo-only per Decision 4; its only
  touch-points are E2 (reuse-claim wording) and E4 (optional `testing.md` freshness) — both
  optional and both preserving the offline/repo-only constraint.

### Incidental (not an existing-skill change, but surfaced during the review)

[`spec-to-prd/SKILL.md`](../skills/spec-to-prd/SKILL.md)'s DO-NOT line defers entity modelling to
**`entity-model`** (the stock `aiup-core` name) rather than this skillset's fork
**`domain-model`**. Ambiguous provenance; worth correcting to `domain-model` for consistency
with the rest of the skillset. (A flaw in the *new* skill, listed here only because it is an
alignment nit between new and existing skills.) **Folded into unit E3**, which already opens
`spec-to-prd/SKILL.md` (see E3 change step 2).

---

## Part E adjustments — autonomous orchestration (apply E1–E3)

> In a fresh session, tell the agent: *"apply the E1–E3 fixes in `plan/to-prd-review.md` using
> sub-agents."* This block is the complete, self-contained spec for that run. **Every design
> choice is already resolved** (E1 decided in the finding; E2 = option (b); E3 = option (b),
> bilateral) so the run — driver **and** sub-agents — needs **no user interaction**.

### Orchestration rule (same as Part A / `create_skills.md`)

These three findings are carried out **autonomously, by the `create_skills.md` orchestration
rule**: a single **driver session** spawns **one cold sub-agent per unit**, runs them **strictly
sequentially in number order (E1 → E2 → E3), never in parallel** — even though some touch
different files and have no dependency between them — and flips each `- [ ]` to `- [x]` **only
after** that sub-agent reports its POST self-check passed. On a blocker the driver leaves the box
`- [ ]`, appends `> blocked: <reason>` after the heading, continues with the rest, and surfaces
all blockers at the end.

Units E1 and E2 both write `skills/skills_overview.md`, and E3 writes `skills/artifacts.md`; the
strict-sequential-in-order rule removes any write conflict (mirrors Part A, where the rule was
kept even for distinct files).

Each unit is **self-contained** so its sub-agent runs cold: the driver hands it the matching
`E#` block below, **plus** the matching finding prose (E1 / E2 / E3 above, including its resolved
**Decision**), **plus** the named target files — nothing else.

**No user interaction — anywhere in the run.**
- These units **edit SKILL.md / overview / artifacts *text* only — they do not *run* any skill**,
  so no run-time HITL gate (glossary write-back, scope-cut write, PRD publish, tracker write) is
  ever triggered. Build-time is fully autonomous, exactly as in Part A.
- Every choice is pre-resolved above. If a sub-agent nonetheless hits a genuinely unspecified
  decision, it must **stop and record a `> blocked:` note** — it must **never** ask the user and
  **never** guess.

> **Scope — E1–E3 only.** **E4** (testing.md freshness) and **E5** (`pareto-scope-cut`
> scope-marker chain) are deliberately left as **optional flagged findings**, *not* adjustment
> units. Do **not** action them in this run.

### The adjustment units

**- [x] E1 · the three composed lenses + overview — accept the PRD draft as an artifact**
- **Files:** [`skills/ubiquitous-language-guard/SKILL.md`](../skills/ubiquitous-language-guard/SKILL.md),
  [`skills/hidden-constraint-sweep/SKILL.md`](../skills/hidden-constraint-sweep/SKILL.md),
  [`skills/adr-threshold-gate/SKILL.md`](../skills/adr-threshold-gate/SKILL.md),
  [`skills/skills_overview.md`](../skills/skills_overview.md).
- **Canonical phrase to insert** (use verbatim wherever an artifact list / stage list is widened):
  *"a PRD draft (the pre-publish `spec-to-prd` Phase-4 projection — provided as in-session/inline
  content, not necessarily a file on disk)."*
- **Change:**
  1. `ubiquitous-language-guard` — add the PRD draft to (a) the `description` artifact list, (b)
     the **Inputs** "Artifact" item, and (c) the `Step-agnostic` line (add a PRD / Phase-4 stage).
     State explicitly that the artifact may be **in-session/inline** content, not only a named file
     or "file in focus."
  2. `hidden-constraint-sweep` — add the PRD draft to (a) the `description`, (b) **Instruction 1**
     ("the requirements doc, use-case spec, or domain/entity model … *or a PRD draft*"), and (c)
     the `Step-agnostic` **Notes** line. Add a **PRD-stage row to the Routing table**: a `missing`
     class found while sweeping the PRD routes to a new FR/NFR (via `domain-requirements`) or a
     use-case alt-flow (via `usecase-spec`) **in the spine**, or into the PRD's freshly-authored
     module/testing decisions — **never patched into the published PRD body** (Doc5: the PRD
     restates nothing). Note the PRD-stage `covered` pointer adaptation (a linked `FR/NFR/UC` id,
     or the module/testing-decision subsection).
  3. `adr-threshold-gate` — add **"a PRD / milestone PRD draft"** as a named example in its
     **Inputs** artifact list (and the `description` if it reads naturally). No behavioral change —
     it already accepts any artifact; this is for symmetry/discoverability.
  4. `skills_overview.md` — update the **input-artifacts** line of the `ubiquitous-language-guard`,
     `hidden-constraint-sweep`, and `adr-threshold-gate` entries to include the PRD-draft stage, so
     the overview's claimed coverage stays truthful (a `review-skills` pass compares the two).
- **POST:** no closed artifact list in `ubiquitous-language-guard` or `hidden-constraint-sweep`
  still excludes the PRD draft (checked in `description`, Inputs, and the step-agnostic line); the
  sweep's Routing table has a PRD-stage row whose follow-ups go to the spine / PRD decisions, never
  the published PRD; `adr-threshold-gate` names the PRD as an example; all three
  `skills_overview.md` entries name the PRD-draft stage; in-session/inline acceptance is stated for
  the two lenses.

**- [x] E2 · `tracker-trace-check` + overview — restate the convention-discovery relationship (leave `trace-check` untouched)**
- **Files:** [`skills/tracker-trace-check/SKILL.md`](../skills/tracker-trace-check/SKILL.md),
  [`skills/skills_overview.md`](../skills/skills_overview.md). **Do NOT edit
  [`skills/trace-check/SKILL.md`](../skills/trace-check/SKILL.md)** — it stays offline/repo-only and
  is left exactly as is (Decision 4 + the resolved E2 decision).
- **Change:** in `tracker-trace-check`, change every place that claims it **"reuses `trace-check`'s
  convention-discovery (id patterns, name normalization)"** — the body intro, the
  "Discover conventions first (reused from `trace-check`, not reinvented)" heading and text, and
  the DO-NOT line forbidding divergence — to state the accurate relationship: it **reuses
  `trace-check`'s *method*** (derive id prefixes from the files — never hard-assume — plus the
  name-normalization rule) **and *extends* it with the UC and ADR id families that `trace-check`
  does not discover** (trace-check discovers only the requirements-id and BR-id patterns; it
  matches UCs by name and never reads ADRs). Keep the "do not reinvent / diverge from the shared
  *method*" intent, but drop the implication that `trace-check` already discovers UC/ADR patterns.
  Mirror the same wording fix in the `tracker-trace-check` entry of `skills_overview.md` (its
  "convention-discovery shared with `trace-check`" sentence).
- **POST:** `tracker-trace-check` no longer claims wholesale reuse of a discovery that covers
  UC/ADR — it says **reuse-method + extend-with-UC/ADR**; the DO-NOT no longer overclaims;
  `skills_overview.md` matches; `trace-check/SKILL.md` is byte-for-byte unchanged.

**- [x] E3 · `spec-to-prd` + `pareto-scope-cut` + `artifacts.md` — make the postponed-decisions-log contract explicit (and fix the `entity-model` nit)**
- **Files:** [`skills/spec-to-prd/SKILL.md`](../skills/spec-to-prd/SKILL.md),
  [`skills/pareto-scope-cut/SKILL.md`](../skills/pareto-scope-cut/SKILL.md),
  [`skills/artifacts.md`](../skills/artifacts.md).
- **Change:**
  1. `spec-to-prd` — replace the vague "postponed-decisions log (appended by the scope-cut skill)"
     everywhere it appears (the Inputs spine table, *Resolve the in-scope set*, the Out-of-Scope
     projection row, and the PRD template's Out of Scope line) with the concrete contract: **"the
     `## Postponed decisions` section(s) `pareto-scope-cut` appends to the END of each spine
     artifact it scope-cut — scan the spine artifacts (requirements, entity model, use-case specs)
     for that exact heading and collect its lines."** Name `## Postponed decisions` as the literal
     token to scan for. Keep "Doc5: link/reference, don't restate."
  2. `spec-to-prd` (incidental nit) — in the DO-NOT line that defers entity modelling, change
     **`entity-model`** to **`domain-model`** (this skillset's fork; the output file stays
     `entity_model.md`).
  3. `pareto-scope-cut` — add a one-line **Contract** note (near its Output format / the
     `## Postponed decisions` definition) stating that the `## Postponed decisions` heading is a
     **stable contract token consumed by `spec-to-prd` and `tracker-trace-check`** and must not be
     renamed. **No mechanism change** — it still appends the section to the artifact it cut.
  4. `artifacts.md` — add a **postponed-decisions row** (alongside the Phase-1..3 tables as
     appropriate): **Produced by** `pareto-scope-cut`; **location** = `## Postponed decisions`
     section appended to each scope-cut artifact (not a standalone file); **consumed by**
     `spec-to-prd` (Out of Scope projection) and `tracker-trace-check`.
- **POST:** `spec-to-prd` specifies *scanning the spine artifacts for the `## Postponed decisions`
  heading* (Inputs + in-scope resolution + Out-of-Scope projection all consistent) and defers to
  `domain-model` (not `entity-model`); `pareto-scope-cut` carries the stable-token Contract note
  with no mechanism change; `artifacts.md` has the postponed-decisions row naming
  producer/location/consumer; the heading literal `## Postponed decisions` matches on both the
  producer and consumer sides.
