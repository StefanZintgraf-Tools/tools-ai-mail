# Plan — Generic AIUP Guardrail Skills + Modified Authoring Skills (`domain-requirements`, `domain-model`)

## Background information

See skills/skills_background_info.md

## What this plan is

A plan for building a small family of **generic, reusable Claude Code skills** that add
domain-modelling discipline to the AI Unified Process (AIUP) chain — discipline the stock
`aiup-core` skills lack. ai-mail is the **first test case, not the audience**: every skill here
must be generic enough to use on any software project.

**For now the skills are built and tested as ai-mail *project skills*** (`.claude/skills/<name>/SKILL.md`),
**by hand — not** with the coding repo's `/make-skill` toolchain. ai-mail is a sandbox; once a skill
proves out it is ported back to the coding project later (mechanism TBD). The upstream `aiup-core`
marketplace is never forked or modified. See **Placement** and **How to build a skill here**.

> This plan is written to be **self-contained**: a fresh session with no memory of the design
> discussion should be able to build every skill from this file plus the listed source materials.

## The decision that shaped this plan

We considered three ways to fix stock `entity-model` (storage/CRUD-flavoured, ignores any
glossary, makes every term an `id`-bearing table, invents `Long`/`Decimal`/`Sequence`):

1. Wrap it in author-specific **bridge** skills (the original todo.md framing).
2. **Genericize** the guardrail rules into first-class skills + modify `entity-model` itself.
3. Bake a light glossary-read into one generic skill and drop the separate discipline.

**Chosen: option 2.** The deciding insight (user, 2026-06-03): the `gr_*.md` guardrails are
**generic and stable** — DDD, domain language, ADR discipline, Pareto/greenfield are universal
good practice, the *same kind of thing* as `entity-model`, not a fast-changing private
methodology. That removes the reason to quarantine them as "bridges." They become **peer generic
skills**. And `entity-model` is modified — not wrapped — to fit the new approach.

Rejected: a single monolithic skill that does everything. Each skill stays **single-responsibility
and independently invokable** (no "monster" skill).

## Architecture — two families of generic skills

### Family A — Guardrail-lens skills (cross-cutting)

