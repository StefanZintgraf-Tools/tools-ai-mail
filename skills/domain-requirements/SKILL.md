---
name: domain-requirements
description: >
  Gathers, organizes, and documents software requirements into structured
  catalogs with functional requirements (user stories), non-functional
  requirements (measurable quality attributes), and constraints — consuming
  the project glossary so terms and actors are used verbatim instead of being
  invented or defaulted to "User/Admin/System". Use when the user asks to
  "write requirements", "create a PRD", "gather requirements", "document
  feature specs", "write user stories", "define NFRs", "list constraints", or
  mentions requirements catalog, requirements analysis, product requirements
  document, glossary-aware requirements, or feature specification.
---

# Domain Requirements

Produces `docs/requirements.md`: a catalog of functional requirements (user
stories), non-functional requirements (measurable quality attributes), and
constraints — written in the project's **ubiquitous language** by consuming the
glossary as input.

The filename stays `docs/requirements.md`: it is the AIUP-chain contract that
downstream skills (use-case-diagram, use-case-spec, domain-model, trace-check)
read.

This is the glossary-aware successor to stock `requirements`. The **only** thing
it changes is the vocabulary input: it reads the glossary (in addition to the
vision document), draws actors/roles from the glossary's actor terms, and uses
domain terms verbatim. It does **not** enforce, evolve, or write back to the
glossary — that stays the `ubiquitous-language-guard` skill (gr_domain_language
L1, consume-only).

## Instructions

Create or update the requirements catalog at `docs/requirements.md` based on
`docs/vision.md` **and** the project glossary (see Glossary Resolution below).
The document contains functional requirements, non-functional requirements, and
constraints organized as Markdown tables.

When a glossary is present, use its terms **verbatim** in requirement titles,
user stories, and constraints; draw FR actors/roles from the glossary's actor
terms; and prefer an existing glossary term over coining a synonym
(gr_domain_language L1).

### Glossary Resolution (argument)

Accept an OPTIONAL glossary path as an argument.

