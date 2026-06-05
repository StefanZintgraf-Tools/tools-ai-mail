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
2. [`grill-with-docs` — **external**](#grill-with-docs--external)
3. [`domain-requirements` — **authoring**](#domain-requirements--authoring)
4. [`ubiquitous-language-guard` — **lens**](#ubiquitous-language-guard--lens)
5. [`pareto-scope-cut` — **lens**](#pareto-scope-cut--lens)
6. [`domain-model` — **authoring**](#domain-model--authoring)
7. [`adr-threshold-gate` — **lens**](#adr-threshold-gate--lens)
8. [`hidden-constraint-sweep` — **lens**](#hidden-constraint-sweep--lens)
9. [`usecase-diag` — **authoring**](#usecase-diag--authoring)
10. [`usecase-spec` — **authoring**](#usecase-spec--authoring)
11. [`trace-check` — **lens**](#trace-check--lens)
12. [`prototype` — **external**](#prototype--external)
13. [`to-prd` — **external**](#to-prd--external)
14. [`to-issues` — **external**](#to-issues--external)
15. [`tdd` — **external**](#tdd--external)
16. [`review-skills` — **meta**](#review-skills--meta)
17. [`refactor-skills` — **meta**](#refactor-skills--meta)

---

## `bmad-brainstorming` — **HITL**

**Purpose.** Facilitates interactive brainstorming sessions using diverse creative techniques and ideation methods. Used twice in the workflow: Phase 1 Step 1 to seed inception artifacts (`painlist.md`, `ideas.md`, `00-foundation.md`) using an AI-recommended method with Pareto prioritization, and Phase 1 Step 3 to challenge vision goals using Assumption Reversal and produce `01-foundation.md`. Produces no AIUP-chain artifact itself; its outputs are raw inception material consumed by downstream skills.

---

## `grill-with-docs` — **external**

**Purpose.** Stress-tests a plan against the existing domain model: sharpens terminology, challenges assumptions, and records durable decisions as ADRs in `docs/adr/`. Its defining role in this workflow is seeding `docs/CONTEXT.md` (the ubiquitous-language glossary) **before** the requirements step, so `domain-requirements` can consume a real glossary on its first pass. Used twice: Phase 2 Step 4 (full grill of `docs/vision.md` + `01-foundation.md`) and Step 8 (targeted re-grill of the diff only, restricting the subject to `git diff HEAD~1 HEAD`).

---

## `domain-requirements` — **authoring**

**Purpose.** Produces `docs/requirements.md` — a catalog of functional requirements (user stories), measurable non-functional requirements, constraints, and an explicit **out-of-scope / non-goals** list, all written in the project's **ubiquitous language**. Two behaviors are load-bearing: (1) the **vocabulary input** — it reads the glossary (in addition to the vision document), draws actors/roles from the glossary's actor terms verbatim (with a heuristic for *identifying* which glossary entries are actors, and a "single actor → don't invent extra roles" rule), and uses domain nouns exactly as defined; and (2) it **carries negative decisions forward** — the vision's non-goals and any alignment rejections become an Out-of-Scope section so scope can be defended later (Aln15). It also frames `requirements.md` as a *summary* of upstream alignment, not the origin of the design concept (Aln13). It does *not* model entities, cut scope, or gate ADRs (those are sibling skills), and — critically — it does *not* enforce, evolve, or write back to the glossary (that stays `ubiquitous-language-guard`); it is **consume-only** on the glossary.

**Input artifacts (must use).**
- **Vision document** (required) — `docs/vision.md`, the source the requirements catalog is derived from. Its **non-goals / out-of-scope** section is read too and carried forward (Aln15). If absent, the skill STOPS — it is the required input.
- **Glossary** (the ubiquitous-language file), resolved by a fallback chain — never a hard-coded filename:
  1. an explicit glossary path passed as an argument → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  4. none found → warn ("No glossary found; proceeding without one — domain terms cannot be verified verbatim and actors will fall back to generic roles") and degrade to **generic behaviour** (generic roles, terms from the vision document), noting that requirements should be re-run once a glossary exists.
- **Negative-decision sources** (optional) — an alignment transcript (`algn_transcript.md`) and/or an idea file (`idea.md`) are read for negative decisions *if present*; their absence is not an error (the vision's out-of-scope suffices).

**Output artifacts / results.**
- `docs/requirements.md` — fixed filename so the AIUP chain stays intact (downstream `use-case-diagram`, `use-case-spec`, `domain-model`, `trace-check` read it), but positioned as a **summary** of upstream alignment, not the source of the design concept (Aln13).
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
everywhere (requirements, models, diagrams, specs, code, UI). It audits a single AIUP
artifact against the project glossary, produces a **term-diff report**, and — only with
explicit human approval (HITL) — evolves the glossary itself. It does *not* model
entities, cut scope, or gate ADRs (those are sibling skills).

**Input artifacts (must use).**
- **Artifact under review** (required) — one AIUP artifact: `requirements.md`, an entity
  model, a `*.puml` use case diagram, or a `use_cases/*.md` spec. Named by the user or the
  file in focus.
- **Glossary** (the ubiquitous-language file), resolved by a fallback chain — never a
  hard-coded filename:
  1. explicit path the user passed → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  4. none found → warn and drop to **report-only** mode running **L4 only** (L1/L2/L6 and
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

**Purpose.** Produces the conceptual domain model: it reads `docs/requirements.md` plus any ADRs and the glossary, and emits `docs/entity_model.md` — a Mermaid ER diagram plus one attribute table per domain term. Its distinctive work is tactical-DDD modeling: it classifies **every** term as Entity, Value-Object, or Aggregate-root (never defaulting to "a table with an `id`") — with an explicit aggregate-root selection procedure and a worked non-root-member example so the boundary is reasoned, not guessed — turns implied business invariants into **explicit** validation rules assigned to the owning domain type, and keeps the model conceptual — no storage/transport mechanics unless a storage target is explicitly declared. It models **one bounded context** per run (flagging cross-context term collisions rather than merging them). It does *not* maintain the glossary, cut scope, gate ADRs, or sweep constraints (those are sibling skills); it only models. The filename stays `entity_model.md` (not `domain_model.md`) because that is the AIUP-chain contract downstream skills (`use-case-spec`, `trace-check`) read.

**Input artifacts (must use).**
- **`docs/requirements.md`** (required) — the source of domain terms and implied invariants. If it is absent the skill STOPS (it is the required source; only the glossary has a fallback).
- **`docs/adr/*`** (read) — architecture decision records, scanned for implied business rules and for an explicit storage-target declaration (which switches the model into physical mode).
- **Glossary** (the ubiquitous-language file), resolved by a fallback chain — never a hard-coded filename:
  1. explicit path passed as an argument → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  4. none found → warn ("No glossary found; proceeding without one — terms cannot be verified verbatim") and proceed. When present, its terms are used **verbatim** as node, term, and attribute names.

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

**Purpose.** A cross-cutting lens that protects the *why* of decisions: it scans any artifact — pre-decision (a plan, requirements doc, entity model, use-case spec, design note) or post-decision (a diff) — for choices that cross the **Architectural Decision Record threshold**, then drafts and human-gates one durable `docs/adr/` record per qualifier. It detects threshold-crossing decisions, asks the human "ADR-worthy?" per hit, drafts `proposed` ADRs in Context / Decision / Consequences / Alternatives form, and writes nothing — and flips nothing to `accepted` — without explicit human approval. It is step-agnostic. It does *not* model entities, maintain the glossary, cut scope, or sweep constraints (those are sibling skills).

**Input artifacts (must use).**
- **Artifact under review** (required) — any single pre- or post-decision artifact: a plan, `requirements.md`, an entity model, a `use_cases/*.md` spec, a diff, or a design note. Named by the user or the file in focus.
- **`docs/adr/*`** (read for numbering and coverage) — the existing ADR files. Scanned to (a) derive the next zero-padded monotonic `NNNN` and (b) avoid re-drafting an already-captured decision. If `docs/adr/` is empty or absent, numbering starts at `0001`.

**Output artifacts / results.**
- One new **`docs/adr/NNNN-<kebab-slug>.md`** file per qualifying decision, at `Status: proposed`, using the required section order (Title / Status / Context / Decision / Consequences / Alternatives). The slug is built from the decision's one-line summary so the filename is greppable. A draft missing **Alternatives** is invalid (the trade-off claim would be unverifiable).
- A **HITL "ADR-worthy?" ask** per threshold-crossing decision — naming all three criteria explicitly — gating every draft; and a second approval gate before any file is written.
- A one-line **"no-ADR, why" note** per sub-threshold decision, naming the single failed criterion. No file is written for these.
- A closing **report**: the ADR files written (paths, all `proposed`) and the list of no-ADR notes with reasons.

**Relation to guardrail items.** This skill is the executable form of the ADR rules in **`gr_adr.md`**, with the criteria and format carried over verbatim:
- **Adr1** Three-Part Threshold — the skill's three-part AND gate (*hard to reverse* AND *surprising without context* AND *real trade-off*); if any one fails, no ADR, and interchangeable choices, easily-reversible refactors, and routine style choices are explicitly out of scope ("ADR noise dilutes signal").
- **Adr2** ADRs Are Durable, In-Tree — files live at `docs/adr/NNNN-<kebab-slug>.md` with a zero-padded monotonic integer; the skill forbids date-numbering (`2026-05-21-foo.md`) precisely because it breaks the supersession chain, and states the durability half (an ADR is never silently deleted — superseded, not removed).
- **Adr3** ADRs Are Distinct From Aln15 Negative Decisions — a one-line guard: the ADR is about the *chosen* road, not a rejected option; rejected options live in the alignment transcript (Aln15) and appear only inside the ADR's Alternatives Considered section. This is the skill's main defense against drafting noise ADRs for considered-but-rejected alternatives.
- **Adr4** ADRs Are Distinct From the PRD — a one-line guard: an ADR records *why* a surprising choice was made, not *what* was decided (that is the PRD/plan), preventing restatement-fat ADRs.
- **Adr5** Required Sections — the draft template enforces Title / Status / Context / Decision / Consequences / Alternatives Considered in order; the section is named "Alternatives Considered" verbatim per the guardrail and is mandatory per Adr1.3, and the legal Status enum (`proposed | accepted | superseded by NNNN | deprecated`) is recorded as a template comment even though the skill only ever writes `proposed`.
- **Adr7** Supersede, Don't Mutate — the skill refuses to edit an already-`accepted` ADR's body, deferring supersession (which it treats as out of scope) rather than mutating.
- **Adr8** Agent May Draft, Human Must Accept — the agent drafts; the `proposed` → `accepted` flip is human-only and never silent. This is the skill's core HITL contract.
- **Adr10** Review Verifies ADR Coverage — the skill's post-decision (diff) mode realizes the coverage check: did any decision cross the Adr1 threshold without an ADR? If so, it surfaces and drafts the missing one.

The threshold's subject matter is architectural decisions, so **`gr_architecture.md`** is the conceptual source — but the skill deliberately does **not** implement that file's structural rules (**A1**–**A11**: layering, dependency direction, module boundaries, public-API compatibility, etc.). It only *captures the rationale* of a crossing decision; enforcing the structure itself is a separate concern.

*Note:* **Adr3** and **Adr4** are carried as one-line guards (see above) — not the full alignment/PRD machinery, but the distinctions an agent needs to avoid drafting noise ADRs (rejected options) or restatement-fat ADRs (*what* instead of *why*). The skill deliberately does **not** implement **Adr6** (author at decision time vs retroactively) or **Adr9** (ADRs as a pull-source for implementation) — those are alignment/implementation-loop concerns outside a single-artifact threshold gate. Supersession (**Adr7** beyond the no-mutate rule) is likewise left out of scope.

---

## `hidden-constraint-sweep` — **lens**

**Purpose.** A cross-cutting lens that pressure-tests a spec against the constraints stakeholders habitually miss: it fires an **8-class hidden-constraint checklist** (security & PII, permissions, data-retention, migrations, observability, public-API-compat, concurrency, out-of-scope) over a requirements doc, use-case spec, or domain model and forces an explicit **`covered` / `not-applicable` / `missing`** verdict for *every* class — every run, in order. Its whole value is that it **defeats agent judgment about which classes apply**: silent omission of a class is forbidden, and a `missing` class **blocks** the sweep from reporting complete. To stop the central loophole on a human-less doc run, a `not-applicable` verdict must **cite a concrete fact in the artifact/context** (not a generic assertion), and the skill states that **`blocked` is the expected, valuable outcome** — never a failure to be dodged by under-reporting `missing` as `not-applicable`. It is a **pure report** — it writes nothing: it surfaces gaps and names concrete follow-ups for the human or a sibling skill (`domain-requirements`, `use-case-spec`, `pareto-scope-cut`) to act on; it does *not* model entities, edit the glossary, gate ADRs, rewrite the spec, or perform the deferral/scope-cut mechanics. Step-agnostic: identical checklist at requirements, use-case-spec, and domain-model stages — only the *kind* of pointer/follow-up varies (FR/NFR at requirements, alt-flow at use-case-spec, invariant/Constraints note at domain-model).

**Input artifacts (must use).**
- **Artifact under sweep** (required) — the requirements doc, use-case spec, or domain/entity model the user names, or the file in focus. If none is named, the skill asks which artifact to sweep before proceeding.
- **Glossary / context** (optional), resolved by a fallback chain — never a hard-coded filename:
  1. explicit path the user passed → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  4. none found → warn (`"no glossary/context found; proceeding without term grounding"`) and continue. Absence never blocks the sweep.

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

**Relation to guardrail items.** Its completeness check is an **AIUP chain-integrity** guarantee (the FR→UC reverse of `trace-check` Check A's UC→FR); no single `gr_*.md` rule defines it. It **consumes** the glossary under **`gr_domain_language.md` L1** (actors verbatim, read side) and routes a needed-but-undefined actor to the `ubiquitous-language-guard` write-back loop under **L6** (flag, never coin). It deliberately does **not** enforce/evolve the glossary (L2/L4/L8 stay `ubiquitous-language-guard`) or cut scope (`gr_greenfield` G1/G9 stay `pareto-scope-cut`) — it only consumes their outputs.

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

**Relation to guardrail items.** Reverse-coverage and the trace line are **AIUP chain-integrity** guarantees (no single `gr_*.md` rule). The BR→invariant *grounding* reflects the spirit of **`gr_ddd.md` D1/D9** (a business rule should be a domain invariant) but only **cites or flags** the document linkage — it never authors the invariant or sees code, exactly the boundary `trace-check` Check D draws. It **consumes** the glossary under **L1** (actors verbatim) and flags unknown actors under **L6**; it does **not** enforce the glossary, cut scope, or model entities (sibling skills own those). The `BR-###` ↔ invariant linkage is handled by this grounding-and-flagging step.

---

## `trace-check` — **lens**

**Purpose.** A cross-cutting lens that protects traceability: every downstream artifact must trace back to something upstream, and every cross-reference must resolve. It reads the AIUP artifact set, runs four consistency checks, produces a single **consistency report** (PASS or a list of breaks), and — only with explicit human approval (HITL) — loops a fix back into the *offending* artifact. It does *not* author requirements, model entities, maintain the glossary, gate ADRs, or cut scope (those are sibling skills).

**Input artifacts (must use).**
- **Requirements** (default `docs/requirements.md`) — the functional-requirement (FR) catalog use cases must trace to. Override path accepted.
- **Use case diagram** (default `docs/use_cases.puml`) — the PlantUML diagram declaring actors and use cases. Override path accepted.
- **Use-case specs** (default `docs/use_cases/*.md`) — per-use-case specs carrying actors, scenarios, named entities, and business rules (`BR-###`). Override glob accepted.
- **Entity model** (default `docs/entity_model.md`) — domain entities and their invariants / validation rules.
- **Glossary** (optional), resolved by a fallback chain — never a hard-coded filename:
  1. explicit path the user passed → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  4. none found → warn and run **Check C in report-only mode** (verbatim glossary matching limited; actor names still cross-checked across diagram and specs).
- Any non-glossary input that is missing triggers a **warn**; the affected check is skipped and reported, and the skill continues (step-agnostic, never crashes on a not-yet-created artifact).

**Output artifacts / results.**
- Before the checks, it **discovers conventions** rather than assuming them: the actual requirement/BR **id patterns** (not a hard-coded `FR-`/`BR-`), whether the project carries a **UC→FR trace convention** at all, and a **name-normalization rule** (trim/lowercase/de-pluralize) so near-matches are caught mechanically, not by judgment.
- A **consistency report** (template in the SKILL.md) with one section per check:
  - **Check A** — every UC traces to ≥1 FR (flags **orphan use cases**, **dangling FR references**, and diagram-UCs-with-no-spec). Gated on a trace convention existing: if none does, it emits a single "traceability not author-able" finding instead of flagging every UC as an orphan.
  - **Check B** — every entity named in a spec exists in `entity_model.md` (flags **missing entities**, including singular/plural and casing near-matches).
  - **Check C** — every actor matches the glossary **verbatim** (flags near-match variations/abbreviations/pluralization/casing, *suspected* translations for human confirmation, and **unknown actors**). With no glossary, it degrades to an intra-artifact actor-consistency check, **labelled "L1 not run"** so a degraded run never reads as an L1 pass.
  - **Check D** — every business rule maps to a domain-model invariant via an explicit semantic-matching procedure (the model carries no BR back-references), flagging **unenforced business rules**, **invariant↔BR conflicts**, and **needs-human-confirmation** where it cannot decide; within-spec duplicate BR ids are out of scope (not cross-artifact).
  - A header line per artifact (path | MISSING) and an overall **Result: PASS | PARTIAL (checks skipped) | BREAKS FOUND (N)** — a run with any check skipped is never `PASS`.
- **HITL fix loop** — for each break the human elects to fix, the skill names the **candidate offending artifact(s)** and, where ambiguous (e.g. an orphan UC could be fixed by adding a trace line to the spec *or* a missing FR to requirements), lets the human pick which to change rather than assuming; it shows an exact before/after diff or new line, applies only per-change-approved edits, then re-runs the affected check. It never invents traces, renames entities/actors, asserts an unprovable translation, or guesses a fix; unknown actors and term changes are *proposed*, routed to the glossary skill, never written here.

**Relation to guardrail items.** Only one rule is operationalized verbatim:
- **L1** Use defined terms exactly (`gr_domain_language.md`) — cited by name in **Check C**: every actor must appear in the resolved glossary verbatim, with casual variation / abbreviation / pluralization-casing drift / translation flagged.

The remaining checks have no single named gr rule ID for cross-artifact traceability — no `gr_*.md` file defines a "every UC traces to an FR" or "every entity in a spec exists in the model" rule — so they are enforced as the executable embodiment of guardrail *intent* rather than carried-over check IDs:
- **Check D** (BR → invariant) reflects the *spirit* of `gr_ddd.md` **D1**/**D9** — a business rule should be enforced as a domain invariant — but the linkage is loose, not a backstop: trace-check reads two **documents** (spec ↔ entity model) and only verifies a mapping exists between them; it **cannot see code**, so it cannot detect a D1 *placement* violation (an invariant enforced in a controller/helper). It surfaces "BR stated in a spec but absent from the model" — a documentation-drift finding — and never authors the invariant (that stays with `entity-model` / `domain-model`).
- **Checks A and B** are reported as **AIUP chain-integrity** findings. They serve the same anti-drift purpose as the documentation guardrails but correspond to no numbered gr rule (and are *not* claimed as `gr_documentation.md` Doc4/Doc5 violations — Doc4 is about behavior changes, Doc5 about not duplicating authoritative sources, neither of which is cross-artifact reference resolution).

*Note:* the skill deliberately does **not** implement `gr_domain_language.md` **L2/L4/L6/L8/L9** (forbidden synonyms, storage-shaped names, new-term introduction, glossary write-back, CLAUDE.md pointer) — those belong to `ubiquitous-language-guard`; trace-check applies L1 to actors only and **proposes**, never writes, glossary changes. It also does not gate or author ADRs (`gr_adr.md`) and does not cut scope.

---

## `prototype` — **external**

**Purpose.** Resolves the top open unknown before committing to a full build — for ai-mail, that is the interaction surface and the plan/apply state machine. Optional first step of Phase 4.

---

## `to-prd` — **external**

**Purpose.** Turns the completed AIUP spec spine (`requirements.md`, `entity_model.md`, `use_cases/*.md`) into a structured Product Requirements Document.

---

## `to-issues` — **external**

**Purpose.** Breaks the PRD into tracer-bullet, vertical-slice GitHub issues ready for implementation.

---

## `tdd` — **external**

**Purpose.** Implements the issues red-green-refactor style (test-driven development).

---

## `review-skills` — **meta**

**Purpose.** Project skill-maintenance tooling (not an AIUP-chain skill): produces a critical review of the skills in this `skills/` folder and writes it to `skills/skills_refactoring.md` — the refactoring worklist that `refactor-skills` later consumes. It **always asks first** whether to review a *single* skill or *all* skills. For each in-scope skill it spawns a **fresh sub-agent** (clean, un-cross-contaminated context) that reads only that one skill's `SKILL.md` (+ `REFERENCE.md`) and its entry here, discovers the `gr_*.md` files the skill cites, and reviews three dimensions: (1) guardrail coverage (missing/partial vs. the claims recorded here), (2) whether an agent running it achieves the skill's stated purpose, (3) writing effectiveness. Each review is headed by a pending `- [ ] refactored` checkbox.

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
