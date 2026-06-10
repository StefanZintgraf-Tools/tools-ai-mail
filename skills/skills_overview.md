# Skills Overview

Overview of the project skills in this `skills/` folder. Each entry records, for one
skill: its **purpose**, the **input artifacts** it must consume, the **output
artifacts / results** it produces, and how it **relates to the guardrail items** in
`ai-knowhow/coding/gr/gr_*.md` (the `gr_XXXX.md` rule files this skill set operationalizes).

Entries are added one skill at a time, in the order of the "skill overview and review"
list in `todo.md`. A skill is reviewed here only after the matching SKILL.md has been
read and cross-checked against its guardrail rules.

Guardrail file legend (referenced below):

- `gr_domain_language.md` — rules `L1`–`L9` (ubiquitous language).
- `gr_greenfield.md` — rules `G1`–`G10` (greenfield design discipline).
- `gr_ddd.md` — rules `D1`–`D9` (tactical domain-driven design).
- `gr_architecture.md` — rules `A1`–`A11` (architecture / infrastructure isolation).
- `gr_adr.md` — rules `Adr1`–`Adr10` (architectural decision records).
- `gr_algn.md` — `Aln#` rules (alignment; incl. `Aln6` hidden-constraint checklist).
- `gr_idea.md` — idea→PRD distillation arc (requirements/specification step).
- `gr_rev.md` — `Rev#` rules (review checklist; mirrors `Aln6` at review time).
- `gr_governance.md` — `Gov#` rules (governance / approval gates).
- `gr_documentation.md` — `Doc#` rules (docs stay aligned, no duplicated sources).

---

## Contents