1. If a glossary path is given as an argument, use it.
2. Otherwise resolve in order: `docs/CONTEXT.md`, then `docs/glossary.md`.
3. If none of these exists, WARN the user ("No glossary found; proceeding
   without one — domain terms cannot be verified verbatim and actors will fall
   back to generic roles") and proceed (degrades to stock behaviour).

Never hard-code a single glossary filename. Always try the resolution order.

### Consume the glossary (the one change vs. stock requirements)

When a glossary is present:

- **Actors/roles come from the glossary.** Draw FR roles from the glossary's
  actor / role terms, used verbatim. Do NOT default to the generic
  "User/Admin/System" set when the glossary names real actors.
- **Domain nouns are verbatim.** Use glossary terms exactly in titles, user
  stories, and constraints — no casual variation, abbreviation, translation,
  pluralization, or re-casing (gr_domain_language L1).
- **Prefer a glossary term over a new synonym.** If the glossary already names a
  concept, use that name; do not coin an alternative for the same concept.
- **New term needed?** If a requirement genuinely needs a concept the glossary
  does not name, do NOT silently invent it. FLAG it for the
  `ubiquitous-language-guard` write-back loop (gr_domain_language L6/L8) and note
  it for user review, rather than coining it here.

This skill consumes the glossary only. It does not add it, edit it, flag
forbidden synonyms, halt on near-matches, or write terms back — those belong to
`ubiquitous-language-guard`.

## DO NOT

- Mix requirement types in a single table
- Skip the user story format for functional requirements
- Use duplicate IDs across requirement types
- Leave the Status column empty
- Default to "User/Admin/System" actors when the glossary names real actors
- Invent a domain noun or synonym when the glossary already has a term — use the
  glossary term verbatim; flag a genuinely-new term for `ubiquitous-language-guard`
  rather than coining it silently
- Enforce, evolve, or write back to the glossary — this skill only consumes it

## Requirement Types

### Functional Requirements (FR)

Define what the system should do. Always use the user story format. Draw the
`[role]` from the glossary's actor terms (verbatim) when a glossary is present.

**Format:** As a [role], I want [goal] so that [benefit].

| ID     | Title        | User Story                                                                                | Priority | Status |
|--------|--------------|-------------------------------------------------------------------------------------------|----------|--------|
| FR-001 | Create Task  | As a project manager, I want to create tasks so that I can track work items.              | High     | Open   |
| FR-002 | Assign Task  | As a project manager, I want to assign tasks to team members so that work is distributed. | High     | Open   |
| FR-003 | Filter Tasks | As a team member, I want to filter tasks by status so that I can focus on relevant items. | Medium   | Open   |

### Non-Functional Requirements (NFR)

Define quality attributes. Must be measurable.

| ID      | Title            | Requirement                                                   | Category     | Priority | Status |
|---------|------------------|---------------------------------------------------------------|--------------|----------|--------|
| NFR-001 | Response Time    | All page loads must complete within 2 seconds.                | Performance  | High     | Open   |
| NFR-002 | Availability     | System must maintain 99.9% uptime during business hours.      | Availability | High     | Open   |
| NFR-003 | Concurrent Users | System must support 100 concurrent users without degradation. | Scalability  | Medium   | Open   |
| NFR-004 | Data Encryption  | All data in transit must use TLS 1.3 encryption.              | Security     | High     | Open   |

### Constraints (C)

Define limitations and boundaries imposed on the solution.

| ID    | Title             | Constraint                                                       | Category  | Priority | Status |
|-------|-------------------|------------------------------------------------------------------|-----------|----------|--------|
| C-001 | Runtime Platform  | Backend must run on Java 21 LTS.                                 | Technical | High     | Open   |
| C-002 | Database Platform | System must use PostgreSQL 16.                                   | Technical | High     | Open   |
| C-003 | Browser Support   | UI must support Chrome, Firefox, and Safari (latest 2 versions). | Technical | High     | Open   |
| C-004 | Budget Limit      | Total development cost must not exceed $50,000.                  | Business  | High     | Open   |
| C-005 | Deadline          | System must be production-ready by Q2 2025.                      | Schedule  | High     | Open   |

## Reference

See [REFERENCE.md](REFERENCE.md) for ID prefixes, priority levels, status values, NFR categories, and constraint
categories.

## Requirement Quality Checks

Every requirement must pass these checks before finalizing:

| Check       | Rule                                 | Bad Example                          | Good Example                  |
|-------------|--------------------------------------|--------------------------------------|-------------------------------|
| Measurable  | NFRs must have a number or threshold | "System should be fast"              | "Pages load within 2 seconds" |
| Singular    | One requirement per row              | "System must log in and export data" | Split into FR-001 and FR-002  |
| Unambiguous | No subjective terms                  | "User-friendly interface"            | "WCAG 2.1 AA compliant"       |
| Testable    | Can write a pass/fail test           | "System is reliable"                 | "99.9% uptime over 30 days"   |
| Unique IDs  | No duplicate IDs across all tables   | Two FR-001 entries                   | Each ID used exactly once     |
| Verbatim    | Domain nouns/actors match the glossary exactly | Coining "Purchase" when glossary says "Order" | Use the glossary term "Order" |

## Error Recovery

- **Incomplete source document**: List what is missing (roles, NFR categories, constraints) and ask the user to clarify
  before proceeding
- **Ambiguous requirement from user**: Rewrite it as a measurable requirement and ask the user to confirm the threshold
- **Conflicting requirements**: Flag the conflict explicitly (e.g., "FR-003 requires real-time sync but C-002 limits to
  batch processing") and ask the user to resolve
- **Missing stakeholder roles**: First take roles from the glossary's actor terms. Only if no glossary is present (or it
  names no actors) default to generic roles (User, Admin, System) and note them for user review
- **Missing glossary**: Warn and continue with stock behaviour (generic roles, terms taken from the vision document);
  note that requirements should be re-run once a glossary exists
- **Concept not in the glossary**: Do not coin a term. Flag the needed term for the `ubiquitous-language-guard` write-back
  loop and note it for user review

## Workflow

1. Read the vision document (`docs/vision.md`) and resolve the glossary
   (argument → `docs/CONTEXT.md` → `docs/glossary.md` → warn). Note the actor /
   role terms and domain nouns the glossary defines.
2. Use TodoWrite to create tasks for each requirement type
3. Write the document header
4. For functional requirements:
    - Identify user roles — from the glossary's actor terms (verbatim) when a
      glossary is present, else generic roles noted for review
    - Define user stories with clear goals and benefits, using glossary terms
      verbatim for domain nouns
    - Assign priorities based on business value
5. For non-functional requirements:
    - Define measurable quality attributes
    - Categorize by NFR type
    - Ensure requirements are testable
6. For constraints:
    - Document technical and business limitations
    - Categorize by constraint type
7. Validate: run every requirement against the quality checks table above
    - No duplicate IDs across all tables
    - All Status columns filled
    - All user stories follow "As a [role], I want [goal] so that [benefit]"
    - All NFRs contain a measurable threshold
    - All domain nouns/actors match the glossary verbatim (when present)
8. POST self-check (glossary consumption):
    - Every FR actor/role traces to a glossary actor term (or is a flagged
      generic fallback when no glossary exists)
    - No storage-shaped (e.g. "…Table", "…Row", "…DTO") or silently-invented
      domain noun appears in any FR title or user story
    - Any genuinely-new term needed is flagged for the `ubiquitous-language-guard`
      write-back loop (L8) rather than silently coined
9. Mark todos complete
