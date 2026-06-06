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

## Requirement Types

### Functional Requirements (FR)

What the system does, always in user-story form. Draw `[role]` from the
glossary's actor terms (verbatim).

**Format:** As a [role], I want [goal] so that [benefit].

| ID     | Title                | User Story                                                                                                            | Priority | Status |
|--------|----------------------|----------------------------------------------------------------------------------------------------------------------|----------|--------|
| FR-001 | Present Proposal     | As a User, I want every Proposal collected into one editable Action Plan so that I can review filings without opening each Mail. | High     | Open   |
| FR-002 | Approve Proposal     | As a User, I want to approve, edit, or reject each Proposal in the Action Plan so that only what I confirm is filed.  | High     | Open   |
| FR-003 | Route to Staging     | As a User, I want below-Confidence Proposals routed to the Staging Area so that nothing is filed into the wrong Target Location. | High     | Open   |

*The roles are the glossary actor "User" verbatim — not generic "project
manager"/"team member" placeholders, and not the doc's own near-miss
"mailbox owner". Domain nouns (Proposal, Action Plan, Staging Area, Confidence,
Target Location) are glossary terms used exactly.*

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

| ID      | Title                 | Decision (what is NOT being done + why / where it goes)                              | Source         |
|---------|-----------------------|-------------------------------------------------------------------------------------|----------------|
| OOS-001 | Mail Write-Back       | The system will never send, reply to, or modify Mail — zero write-back (CON-1).      | vision non-goal |
| OOS-002 | AI-Suggested Renaming | Inferring a Target Location's Naming Scheme to suggest a Target Filename → M2b (F32). | vision non-goal |
| OOS-003 | Shared Mailboxes      | acontis / shared / PST mailboxes are excluded; v1 is private-mailbox only.           | vision non-goal |

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

1. Read `docs/vision.md` (including its non-goals/out-of-scope section) and
   resolve the glossary (argument → `docs/CONTEXT.md` → `docs/glossary.md` →
   warn). Note the glossary's actor terms and domain nouns. If present, also read
   `algn_transcript.md` / `idea.md` for negative decisions.
2. Use TodoWrite to create tasks for each requirement type.
3. Write the document header, noting the resolved glossary path.
4. Functional requirements — identify roles from glossary actor terms (verbatim),
   write user stories with glossary nouns verbatim, assign priorities.
5. Non-functional requirements — measurable quality attributes, categorized,
   testable.
6. Constraints — technical/business/schedule limitations, categorized.
7. Out-of-Scope / Non-Goals — one OOS row per negative decision carried from the
   vision non-goals (and any alignment rejection), each citing its source.
8. Flagged Terms — list any concept a requirement needed that the glossary does
   not name; do not coin it inline.
9. Validate against the [Quality Checks](#requirement-quality-checks): unique IDs
   across all tables, all Status filled, user-story format on every FR, a
   measurable threshold on every NFR, and all domain nouns/actors verbatim.
10. POST self-check (glossary consumption + scope):
    - Every FR actor traces to a glossary actor term (or is a flagged generic
      fallback when no glossary exists).
    - No storage-shaped (`…Table`, `…Row`, `…DTO`) or silently-invented domain
      noun appears in any title or user story; any genuinely-new term is in the
      Flagged Terms section, not coined inline (gr_domain_language **L6**).
    - Every vision non-goal / alignment rejection appears as an OOS row (Aln15).
11. Mark todos complete.