One skill per `gr_*` cluster. Each is **independent**, usable at *many* AIUP steps (not just
before `domain-model`), and runs against any artifact. Source of truth for the rules:
[`c:\PROJ\ai-knowhow\coding\gr\*.md`](file:///c:/PROJ/ai-knowhow/coding/gr).

| Skill | gr cluster | What it does (generic) | AIUP steps it serves |
| ----- | ---------- | ---------------------- | -------------------- |
| `ubiquitous-language-guard` | `gr_domain_language` L1,L2,L4,L6,L8,L9 + `gr_greenfield` G7 | Enforce & evolve the project glossary: flag forbidden synonyms (L2), storage-shaped names (L4), silently-invented terms (L6); on near-match halt-and-ask *same / refinement / new*; confirm domain names appear verbatim (L1); write HITL-approved new/changed terms **back** into the glossary (L8); check the CLAUDE.md pointer (L9). | requirements, domain-model, use-case-diagram, use-case-spec — **all of them** |
| `hidden-constraint-sweep` | `gr_algn` Aln6 + B5 | Run the 8-class checklist — security/PII, permissions, data-retention, migrations, observability, public-API-compat, concurrency, out-of-scope — each → `covered` / `not-applicable` (recorded reason) / `missing` (blocks). | requirements, use-case-spec, domain-model |
| `adr-threshold-gate` | `gr_adr` Adr1, Adr5, Adr8 | Detect decisions crossing the bar (hard-to-reverse AND surprising AND real trade-off); per hit HITL-ask "ADR-worthy?" naming the 3 criteria; draft per Adr5; `proposed→accepted` HITL only (Adr8). | any step (pre or post) |
| `pareto-scope-cut` | `gr_greenfield` G1,G3,G5,G9,G10 | Flag entities/FRs/flows built for imagined/future scope; push to a deferred list with a one-line postponed-decision record each (G9). | requirements, domain-model, use-case-diagram |
| `trace-check` | `gr_domain_language` L1 + AIUP-native traceability | Cross-artifact consistency: every UC traces to ≥1 FR; every entity named in a spec exists in the domain-model; actors match the glossary (L1); every business rule maps to a domain-model invariant. Reports breaks; fixes loop back HITL. | use-case-diagram, use-case-spec, any time artifacts drift |

### Family B — Modified authoring skills

Forked from the stock `aiup-core` authoring skills so they **consume the glossary** as input. Both are
*generic successors*, not wrappers; both **consume** the glossary but **do not maintain** it (that stays
`ubiquitous-language-guard`'s job).

| Skill | Replaces | gr cluster it absorbs |
| ----- | -------- | --------------------- |
| `domain-requirements` | stock `aiup-core:requirements` | `gr_domain_language` L1 (consumes glossary: terms + actors verbatim) |
| `domain-model` | stock `aiup-core:entity-model` | `gr_ddd` D1,D2,D3,D5,D7,D9 + `gr_architecture` A9 + `gr_domain_language` (consumes glossary) |

The two are **not symmetric.** `domain-model` also fixes *structural* defects (everything-a-table,
forced datatypes) that no lens can post-process — that is why it was the original "exception."
`domain-requirements` fixes **only** the vocabulary-input defect (stock `requirements` reads
`vision.md`, never a glossary, so it invents terms and defaults to "User/Admin/System" actors). See
§"What changes" for each.

## The boundary: what's IN `domain-model` vs. a separate lens

The single most important design line in this plan — recorded so it doesn't get re-litigated:

- **IN `domain-model`** (intrinsic to producing a good model):
  - Read the glossary as **input**; use domain terms **verbatim** (no renaming to storage shapes).
  - Classify each term **Entity | Value-Object | Aggregate-root** (D5/D2) — not "everything is a
    table with an `id`."
  - Turn domain invariants into **validation rules** (D3/D9).
  - Keep infrastructure **out** of the model (A9) — model identity, not transport/storage ids.
  - **Conceptual-first**: relationships, cardinalities, invariants. Physical datatypes
    (`Long`/`Decimal`/`Sequence`) are **opt-in** behind a declared storage target — never the
    default. Fixes stock entity-model's stack-agnostic contradiction.
- **OUT of `domain-model`, stays a lens** (cross-cutting, reused elsewhere):
  - ADR threshold (`adr-threshold-gate`), the constraint sweep (`hidden-constraint-sweep`),
    scope-cutting (`pareto-scope-cut`), and glossary **maintenance/enforcement**
    (`ubiquitous-language-guard`).

## What changes in `domain-model` vs. stock `entity-model`

Three stock defects that contradict its own "stack-agnostic" claim — fixed at source:

1. **No forced relational datatypes.** Conceptual mode by default; `Long`/`Decimal`/`Sequence`/PK
   columns appear only when a storage target is declared.
2. **No forced surrogate `id`.** Value-objects and aggregates are first-class; not every entity
   gets an identity column.
3. **Reads a glossary when present** (e.g. a `CONTEXT.md`); terms used verbatim.

Everything else stock `entity-model` does well (Mermaid ER diagram, per-entity attribute tables,
explicit validation rules, the cross-validation pass) is **kept**.

## What changes in `domain-requirements` vs stock `requirements`

**Exactly one** change — stock `requirements` has no structural defect, only a vocabulary-input one:

1. **Consumes the glossary.** Reads the glossary (resolve `docs/CONTEXT.md` → `docs/glossary.md`,
   warn-and-continue if absent) in addition to `vision.md`; uses domain terms **verbatim**; draws FR
   actors/roles from the glossary's actor terms instead of the stock "User/Admin/System" default;
   prefers a glossary term over coining a synonym.

Everything else stock `requirements` does well (the FR/NFR/C catalog, the user-story format, the
measurable-NFR rule, the quality-checks table, error recovery) is **kept**. Enforcement, synonym
flagging, near-match halting, and glossary write-back are **not** added here — those stay
`ubiquitous-language-guard` (the run-time partner). Contingency: this change is only valuable once a
glossary exists *before* the requirements step — see [`workflow.md`](workflow.md).

## Source materials (read these first)

A fresh session needs only this file plus these. All paths absolute.

**Guardrail rules — the source of truth for each skill's behaviour:**
- `c:\PROJ\ai-knowhow\coding\gr\gr_domain_language.md` — L1,L2,L4,L6,L8,L9
- `c:\PROJ\ai-knowhow\coding\gr\gr_ddd.md` — D1,D2,D3,D5,D7,D9
- `c:\PROJ\ai-knowhow\coding\gr\gr_algn.md` — Aln6, B5
- `c:\PROJ\ai-knowhow\coding\gr\gr_adr.md` — Adr1, Adr5, Adr8
- `c:\PROJ\ai-knowhow\coding\gr\gr_greenfield.md` — G1,G3,G5,G7,G9,G10
- `c:\PROJ\ai-knowhow\coding\gr\gr_architecture.md` — A9

**Stock AIUP skill to use as the `domain-model` baseline (modify a *copy*, never edit upstream):**
- `c:\PROJ\github\aiup\marketplace\aiup-core\skills\entity-model\SKILL.md` (reliable git clone)
- also installed at `~\.claude\plugins\marketplaces\ai-unified-process-marketplace\aiup-core\skills\entity-model\SKILL.md`

**Stock AIUP skill to use as the `domain-requirements` baseline (modify a *copy*, never edit upstream):**
- `c:\PROJ\github\aiup\marketplace\aiup-core\skills\requirements\SKILL.md` (reliable git clone)
- also installed at `~\.claude\plugins\marketplaces\ai-unified-process-marketplace\aiup-core\skills\requirements\SKILL.md`
- a project-skill copy already in this repo: `c:\PROJ\ai-mail\.claude\skills\requirements\SKILL.md`

**SKILL.md format exemplars (copy the shape):**
- `c:\PROJ\ai-mail\.claude\skills\entity-model\SKILL.md` — an existing project-skill in this repo
- other `aiup-core` bodies: `…\aiup-core\skills\{use-case-diagram,use-case-spec,requirements}\SKILL.md`

**ai-mail artifacts the skills run against (the test case only — keep them out of the SKILL bodies):**
- glossary: `c:\PROJ\ai-mail\docs\CONTEXT.md`
- `c:\PROJ\ai-mail\docs\requirements.md`, `docs\vision.md`, `docs\adr\*.md`
- scope marker (M2 vs M2b/M3/M4): `c:\PROJ\ai-mail\plan\01-foundation.md`

**Phase-4 PRD chain only (build specs #8–#10) — REQUIRED reading for those three skills:**
- `c:\PROJ\ai-mail\plan\to-prd-review.md` — the PRD-integration review and source of truth for the
  detail the #8–#10 blocks only summarize: the PRD section→artifact projection mapping (Part B), the
  brownfield graceful-degradation rule, the `testing.md` `Re: NFR-###` convention with a worked
  example, and the resolved decisions behind all three skills.
- vanilla baseline to project from (the 7-section PRD template):
  `c:\PROJ\ai-knowhow\skills-plugins\matt_pocock_skills\skills\engineering\to-prd\SKILL.md`.

**Optional background (NOT required to build):** `todo.md` section *create new skills to align aiup
and the coding project*; handoff `…\Temp\handoff-aiup-bridge-skills.md`.

## How to build a skill here (manual, no toolchain)

- **Location:** `c:\PROJ\ai-mail\skills\<skill-name>\SKILL.md`. One folder per skill; folder name =
  `name:` in the frontmatter (kebab-case). The canonical copy lives under `skills\` (version-controlled,
  Git-tracked). After writing the file, create a directory junction (symlink) so Claude Code can find it:
  `mklink /J .claude\skills\<skill-name> ..\..\skills\<skill-name>` (run from the repo root, Windows cmd;
  PowerShell: `New-Item -ItemType Junction -Path .claude\skills\<skill-name> -Target .\skills\<skill-name>`).
  An example already exists at `.claude\skills\entity-model\`.
- **Anatomy:** YAML frontmatter with `name:` and a `description:` written in the third person and
  packed with trigger phrases (the `description` is what makes the skill auto-invoke). Then a
  markdown body: `## Instructions`, `## DO NOT`, `## Workflow`, plus any reference tables — mirror the
  existing `entity-model` SKILL.md.
- **Glossary argument convention** (for the glossary-reading skills — `ubiquitous-language-guard`,
  `domain-model`, `trace-check`): accept an optional glossary path; resolve in order
  `docs/CONTEXT.md` → `docs/glossary.md`; if neither exists, warn and proceed without one. **Never
  hard-code `CONTEXT.md`** — that name is ai-mail's, not generic.
- **HITL writes:** any skill that writes back to a shared doc (`ubiquitous-language-guard` → glossary,
  `adr-threshold-gate` → `docs/adr/`, `trace-check` → the offending artifact) must show the change and
  get explicit approval before writing (Adr8, L8).
- **Single responsibility:** no orchestrator skill yet (see Composition model). Each skill is run and
  reviewed on its own.

## Orchestration — single session, one sub-agent per skill

The skills are built in **one driver session** that spawns a **sub-agent per skill** and tracks
progress via the `- [ ]` checkboxes in the per-skill build-spec headings below. Marking convention:
`- [ ]` = not built; `- [x]` = built (SKILL.md written + self-checked). The driver updates the
checkbox only after the sub-agent reports success. **IMPORTANT: run sub-agents strictly one at a time,
in ascending spec-number order — the order the `### N · <skill>` blocks appear below (#1, then #2, …).
Never run two sub-agents in parallel, even when their specs have no dependency between them.**

**Driver protocol:**

1. **Build strictly sequentially, in spec-number order.** Run exactly one sub-agent at a time, in the
   order the `### N · <skill>` blocks appear below (#1, then #2, …), and wait for each to finish
   (step 3) before starting the next — **never in parallel**, even for specs with no dependency between
   them. Sequential-in-order also satisfies every build dependency for free, because dependencies
   always point *backward* in the numbering: `domain-model` (#2) consumes the glossary
   `ubiquitous-language-guard` (#1) maintains, so #1 finishes before #2; the lenses (#3–#6) and the
   Phase-4 chain (#8–#10) likewise build one at a time in number order. Runtime composition
   (`spec-to-prd` #8 invoking `testing-strategy` #9; `tracker-trace-check` #10 reusing `trace-check`
   #6) is a *run-time* relationship and does **not** change build order. Skip any spec already marked
   `- [x]`.
2. **One sub-agent per skill.** Give each sub-agent: this file's matching `### N · <skill>` build
   spec, the `## How to build a skill here` rules, the cited `gr_*.md` source items (for
   `domain-model`, also the stock `entity-model` SKILL.md baseline), and — for the Phase-4 chain
   (#8–#10) — the spec's `Decision/rationale` doc
   [`../plan/to-prd-review.md`](../plan/to-prd-review.md), which carries the full section→artifact
   projection mapping, the brownfield-fallback behavior, and the worked examples that the compressed
   build spec only summarizes. The sub-agent writes the canonical
   `skills\<skill-name>\SKILL.md`, creates the `.claude\skills\<skill-name>` junction pointing at it
   (per `## How to build a skill here`), and runs the spec's POST self-check.
3. **Wait for completion.** The driver waits until each sub-agent finishes or reports a blocker.
   - On **success** → flip that skill's heading from `- [ ]` to `- [x]` in this file.
   - On **blocker/issue** → leave `- [ ]`, append a one-line note after the heading
     (`> blocked: <reason>`), and continue with the others; surface all blockers at the end.
4. **HITL gate.** Skills that write back to shared docs still require human approval at *run* time
   (see `## How to build a skill here` → HITL writes); building the SKILL.md does not bypass that.

> Sub-agents run cold: each must be handed enough context (its build spec + the gr items + the
> build-here rules) to produce a SKILL.md without seeing the rest of this discussion.

## Per-skill build specs

Each block is enough to build the skill cold. `gr:` = the rule items it implements (read them in the
files above). All skills are **generic** — no ai-mail specifics in the SKILL.md body; ai-mail values
appear only as the test case.

### - [x] 1 · `ubiquitous-language-guard`  (Family A · lens)
- **gr:** gr_domain_language L1,L2,L4,L6,L8,L9 + gr_greenfield G7.
- **In:** any AIUP artifact (requirements / entity_model / *.puml / use_cases/*.md) + glossary (arg).
- **Does:** flag forbidden synonyms (L2 — e.g. the glossary's `_Avoid_` lists), storage-shaped names
  (L4), silently-invented terms (L6); on a lexical/semantic near-match **halt and ask** *same /
  refinement / new*; confirm every domain name appears **verbatim** (L1).
- **Out:** a term-diff report; HITL-approved new/changed terms written **back** into the glossary
  (L8); a check that CLAUDE.md still points at the glossary (L9).

### - [x] 2 · `domain-model`  (Family B · modified core — replaces stock `entity-model`)
- **Baseline:** start from a *copy* of the stock `entity-model` SKILL.md; keep its Mermaid-ER +
  per-entity attribute-table + cross-validation structure; change only the three defects below.
- **gr:** gr_ddd D1,D2,D3,D5,D7,D9 + gr_architecture A9 + gr_domain_language (consumes glossary).
- **In:** glossary (arg), `docs/requirements.md`, `docs/adr/*`.
- **Does:** classify **each** glossary term as **Entity | Value-Object | Aggregate-root** (D5/D2 —
  not "everything is a table with an `id`"); turn implied invariants into **validation rules**
  (D3/D9); keep infrastructure **out** of the model (A9 — model domain identity, never a transport/
  storage id); **conceptual-first** — physical datatypes (`Long`/`Decimal`/`Sequence`/PK) appear
  **only** when a storage target is explicitly declared; use glossary terms **verbatim**.
- **Out:** `docs/entity_model.md` — **keep this filename** though the skill is named `domain-model`;
  it is the AIUP chain contract that `use-case-spec` and `trace-check` read.
- **POST self-check:** ER uses glossary names verbatim; no storage datatypes leaked in conceptual
  mode; no out-of-scope (deferred) entities; any genuinely-new structural entity looped back into the
  glossary via `ubiquitous-language-guard`.

### - [x] 3 · `hidden-constraint-sweep`  (Family A · lens)
- **gr:** gr_algn Aln6 + B5.
- **In:** a requirements doc or a use-case spec (+ glossary/context).
- **Does:** run the 8-class checklist — security/PII, permissions, data-retention, migrations,
  observability, public-API-compat, concurrency, out-of-scope — each → `covered` (pointer) |
  `not-applicable` (recorded reason) | `missing` (blocks).
- **Out:** a per-class table; `missing` classes become new FR/NFR, use-case alt-flows, or G9
  deferrals.

### - [x] 4 · `adr-threshold-gate`  (Family A · lens)
- **gr:** gr_adr Adr1, Adr5, Adr8.
- **In:** any artifact (pre or post) + `docs/adr/*`.
- **Does:** scan for decisions crossing **Adr1** (hard-to-reverse AND surprising AND real
  trade-off); per hit, HITL-ask "ADR-worthy?" naming the three criteria; draft per **Adr5** (Context
  / Decision / Consequences / Alternatives); status `proposed`→`accepted` by HITL only (**Adr8**).
- **Out:** a new `docs/adr/NNNN-*.md` (proposed) per qualifying decision + a one-line "no-ADR, why"
  note for sub-threshold ones.

### - [x] 5 · `pareto-scope-cut`  (Family A · lens)
- **gr:** gr_greenfield G1,G3,G5,G9,G10.
- **In:** any planning artifact + the project's scope marker (ai-mail: M2 vs M2b/M3/M4 in
  `plan/01-foundation.md`).
- **Does:** flag entities/FRs/flows built for imagined/future needs (G1/G3/G5/G10); push each to a
  deferred list with a one-line postponed-decision record (G9).
- **Out:** an in-scope vs deferred split + a "Postponed decisions" log appended to the artifact.

### - [x] 6 · `trace-check`  (Family A · lens — the one new downstream concern)
- **gr:** gr_domain_language L1 + AIUP-native traceability (no single gr cluster).
- **In:** `docs/requirements.md`, `docs/use_cases.puml`, `docs/use_cases/*.md`,
  `docs/entity_model.md`, glossary.
- **Does:** verify every UC traces to ≥1 FR; every entity named in a spec exists in
  `entity_model.md`; every actor matches the glossary (L1); every business rule (BR-###) maps to a
  domain-model invariant.
- **Out:** a consistency report (pass / list of breaks); HITL fixes loop back into the offending
  artifact.

### - [x] 7 · `domain-requirements`  (Family B · modified authoring — replaces stock `requirements`)
- **Baseline:** start from a *copy* of the stock `requirements` SKILL.md; keep its FR/NFR/C catalog
  structure, user-story format, quality-checks table, and error-recovery **wholesale** — change **only**
  the glossary-consumption defect below.
- **gr:** gr_domain_language L1 (canonical terms **verbatim**) — **consumes** the glossary; does **not**
  enforce or evolve it (that stays `ubiquitous-language-guard`).
- **In:** glossary (arg; resolve `docs/CONTEXT.md` → `docs/glossary.md`; warn-and-continue if absent),
  `docs/vision.md`.
- **Does:** read the glossary as input; draw FR actors/roles from the glossary's actor terms (**not**
  the stock "User/Admin/System" default); use domain terms **verbatim** in titles/user-stories/
  constraints; prefer a glossary term over coining a synonym. Everything else stock `requirements` does
  is kept.
- **Out:** `docs/requirements.md` — **keep this filename** (AIUP chain contract downstream skills read).
- **POST self-check:** actors trace to glossary terms; no storage-shaped or silently-invented domain
  nouns in FR titles; any genuinely-new term is flagged for the `ubiquitous-language-guard` write-back
  loop (L8) rather than silently coined.
- **NOTE (contingency):** only useful once a glossary exists *before* this step — see
  [`workflow.md`](workflow.md) (grill-with-docs seeds `CONTEXT.md` before requirements). On a cold
  project with no glossary, it degrades to stock behaviour (warn-and-continue).

### - [x] 8 · `spec-to-prd`  (authoring — replaces external `to-prd`; Phase 4)
- **Decision/rationale:** [`../plan/to-prd-review.md`](../plan/to-prd-review.md) (Decision 9). Projects
  the existing spec spine onto the tracker as a **thin** PRD; supersedes the vendored `to-prd` (which
  authors from conversation). Falls back to vanilla codebase-driven authoring **only** where the spine
  is missing/thin (brownfield).
- **gr:** gr_documentation Doc5 (no duplication of authoritative sources) + gr_domain_language L1
  (consume glossary verbatim, read side) + gr_adr (respect/flag ADRs) + AIUP-native traceability
  (carry `FR/UC/BR/ADR` IDs onto the tracker).
- **In:** scope marker (arg → the requirements doc's declared milestone / Status scope split → ask only
  if genuinely ambiguous); AIUP chain defaults `docs/requirements.md`, `docs/use_cases/*.md` +
  `docs/use_cases.puml`, `docs/entity_model.md`, `docs/vision.md`, glossary (arg; `docs/CONTEXT.md` →
  `docs/glossary.md` → warn), `docs/adr/*`, the postponed-decisions log, and
  `docs/testing/<milestone>.md` (from #9) — overridable by an optional manifest arg. Tracker via
  `docs/agents/issue-tracker.md`; label vocabulary via `docs/agents/triage-labels.md`.
- **Does:** resolve the in-scope FR/UC set at the marker; **interactive deep-module sketch** (HITL —
  modules + which want tests), grounded in entity model + use cases (+ codebase in brownfield); invoke
  `testing-strategy` (#9) in-session so it sees the just-decided modules; draft a thin PRD on the
  vanilla 7-section template (Problem Statement · Solution · User Stories · Implementation Decisions ·
  Testing Decisions · Out of Scope · Further Notes), **linking `FR/UC/BR/ADR` IDs** for spine-derived
  sections and authoring fresh **only** module + testing decisions (Testing Decisions links
  `docs/testing/<milestone>.md`); run the composed lenses (`ubiquitous-language-guard`,
  `hidden-constraint-sweep`, `adr-threshold-gate`) on the draft.
- **Out:** **one thin PRD per milestone** published to the tracker (`ready-for-agent`), carrying
  traceability refs; duplicates no spine content.
- **POST self-check:** PRD restates no spine content (links IDs); every in-scope requirement is linked
  by ID and present on the tracker (forward coverage); scope marker honored; lenses run; generic body
  (no hard-coded project paths beyond the AIUP chain defaults).
- **Section→source projection** (link IDs, never restate — full table in `to-prd-review.md` Part B):
  Problem Statement ← `docs/vision.md` + pain catalogue (background, not quoted); Solution ←
  `docs/vision.md` golden-path; User Stories ← `docs/requirements.md` FRs *carried with their `FR-###`
  IDs* + `UC-###` refs; Implementation Decisions ← ADRs (linked) + `docs/entity_model.md` + the
  interactive module sketch (authored fresh); Testing Decisions ← `docs/testing/<milestone>.md` (#9) +
  NFRs by `NFR-###`; Out of Scope ← requirements OOS + the postponed-decisions log. Internal IDs
  (`P##`/`A##`, `M#`/`F##`) inform synthesis but are **never** quoted into the published PRD.
- **Brownfield graceful-degradation:** for any spine artifact that is missing or thin, fall back to
  codebase-driven authoring (vanilla `to-prd` behavior) **for that section only**. `spec-to-prd` is a
  *superset* of the vanilla skill, not a replacement that assumes a complete spine.

### - [x] 9 · `testing-strategy`  (authoring — new artifact; Phase 4)
- **Decision/rationale:** [`../plan/to-prd-review.md`](../plan/to-prd-review.md) (Decisions 2–3). Owns
  the *how-to-test* artifact, invoked by #8 right after the module sketch so it can read the
  just-decided (ephemeral) modules.
- **gr:** gr_greenfield G8 (initial testing strategy) + gr_documentation Doc5 (reference, don't duplicate).
- **In:** the just-decided module decomposition (from #8's in-session sketch); `docs/requirements.md`
  NFRs/constraints (the thresholds to *reference*); the chosen stack if declared (else stack-agnostic +
  flag); the `tdd` skill (universal philosophy to *reference*); scope marker.
- **Does:** author the **project-specific** strategy only — module/test-surface priorities, test-double
  policy at the real boundaries, prior art (immediate in brownfield); **every entry opens `Re: NFR-###`
  / `Re: C-###`** (references the threshold, **never restates** it) and references the `tdd` skill for
  universal philosophy rather than restating it; stack undeclared → write stack-agnostic + flag the
  dependency.
- **Out:** **one `docs/testing/<milestone>.md` per milestone** (HITL write).
- **POST self-check:** every entry cites an NFR/constraint; no threshold restated; no `tdd` philosophy
  duplicated; stack assumptions flagged where the stack is undeclared.
- **Worked example — the `Re: NFR-###` convention** (the NFR holds the bar; `testing.md` holds only the
  *how*): *NFR-002 states "0 duplicate writes" →* `testing.md` entry: "`Re: NFR-002` — run the batch
  twice through the apply surface against a temp Routing Root + temp ledger; assert 0 new files, 1 new
  provenance link; real temp FS, fake mail source." The threshold ("0 duplicate writes") stays in the
  NFR and is **referenced, never copied**.

### - [x] 10 · `tracker-trace-check`  (Family A · lens — tracker-aware counterpart of `trace-check`; Phase 4)
- **Decision/rationale:** [`../plan/to-prd-review.md`](../plan/to-prd-review.md) (Decision 4). The
  repo↔tracker drift audit, **built up front**; offline `trace-check` (#6) stays unmodified.
- **gr:** AIUP-native traceability (no single gr cluster, like `trace-check`) + gr_domain_language L1
  (actors). **Reuses** `trace-check`'s convention-discovery (id patterns, name normalization) — does
  not reinvent it.
- **In:** the in-repo spine (`docs/requirements.md`, `docs/use_cases/*.md` + `docs/use_cases.puml`,
  `docs/entity_model.md`, glossary); the published PRD/issues for a milestone (tracker via
  `docs/agents/issue-tracker.md`); scope marker.
- **Does:** **dangling-ref check** (every `FR/UC/BR/ADR` id cited on the tracker resolves to a real
  spine artifact) and **forward-coverage check** (every in-scope requirement is on the tracker) as
  mechanical PASS/FAIL; **semantic-divergence check** (a tracker item contradicts its linked spine
  artifact) as `needs-human-confirmation` (à la `trace-check` Check D).
- **Out:** a consistency report (pass / list of breaks); HITL fix loop — repo-side fixes proposed into
  the offending artifact, tracker-side fixes proposed, **never auto-applied**.
- **POST self-check:** mechanical checks deterministic; semantic divergences marked
  `needs-human-confirmation`, not auto-fixed; no tracker write without HITL; convention-discovery reused
  from `trace-check`, not duplicated.

## Composition model

By **convention**, not a heavyweight orchestrator (Pareto; `gr_greenfield` G5 = extract shared
structure only once it's actually reused twice):

```
ubiquitous-language-guard   →  (enforce glossary on requirements)
pareto-scope-cut            →  (cut imagined scope)
domain-model                →  (produce the model, glossary-aware, VO/aggregate-aware)
adr-threshold-gate          →  (catch any irreversible modelling decision)
hidden-constraint-sweep     →  (retention/concurrency/PII the model implies)
```

Each step is invoked explicitly and reviewed between runs (AIUP's edit-between-steps discipline).
A thin per-step **orchestrator** (`prep-domain-model`, etc.) is deferred — add one only if running
the lenses by hand proves annoying across ≥2 steps.

The full end-to-end order (inception → vision → glossary → requirements → model/spec spine → post-spec)
lives in [`workflow.md`](workflow.md). `domain-requirements` runs at the **requirements step**, *before*
this model-phase chain.

## Build order (value-first, Pareto)

Built and tested **as ai-mail project skills** for now (not via the coding `/make-skill` toolchain —
see Placement). Source material per skill = the cited `gr_*.md` items +, for `domain-model`, the
stock `aiup-core:entity-model` SKILL.md body as the baseline to modify.

1. **`ubiquitous-language-guard`** — highest reuse; standalone; fixes the "glossary ignored" gap
   that motivated everything.
2. **`domain-model`** — the immediate next AIUP step for ai-mail; consumes #1's glossary.
3. **`hidden-constraint-sweep`** + **`adr-threshold-gate`** — needed by the use-case-spec step;
   retroactively useful on the model.
4. **`pareto-scope-cut`** — embed inline in the modelling step first; extract to a standalone skill
   only once a second consumer appears (G5).
5. **`trace-check`** — the one genuinely-new downstream concern: cross-artifact consistency
   (UC→FR, entity-in-spec, actor↔glossary, BR↔invariant). Step-agnostic like the other lenses.
6. **`domain-requirements`** *(not yet built — the one skill a fresh session must still create; build
   spec #7)* — fork stock `requirements` to consume the glossary. Independent of #1–#5; build it from
   build spec #7 + the stock `requirements` baseline.
7. **Phase-4 PRD chain** *(not yet built — build specs #8–#10)* — `spec-to-prd`, `testing-strategy`,
   `tracker-trace-check`. The matt-pocock `to-prd` integration (rationale + section→artifact mapping:
   [`../plan/to-prd-review.md`](../plan/to-prd-review.md)). **No build dependency among them** (they
   compose only at *run* time — `spec-to-prd` invokes `testing-strategy`, and `tracker-trace-check`
   reuses `trace-check`'s convention-discovery) — but per the **Orchestration** rule the driver still
   builds them **one at a time in spec order (#8 → #9 → #10), never in parallel**.

**Downstream use-case steps need no modified skill** (decided 2026-06-03; **superseded 2026-06-05 by
Decision 8** — the use-case steps are now the forks `usecase-diag` / `usecase-spec`; the paragraph
below records the original reasoning). `use-case-diagram` and
`use-case-spec` run as **stock `aiup-core` + composed Family-A lenses + `trace-check`**. The lenses
are step-agnostic, so they already cover the stock gaps: fabricated actors → `ubiquitous-language-guard`;
weak scope/slice → `pareto-scope-cut`; thin alt-flows → `hidden-constraint-sweep`; unforced
interaction-surface decision → `adr-threshold-gate`. Build a modified `use-case-spec` **only
reactively** — if composition visibly fails on business-rule↔invariant linkage (the one thread stock
spec can't reach, since it reads puml + requirements but never the domain-model). `domain-model` was
the exception that needed a modified skill; the use-case steps are not.

## ai-mail as the first test case

ai-mail exercises every skill against a real model: glossary at
[`../docs/CONTEXT.md`](../docs/CONTEXT.md), requirements at
[`../docs/requirements.md`](../docs/requirements.md), ADRs in `../docs/adr/`. Expected VO/aggregate
calls: `Confidence`/`RoutingKey`/`Sender` = value-objects; `Mail`/`Attachment`/`Proposal`/
`Ledger-entry` = entities; the Provenance Ledger = its own aggregate (ADR-0001). Deferred (M2b)
terms — Document Type, Naming Scheme, F32 — must be cut by `pareto-scope-cut`, not modelled.

**Method-test capture** (this project is a live workflow experiment): for each skill, log where it
caught something stock AIUP missed vs. where it was overhead. Feed findings back into the skill's
source docs.

## Placement

For now, build and iterate the skills **inside ai-mail as project skills** — ai-mail is the
**sandbox** for trying skillsets, not yet wired to the coding toolchain. Do **not** use the coding
repo's `/make-skill` for now.

**File layout:**
- Canonical skill files live under `skills\<name>\SKILL.md` (version-controlled, tracked in Git).
- `.claude\skills\<name>` is a directory junction pointing at `skills\<name>` — it is what Claude
  Code actually looks up; it is **not** the authoritative copy. Create one junction per skill right
  after writing the SKILL.md (see **Location** under "How to build a skill here").

Once a skill proves out here, port it back to the coding project (mechanism TBD — likely the
`skills/output/` toolchain later). Upstream `aiup-core` marketplace stays **untouched** throughout.

## Decisions (all resolved — nothing open)

1. **Skill name = `domain-model`** (not `entity-model`) — signals the conceptual/DDD upgrade and
   avoids confusion with the still-installed `aiup-core:entity-model`.
2. **Output filename stays `docs/entity_model.md`** — the AIUP chain contract downstream skills
   (`use-case-spec`, `trace-check`) read. The skill is renamed; its output file is not.
3. **Glossary = an argument**, resolved `docs/CONTEXT.md` → `docs/glossary.md`, warn-and-continue if
   absent. No skill hard-codes `CONTEXT.md`.
4. **Downstream use-case steps need no modified skill** — stock `aiup-core` + Family-A lenses +
   `trace-check`. A modified `use-case-spec` is built **only reactively** if BR↔invariant linkage
   breaks. **(Superseded 2026-06-05 — see Decision 8.)**
5. **Build & test as ai-mail project skills, by hand** — no `/make-skill` for now; port back to the
   coding project later (mechanism TBD).
6. **No orchestrator skill yet** — compose by convention; extract a `prep-*` only if manual
   sequencing proves annoying across ≥2 steps (G5).
7. **Fork stock `requirements` → `domain-requirements`** (2026-06-03) — a *thin* second authoring fork.
   Unlike `domain-model` (which fixed *structural* defects a lens can't post-process), this fixes the
   single *consumption* defect: stock `requirements` reads only `vision.md`, never a glossary, so it
   coins terms and defaults to "User/Admin/System" actors. The fork makes it **consume** the glossary
   (terms + actors verbatim) — and nothing else; enforcement/evolution stays `ubiquitous-language-guard`.
   Justified despite the reactive-only rule (Decision 4) because (a) requirements is regenerated against
   the glossary, so prevention-at-generation beats lens-cure-after, and (b) the workflow now seeds the
   glossary *before* the requirements step ([`workflow.md`](workflow.md)), so the fork has something to
   read on pass one. Output filename stays `docs/requirements.md`.
8. **Fork stock `use-case-diagram`/`use-case-spec` → `usecase-diag`/`usecase-spec`** (2026-06-05) —
   supersedes Decision 4's reactive-only stance. Two reasons: (a) the project is diverging from stock
   `aiup-core` toward an owned use-case toolchain, and (b) the anticipated reactive trigger effectively
   fired — **completeness**. A downstream lens (`trace-check`) can only check **UC→FR** (orphan/fabricated
   use cases), never **FR→UC** (a *missing* use case); guaranteeing every in-scope FR yields a use case is
   a *generation-time* property, so prevention-at-authoring beats lens-cure-after — the same logic as
   Decision 7 (`domain-requirements`). The forks **consume** the glossary (actors verbatim, L1 read side)
   and the scope marker (in-scope FR set) but, like the other forks, do **not** enforce the glossary or
   cut scope (those stay `ubiquitous-language-guard` / `pareto-scope-cut`). `usecase-diag` guarantees
   forward coverage (every in-scope FR → ≥1 UC or a recorded spec-level detail); `usecase-spec` emits a
   `Requirements covered (FR-###)` trace line — which supplies the very UC→FR convention `trace-check`
   Check A is gated on — and enforces fail-closed reverse coverage (every in-scope FR cited by ≥1 spec).
   The earlier BR↔invariant trigger is folded into `usecase-spec` as a cite-or-flag grounding step (it
   cites an existing invariant or flags a missing one; it never authors it). Output filenames stay
   `docs/use_cases.puml` and `docs/use_cases/*.md` (AIUP chain contract). `trace-check` is left
   **unmodified**; adding a reverse FR→UC check there is now *optional drift-insurance*, not load-bearing.
9. **Phase-4 PRD chain = `spec-to-prd` + `testing-strategy` + `tracker-trace-check`** (2026-06-07) — the
   matt-pocock `to-prd` integration; full rationale and the PRD section→artifact mapping live in
   [`../plan/to-prd-review.md`](../plan/to-prd-review.md). (a) **`spec-to-prd`** replaces the vendored
   `to-prd`: it *projects* the spec spine onto the tracker as a **thin, milestone-scoped** PRD (links
   `FR/UC/BR/ADR` IDs, duplicates nothing — Doc5) instead of re-authoring from conversation, falling
   back to vanilla authoring only where the spine is thin (brownfield). (b) **`testing-strategy`** owns
   `docs/testing/<milestone>.md` (closes G8; references NFR thresholds + the `tdd` philosophy, restates
   neither), invoked by `spec-to-prd` right after its module sketch. (c) **`tracker-trace-check`** is the
   repo↔tracker drift audit, **built up front**; offline `trace-check` is left unmodified. **One PRD and
   one `testing.md` per milestone.** Module decomposition stays an *interactive* step inside
   `spec-to-prd` (no pre-baked module artifact — premature architecture, G1/G5/G6). Build specs #8–#10.