1. [`bmad-brainstorming` — **HITL**](#bmad-brainstorming--hitl)
2. [`declare-milestone` — **authoring**](#declare-milestone--authoring)
3. [`grill-with-docs` — **external**](#grill-with-docs--external)
4. [`domain-requirements` — **authoring**](#domain-requirements--authoring)
5. [`ubiquitous-language-guard` — **lens**](#ubiquitous-language-guard--lens)
6. [`pareto-scope-cut` — **lens**](#pareto-scope-cut--lens)
7. [`domain-model` — **authoring**](#domain-model--authoring)
8. [`adr-threshold-gate` — **lens**](#adr-threshold-gate--lens)
9. [`hidden-constraint-sweep` — **lens**](#hidden-constraint-sweep--lens)
10. [`usecase-diag` — **authoring**](#usecase-diag--authoring)
11. [`usecase-spec` — **authoring**](#usecase-spec--authoring)
12. [`trace-check` — **lens**](#trace-check--lens)
13. [`prototype` — **external**](#prototype--external)
14. [`to-prd` — **external** (superseded by `spec-to-prd`)](#to-prd--external-superseded-by-spec-to-prd)
15. [`spec-to-prd` — **authoring**](#spec-to-prd--authoring)
16. [`testing-strategy` — **authoring**](#testing-strategy--authoring)
17. [`to-issues` — **external**](#to-issues--external)
18. [`tdd` — **external**](#tdd--external)
19. [`tracker-trace-check` — **lens**](#tracker-trace-check--lens)
20. [`review-skills` — **meta**](#review-skills--meta)
21. [`refactor-skills` — **meta**](#refactor-skills--meta)

---

## `bmad-brainstorming` — **HITL**

**Purpose.** Facilitates interactive brainstorming sessions using diverse creative techniques and ideation methods. Used twice in the workflow: Phase 1 Step 1 to seed inception artifacts (`painlist.md`, `00-foundation.md`) using an AI-recommended method with Pareto prioritization, and Phase 1 Step 3 to challenge vision goals using Assumption Reversal and produce `01-foundation.md`. Produces no downstream artifact itself; its outputs are raw inception material consumed by downstream skills.

---

## `declare-milestone` — **authoring**

**Purpose.** Selects and durably declares the **next milestone** — the in-scope slice one PRD-loop iteration will ship — up front, at the start of the loop and *before* the vision step, rather than reconstructing it late from a status column. Because the vision is milestone-bound, the milestone must exist first: this skill picks it by honouring the project's build-order **dependencies**, the **Pareto / one-slice-at-a-time** discipline (commit to a single slice, not a multi-release roadmap), and the **already-shipped state**, then records the choice durably and HITL-confirms it. Its output becomes the scope-defining input the vision step is written against. It models no entities, authors no requirements, and does **not** fork the spec spine per milestone (those are sibling concerns); it only declares the milestone. On loop-back — when the declared milestone ships — it is re-run to pick the successor, seeding a fresh vision.

**Input artifacts (must use).**

- **The capability / build-order plan** (required) — the project's plan that names the candidate capabilities/primitives and their ordering, resolved by a fallback chain — never a hard-coded path: an explicit plan path passed as an argument → a conventional plan location in the repo → if neither is found, **ask** the user which plan defines the build order. It is never guessed silently, and no project's plan paths or marker names are hard-coded.
- **Already-shipped state** (required) — what previous iterations have already delivered (the predecessor milestone and the shipped capabilities), so the next pick respects what is done and is not re-selected. Read from the durable declaration location and/or the plan's status; if it cannot be determined, the user is asked rather than assumed.

**Output artifacts / results.**

- **A declared milestone** — recorded durably in a project-designated location: its **name**, the **capability / primitive set it commits to**, and its **predecessor** (the milestone it builds on). This record is the scope-defining input the vision step consumes.
- **A HITL confirmation** of the selected milestone before it is committed — the dependency/Pareto/shipped-state reasoning is shown and the human approves the choice; the selection is never written silently.
- **Loop-back behaviour** — on a fresh run after milestone N ships, the skill picks N+1 (next by dependency + Pareto, not yet shipped) and declares it, so a new vision can be written against the new scope.

**Relation to guardrail items.** This skill is the executable form of the greenfield build-order discipline in **`gr_greenfield.md`** — the Pareto / one-slice-at-a-time framing for "pick the next thing to build," carried over verbatim:

- **G10** Smallest Architecture / Next Known Requirement — the milestone is sized to the *next* concrete slice the build order calls for, not a multi-release roadmap; one slice is committed at a time.
- **G3** Defer Expensive Decisions — candidates whose dependencies are unmet, or that belong to a later slice, are left for a future iteration rather than pulled forward into the current milestone.

*Note:* the skill only *declares* scope — it does not perform the item-level scope cut or the postponed-decision log (those stay `pareto-scope-cut`), author the vision/requirements (those are downstream), or fork the spec spine per milestone. It selects, records, and HITL-confirms the milestone, and nothing more.

---

## `grill-with-docs` — **external**

**Purpose.** Stress-tests a plan against the existing domain model: sharpens terminology, challenges assumptions, and records durable decisions as ADRs in `docs/adr/`. Its defining role in this workflow is seeding `docs/CONTEXT.md` (the ubiquitous-language glossary) **before** the requirements step, so `domain-requirements` can consume a real glossary on its first pass. Used twice: Phase 2 Step 4 (full grill of `docs/vision.md` + `01-foundation.md`) and Step 8 (targeted re-grill of the diff only, restricting the subject to `git diff HEAD~1 HEAD`).

---

## `domain-requirements` — **authoring**

**Purpose.** Produces `docs/requirements.md` — a catalog of functional requirements (user stories), measurable non-functional requirements, constraints, and an explicit **out-of-scope / non-goals** list, all written in the project's **ubiquitous language**. Two behaviors are load-bearing: (1) the **vocabulary input** — it reads the glossary (in addition to the vision document), draws actors/roles from the glossary's actor terms verbatim (with a heuristic for *identifying* which glossary entries are actors, and a "single actor → don't invent extra roles" rule), and uses domain nouns exactly as defined; and (2) it **carries negative decisions forward** — the vision's non-goals and any alignment rejections become an Out-of-Scope section so scope can be defended later (Aln15). It also frames `requirements.md` as a *summary* of upstream alignment, not the origin of the design concept (Aln13). The catalog it emits is **vision-scoped** — it documents exactly the slice the vision already chose, inheriting that scope rather than deciding scope itself: it does **not** apply the milestone deferral cut (the Open/Deferred split — that stays `pareto-scope-cut`'s "Scope split"), does **not** reach beyond the vision into other capabilities, and is **never bound to a module/milestone identifier** in its title, examples, or tables (the upstream step that *declares* the milestones — analysed in `milestone_review.md` §3.5 — is the `declare-milestone` concern, handed off cleanly, not restated here). It does *not* model entities, cut scope, or gate ADRs (those are sibling skills), and — critically — it does *not* enforce, evolve, or write back to the glossary (that stays `ubiquitous-language-guard`); it is **consume-only** on the glossary.

**Input artifacts (must use).**

- **Vision document** (required) — `docs/vision.md`, the source the requirements catalog is derived from. Its **non-goals / out-of-scope** section is read too and carried forward (Aln15). If absent, the skill STOPS — it is the required input.
- **Glossary** (the ubiquitous-language file), resolved by a fallback chain — never a hard-coded filename:
  1. an explicit glossary path passed as an argument → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  2. none found → warn ("No glossary found; proceeding without one — domain terms cannot be verified verbatim and actors will fall back to generic roles") and degrade to **generic behaviour** (generic roles, terms from the vision document), noting that requirements should be re-run once a glossary exists.
- **Foundation / build-order / capability plan** (optional) — whatever artifact carries the project's stable upstream IDs (capabilities, primitives, pains, or equivalent), the source for the per-requirement upstream trace. Resolved by the same kind of fallback chain as the glossary — never a hard-coded filename: 1. an explicit foundation-plan path passed as an argument → 2. a conventional plan path → 3. none found → note ("No foundation plan found; emitting the catalog without upstream-ID traces") and **skip** the upstream trace. Upstream IDs the project does not define are **never invented** — the trace degrades to a no-op when no plan exists.
- **Negative-decision sources** (optional) — an alignment transcript (`algn_transcript.md`) and/or an idea file (`idea.md`) are read for negative decisions *if present*; their absence is not an error (the vision's out-of-scope suffices).

**Output artifacts / results.**

- `docs/requirements.md` — fixed filename so the downstream chain stays intact (downstream `use-case-diagram`, `use-case-spec`, `domain-model`, `trace-check` read it), but positioned as a **summary** of upstream alignment, not the source of the design concept (Aln13).
- A **`Source:` trace line** opening the document — naming the upstream artifacts the catalog derives from (the vision, plus the foundation plan when one was resolved, and the resolved glossary path) so traceability is visible at the top. When a foundation plan defining stable upstream IDs was resolved, each requirement also carries a **per-requirement upstream trace** citing the upstream element it realises (in its Title or a trace column); where no such plan exists the trace is a no-op and no ID is invented.
- Four non-mixed Markdown tables: **FR** (user-story format, `As a [role], I want [goal] so that [benefit]`, roles drawn from glossary actor terms), **NFR** (measurable quality attributes, categorized), **Constraints** (categorized technical/business/schedule limitations), and **Out-of-Scope / Non-Goals (OOS)** (one row per negative decision, each citing its source) — each row carrying a unique ID and a filled Status column, validated against the Requirement Quality Checks table (Measurable, Singular, Unambiguous, Testable, Unique IDs, Verbatim).
- A **Flagged Terms** section — a concrete landing place where a concept a requirement needs but the glossary does not name is *surfaced for the `ubiquitous-language-guard` write-back loop*, not silently coined here.

**Relation to guardrail items.** This skill operationalizes the requirements/specification step that follows the **`gr_idea.md`** distillation arc — it sits at the `prd` stage (a structured FR/NFR/constraint specification), **not** the `ide` stage (`idea.md` is 3–6 goals with no acceptance criteria); the genuine carry-forward it honors is **Idea3** negative goals → Aln15 out-of-scope. It realizes the destination-document role in **`gr_algn.md`**: **Aln13** (requirements.md *summarizes* alignment, does not replace it) and **Aln15** (negative decisions carried into the out-of-scope section). Its glossary consumption is bounded by specific rules of **`gr_domain_language.md`**, cited verbatim:

- **L1** Use Defined Terms Exactly — domain nouns and actors appear verbatim in titles, user stories, constraints, and out-of-scope items; no casual variation, abbreviation, translation, pluralization, or re-casing.
- **L6** Introduce New Terms Explicitly — a genuinely-new concept is *flagged in the Flagged Terms section*, never silently invented; it is routed to the `ubiquitous-language-guard` write-back loop rather than coined in the requirements doc.
- **L8** `CONTEXT.md` Is the Ubiquitous-Language Artifact — honored on the *read* side only: the glossary (`CONTEXT.md` / `glossary.md`) is treated as the source of truth for terms and consumed as ground truth (the write-back itself is L8, owned by `ubiquitous-language-guard`).

*Note:* this skill deliberately does **not** implement the *enforcement* or *write-back* half of `gr_domain_language.md` — **L2** (forbidden synonyms), **L4** (storage-shaped names), **L5** (rename propagation), **L7** (near-match / bounded-context gating), and the **L8 write-back** to the glossary all stay with `ubiquitous-language-guard`. `domain-requirements` only consumes the glossary; it never edits, flags forbidden synonyms, halts on near-matches, or writes terms back.

---

## `ubiquitous-language-guard` — **lens**

**Purpose.** A cross-cutting lens that protects meaning: one concept → exactly one name
everywhere (requirements, models, diagrams, specs, code, UI). It audits a single project
artifact against the project glossary, produces a **term-diff report**, and — only with
explicit human approval (HITL) — evolves the glossary itself. It does *not* model
entities, cut scope, or gate ADRs (those are sibling skills).

**Input artifacts (must use).**

- **Artifact under review** (required) — one project artifact: `requirements.md`, an entity
  model, a `*.puml` use case diagram, a `use_cases/*.md` spec, or a PRD draft (the
  pre-publish `spec-to-prd` Phase-4 projection — in-session/inline content, not necessarily
  a file on disk). Named by the user or the file in focus.
- **Glossary** (the ubiquitous-language file), resolved by a fallback chain — never a
  hard-coded filename:
  1. explicit path the user passed → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  2. none found → warn and drop to **report-only** mode running **L4 only** (L1/L2/L6 and
     the L8 write-back cannot run without a glossary).
- **`CLAUDE.md`** (read-only) — checked for a pointer to the resolved glossary (L9), only
  when a glossary exists.

**Output artifacts / results.**

- A **term-diff report** (template in the SKILL.md) with sections: L1 verbatim violations,
  L2 forbidden/candidate synonyms, L3 technical names in the domain layer, L4
  storage-shaped names, L6 new/unknown terms, L7 cross-context collisions, near-match
  decisions (incl. an `UNRESOLVED` state for AFK runs), proposed glossary changes, and L9
  CLAUDE.md pointer status.
- **HITL write-back** of approved new/refined terms into the resolved glossary file
  (`docs/CONTEXT.md` / `docs/glossary.md`) — per-change approval, structure preserved.
- A **proposed CLAUDE.md pointer fix** when the pointer is missing/wrong — *surfaced, not
  auto-applied* (CLAUDE.md ownership stays with the human).

**Relation to guardrail items.** This skill is the executable form of the
`align-concept` rules in **`gr_domain_language.md`**, with the check IDs carried over
verbatim:

- **L1** Use defined terms exactly (verbatim) — flags casual variation, abbreviation,
  pluralization/casing drift, translation.
- **L2** No forbidden synonyms — checks each term's `_Avoid_` list; **when no `_Avoid_`
  list exists, falls back to judgment** and flags plausible synonyms as *candidates* for
  human confirmation (never reports an empty table as "clean"). A synonym is allowed only
  if the glossary defines it as a *different* concept.
- **L3** Separate domain terms from technical terms — flags technical-suffixed names
  (`InvoiceDTO`, `InvoiceRow`) in the conceptual/domain-layer artifacts it audits, **with
  the layer caveat**: a name explicitly scoped to a technical layer is not flagged.
- **L4** Naming reflects behavior, not storage — flags `Table`/`Row`/`Record`/`DTO`/
  `Blob`/`Json`/`Payload`/`Flag`… used as the domain name. (L4 is the only check that runs
  without a glossary.)
- **L6** Introduce new terms explicitly — no silent invention; a **domain-significant**
  term (actor/role, entity/aggregate, status value, operation/event, or capitalized domain
  noun — excluding generic English and tech vocab) absent from the glossary is flagged with
  a proposed definition or routed through the near-match gate. The near-match gate
  (same / refinement / new) is **batched** and, on AFK runs with no human, marks items
  `UNRESOLVED` rather than guessing; `same` decisions fold back into the L1/L2 tables.
- **L7** Match language across bounded contexts deliberately — **partial**: the near-match
  gate covers intra-context look-alikes, and when the glossary defines a term in more than
  one bounded context the skill audits the artifact against its own context and flags
  same-word cross-context collisions (it does not handle the full "same word, two contexts"
  case beyond flagging).
- **L8** the glossary (`docs/CONTEXT.md` / `docs/glossary.md`) is the ubiquitous-language
  artifact and the source of truth for terms — realized here as the HITL write-back to that
  file. Newly confirmed vocabulary
  (the former standalone "G7" concern) feeds this write-back so the glossary stays current.
- **L9** CLAUDE.md points to the domain docs — verified (only when a glossary exists) with
  the canonical role-string ("Domain glossary; read before any planning or implementation;
  update in-session when terms emerge or shift"); fix proposed, not auto-edited.

*Note:* the skill deliberately does **not** implement gr **L5** (renaming propagation
across code/tests/APIs) — that is a code-wide refactor concern, outside a single-artifact
language audit. **G7** (`gr_greenfield.md`, record initial vocabulary) is folded into the
L8 write-back rather than carried as a separate section.

---

## `pareto-scope-cut` — **lens**

**Purpose.** A cross-cutting lens that enforces "build only what the next concrete requirement needs." It takes a single planning artifact plus the project's **scope marker** (the milestone/phase that defines "now"), enumerates every scopeable item, splits them into **in-scope** vs **deferred**, and records each deferral as a one-line postponed-decision so it is never silently re-decided. It produces a **scope split + postponed-decisions log** and — only with explicit human approval (HITL) — appends them to the artifact. It does *not* model entities, maintain a glossary, gate ADRs, or sweep constraints (those are sibling skills); it *only* does the scope cut and the postponed-decision log.

**Input artifacts (must use).**

- **Artifact to scope-cut** (required) — any planning doc: a vision/requirements catalog (docs/vision.md, docs/requirements.md), 
   entity/domain model, use-case diagram (`*.puml`), or a use-case spec (`use_cases/*.md`). 
   Named by the user or the file in focus.
- **Scope marker** (required) — the boundary that defines "now," typically a milestone/phase marker named in a planning doc. Taken as an argument if given; otherwise the user is asked which marker defines current scope. The boundary is NEVER guessed silently, and no project's milestone names or plan file paths are hard-coded — the marker is read generically.
- **Scope marker's requirement set** (required) — the concrete requirements the marker *commits to*, read from the planning doc that names it. Classification is done against the marker's actual requirements, not its name alone; when markers are sequential, "at or before" is resolved from the marker order in that same doc. If the requirements cannot be found, the user is asked rather than guessing.

**Output artifacts / results.**

- A **Scope split** section (template in the SKILL.md) headed `## Scope split (against <scope marker>)`, with an **In scope** list (one-line why each item is needed now) and a **Deferred** list (one-line why each item is future/imagined). Every enumerated item is classified exactly once.
- A **Postponed decisions** log — one G9-format line per deferred item: `- [<item>] Deferred: <what>. Reason: <why, cites G1/G3/G5/G6/G10>. Revisit when: <trigger>.`
- **HITL append** of both sections to the END of the artifact, only after the proposed split + log are shown and explicitly approved. In-scope content is never deleted or rewritten; unrelated sections are left untouched; the skill only splits and appends.

**Relation to guardrail items.** This skill is the executable form of the over-engineering rules in **`gr_greenfield.md`** ("prevent premature architecture and over-engineering… the danger is building for imagined needs"), with the rule IDs carried over verbatim:

- **G1** Boring, Explicit, Replaceable First — flags clever, generalized, or "future-proof" designs where a simpler explicit one meets the current need.
- **G3** Defer Expensive Decisions — flags expensive-later-cheap decisions dressed up early (multi-tenancy, internationalization, advanced patterns) with no concrete requirement at the marker.
- **G5** No Premature Abstraction — flags an abstraction (shared base, generic type, interface) extracted with fewer than two concrete cases demanding it.
- **G6** No Premature Framework — flags a framework, ORM, message bus, or plugin/extension system introduced before the current scope requires it (the "build flexibility in" gold-plating the marker does not demand).
- **G9** Record Postponed Decisions — realized as the one-line postponed-decision record per deferred item, so decisions are written down and never silently re-decided.
- **G10** Smallest Architecture That Supports the Next Known Requirement — flags items sized for a multi-release roadmap rather than the next concrete requirement at the marker.

*Note:* the skill deliberately implements only G1/G3/G5/G6/G9/G10 and does **not** cover the rest of `gr_greenfield.md` — **G2** (first vertical slice before layers), **G4** (establish conventions once), **G7** (record initial vocabulary — owned by `ubiquitous-language-guard`), and **G8** (initial testing strategy) — as those are build-sequencing, convention, language, and testing concerns outside a single-artifact scope cut.

---

## `domain-model` — **authoring**

**Purpose.** Produces the conceptual domain model: it reads `docs/requirements.md` plus any ADRs and the glossary, and emits `docs/entity_model.md` — a Mermaid ER diagram plus one attribute table per domain term. Its distinctive work is tactical-DDD modeling: it classifies **every** term as Entity, Value-Object, or Aggregate-root (never defaulting to "a table with an `id`") — with an explicit aggregate-root selection procedure and a worked non-root-member example so the boundary is reasoned, not guessed — turns implied business invariants into **explicit** validation rules assigned to the owning domain type, and keeps the model conceptual — no storage/transport mechanics unless a storage target is explicitly declared. It models **one bounded context** per run (flagging cross-context term collisions rather than merging them). It does *not* maintain the glossary, cut scope, gate ADRs, or sweep constraints (those are sibling skills); it only models. The filename stays `entity_model.md` (not `domain_model.md`) because that is the downstream contract read by `use-case-spec` and `trace-check`.

**Input artifacts (must use).**

- **`docs/requirements.md`** (required) — the source of domain terms and implied invariants. If it is absent the skill STOPS (it is the required source; only the glossary has a fallback).
- **`docs/adr/*`** (read) — architecture decision records, scanned for implied business rules and for an explicit storage-target declaration (which switches the model into physical mode).
- **Glossary** (the ubiquitous-language file), resolved by a fallback chain — never a hard-coded filename:
  1. explicit path passed as an argument → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  2. none found → warn ("No glossary found; proceeding without one — terms cannot be verified verbatim") and proceed. When present, its terms are used **verbatim** as node, term, and attribute names.

**Output artifacts / results.**

- **`docs/entity_model.md`** — created or updated, with a header recording **Mode** (`Conceptual` by default, or `Physical (storage target: <X>, per <ADR/req>)`) and the resolved **Glossary** path.
- An **ER diagram** (Mermaid `erDiagram`) showing verbatim term names and relationships **only** — no attributes inside entity blocks — with every relationship pointing to the **aggregate-root**, not to internal members (D2).
- **One attribute table per term**, each under a `### TERM_NAME — <Kind>` heading (plus `[aggregate: ROOT]` for non-root members). Conceptual columns by default (`Attribute | Description | Type | Validation Rules`, conceptual types only); physical columns (`Data Type`, `Length/Precision`, PK/FK/Sequence) appear **only** behind a declared storage target.
- **Explicit validation rules** in every cell (never empty, but never invented — `Optional` when requirements are silent; `Not Null`/ranges/values only when the source implies them), with cross-attribute / cross-entity invariants captured in a **Constraints** note as the aggregate's construction-time invariants.
- A final **cross-validation pass**: diagram ↔ table parity, every term classified, no forced surrogate `id`, no value-object identity column, no storage datatypes or leaked infrastructure in conceptual mode, every reference resolvable, all names verbatim, no out-of-scope/deferred term pulled in.

**Relation to guardrail items.** This skill operationalizes the tactical rules of **`gr_ddd.md`**, the infrastructure-isolation rules of **`gr_architecture.md`**, and the verbatim-naming rules of **`gr_domain_language.md`** — IDs carried over verbatim:

- **D1** Keep Domain Rules Inside the Domain (`gr_ddd.md`) — at the conceptual level, each implied business invariant is assigned to the domain type that *owns* it (an attribute's Validation Rules cell or the aggregate-root's Constraints), keeping the rule inside the model rather than deferring it to a controller/helper.
- **D2** Respect Aggregate Boundaries (`gr_ddd.md`) — relationships from other terms point to the aggregate-root, and the root's table/Constraints carry the invariants spanning its members; an explicit root-selection procedure decides where the boundary falls.
- **D3** Enforce Invariants at Construction (`gr_ddd.md`) — multi-attribute/cross-entity invariants become **Constraints** so an instance cannot exist in an invalid state.
- **D5** Value Objects Are Immutable (`gr_ddd.md`) — value-objects are modeled immutable, compared by value, and given **no** identity column.
- **D9** Validation Lives Where the Invariant Lives (`gr_ddd.md`) — each implied invariant is made an explicit Validation Rule on the term that owns it.
- **A9** Keep Infrastructure Out of Domain (`gr_architecture.md`) — persistence keys, surrogate/auto-increment ids, framework types, message-broker ids, file paths, and HTTP/transport fields must not appear in conceptual mode; identity is a natural domain key.
- **A10** No Speculative Extension Points (`gr_architecture.md`) — the cross-validation pass rejects any out-of-scope/deferred term or speculative column added "in case"; the model carries only what requirements imply.
- **L1** Use Defined Terms Exactly, **L2** No Forbidden Synonyms, **L4** Naming Reflects Behavior Not Storage (`gr_domain_language.md`) — glossary terms are used verbatim as entity/value-object/aggregate and attribute names, with no synonyms; **L4** is cited explicitly to ban storage-/transport-shaped *names* (`MessageRow`, `OrderDTO`, `AccountTable`) — distinct from the conceptual-mode datatype ban, the name stays domain-shaped even in physical mode.
- **L6** Introduce New Terms Explicitly (`gr_domain_language.md`) — a genuinely-new structural concept is **flagged** for the glossary (looped back via the `ubiquitous-language-guard`) rather than coined here.

*Note:* the skill deliberately does **not** implement the glossary write-back (**L8**) or the `CLAUDE.md` pointer check (**L9**) of `gr_domain_language.md`, nor scope-cutting, ADR-gating, or constraint-sweeping — those are the responsibility of `ubiquitous-language-guard`, `pareto-scope-cut`, `adr-threshold-gate`, and `hidden-constraint-sweep` (for systematic invariant recall the skill points the modeller at `hidden-constraint-sweep` rather than sweeping itself). **D7** (Bounded Context Boundaries) is handled by the stated single-bounded-context assumption — the skill models one context per run and flags cross-context term collisions rather than merging them. It leaves the remaining `gr_ddd.md` rules (**D4**, **D6**, **D8**) to code-level skills, since they govern runtime services, events, and code structure rather than a conceptual model document.

---

## `adr-threshold-gate` — **lens**

**Purpose.** A cross-cutting lens that protects the *why* of decisions: it scans any artifact — pre-decision (a plan, requirements doc, entity model, use-case spec, PRD / milestone PRD draft, design note) or post-decision (a diff) — for choices that cross the **Architectural Decision Record threshold**, then drafts and human-gates one durable `docs/adr/` record per qualifier. It detects threshold-crossing decisions, asks the human "ADR-worthy?" per hit, drafts `proposed` ADRs in Context / Decision / Consequences / Alternatives form, and writes nothing — and flips nothing to `accepted` — without explicit human approval. It is step-agnostic. It does *not* model entities, maintain the glossary, cut scope, or sweep constraints (those are sibling skills).

**Input artifacts (must use).**

- **Artifact under review** (required) — any single pre- or post-decision artifact: a plan, `requirements.md`, an entity model, a `use_cases/*.md` spec, a PRD / milestone PRD draft (the pre-publish `spec-to-prd` Phase-4 projection), a diff, or a design note. Named by the user or the file in focus.
- **`docs/adr/*`** (read for numbering and coverage) — the existing ADR files. Scanned to (a) derive the next zero-padded monotonic `NNNN` and (b) avoid re-drafting an already-captured decision. If `docs/adr/` is empty or absent, numbering starts at `0001`.

**Output artifacts / results.**

- One new **`docs/adr/NNNN-<kebab-slug>.md`** file per qualifying decision, at `Status: proposed`, using the required section order (Title / Status / Context / Decision / Consequences / Alternatives). The slug is built from the decision's one-line summary so the filename is greppable. A draft missing **Alternatives** is invalid (the trade-off claim would be unverifiable).
- A **HITL "ADR-worthy?" ask** per threshold-crossing decision — naming all three criteria explicitly — gating every draft; and a second approval gate before any file is written.
- A one-line **"no-ADR, why" note** per sub-threshold decision, naming the single failed criterion. No file is written for these.
- A one-line **"already captured: NNNN" note** per extracted decision an existing ADR already covers — the **Adr10 dedup** skip, surfaced so the decision is acknowledged without re-drafting. No file is written for these.
- A closing **report**: the ADR files written (paths, all `proposed`), the "already captured" dedup skips, and the list of no-ADR notes with reasons.

**Relation to guardrail items.** This skill is the executable form of the ADR rules in **`gr_adr.md`**, with the criteria and format carried over verbatim:

- **Adr1** Three-Part Threshold — the skill's three-part AND gate (*hard to reverse* AND *surprising without context* AND *real trade-off*); if any one fails, no ADR, and interchangeable choices, easily-reversible refactors, and routine style choices are explicitly out of scope ("ADR noise dilutes signal").
- **Adr2** ADRs Are Durable, In-Tree — files live at `docs/adr/NNNN-<kebab-slug>.md` with a zero-padded monotonic integer; the skill forbids date-numbering (`2026-05-21-foo.md`) precisely because it breaks the supersession chain, and states the durability half (an ADR is never silently deleted — superseded, not removed).
- **Adr3** ADRs Are Distinct From Aln15 Negative Decisions — a one-line guard: the ADR is about the *chosen* road, not a rejected option; rejected options live in the alignment transcript (Aln15) and appear only inside the ADR's Alternatives Considered section. This is the skill's main defense against drafting noise ADRs for considered-but-rejected alternatives.
- **Adr4** ADRs Are Distinct From the PRD — a one-line guard: an ADR records *why* a surprising choice was made, not *what* was decided (that is the PRD/plan), preventing restatement-fat ADRs.
- **Adr5** Required Sections — the draft template enforces Title / Status / Context / Decision / Consequences / Alternatives Considered in order; the section is named "Alternatives Considered" verbatim per the guardrail and is mandatory per Adr1.3, and the legal Status enum (`proposed | accepted | superseded by NNNN | deprecated`) is recorded as a template comment even though the skill only ever writes `proposed`.
- **Adr7** Supersede, Don't Mutate — the skill refuses to edit an already-`accepted` ADR's body, deferring supersession (which it treats as out of scope) rather than mutating.
- **Adr8** Agent May Draft, Human Must Accept — the agent drafts; the `proposed` → `accepted` flip is human-only and never silent. This is the skill's core HITL contract.
- **Adr10** Review Verifies ADR Coverage — realized in two facets: (a) the skill's post-decision (diff) mode runs the coverage check (did any decision cross the Adr1 threshold without an ADR? if so it surfaces and drafts the missing one), and (b) every run **dedups against existing `docs/adr/*`** — an extracted decision an existing ADR already captures is skipped with an "already captured: NNNN" note rather than re-drafted.

The threshold's subject matter is architectural decisions, so **`gr_architecture.md`** is the conceptual source — but the skill deliberately does **not** implement that file's structural rules (**A1**–**A11**: layering, dependency direction, module boundaries, public-API compatibility, etc.). It only *captures the rationale* of a crossing decision; enforcing the structure itself is a separate concern.

*Note:* **Adr3** and **Adr4** are carried as one-line guards (see above) — not the full alignment/PRD machinery, but the distinctions an agent needs to avoid drafting noise ADRs (rejected options) or restatement-fat ADRs (*what* instead of *why*). The skill deliberately does **not** implement **Adr6** (author at decision time vs retroactively) or **Adr9** (ADRs as a pull-source for implementation) — those are alignment/implementation-loop concerns outside a single-artifact threshold gate. Supersession (**Adr7** beyond the no-mutate rule) is likewise left out of scope.

---

## `hidden-constraint-sweep` — **lens**

**Purpose.** A cross-cutting lens that pressure-tests a spec against the constraints stakeholders habitually miss: it fires an **8-class hidden-constraint checklist** (security & PII, permissions, data-retention, migrations, observability, public-API-compat, concurrency, out-of-scope) over a requirements doc, use-case spec, domain model, or PRD draft and forces an explicit **`covered` / `not-applicable` / `missing`** verdict for *every* class — every run, in order. Its whole value is that it **defeats agent judgment about which classes apply**: silent omission of a class is forbidden, and a `missing` class **blocks** the sweep from reporting complete. To stop the central loophole on a human-less doc run, a `not-applicable` verdict must **cite a concrete fact in the artifact/context** (not a generic assertion), and the skill states that **`blocked` is the expected, valuable outcome** — never a failure to be dodged by under-reporting `missing` as `not-applicable`. It is a **pure report** — it writes nothing: it surfaces gaps and names concrete follow-ups for the human or a sibling skill (`domain-requirements`, `use-case-spec`, `pareto-scope-cut`) to act on; it does *not* model entities, edit the glossary, gate ADRs, rewrite the spec, or perform the deferral/scope-cut mechanics. Step-agnostic: identical checklist at requirements, use-case-spec, domain-model, and PRD-draft (the pre-publish `spec-to-prd` Phase-4 projection) stages — only the *kind* of pointer/follow-up varies (FR/NFR at requirements, alt-flow at use-case-spec, invariant/Constraints note at domain-model, and a linked `FR/NFR/UC` id or the module/testing-decision subsection at the PRD-draft stage).

**Input artifacts (must use).**

- **Artifact under sweep** (required) — the requirements doc, use-case spec, domain/entity model, or PRD draft (the pre-publish `spec-to-prd` Phase-4 projection — in-session/inline content, not necessarily a file on disk) the user names, or the file in focus. If none is named, the skill asks which artifact to sweep before proceeding.
- **Glossary / context** (optional), resolved by a fallback chain — never a hard-coded filename:
  1. explicit path the user passed → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  2. none found → warn (`"no glossary/context found; proceeding without term grounding"`) and continue. Absence never blocks the sweep.

**Output artifacts / results.**

- A **per-class verdict table** (template in the SKILL.md): one row per class with its verdict and mandatory evidence — a **pointer** for `covered` (FR/NFR id, section, flow, or glossary term; a verdict with no pointer is *not* `covered`), a **concrete-fact reason** for `not-applicable` (a generic assertion is rejected), or a **routed follow-up** for `missing`.
- A **Follow-ups list** — one line per `missing` class, each routed to exactly one of: a new FR, a new NFR, a use-case alternative flow, a new invariant/Constraints note (at the domain-model stage), or a deferral candidate (handed to the scope-cut skill, not enacted here).
- A **sweep verdict**: `clean` (no class `missing`) or `blocked` (one or more `missing`, listed by class). A `blocked` sweep must not be reported as complete — and is the *expected, valuable* outcome when gaps exist, not a failure. When the sweep feeds a `gr_rev.md` Rev11 review block, `clean` maps to **approve** / **approve-with-comments** and `blocked` maps to **request-changes** / **block** (block for a hard safety gap, e.g. Security/PII or Permissions).

**Relation to guardrail items.** This skill is the executable form of the alignment-close hidden-constraint sweep in **`gr_algn.md`**, with its mechanics carried over verbatim:

- **Aln6** Hidden-Constraint Checklist — the source rule. It mandates the sweep "fires **always at close**, regardless of whether the topic plausibly engaged a class," and supplies the three outcomes (`covered` with a pointer, `not-applicable` with a recorded reason, `missing` which **blocks** close — "No silent passes, no 'documented gap' closes"). Aln6 enumerates the exact **8** classes this skill uses: Security, Permissions / authorization, Data retention, Migrations, Observability, Public API compatibility, Concurrency, and Out-of-scope. "Silent omission of a class is forbidden" maps directly onto the skill's DO-NOT list.
- It also operationalizes the review-side mirror in **`gr_rev.md`**: **Rev7** Check Hidden-Constraint Coverage (cross-references `gr_algn.md`; "A 'not applicable' verdict is stated, not assumed") and the **Rev11** Reviewer Output Format requirement for an explicit per-class "covered / not applicable / missing" statement. As `gr_algn.md` notes, "Aln6 feeds gr_rev.md Rev7 — what was checked during grilling becomes the review checklist"; this skill is the shared checklist behind both phases.

*Reconciliation note:* the skill follows the **Aln6 8-class** set. `gr_rev.md` Rev7 lists only **7** classes — it omits **out-of-scope** and pairs retention+migrations on one line. Per the build spec the skill keeps Aln6's fuller set; the difference is presentational, not a conflict in intent.

*Deliberately not implemented.* The skill **does not** enact deferrals or perform scope cuts (Aln15 negative-decision capture and the scope-cut mechanics belong to `pareto-scope-cut`); it only surfaces a deferral *candidate*. It also does not run the public-API *snapshot comparison* of `gr_rev.md` **Rev5a** / approval gate of **`gr_governance.md` Gov3** — it flags the public-API-compat *class* as a constraint to verify, but does not regenerate or diff an API snapshot. Glossary write-back (`gr_domain_language.md` L8), ADR gating (`gr_adr.md` Adr1), and entity modeling are explicitly out of scope.

---

## `usecase-diag` — **authoring**

**Purpose.** Produces `docs/use_cases.puml` — a PlantUML actor/use-case diagram derived from `requirements.md` and the domain model — and adds the one guarantee a downstream lens cannot add after the fact: **forward FR→UC coverage**. Every *in-scope* functional requirement must be realised by ≥1 use case or explicitly recorded as a *spec-level* detail (an error path / validation / sub-rule carried later as an alt-flow or BR), so the diagram can never silently omit a relevant use case. It emits the FR id(s) each use case realises, supplying the UC→FR convention downstream skills read. Still run with the step-agnostic lenses composed on top (`ubiquitous-language-guard`, `pareto-scope-cut`, `adr-threshold-gate`, `hidden-constraint-sweep`); this skill owns *completeness* only.

**Input artifacts (must use).**

- **`docs/requirements.md`** (required) — the FR catalog and any **Scope split** / Status column. If absent the skill STOPS.
- **Scope marker** (optional arg) — the milestone/phase that defines "now"; the **in-scope FR set** is resolved from the requirements doc's Scope split / Status (non-`Deferred`/non-`Out-of-scope` otherwise). No milestone names hard-coded; ambiguous scope is **asked**, never guessed.
- **`docs/entity_model.md`** (optional) — read for the domain nouns the use cases act on (names stay domain-shaped).
- **Glossary** (optional arg) — resolved `explicit → docs/CONTEXT.md → docs/glossary.md → warn-and-continue`; actor names used **verbatim** (L1, read side); no "User/Administrator" default when the glossary names actors.

**Output artifacts / results.**

- **`docs/use_cases.puml`** — created/updated; `UC-{3-digit}` ids, glossary-verbatim actors, each UC carrying its FR id(s).
- A **FR → UC coverage map** resolving every in-scope FR to `≥1 UC` or `spec-level (owning UC)`; an in-scope FR that is neither is a **coverage gap** that blocks completion (fail-closed).

**Relation to guardrail items.** Its completeness check is a **cross-artifact integrity** guarantee (the FR→UC reverse of `trace-check` Check A's UC→FR); no single `gr_*.md` rule defines it. It **consumes** the glossary under **`gr_domain_language.md` L1** (actors verbatim, read side) and routes a needed-but-undefined actor to the `ubiquitous-language-guard` write-back loop under **L6** (flag, never coin). It deliberately does **not** enforce/evolve the glossary (L2/L4/L8 stay `ubiquitous-language-guard`) or cut scope (`gr_greenfield` G1/G9 stay `pareto-scope-cut`) — it only consumes their outputs.

---

## `usecase-spec` — **authoring**

**Purpose.** Produces per-use-case spec files under `docs/use_cases/*.md` (actors, preconditions, main/alternative scenarios, postconditions, `BR-###` business rules), adding two coverage guarantees: (1) each spec carries a **`Requirements covered (FR-###)`** trace line — supplying the UC→FR convention `trace-check` Check A is *gated on* (without it Check A reports "no trace convention found"); and (2) a **fail-closed reverse-coverage gate** — every in-scope FR must be cited by ≥1 spec (covered-line, flow step, or BR), else completion is blocked. Run with the same composed lenses as `usecase-diag`.

**Input artifacts (must use).**

- **`docs/requirements.md`** (required) — FR catalog + Scope split / Status. STOP if absent.
- **`docs/use_cases.puml`** (default) — the use-case set and each UC's FR id(s); if absent, **warn** and derive use cases from the in-scope FR set.
- **Scope marker** (optional arg) — in-scope FR set resolved as in `usecase-diag`; ambiguous scope **asked**.
- **`docs/entity_model.md`** (optional) — each `BR-###` should correspond to a domain-model **invariant**; the skill **cites** it or **flags** a missing/contradicting one — it never authors the invariant (that stays `domain-model`).
- **Glossary** (optional arg) — resolved `explicit → docs/CONTEXT.md → docs/glossary.md → warn`; actors/terms **verbatim** (L1, read side).
- **`$ARGUMENTS`** — the use case(s) to (re)write; default to all UCs in the diagram.

**Output artifacts / results.**

- **`docs/use_cases/*.md`** — one file per use case, each with a `Requirements covered (FR-###)` Overview line.
- A **FR → spec coverage map** resolving every in-scope FR to a citing spec; an in-scope FR cited nowhere is a **coverage gap** that blocks completion (fail-closed). Deferred / out-of-scope FRs are excluded.

**Relation to guardrail items.** Reverse-coverage and the trace line are **cross-artifact integrity** guarantees (no single `gr_*.md` rule). The BR→invariant *grounding* reflects the spirit of **`gr_ddd.md` D1/D9** (a business rule should be a domain invariant) but only **cites or flags** the document linkage — it never authors the invariant or sees code, exactly the boundary `trace-check` Check D draws. It **consumes** the glossary under **L1** (actors verbatim) and flags unknown actors under **L6**; it does **not** enforce the glossary, cut scope, or model entities (sibling skills own those). The `BR-###` ↔ invariant linkage is handled by this grounding-and-flagging step.

---

## `trace-check` — **lens**

**Purpose.** A cross-cutting lens that protects traceability: every downstream artifact must trace back to something upstream, and every cross-reference must resolve. It reads the project artifact set, runs a non-blocking upstream-**freshness pre-check** (Check 0) plus **four consistency checks** (A–D), produces a single **consistency report** (PASS or a list of breaks), and — only with explicit human approval (HITL) — loops a fix back into the *offending* artifact. It does *not* author requirements, model entities, maintain the glossary, gate ADRs, or cut scope (those are sibling skills).

**Input artifacts (must use).**

- **Requirements** (default `docs/requirements.md`) — the functional-requirement (FR) catalog use cases must trace to. Override path accepted.
- **Use case diagram** (default `docs/use_cases.puml`) — the PlantUML diagram declaring actors and use cases. Override path accepted.
- **Use-case specs** (default `docs/use_cases/*.md`) — per-use-case specs carrying actors, scenarios, named entities, and business rules (`BR-###`). Override glob accepted.
- **Entity model** (default `docs/entity_model.md`) — domain entities and their invariants / validation rules.
- **Glossary** (optional), resolved by a fallback chain — never a hard-coded filename:
  1. explicit path the user passed → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  2. none found → warn and run **Check C in report-only mode** (verbatim glossary matching limited; actor names still cross-checked across diagram and specs).
- **Vision** (optional, default `docs/vision.md`) — the upstream vision/goals doc, used **only by Check 0** (upstream freshness); its *content* is not read by Checks A–D. If absent, the `vision → requirements` freshness pair is skipped and the run continues.
- Any non-glossary input that is missing triggers a **warn**; the affected check is skipped and reported, and the skill continues (step-agnostic, never crashes on a not-yet-created artifact).

**Output artifacts / results.**

- Before the checks, it **discovers conventions** rather than assuming them: the actual requirement/BR **id patterns** (not a hard-coded `FR-`/`BR-`), whether the project carries a **UC→FR trace convention** at all, and a **name-normalization rule** (trim/lowercase/de-pluralize) so near-matches are caught mechanically, not by judgment.
- A **consistency report** (template in the SKILL.md) with one section per check:
  - **Check 0** — **upstream freshness** (a non-blocking, git-based pre-check, run first): for each adjacent pair in the chain `vision → requirements → use-case diagram → use-case specs → entity model`, it compares **effective last-modified recency** (last-commit time, with any uncommitted working-tree edit counting as *now*) and emits a **stale-downstream warning** when an upstream file is newer than the downstream it feeds — signalling the downstream (and the traces built on it) may be stale, with a re-grill/re-review recommendation. It is **advisory**: never a break, never halts the run, but any warning forces the result to at least `PARTIAL`. The `vision → requirements` link is the highest-value one (vision is read by no other check). Skipped (→ `PARTIAL`) when the project is not a git repo or git is unavailable.
  - **Check A** — every UC traces to ≥1 FR (flags **orphan use cases**, **dangling FR references**, and diagram-UCs-with-no-spec). Gated on a trace convention existing: if none does, it emits a single "traceability not author-able" finding instead of flagging every UC as an orphan.
  - **Check B** — every entity named in a spec exists in `entity_model.md` (flags **missing entities**, including singular/plural and casing near-matches).
  - **Check C** — every actor matches the glossary **verbatim** (flags near-match variations/abbreviations/pluralization/casing, *suspected* translations for human confirmation, and **unknown actors**). With no glossary, it degrades to an intra-artifact actor-consistency check, **labelled "L1 not run"** so a degraded run never reads as an L1 pass.
  - **Check D** — every business rule maps to a domain-model invariant via an explicit semantic-matching procedure (the model carries no BR back-references), flagging **unenforced business rules**, **invariant↔BR conflicts**, and **needs-human-confirmation** where it cannot decide; within-spec duplicate BR ids are out of scope (not cross-artifact).
  - A header line per artifact (path | MISSING) and an overall **Result: PASS | PARTIAL (checks skipped) | BREAKS FOUND (N)** — a run with any check skipped, *or* with any Check 0 stale-downstream warning, is never `PASS` (a Check 0 warning forces at least `PARTIAL` but is **not** counted in the break total N — it is advisory, not a break).
- **HITL fix loop** — for each break the human elects to fix, the skill names the **candidate offending artifact(s)** and, where ambiguous (e.g. an orphan UC could be fixed by adding a trace line to the spec *or* a missing FR to requirements), lets the human pick which to change rather than assuming; it shows an exact before/after diff or new line, applies only per-change-approved edits, then re-runs the affected check. It never invents traces, renames entities/actors, asserts an unprovable translation, or guesses a fix; unknown actors and term changes are *proposed*, routed to the glossary skill, never written here.

**Relation to guardrail items.** Only one rule is operationalized verbatim:

- **L1** Use defined terms exactly (`gr_domain_language.md`) — cited by name in **Check C**: every actor must appear in the resolved glossary verbatim, with casual variation / abbreviation / pluralization-casing drift / translation flagged.

The remaining checks have no single named gr rule ID for cross-artifact traceability — no `gr_*.md` file defines a "every UC traces to an FR" or "every entity in a spec exists in the model" rule — so they are enforced as the executable embodiment of guardrail *intent* rather than carried-over check IDs:

- **Check 0** (upstream freshness) maps to **no** `gr_*.md` rule — it is a git-based, **advisory** chain-integrity signal in the same anti-drift spirit as Checks A and B, and the only check that touches `vision.md` (closing the otherwise-invisible top `vision → requirements` link of the chain). It reads commit times and working-tree status, **not content**, so it detects *recency* drift only — never whether a change was meaningful; that substance call, and the decision to re-grill, stay with the human. It never halts: a warning forces `PARTIAL`, and a non-git repo skips it.
- **Check D** (BR → invariant) reflects the *spirit* of `gr_ddd.md` **D1**/**D9** — a business rule should be enforced as a domain invariant — but the linkage is loose, not a backstop: trace-check reads two **documents** (spec ↔ entity model) and only verifies a mapping exists between them; it **cannot see code**, so it cannot detect a D1 *placement* violation (an invariant enforced in a controller/helper). It surfaces "BR stated in a spec but absent from the model" — a documentation-drift finding — and never authors the invariant (that stays with `entity-model` / `domain-model`).
- **Checks A and B** are reported as **cross-artifact integrity** findings. They serve the same anti-drift purpose as the documentation guardrails but correspond to no numbered gr rule (and are *not* claimed as `gr_documentation.md` Doc4/Doc5 violations — Doc4 is about behavior changes, Doc5 about not duplicating authoritative sources, neither of which is cross-artifact reference resolution).

*Note:* the skill deliberately does **not** implement `gr_domain_language.md` **L2/L4/L6/L8/L9** (forbidden synonyms, storage-shaped names, new-term introduction, glossary write-back, CLAUDE.md pointer) — those belong to `ubiquitous-language-guard`; trace-check applies L1 to actors only and **proposes**, never writes, glossary changes. It also does not gate or author ADRs (`gr_adr.md`) and does not cut scope.

---

## `prototype` — **external**

**Purpose.** Resolves the top open unknown before committing to a full build — for ai-mail, that is the interaction surface and the plan/apply state machine. Optional first step of Phase 4.

---

## `to-prd` — **external** (superseded by `spec-to-prd`)

**Purpose.** Turns the completed spec spine (`requirements.md`, `entity_model.md`, `use_cases/*.md`) into a structured Product Requirements Document.

> **Superseded by `spec-to-prd`** in this skillset. The vendored matt-pocock `to-prd` *authors* the PRD **from the live conversation** (re-deriving user stories/problem/solution and discarding the spine's `FR/UC/BR/ADR` IDs — the `gr_documentation.md` Doc5 duplication anti-pattern). `spec-to-prd` (below) replaces it: it **projects** the existing spine onto the tracker as a thin, ID-linking PRD and falls back to conversation/codebase authoring only where the spine is missing/thin. Use `spec-to-prd` in Phase 4; `to-prd` is retained here only for lineage/reference.

---

## `spec-to-prd` — **authoring**

**Purpose.** Projects the existing spec spine onto the issue tracker as a **thin, milestone-scoped PRD** — it **links** the spine's stable IDs (`FR-###`/`NFR-###`/`UC-###`/`BR-###`/`ADR-####`) rather than restating their content, and authors fresh **only** the two sections the spine genuinely lacks: the module/implementation decisions (an interactive deep-module sketch) and the testing decisions (delegated to `testing-strategy`). It supersedes the vendored `to-prd`, whose conversation-authoring would re-derive and duplicate the spine. Where a spine artifact is missing or thin (brownfield), it **degrades gracefully**, falling back to vanilla codebase-driven authoring for *that section only* — making it a superset of `to-prd`, not a replacement that assumes a complete spine. It does *not* slice issues (`to-issues`) or implement (`tdd`); it only produces the milestone PRD.

**Input artifacts (must use).**

- **Scope marker** (required) — the milestone that defines "now": resolved arg → the requirements doc's declared milestone / Status scope split → asked only if genuinely ambiguous (multiple undelimited milestones); never guessed silently.
- **The spec-spine, via the AIUP-chain defaults** (overridable by an optional manifest arg) — `docs/requirements.md` (FR/NFR/C/OOS), `docs/use_cases/*.md` + `docs/use_cases.puml` (UC/BR), `docs/entity_model.md` (aggregates/invariants), `docs/vision.md` (problem/solution), the postponed-decisions log (Out of Scope), and `docs/testing/<milestone>.md` (from `testing-strategy`, invoked in-session). The **in-scope FR/UC set** is resolved at the marker (non-deferred, non-out-of-scope).
- **Glossary**, resolved by the standard fallback chain — `explicit arg → docs/CONTEXT.md → docs/glossary.md → warn`; vocabulary used **verbatim** (L1, read side).
- **`docs/adr/*`** (read) — decisions in the touched area, respected/flagged.
- **Tracker wiring** — the tracker is reached abstractly via `docs/agents/issue-tracker.md`; the label vocabulary (`ready-for-agent`) via `docs/agents/triage-labels.md`. No tracker specifics are hard-coded.

**Output artifacts / results.**

- **One thin PRD per milestone**, published to the tracker with `ready-for-agent`, on the vanilla `to-prd` 7-section template (Problem Statement · Solution · User Stories · Implementation Decisions · Testing Decisions · Out of Scope · Further Notes). Spine-derived sections **link IDs** (User Stories ← FRs carried with their `FR-###` IDs + `UC-###` refs; Implementation Decisions ← linked ADRs + entity model; Testing Decisions ← `docs/testing/<milestone>.md` + NFRs by `NFR-###`; Out of Scope ← requirements OOS + postponed-decisions); only the module/implementation decisions and the testing-decisions framing are authored fresh.
- **Traceability refs** (`FR/UC/BR/ADR`) carried onto the PRD/issues so the tracker stays linked to the in-repo spine. Internal IDs (`P##`/`A##`, `M#`/`F##`) inform synthesis but are **never** quoted into the published PRD (internal-ID hygiene).
- An **interactive deep-module sketch** (HITL) — the major modules with deep, isolated, testable interfaces, grounded in the entity model + use cases (+ codebase exploration in brownfield); the human confirms the modules and which want tests. Right after the sketch, the skill **invokes `testing-strategy` in-session** so it sees the just-decided (ephemeral) modules.
- The **composed step-agnostic lenses are run on the PRD draft before publishing** — `ubiquitous-language-guard` (drift in the freshly-synthesized module/testing prose), `hidden-constraint-sweep` (did the synthesis drop a class?), and `adr-threshold-gate` (did a module/interface decision cross the ADR threshold?) — extending Phase-3 gating across the Phase-4 boundary.

**Relation to guardrail items.** No single `gr_*.md` cluster owns the projection; the skill operationalizes a set of cited rules:

- **`gr_documentation.md` Doc5** (no duplication of authoritative sources) — the load-bearing constraint: the PRD **links** spine IDs and restates none of their content, so the requirements artifact (`requirements.md`) stays the single source and the PRD is a tracker-facing *projection*, not a second origin.
- **`gr_domain_language.md` L1** (use defined terms exactly) — the glossary is consumed **verbatim** on the read side; the skill does not enforce or evolve the glossary (that stays `ubiquitous-language-guard`).
- **`gr_adr.md`** — ADRs in the touched area are respected and linked, not restated; an ADR-threshold-crossing module decision is routed to `adr-threshold-gate` (one of the composed lenses), not gated here.
- **AIUP-native traceability** (the same cross-artifact integrity guarantee `trace-check`/`usecase-spec` carry, with no single named gr ID) — `FR/UC/BR/ADR` IDs are carried onto the tracker, and the POST self-check asserts **forward coverage**: every in-scope requirement reached the tracker with its ID.

---

## `testing-strategy` — **authoring**

**Purpose.** Owns the *how-to-test* artifact the spine lacks: it authors **one `docs/testing/<milestone>.md` per milestone**, carrying only the **project-specific** strategy — module/test-surface priorities, test-double policy at the real boundaries, and prior art — and **referencing** rather than restating the two things that live elsewhere (NFR/constraint **thresholds** in `requirements.md`, universal test **philosophy** in the `tdd` skill). It is a standalone authoring skill invoked by `spec-to-prd` **in-session, right after its interactive module sketch**, so it can read the just-decided (ephemeral) module decomposition before that context is gone. It closes `gr_greenfield.md` G8 (initial testing strategy), a rule no other skill owned. It does not author requirements, model entities, or set the thresholds it references (those are sibling skills / upstream artifacts).

**Input artifacts (must use).**

- **The just-decided module decomposition** (required) — read from `spec-to-prd`'s in-session module sketch; the strategy's test-surface priorities are pinned to these modules, which is why the skill runs at PRD time (the modules do not exist at requirements time).
- **`docs/requirements.md`** — the NFRs / constraints whose **thresholds** each strategy entry *references* (`Re: NFR-###` / `Re: C-###`), never restates.
- **Chosen stack** if declared — used to pick concrete test surfaces/doubles; **if undeclared, the strategy is written stack-agnostic and the stack dependency is flagged** rather than guessed.
- **The `tdd` skill** — the universal test philosophy ("test behavior through public interfaces") it *references* for the cross-project parts, carrying only the project-specific *how*.
- **Scope marker** — the milestone whose `docs/testing/<milestone>.md` is being authored.

**Output artifacts / results.**

- **`docs/testing/<milestone>.md`** (HITL write), one per milestone — mirroring how `docs/use_cases/*.md` fans out.
- Each entry **opens `Re: NFR-###` / `Re: C-###`** (references the threshold, never restates it — the bar stays in the NFR) and adds the project-specific method (test surface, test-double policy at the real boundary, prior art); universal philosophy is referenced from `tdd`, not duplicated.

**Relation to guardrail items.**

- **`gr_greenfield.md` G8** (initial testing strategy) — the source rule; this skill is the executable form of G8 and the only skill that owns it.
- **`gr_documentation.md` Doc5** (reference, don't duplicate authoritative sources) — thresholds stay in the NFRs and philosophy stays in `tdd`; `testing.md` references both by ID/skill and restates neither, so it adds genuinely-new *how* without duplicating any existing source.

---

## `to-issues` — **external**

**Purpose.** Breaks the PRD into tracer-bullet, vertical-slice GitHub issues ready for implementation.

---

## `tdd` — **external**

**Purpose.** Implements the issues red-green-refactor style (test-driven development).

---

## `tracker-trace-check` — **lens**

**Purpose.** A tracker-aware cross-cutting lens — the **repo↔tracker drift-audit counterpart** of `trace-check`. Where `trace-check` stays offline/repo-only (and must, to keep its determinism and portability), this skill catches *post-publish* divergence between the in-repo spine and the PRD/issues published to the tracker by `spec-to-prd`. It runs two mechanical PASS/FAIL checks (dangling-ref + forward-coverage) and one judgment check (semantic divergence, reported as `needs-human-confirmation` à la `trace-check` Check D), produces a **consistency report**, and — only with explicit human approval (HITL) — loops fixes back, proposing repo-side and tracker-side edits but **never auto-applying** them. It **reuses** `trace-check`'s convention-discovery *method* (derive id prefixes from the files — never hard-assume — plus name-normalization) rather than reinventing it, and **extends** that method with the UC and ADR id families `trace-check` does not discover (`trace-check` discovers only the requirements-id and BR-id patterns; it matches use cases by name and never reads ADRs). It does not author the spine, publish the PRD, or set scope (those are sibling skills).

**Input artifacts (must use).**

- **The in-repo spine** (required) — `docs/requirements.md`, `docs/use_cases/*.md` + `docs/use_cases.puml`, `docs/entity_model.md`, and the glossary — the authoritative side every tracker reference must resolve back to.
- **The published PRD / issues for a milestone** (required) — reached abstractly via `docs/agents/issue-tracker.md`; the tracker side whose references and coverage are audited. No tracker specifics hard-coded.
- **Scope marker** (required) — the milestone whose in-scope requirement set defines what *must* be on the tracker for the forward-coverage check.

**Output artifacts / results.**

- A **consistency report** — PASS or a list of breaks, one section per check:
  - **Dangling-ref** (mechanical PASS/FAIL) — every `FR/UC/BR/ADR` id cited on the tracker resolves to a real spine artifact.
  - **Forward-coverage** (mechanical PASS/FAIL) — every in-scope requirement at the marker is present on the tracker.
  - **Semantic divergence** (`needs-human-confirmation`, not mechanical) — a tracker item that contradicts its linked spine artifact is surfaced for a human decision, never auto-judged.
- A **HITL fix loop** — for each break the human elects to fix, the skill *proposes* the edit (repo-side into the offending spine artifact, or tracker-side onto the issue) and applies it only on per-change approval; **tracker edits are never auto-applied**.

**Relation to guardrail items.** Like `trace-check`, no single `gr_*.md` cluster defines repo↔tracker traceability — the mechanical checks are the executable embodiment of **AIUP-native traceability** intent (every published reference resolves; every in-scope requirement reached the tracker), the repo↔tracker mirror of `spec-to-prd`'s forward-coverage POST check. The one carried-over rule is **`gr_domain_language.md` L1** (use defined terms exactly), applied to **actors** as in `trace-check`'s Check C. The convention-discovery *method* (derive id prefixes from the files; name-normalization) is **shared with `trace-check`**, not duplicated — and **extended** here to the UC and ADR id families `trace-check` does not discover (it covers only the requirements-id and BR-id patterns, matches use cases by name, and never reads ADRs).

---

## `review-skills` — **meta**

**Purpose.** Project skill-maintenance tooling (not an authoring-chain skill): produces a critical review of the skills in this `skills/` folder and writes it to `skills/skills_refactoring.md` — the refactoring worklist that `refactor-skills` later consumes. It **always asks first** whether to review a *single* skill or *all* skills. For each in-scope skill it spawns a **fresh sub-agent** (clean, un-cross-contaminated context) that reads only that one skill's `SKILL.md` (+ `REFERENCE.md`) and its entry here, discovers the `gr_*.md` files the skill cites, and reviews three dimensions: (1) guardrail coverage (missing/partial vs. the claims recorded here), (2) whether an agent running it achieves the skill's stated purpose, (3) writing effectiveness. Each review is headed by a pending `- [ ] refactored` checkbox.

**Input artifacts (must use).**

- The in-scope skill(s) under `skills/*/SKILL.md` (+ `REFERENCE.md`). Excludes `skills/archive/`, the loose `skills/*.md` files, and the meta-skills `review-skills` / `refactor-skills` themselves.
- This file (`skills_overview.md`) — read each reviewed skill's declared `gr` cluster and **claimed** coverage; the review verifies and, where wrong, challenges those claims.
- The guardrail rule files `c:\PROJ\ai-knowhow\coding\gr\gr_*.md` — which ones apply is **discovered** from the skill's own citations, never hard-coded.

**Output artifacts / results.**

- `skills/skills_refactoring.md` — per-skill review sections (3 dimensions + **Recommended refactor actions**), each headed by `- [ ] refactored`. Single-skill mode splices/replaces only that one section.
- A **Glossary-resolution guard** section: a driver-level cross-cutting check run over **all** skills (canonical chain `arg → docs/CONTEXT.md → docs/glossary.md → warn`), flagging any root-`context.md`/context-map/bare-`context.md` deviation; glossary-less skills are recorded `N/A`. Verdict `clean` / `drift`.

**Relation to guardrail items.** None operationalized — this is skill-maintenance tooling, not a guardrail/authoring skill. It *audits* other skills' `gr_*.md` coverage rather than implementing a `gr` cluster of its own.

---

## `refactor-skills` — **meta**

**Purpose.** Project skill-maintenance tooling that consumes `skills/skills_refactoring.md` and refactors every skill still marked `- [ ] refactored`, in a **single invocation**. It spawns one fresh sub-agent per pending skill, **sequentially** (not parallel — refactors share `skills_overview.md`, so concurrent writes would collide); each applies its skill's **Recommended refactor actions** to the `SKILL.md` (and this overview where a coverage claim/boundary changes), runs the skill's POST self-check, and the driver flips that skill's checkbox to `- [x] refactored`. When no skill is left pending or blocked, it archives the worklist.

**Input artifacts (must use).**

- `skills/skills_refactoring.md` (required) — the worklist from `review-skills`. If absent, STOP and direct the user to run `review-skills` first.
- Per pending skill (read by its sub-agent): that skill's review section (the Recommended actions are the brief), its `SKILL.md` (+ `REFERENCE.md`), the cited `gr_*.md` files, its `create_skills.md` build spec, and its `skills_overview.md` entry.

**Output artifacts / results.**

- Refactored `skills/<name>/SKILL.md` (+ `REFERENCE.md`) per pending skill, with `skills_overview.md` adjusted where a refactor changes a stated claim/boundary.
- Updated checkboxes in `skills/skills_refactoring.md` (`- [ ] → - [x]`; blockers annotated `> blocked: <reason>`).
- On full completion only: the worklist moved to `skills/archive/skills_refactoring_YYYYMMDDHHMM.md`.

**Relation to guardrail items.** None operationalized — skill-maintenance tooling. It *applies* the guardrail-coverage findings recorded by `review-skills`; sub-agents read the relevant `gr_*.md` files as the standard each refactor must meet.
