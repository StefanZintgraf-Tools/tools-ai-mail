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
3. [`domain-requirements` — **fork**](#domain-requirements--fork)
4. [`ubiquitous-language-guard` — **lens**](#ubiquitous-language-guard--lens)
5. [`pareto-scope-cut` — **lens**](#pareto-scope-cut--lens)
6. [`domain-model` — **fork**](#domain-model--fork)
7. [`adr-threshold-gate` — **lens**](#adr-threshold-gate--lens)
8. [`hidden-constraint-sweep` — **lens**](#hidden-constraint-sweep--lens)
9. [`use-case-diagram` — **stock**](#use-case-diagram--stock)
10. [`use-case-spec` — **stock**](#use-case-spec--stock)
11. [`trace-check` — **lens**](#trace-check--lens)
12. [`prototype` — **external**](#prototype--external)
13. [`to-prd` — **external**](#to-prd--external)
14. [`to-issues` — **external**](#to-issues--external)
15. [`tdd` — **external**](#tdd--external)

---

## `bmad-brainstorming` — **HITL**

**Purpose.** Facilitates interactive brainstorming sessions using diverse creative techniques and ideation methods. Used twice in the workflow: Phase 1 Step 1 to seed inception artifacts (`painlist.md`, `ideas.md`, `00-foundation.md`) using an AI-recommended method with Pareto prioritization, and Phase 1 Step 3 to challenge vision goals using Assumption Reversal and produce `01-foundation.md`. Produces no AIUP-chain artifact itself; its outputs are raw inception material consumed by downstream skills.

---

## `grill-with-docs` — **external**

**Purpose.** Stress-tests a plan against the existing domain model: sharpens terminology, challenges assumptions, and records durable decisions as ADRs in `docs/adr/`. Its defining role in this workflow is seeding `docs/CONTEXT.md` (the ubiquitous-language glossary) **before** the requirements step, so `domain-requirements` can consume a real glossary on its first pass. Used twice: Phase 2 Step 4 (full grill of `docs/vision.md` + `01-foundation.md`) and Step 8 (targeted re-grill of the diff only, restricting the subject to `git diff HEAD~1 HEAD`).

---

## `domain-requirements` — **fork**

**Purpose.** A glossary-aware fork of the stock `requirements` skill that produces `docs/requirements.md` — a catalog of functional requirements (user stories), measurable non-functional requirements, and constraints, all written in the project's **ubiquitous language**. The **only** thing it changes versus stock `requirements` is the vocabulary input: it reads the glossary (in addition to the vision document), draws actors/roles from the glossary's actor terms verbatim, and uses domain nouns exactly as defined. It does *not* model entities, cut scope, or gate ADRs (those are sibling skills), and — critically — it does *not* enforce, evolve, or write back to the glossary (that stays `ubiquitous-language-guard`); it is **consume-only**.

**Input artifacts (must use).**
- **Vision document** (required) — `docs/vision.md`, the source the requirements catalog is derived from.
- **Glossary** (the ubiquitous-language file), resolved by a fallback chain — never a hard-coded filename:
  1. an explicit glossary path passed as an argument → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  4. none found → warn ("No glossary found; proceeding without one — domain terms cannot be verified verbatim and actors will fall back to generic roles") and degrade to **stock behaviour** (generic roles, terms from the vision document), noting that requirements should be re-run once a glossary exists.

**Output artifacts / results.**
- `docs/requirements.md` — the AIUP-chain contract that downstream skills (`use-case-diagram`, `use-case-spec`, `domain-model`, `trace-check`) read. The filename is fixed deliberately so the chain stays intact.
- Three non-mixed Markdown tables: **FR** (user-story format, `As a [role], I want [goal] so that [benefit]`, with roles drawn from glossary actor terms), **NFR** (measurable quality attributes, categorized), and **Constraints** (categorized technical/business/schedule limitations) — each row carrying a unique ID and a filled Status column, validated against the Requirement Quality Checks table (Measurable, Singular, Unambiguous, Testable, Unique IDs, Verbatim).
- **Flags for the `ubiquitous-language-guard` write-back loop** — when a requirement genuinely needs a concept the glossary does not name, the term is *surfaced for review*, not silently coined here.

**Relation to guardrail items.** This skill operationalizes the requirements/specification step of **`gr_idea.md`** (the `ide` → `prd` distillation arc — turning a vision/brief into a structured specification with FRs, NFRs, and constraints) and the destination-document role described in **`gr_algn.md`** (Aln13, "PRD summarizes alignment, does not replace it"; Aln15 out-of-scope/constraints carried forward). Its distinguishing behavior — the glossary consumption — is bounded by specific rules of **`gr_domain_language.md`**, cited verbatim:
- **L1** Use Defined Terms Exactly — domain nouns and actors appear verbatim in titles, user stories, and constraints; no casual variation, abbreviation, translation, pluralization, or re-casing.
- **L6** Introduce New Terms Explicitly — a genuinely-new concept is *flagged and proposed*, never silently invented; it is routed to the `ubiquitous-language-guard` write-back loop rather than coined in the requirements doc.
- **L8** `CONTEXT.md` Is the Ubiquitous-Language Artifact — honored on the *read* side only: the glossary (`CONTEXT.md` / `glossary.md`) is treated as the source of truth for terms and consumed as ground truth.

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
  4. none found → warn and run in **report-only** mode (L8 write-back and L1 verbatim
  checks are limited).
- **`CLAUDE.md`** (read-only) — checked for a pointer to the resolved glossary (L9).

**Output artifacts / results.**
- A **term-diff report** (template in the SKILL.md) with sections: L1 verbatim violations,
  L2 forbidden synonyms, L4 storage-shaped names, L6 new/unknown terms, near-match
  decisions, proposed glossary changes, and L9 CLAUDE.md pointer status.
- **HITL write-back** of approved new/refined terms into the resolved glossary file
  (`CONTEXT.md` / `glossary.md`) — per-change approval, structure preserved.
- A **proposed CLAUDE.md pointer fix** when the pointer is missing/wrong — *surfaced, not
  auto-applied* (CLAUDE.md ownership stays with the human).

**Relation to guardrail items.** This skill is the executable form of the
`align-concept` rules in **`gr_domain_language.md`**, with the check IDs carried over
verbatim:
- **L1** Use defined terms exactly (verbatim) — flags casual variation, abbreviation,
  pluralization/casing drift, translation.
- **L2** No forbidden synonyms — checks each term's `_Avoid_` list; a synonym is allowed
  only if the glossary defines it as a *different* concept.
- **L4** Naming reflects behavior, not storage — flags `Table`/`Row`/`Record`/`DTO`/
  `Blob`/`Json`/`Payload`/`Flag`… used as the domain name (overlaps gr **L3**, separate
  domain vs technical terms).
- **L6** Introduce new terms explicitly — no silent invention; propose a definition or
  route through the near-match gate. The near-match gate (same / refinement / new) enforces
  gr **L7** (match language across bounded contexts deliberately — do not unify by accident).
- **L8** `CONTEXT.md` is the ubiquitous-language artifact and the source of truth for
  terms — realized here as the HITL write-back to that file.
- **L9** CLAUDE.md points to the domain docs — verified, fix proposed (not auto-edited).
- **G7** (`gr_greenfield.md`) Initial domain vocabulary is recorded — covered by the
  skill's "G7 — record initial vocabulary as it emerges", feeding the L8 write-back so the
  glossary stays current from the start in greenfield work.

*Note:* the skill deliberately does **not** implement gr **L5** (renaming propagation
across code/tests/APIs) — that is a code-wide refactor concern, outside a single-artifact
language audit.

---

## `pareto-scope-cut` — **lens**

**Purpose.** A cross-cutting lens that enforces "build only what the next concrete requirement needs." It takes a single planning artifact plus the project's **scope marker** (the milestone/phase that defines "now"), enumerates every scopeable item, splits them into **in-scope** vs **deferred**, and records each deferral as a one-line postponed-decision so it is never silently re-decided. It produces a **scope split + postponed-decisions log** and — only with explicit human approval (HITL) — appends them to the artifact. It does *not* model entities, maintain a glossary, gate ADRs, or sweep constraints (those are sibling skills); it *only* does the scope cut and the postponed-decision log.

**Input artifacts (must use).**
- **Artifact to scope-cut** (required) — any one planning doc: a requirements catalog, entity/domain model, `*.puml` use-case diagram, or a `use_cases/*.md` spec. Named by the user or the file in focus.
- **Scope marker** (required) — the boundary that defines "now," typically a milestone/phase marker named in a planning doc. Taken as an argument if given; otherwise the user is asked which marker defines current scope. The boundary is NEVER guessed silently, and no project's milestone names or plan file paths are hard-coded — the marker is read generically.

**Output artifacts / results.**
- A **Scope split** section (template in the SKILL.md) headed `## Scope split (against <scope marker>)`, with an **In scope** list (one-line why each item is needed now) and a **Deferred** list (one-line why each item is future/imagined). Every enumerated item is classified exactly once.
- A **Postponed decisions** log — one G9-format line per deferred item: `- [<item>] Deferred: <what>. Reason: <why, cites G1/G3/G5/G10>. Revisit when: <trigger>.`
- **HITL append** of both sections to the END of the artifact, only after the proposed split + log are shown and explicitly approved. In-scope content is never deleted or rewritten; unrelated sections are left untouched; the skill only splits and appends.

**Relation to guardrail items.** This skill is the executable form of the over-engineering rules in **`gr_greenfield.md`** ("prevent premature architecture and over-engineering… the danger is building for imagined needs"), with the rule IDs carried over verbatim:
- **G1** Boring, Explicit, Replaceable First — flags clever, generalized, or "future-proof" designs where a simpler explicit one meets the current need.
- **G3** Defer Expensive Decisions — flags expensive-later-cheap decisions dressed up early (plugin systems, multi-tenancy, internationalization, advanced patterns) with no concrete requirement at the marker.
- **G5** No Premature Abstraction — flags an abstraction (shared base, generic type, interface) extracted with fewer than two concrete cases demanding it.
- **G9** Record Postponed Decisions — realized as the one-line postponed-decision record per deferred item, so decisions are written down and never silently re-decided.
- **G10** Smallest Architecture That Supports the Next Known Requirement — flags items sized for a multi-release roadmap rather than the next concrete requirement at the marker.

*Note:* the skill deliberately implements only G1/G3/G5/G9/G10 and does **not** cover the rest of `gr_greenfield.md` — **G2** (first vertical slice before layers), **G4** (establish conventions once), **G6** (no premature framework), **G7** (record initial vocabulary — owned by `ubiquitous-language-guard`), and **G8** (initial testing strategy) — as those are build-sequencing, convention, language, and testing concerns outside a single-artifact scope cut.

---

## `domain-model` — **fork**

**Purpose.** A *fork* skill that produces the conceptual domain model: it reads `docs/requirements.md` plus any ADRs and the glossary, and emits `docs/entity_model.md` — a Mermaid ER diagram plus one attribute table per domain term. Its distinctive work is tactical-DDD modeling: it classifies **every** term as Entity, Value-Object, or Aggregate-root (never defaulting to "a table with an `id`"), turns implied business invariants into **explicit** validation rules, and keeps the model conceptual — no storage/transport mechanics unless a storage target is explicitly declared. It does *not* maintain the glossary, cut scope, gate ADRs, or sweep constraints (those are sibling skills); it only models. The filename stays `entity_model.md` (not `domain_model.md`) because that is the AIUP-chain contract downstream skills (`use-case-spec`, `trace-check`) read.

**Input artifacts (must use).**
- **`docs/requirements.md`** (required) — the source of domain terms and implied invariants when no glossary is present.
- **`docs/adr/*`** (read) — architecture decision records, scanned for implied business rules and for an explicit storage-target declaration (which switches the model into physical mode).
- **Glossary** (the ubiquitous-language file), resolved by a fallback chain — never a hard-coded filename:
  1. explicit path passed as an argument → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  4. none found → warn ("No glossary found; proceeding without one — terms cannot be verified verbatim") and proceed. When present, its terms are used **verbatim** as node, term, and attribute names.

**Output artifacts / results.**
- **`docs/entity_model.md`** — created or updated, with a header recording **Mode** (`Conceptual` by default, or `Physical (storage target: <X>, per <ADR/req>)`) and the resolved **Glossary** path.
- An **ER diagram** (Mermaid `erDiagram`) showing verbatim term names and relationships **only** — no attributes inside entity blocks — with every relationship pointing to the **aggregate-root**, not to internal members (D2).
- **One attribute table per term**, each under a `### TERM_NAME — <Kind>` heading (plus `[aggregate: ROOT]` for non-root members). Conceptual columns by default (`Attribute | Description | Type | Validation Rules`, conceptual types only); physical columns (`Data Type`, `Length/Precision`, PK/FK/Sequence) appear **only** behind a declared storage target.
- **Explicit validation rules** in every cell (never empty), with cross-attribute / cross-entity invariants captured in a **Constraints** note as the aggregate's construction-time invariants.
- A final **cross-validation pass**: diagram ↔ table parity, every term classified, no forced surrogate `id`, no value-object identity column, no storage datatypes or leaked infrastructure in conceptual mode, every reference resolvable, all names verbatim, no out-of-scope/deferred term pulled in.

**Relation to guardrail items.** This skill operationalizes the tactical rules of **`gr_ddd.md`**, the infrastructure-isolation rule of **`gr_architecture.md`**, and the verbatim-naming rules of **`gr_domain_language.md`** — IDs carried over verbatim:
- **D2** Respect Aggregate Boundaries (`gr_ddd.md`) — relationships from other terms point to the aggregate-root, and the root's table/Constraints carry the invariants spanning its members.
- **D3** Enforce Invariants at Construction (`gr_ddd.md`) — multi-attribute/cross-entity invariants become **Constraints** so an instance cannot exist in an invalid state.
- **D5** Value Objects Are Immutable (`gr_ddd.md`) — value-objects are modeled immutable, compared by value, and given **no** identity column.
- **D9** Validation Lives Where the Invariant Lives (`gr_ddd.md`) — each implied invariant is made an explicit Validation Rule on the term that owns it.
- **A9** Keep Infrastructure Out of Domain (`gr_architecture.md`) — persistence keys, surrogate/auto-increment ids, framework types, message-broker ids, file paths, and HTTP/transport fields must not appear in conceptual mode; identity is a natural domain key.
- **L1** Use Defined Terms Exactly, **L2** No Forbidden Synonyms, **L4** Naming Reflects Behavior Not Storage (`gr_domain_language.md`) — glossary terms are used verbatim as entity/value-object/aggregate and attribute names, with no synonyms or storage-shaped names.
- **L6** Introduce New Terms Explicitly (`gr_domain_language.md`) — a genuinely-new structural concept is **flagged** for the glossary (looped back via the `ubiquitous-language-guard`) rather than coined here.

*Note:* the skill deliberately does **not** implement the glossary write-back (**L8**) or the `CLAUDE.md` pointer check (**L9**) of `gr_domain_language.md`, nor scope-cutting, ADR-gating, or constraint-sweeping — those are the responsibility of `ubiquitous-language-guard`, `pareto-scope-cut`, `adr-threshold-gate`, and `hidden-constraint-sweep`. It also leaves the remaining `gr_ddd.md` rules (**D1**, **D4**, **D6**, **D7**, **D8**) to code-level skills, since they govern runtime layering and code structure rather than a conceptual model document.

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
- **Adr2** ADRs Are Durable, In-Tree — files live at `docs/adr/NNNN-<kebab-slug>.md` with a zero-padded monotonic integer; the skill forbids date-numbering (`2026-05-21-foo.md`) precisely because it breaks the supersession chain.
- **Adr5** Required Sections — the draft template enforces Title / Status / Context / Decision / Consequences / Alternatives in order; an Alternatives section is mandatory per Adr1.3.
- **Adr7** Supersede, Don't Mutate — the skill refuses to edit an already-`accepted` ADR's body, deferring supersession (which it treats as out of scope) rather than mutating.
- **Adr8** Agent May Draft, Human Must Accept — the agent drafts; the `proposed` → `accepted` flip is human-only and never silent. This is the skill's core HITL contract.
- **Adr10** Review Verifies ADR Coverage — the skill's post-decision (diff) mode realizes the coverage check: did any decision cross the Adr1 threshold without an ADR? If so, it surfaces and drafts the missing one.

The threshold's subject matter is architectural decisions, so **`gr_architecture.md`** is the conceptual source — but the skill deliberately does **not** implement that file's structural rules (**A1**–**A11**: layering, dependency direction, module boundaries, public-API compatibility, etc.). It only *captures the rationale* of a crossing decision; enforcing the structure itself is a separate concern.

*Note:* the skill deliberately does **not** implement **Adr3** (distinguishing ADRs from `Aln15` rejected-option entries), **Adr4** (ADR-vs-PRD distinction), **Adr6** (author at decision time vs retroactively), or **Adr9** (ADRs as a pull-source for implementation) — those are alignment/PRD/implementation-loop concerns outside a single-artifact threshold gate. Supersession (**Adr7** beyond the no-mutate rule) is likewise left out of scope.

---

## `hidden-constraint-sweep` — **lens**

**Purpose.** A cross-cutting lens that pressure-tests a spec against the constraints stakeholders habitually miss: it fires an **8-class hidden-constraint checklist** (security & PII, permissions, data-retention, migrations, observability, public-API-compat, concurrency, out-of-scope) over a requirements doc or use-case spec and forces an explicit **`covered` / `not-applicable` / `missing`** verdict for *every* class — every run, in order. Its whole value is that it **defeats agent judgment about which classes apply**: silent omission of a class is forbidden, and a `missing` class **blocks** the sweep from reporting complete. It does *not* model entities, edit the glossary, gate ADRs, rewrite the spec, or perform the deferral/scope-cut mechanics — it only surfaces gaps and names concrete follow-ups (those are sibling skills, e.g. `pareto-scope-cut`). Step-agnostic: identical checklist at requirements, use-case-spec, and domain-model stages — only the *kind* of pointer/follow-up varies (FR/NFR vs. alt-flow).

**Input artifacts (must use).**
- **Artifact under sweep** (required) — the requirements doc or use-case spec the user names, or the file in focus. If none is named, the skill asks which artifact to sweep before proceeding.
- **Glossary / context** (optional), resolved by a fallback chain — never a hard-coded filename:
  1. explicit path the user passed → 2. `docs/CONTEXT.md` → 3. `docs/glossary.md` →
  4. none found → warn (`"no glossary/context found; proceeding without term grounding"`) and continue. Absence never blocks the sweep.

**Output artifacts / results.**
- A **per-class verdict table** (template in the SKILL.md): one row per class with its verdict and mandatory evidence — a **pointer** for `covered` (FR/NFR id, section, flow, or glossary term; a verdict with no pointer is *not* `covered`), a **recorded plain-language reason** for `not-applicable`, or a **routed follow-up** for `missing`.
- A **Follow-ups list** — one line per `missing` class, each routed to exactly one of: a new FR, a new NFR, a use-case alternative flow, or a deferral candidate (handed to the scope-cut skill, not enacted here).
- A **sweep verdict**: `clean` (no class `missing`) or `blocked` (one or more `missing`, listed by class). A `blocked` sweep must not be reported as complete.

**Relation to guardrail items.** This skill is the executable form of the alignment-close hidden-constraint sweep in **`gr_algn.md`**, with its mechanics carried over verbatim:
- **Aln6** Hidden-Constraint Checklist — the source rule. It mandates the sweep "fires **always at close**, regardless of whether the topic plausibly engaged a class," and supplies the three outcomes (`covered` with a pointer, `not-applicable` with a recorded reason, `missing` which **blocks** close — "No silent passes, no 'documented gap' closes"). Aln6 enumerates the exact **8** classes this skill uses: Security, Permissions / authorization, Data retention, Migrations, Observability, Public API compatibility, Concurrency, and Out-of-scope. "Silent omission of a class is forbidden" maps directly onto the skill's DO-NOT list.
- It also operationalizes the review-side mirror in **`gr_rev.md`**: **Rev7** Check Hidden-Constraint Coverage (cross-references `gr_algn.md`; "A 'not applicable' verdict is stated, not assumed") and the **Rev11** Reviewer Output Format requirement for an explicit per-class "covered / not applicable / missing" statement. As `gr_algn.md` notes, "Aln6 feeds gr_rev.md Rev7 — what was checked during grilling becomes the review checklist"; this skill is the shared checklist behind both phases.

*Reconciliation note:* the skill follows the **Aln6 8-class** set. `gr_rev.md` Rev7 lists only **7** classes — it omits **out-of-scope** and pairs retention+migrations on one line. Per the build spec the skill keeps Aln6's fuller set; the difference is presentational, not a conflict in intent.

*Deliberately not implemented.* The skill **does not** enact deferrals or perform scope cuts (Aln15 negative-decision capture and the scope-cut mechanics belong to `pareto-scope-cut`); it only surfaces a deferral *candidate*. It also does not run the public-API *snapshot comparison* of `gr_rev.md` **Rev5a** / approval gate of **`gr_governance.md` Gov3** — it flags the public-API-compat *class* as a constraint to verify, but does not regenerate or diff an API snapshot. Glossary write-back (`gr_domain_language.md` L8), ADR gating (`gr_adr.md` Adr1), and entity modeling are explicitly out of scope.

---

## `use-case-diagram` — **stock**

**Purpose.** Stock AIUP skill that produces `docs/use_cases.puml` — a PlantUML actor/use-case diagram derived from `requirements.md` and the domain model. Run with step-agnostic lenses (`ubiquitous-language-guard`, `pareto-scope-cut`, `adr-threshold-gate`, `hidden-constraint-sweep`) composed on top rather than forked into the skill itself.

---

## `use-case-spec` — **stock**

**Purpose.** Stock AIUP skill that produces per-use-case spec files under `docs/use_cases/*.md`, each detailing actors, main/alternative scenarios, and business rules (`BR-###`). Run with the same composed lenses as `use-case-diagram`. A forked version is built only reactively if the `BR-###` ↔ invariant linkage breaks (see `skills/create_skills.md` §"Build order").

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
- A **consistency report** (template in the SKILL.md) with one section per check:
  - **Check A** — every UC traces to ≥1 FR (flags **orphan use cases** and **dangling FR references**).
  - **Check B** — every entity named in a spec exists in `entity_model.md` (flags **missing entities**, including singular/plural and casing near-mismatches).
  - **Check C** — every actor matches the glossary **verbatim** (flags casual variations, abbreviations, pluralization/casing drift, translations, and **unknown actors**).
  - **Check D** — every `BR-###` maps to a domain-model invariant (flags **unenforced business rules**, invariant↔BR conflicts, and duplicate/contradictory BR ids).
  - A header line per artifact (path | MISSING) and an overall **Result: PASS | BREAKS FOUND (N)**.
- **HITL fix loop** — for each break the human elects to fix, the skill names the offending artifact, shows an exact before/after diff or new line, and applies only per-change-approved edits, then re-runs the affected check. It never invents traces, renames entities/actors, or guesses a fix; unknown actors and term changes are *proposed*, routed to the glossary skill, never written here.

**Relation to guardrail items.** Only one rule is operationalized verbatim:
- **L1** Use defined terms exactly (`gr_domain_language.md`) — cited by name in **Check C**: every actor must appear in the resolved glossary verbatim, with casual variation / abbreviation / pluralization-casing drift / translation flagged.

The remaining checks have no single named gr rule ID for cross-artifact traceability — no `gr_*.md` file defines a "every UC traces to an FR" or "every entity in a spec exists in the model" rule — so they are enforced as the executable embodiment of guardrail *intent* rather than carried-over check IDs:
- **Check D** (BR-### → invariant) backstops `gr_ddd.md` **D1** (business invariants belong in the domain model) and **D9** (validation lives where the invariant lives): a `BR-###` with no corresponding entity-model invariant is surfaced as an unenforced rule. The skill **verifies the mapping exists; it does not author the invariant** — that stays with `entity-model` / `domain-model`.
- **Checks A and B** enforce the broader "artifacts must not drift apart" discipline behind the documentation guardrails (`gr_documentation.md` Doc4/Doc5 — docs stay aligned, authoritative sources are not duplicated) but correspond to no numbered gr rule; they are reported as structural consistency findings.

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
