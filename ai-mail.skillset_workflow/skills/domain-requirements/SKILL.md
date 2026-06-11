---
name: domain-requirements
description: >
  Gathers, organizes, and documents software requirements into structured
  catalogs with functional requirements (user stories), non-functional
  requirements (measurable quality attributes), constraints, and an explicit
  out-of-scope / non-goals list — consuming the project glossary so terms and
  actors are used verbatim instead of being invented or defaulted to
  "User/Admin/System". Use when the user asks to "write requirements", "create a
  PRD", "gather requirements", "document feature specs", "write user stories",
  "define NFRs", "list constraints", "capture out-of-scope / non-goals", or
  mentions requirements catalog, requirements analysis, product requirements
  document, glossary-aware requirements, or feature specification.
---

# Domain Requirements

Produces `docs/requirements.md`: a catalog of functional requirements (user
stories), non-functional requirements (measurable quality attributes),
constraints, and an explicit **out-of-scope / non-goals** list — written in the
project's **ubiquitous language** by consuming the glossary as input.

`docs/requirements.md` is a **summary** of upstream alignment (the vision, the
grilling that produced `CONTEXT.md` and the ADRs), not the origin of the design
concept (gr_algn **Aln13**). It restates decisions already made — including the
decisions *not* to do something (gr_algn **Aln15**). The filename is fixed so the
downstream chain stays intact (downstream skills — use-case-diagram, use-case-spec,
domain-model, trace-check — read it).

Two behaviors are load-bearing: (1) the **vocabulary input** — it reads the
glossary and uses domain terms and actors verbatim; and (2) it **carries negative
decisions forward** from the vision/alignment into an Out-of-Scope section so
scope can be defended later. It is **consume-only** on the glossary — it does not
enforce, evolve, or write back to it (that stays `ubiquitous-language-guard`).

