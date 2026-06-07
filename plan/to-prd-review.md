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

1. **Record all settled decisions** (thin PRD, one-PRD-per-milestone, `testing.md`, standalone
   `testing-strategy`, drift audit) in `skills/workflow.md` + `skills/artifacts.md` so downstream
   skills assume them.
2. **Update `skills/workflow.md` (Phase 4)** to the new sequence (see Part C ordering): the `to-prd`
   row becomes `spec-to-prd`; insert `testing-strategy` right after the module sketch; add "run the
   composed lenses on the draft before publish"; add `tracker-trace-check` after publish; "loop once
   per in-scope milestone."
3. **Update `skills/artifacts.md`:** add rows for `docs/testing/<milestone>.md` and the thin PRD
   (lives on the tracker), noting the PRD **links** spine IDs and duplicates no spine content.
4. **Update `skills/skills_overview.md`:** add entries for `spec-to-prd`, `testing-strategy`, and
   `tracker-trace-check` (purpose / inputs / outputs / gr relation); add the "lenses on the PRD" note;
   mark the vendored `to-prd` as **superseded by `spec-to-prd`** in this skillset.
5. **Leave `trace-check` unchanged** — it stays offline/repo-only (Decision 3); the repo↔tracker audit
   is the new `tracker-trace-check` skill, which *reuses* `trace-check`'s convention-discovery.
6. **Append three per-skill build specs** to `skills/create_skills.md` (`### - [ ] N · <skill>` blocks
   in the existing `gr / In / Does / Out / POST` format, continuing the current numbering) so the
   skillset's checkbox-driven orchestration can build them cold. The PRD source manifest (Option 5.1)
   is **optional/deferred** — `spec-to-prd` defaults to the AIUP chain filenames, so a manifest is only
   needed for non-standard layouts.

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