**Scope stance — vision-scoped, no further.** This skill emits a
**vision-scoped catalog**: it documents exactly the slice the vision already
chose, inheriting the vision's scope rather than deciding scope itself. It does
**not** apply the milestone deferral cut (the level-2 Open/Deferred split — that
is `pareto-scope-cut`'s "Scope split"), and it does **not** reach beyond the
vision into other capabilities. Consequently the catalog is **never bound to a
module or milestone identifier** in its title, examples, or tables — there is no
marker to resolve here, because the vision already carries the scope. (The
upstream step that *declares* the milestones and their order — and feeds the
chosen slice to the vision — is analysed in
`skills/skillfactory/milestone_review.md` §3.5; do not restate it, just hand off
cleanly to it.)

## Inputs

### Vision document (required)

`docs/vision.md` — the source the requirements catalog is derived from. Read its
**non-goals / out-of-scope** section too: those negative decisions are carried
into the Out-of-Scope table below (Aln15). If `docs/vision.md` is absent, STOP
and ask for the source — it is the required input.

### Glossary (resolved by a fallback chain — never a hard-coded filename)

1. an explicit glossary path passed as an argument → 2. `docs/CONTEXT.md` →
3. `docs/glossary.md` → 4. **none found** → WARN ("No glossary found; proceeding
without one — domain terms cannot be verified verbatim and actors will fall back
to generic roles") and degrade to **generic behaviour** (generic roles, terms
taken from the vision), noting that requirements should be re-run once a glossary
exists.

Always try the resolution order; never hard-code a single filename.

**Identifying actors in the glossary.** An actor/role term is a glossary entry
whose definition describes *who* initiates or performs actions — a human role, an
organizational role, or an external system — rather than a thing acted upon (an
entity), a measurement (a value), or a status. Signals: the definition says
"actor", "role", "user", "owner", "the one who…", or names a person/system that
initiates, approves, or operates the system. Use the actors the glossary names,
verbatim. **If the glossary defines a single actor, do not invent extra roles**
to populate a "User/Admin/System" set.

### Foundation / build-order / capability plan (optional — resolved by a fallback chain)

The project's **foundation plan** — whatever artifact carries the project's
stable upstream IDs (capabilities, primitives, pains, or equivalent
identifiers). It is the source for the per-requirement upstream trace below.
Resolve it exactly as the glossary is resolved — try the order, never hard-code a
single filename:

1. an explicit foundation-plan path passed as an argument → 2. a conventional
plan path (e.g. `docs/foundation.md`, `plan/foundation.md`, or the project's
build-order doc) → 3. **none found** → NOTE ("No foundation plan found; emitting
the catalog without upstream-ID traces") and **skip** the per-requirement
upstream trace. Never invent upstream IDs that the project does not define — the
trace degrades to a no-op when no plan exists.

### Negative-decision sources (for the Out-of-Scope section)

Primary source is the vision's non-goals/out-of-scope section (above). Also read,
**if present**: an alignment transcript (`algn_transcript.md`) for in-session
rejections, and an idea file (`idea.md`) for negative goals. Their absence is not
an error — the vision's out-of-scope is enough.

## Consume the glossary

When a glossary is present, apply these four rules everywhere — titles, user
stories, constraints, and the out-of-scope list:

1. **Actors come from the glossary**, used verbatim (see "Identifying actors"
   above). Do NOT default to "User/Admin/System" when the glossary names real
   actors.
2. **Domain nouns are verbatim** — no casual variation, abbreviation,
   translation, pluralization, or re-casing (gr_domain_language **L1**).
3. **Prefer a glossary term over a new synonym** — if the glossary already names
   a concept, use that name; do not coin an alternative for the same concept.
4. **New term needed? Flag, don't coin.** If a requirement genuinely needs a
   concept the glossary does not name, do NOT silently invent it. Record it in
   the **Flagged Terms** section for the `ubiquitous-language-guard` write-back
   loop (gr_domain_language **L6**) — that is where new terms are introduced
   explicitly, not here.

This skill consumes the glossary only. Everything in the DO NOT list below is the
boundary it must not cross.

## DO NOT

- Mix requirement types in a single table, or reuse an ID across types
- Skip the user-story format for functional requirements, or leave a Status empty
- Violate any of the four "Consume the glossary" rules above — in particular,
  default to generic actors when the glossary names real ones, or coin a domain
  noun the glossary does not have (flag it instead)
- Enforce, evolve, or write back to the glossary, flag forbidden synonyms, or
  halt on near-matches — those belong to `ubiquitous-language-guard`
- Drop a negative decision from the vision/alignment instead of recording it in
  the Out-of-Scope section
- Invent upstream IDs (capabilities, primitives, pains) the foundation plan does
  not define — when no plan is resolved, the upstream trace is a no-op, not a
  guess
- Bind the catalog to a module or milestone identifier (title, examples, or
  tables), or apply the milestone deferral cut — the vision already set the scope
  and `pareto-scope-cut` owns the Open/Deferred split

## Document header

The catalog opens with a **`Source:` trace line** naming the upstream artifacts
it derives from — the vision, plus the foundation plan when one was resolved (and
the resolved glossary path). This makes traceability visible at the top, so a
reader can see what the requirements descend from without reverse-engineering it.
Example: `Source: docs/vision.md; docs/foundation.md; glossary docs/CONTEXT.md`.
If the foundation plan was not found, name only the artifacts that were.

## Requirement Types

### Functional Requirements (FR)

What the system does, always in user-story form. Draw `[role]` from the
glossary's actor terms (verbatim).

**Format:** As a [role], I want [goal] so that [benefit].

Where a foundation plan defines stable upstream IDs, append the upstream element
each requirement realises in the Title (e.g. `Borrow a Title (F01)`); where no
such IDs exist, leave the Title plain — the trace is a no-op (see the foundation
plan input above).

| ID     | Title                  | User Story                                                                                                  | Priority | Status |
|--------|------------------------|------------------------------------------------------------------------------------------------------------|----------|--------|
| FR-001 | Borrow a Title (F01)   | As a Member, I want to borrow an available Title so that I can take it home for the loan period.            | High     | Open   |
| FR-002 | Renew a Loan (F02)     | As a Member, I want to renew an active Loan before it is due so that I can keep the Title longer.           | High     | Open   |
| FR-003 | Return a Title (F03)   | As a Member, I want to return a borrowed Title so that the Loan is closed and the Title becomes available.  | High     | Open   |

*The role is the glossary actor "Member" used verbatim — taken from the glossary,
not defaulted to a generic "User"/"Admin"/"System" placeholder, and not softened
to a near-miss synonym. Domain nouns (Title, Loan) are glossary terms used
exactly. Each Title cites the upstream element it realises (here `F01`–`F03`) —
this only appears because a foundation plan defined those IDs; with no plan, the
Title would read "Borrow a Title" with no trace.*

### Non-Functional Requirements (NFR)

Quality attributes. Must be measurable (a number or threshold).

| ID      | Title            | Requirement                                                   | Category     | Priority | Status |
|---------|------------------|---------------------------------------------------------------|--------------|----------|--------|
| NFR-001 | Response Time    | All page loads must complete within 2 seconds.                | Performance  | High     | Open   |
| NFR-002 | Availability     | System must maintain 99.9% uptime during business hours.      | Availability | High     | Open   |
| NFR-003 | Concurrent Users | System must support 100 concurrent users without degradation. | Scalability  | Medium   | Open   |

### Constraints (C)

Limitations imposed on the *solution* (technology, business, schedule). A
constraint is a boundary on **how** the work is built — distinct from an
Out-of-Scope item, which is a decision **not to build** something at all.

| ID    | Title             | Constraint                                                       | Category  | Priority | Status |
|-------|-------------------|------------------------------------------------------------------|-----------|----------|--------|
| C-001 | Runtime Platform  | Backend must run on Java 21 LTS.                                 | Technical | High     | Open   |
| C-002 | Database Platform | System must use PostgreSQL 16.                                   | Technical | High     | Open   |
| C-003 | Budget Limit      | Total development cost must not exceed $50,000.                  | Business  | High     | Open   |

### Out-of-Scope / Non-Goals (OOS)

The decisions *not* to do something, carried forward from the vision's non-goals
and any alignment rejections (gr_algn **Aln15**, gr_idea **Idea3**). This is how
scope is defended later — without it, a "we explicitly will not do X" decision is
silently lost. **Not** the same as a Constraint (a limitation on how you build)
or a Deferred FR status (a thing in scope but not yet built): an OOS item is out
of this scope marker entirely.

| ID      | Title              | Decision (what is NOT being done + why / where it goes)                                   | Source           |
|---------|--------------------|-------------------------------------------------------------------------------------------|------------------|
| OOS-001 | Fines & Payments   | The system will never charge, collect, or track monetary fines on an overdue Loan.        | vision non-goal  |
| OOS-002 | Title Reservations | Letting a Member reserve a Title that is currently on Loan is excluded from this scope.    | vision non-goal  |
| OOS-003 | Inter-Library Loan | Borrowing a Title from another library's catalog is out of scope; same-catalog Loans only. | alignment reject |

## Open Questions

A place for a **named but unresolved decision** surfaced while writing the
catalog — distinct from a Deferred FR (in scope, just not built yet) and from an
OOS item (a settled decision *not* to do something). An Open Question is not yet
settled either way; recording it keeps it visible instead of silently dropped.
Omit the section if there are none.

| ID    | Question                                                        | Blocks (FR/NFR/C/OOS id) |
|-------|-----------------------------------------------------------------|--------------------------|
| OQ-001 | Should a Member be allowed more than one active Loan at a time? | FR-001                   |

## Flagged Terms (for `ubiquitous-language-guard`)

When a requirement needs a concept the glossary does not name, record it here
instead of coining it inline (gr_domain_language **L6**). This is a hand-off list,
not a glossary edit — `ubiquitous-language-guard` runs the write-back.

| Proposed Term | Why a requirement needs it | Where used (FR/NFR/C/OOS id) |
|---------------|----------------------------|------------------------------|
| *(none)*      |                            |                              |

## Reference

See [REFERENCE.md](REFERENCE.md) for ID prefixes, priority levels, status values,
NFR categories, constraint categories, and out-of-scope sources.

## Requirement Quality Checks

Every requirement must pass these before finalizing:

| Check       | Rule                                            | Bad Example                                   | Good Example                  |
|-------------|-------------------------------------------------|-----------------------------------------------|-------------------------------|
| Measurable  | NFRs must have a number or threshold            | "System should be fast"                       | "Pages load within 2 seconds" |
| Singular    | One requirement per row                         | "System must log in and export data"          | Split into FR-001 and FR-002  |
| Unambiguous | No subjective terms                             | "User-friendly interface"                     | "WCAG 2.1 AA compliant"       |
| Testable    | Can write a pass/fail test                      | "System is reliable"                          | "99.9% uptime over 30 days"   |
| Unique IDs  | No duplicate IDs across all tables              | Two FR-001 entries                            | Each ID used exactly once     |
| Verbatim    | Domain nouns/actors match the glossary exactly  | Coining "Purchase" when glossary says "Order" | Use the glossary term "Order" |

## Error Recovery

- **Incomplete vision document**: List what is missing (roles, NFR categories,
  constraints, non-goals) and ask the user to clarify before proceeding.
- **Ambiguous requirement from user**: Rewrite it as a measurable requirement and
  ask the user to confirm the threshold.
- **Conflicting requirements**: Flag the conflict explicitly (e.g., "FR-003
  requires real-time sync but C-002 limits to batch processing") and ask the user
  to resolve.
- **Missing actors / glossary / new term needed**: All three are handled by the
  rules in [Inputs](#inputs) and [Consume the glossary](#consume-the-glossary)
  — take actors from glossary actor terms (else generic, noted for review), warn
  and degrade when no glossary exists, and record a genuinely-new term in the
  Flagged Terms section rather than coining it.

## Workflow

1. Read `docs/vision.md` (including its non-goals/out-of-scope section), resolve
   the glossary (argument → `docs/CONTEXT.md` → `docs/glossary.md` → warn), and
   resolve the foundation plan (argument → conventional plan path → none → note
   and skip the upstream trace). Note the glossary's actor terms and domain nouns,
   and the foundation plan's stable upstream IDs if one was found. If present,
   also read `algn_transcript.md` / `idea.md` for negative decisions.
2. Use TodoWrite to create tasks for each requirement type.
3. Write the document header: a `Source:` trace line naming the upstream
   artifacts the catalog derives from (vision + foundation plan when resolved),
   and note the resolved glossary path. Do not bind the title to a
   module/milestone identifier — the catalog is vision-scoped.
4. Functional requirements — identify roles from glossary actor terms (verbatim),
   write user stories with glossary nouns verbatim, assign priorities. Where the
   foundation plan defines stable IDs, cite the upstream element each requirement
   realises (in its Title or a trace column); where it does not, skip the
   trace — never invent IDs.
5. Non-functional requirements — measurable quality attributes, categorized,
   testable.
6. Constraints — technical/business/schedule limitations, categorized.
7. Out-of-Scope / Non-Goals — one OOS row per negative decision carried from the
   vision non-goals (and any alignment rejection), each citing its source.
8. Open Questions — record any named-but-unresolved decision surfaced while
   writing (distinct from a Deferred FR or an OOS item); omit the section if none.
9. Flagged Terms — list any concept a requirement needed that the glossary does
   not name; do not coin it inline.
10. Validate against the [Quality Checks](#requirement-quality-checks): unique IDs
   across all tables, all Status filled, user-story format on every FR, a
   measurable threshold on every NFR, and all domain nouns/actors verbatim.
11. POST self-check (glossary consumption + scope + trace):
    - Every FR actor traces to a glossary actor term (or is a flagged generic
      fallback when no glossary exists).
    - No storage-shaped (`…Table`, `…Row`, `…DTO`) or silently-invented domain
      noun appears in any title or user story; any genuinely-new term is in the
      Flagged Terms section, not coined inline (gr_domain_language **L6**).
    - Every vision non-goal / alignment rejection appears as an OOS row (Aln15).
    - The document opens with a `Source:` trace line; where a foundation plan was
      resolved, every requirement cites its upstream element, and no upstream ID
      was invented when no plan exists.
    - The catalog is bound to no module/milestone identifier and applies no
      deferral cut (it is vision-scoped).
12. Mark todos complete.
