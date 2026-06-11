# `domain-requirements` genericity review — does the skill leak ai-mail, and how should it ingest scope?

**Date:** 2026-06-09

**Question (from `todo.md`).** The workflow and skillset need adjusting. `domain-requirements` is a
candidate: (1) the skill is meant to be **generic for any project** but reads as if it is specifically
about ai-mail; (2) there is **no "next milestone" handling** in the workflow; (3) how should the skill
**ingest** the information that today is *baked into the skill itself*, so the output is as rich as — or
richer than — the current `docs/requirements.md`; and (4) the artifacts in `docs/` seem to **mix up
modules with possible milestones**.

**Method.** Read [`skills/domain-requirements/SKILL.md`](../domain-requirements/SKILL.md) +
[`REFERENCE.md`](../domain-requirements/REFERENCE.md), the produced
[`docs/requirements.md`](../../docs/requirements.md), the skill's entry in
[`skills_overview.md`](../skills_overview.md), the sequence in [`workflow.md`](../workflow.md), the
artifact contract in [`artifacts.md`](../artifacts.md), the genericity rule in
[`skills/CLAUDE.md`](../CLAUDE.md), and the existing
[`skillfactory/milestone_review.md`](milestone_review.md) (which already resolved the milestone-vs-module
question at the *workflow* level). The orchestration block at the end follows
[`skillfactory/to-prd-review.md`](to-prd-review.md) § "Part A — adjust the existing skillset" verbatim.

---

## TL;DR

1. **The skill genuinely leaks ai-mail** — but only in two places: the **FR example table** and the
   **Out-of-Scope example table** (plus their italic captions) are written entirely in ai-mail's
   ubiquitous language (`Proposal`, `Action Plan`, `Staging Area`, `Target Location`, `Mailbox`,
   `acontis`, `PST`, `M2b`, `F32`, `CON-1`). This is a direct violation of
   [`skills/CLAUDE.md`](../CLAUDE.md)'s hard rule ("No domain terms or identifiers — not `P##`/`A##`
   pains, `F##` primitives, `M#` capabilities"). The NFR and Constraint example tables are **already
   neutral** (`Response Time 2 s`, `Java 21`, `PostgreSQL 16`) — only FR + OOS need de-leaking.
2. **The skill has zero scope-marker / milestone awareness**, unlike the rest of the chain
   (`pareto-scope-cut`, `usecase-diag`, `usecase-spec`, `spec-to-prd`, `testing-strategy`,
   `tracker-trace-check` all resolve a scope marker). That is **correct for its phase** — it runs in
   Phase 2, before scope is cut — but the skill never *says so*, so the boundary is invisible and the
   produced `requirements.md` looks like the skill "should have" scoped it.
3. **The richness of `docs/requirements.md` is not produced by the skill** — it was added by hand /
   downstream. The skill template emits four bare tables; the real file additionally has a
   **milestone-scoped title**, a **`Source:` / upstream-ID trace header**, a **per-row trace to an
   upstream primitive** (`FR-001 … (F01)`), an **`## Open Questions`** section, a **`## Scope split`**,
   and a **`## Postponed decisions`** log. The skill should ingest the *generic* equivalent of the
   inputs that produced this, not carry ai-mail's instances inside its own body.
4. **`docs/requirements.md` does conflate module and milestone** — its title is `Requirements — M2 ·
   Attachment Auto-Router` and its scope-split heading reads `(against M2 · Attachment Auto-Router)`,
   labelling the scope with a **module ID** (`M2`). [`milestone_review.md`](milestone_review.md) already
   established that `M#` are **modules, not milestones**, and that milestone ≡ module *only by today's
   build strategy*. The skill-side fix is to never bind the catalog to a module ID; the workflow-side
   fix (declare milestones explicitly) is **owned by `milestone_review.md`** and not re-litigated here.

**One-line conclusion.** De-leak the two example tables, make the skill's **phase boundary explicit**
(it emits a **vision-scoped** catalog — the slice the vision already chose; it neither applies the
milestone deferral cut nor reaches beyond the vision), and give it a **generic upstream-traceability
ingestion contract** so any project gets the richness ai-mail got — without any ai-mail term living in
the skill.

---

## Finding 1 — the FR and OOS examples leak ai-mail's ubiquitous language *(High — rule violation)*

[`skills/CLAUDE.md`](../CLAUDE.md) is unambiguous: a skill must contain **no project names, no project
paths, no domain terms or identifiers**, and a self-check must scan every edit for them. The
`domain-requirements` body fails that self-check today:

| Location in `SKILL.md` | Leaked ai-mail content |
| --- | --- |
| FR example table (lines ~116-118) | `Present Proposal`, `Approve Proposal`, `Route to Staging`; nouns `Proposal`, `Action Plan`, `Staging Area`, `Confidence`, `Target Location`, `Mail` |
| FR caption (lines ~120-123) | names the glossary actor `User` **and the doc's actual near-miss `"mailbox owner"`**, plus the five ai-mail nouns again |
| OOS example table (lines ~158-160) | `Mail Write-Back … modify Mail … (CON-1)`; `AI-Suggested Renaming … Naming Scheme … Target Filename → M2b (F32)`; `Shared Mailboxes — acontis / shared / PST … v1 private-mailbox only` |

`M2b`, `F32`, and `CON-1` are exactly the `M#` / `F##` / `CON-#` identifiers the rule names as forbidden.
The captions are worse than the tables: they reference ai-mail's *own* `requirements.md` wording
(`"the doc's own near-miss 'mailbox owner'"`), which only makes sense if you know the ai-mail file.

**Why the examples still teach the rule once de-leaked.** Every example exists to illustrate a *generic*
rule (actors verbatim from the glossary; nouns verbatim; one requirement per row; OOS carries a negative
decision + its source). A single neutral illustrative domain — e.g. a library catalog (`Member`,
`Loan`, `Title`) or an order system (`Customer`, `Order`, `Line Item`) — teaches all of it without a
single ai-mail token. The NFR/Constraint tables already prove this works.

**Fix:** Finding 1 → **unit G1, change-part (a)**.

---

## Finding 2 — the skill is silent about its phase boundary (no milestone/scope stance) *(Medium)*

Every neighbouring skill resolves a scope marker; `domain-requirements` does not — and **should not**,
because its input, the vision, is **already milestone-scoped** (§3.5 of
[`milestone_review.md`](milestone_review.md): the vision is bound to one capability at Phase 1). So the
catalog simply **inherits the vision's scope** — the skill has no marker to resolve. The problem is not
that it lacks scoping; it is that the skill **never states this boundary**, so:

- a reader expects it to scope (it does not), and
- the produced `requirements.md` ends up carrying scope artifacts *anyway* (a milestone title +
  `## Scope split`), making it look as though the skill emitted those — when in fact the milestone label
  came from the vision and the `## Scope split` from `pareto-scope-cut` + hand-edits.

The skill should say, in one place, that it emits a **vision-scoped catalog** — the slice the vision
already chose — and that it neither (a) applies the **milestone deferral cut** (`Open`/`Deferred`, the
level-2 split — that is `pareto-scope-cut`'s `## Scope split`) nor (b) reaches **beyond the vision** into
other capabilities. That makes the phase boundary explicit without adding a scope marker the skill has no
business resolving.

> **Cross-reference, do not duplicate.** The *workflow-level* milestone gap — "there is no step that
> *declares* the milestones and their order" — is analysed in [`milestone_review.md`](milestone_review.md)
> §3.5, whose recommendation is a **Phase-1 `declare-milestone` skill** that runs *before* the vision and
> feeds it the scope (because the vision is already milestone-bound). This review does **not** restate or
> re-decide that; it only makes `domain-requirements` hand off cleanly to it.

**Fix:** Finding 2 → **unit G1, change-part (b)** (skill text) + **unit G2** (overview sync).

---

## Finding 3 — the richness came from inputs, not from the skill; make ingestion generic *(Medium)*

The real [`docs/requirements.md`](../../docs/requirements.md) is markedly richer than the skill's
four-table template. What it has that the skill never instructs:

| Element in `requirements.md` | Produced by | In the skill today? |
| --- | --- | --- |
| Milestone-scoped **title** (`Requirements — M2 · …`) | hand / downstream | No |
| **`Source:` trace header** naming upstream artifacts + stable upstream IDs (`F##`, `M#`, `P##`, `A##`, `CON-#`) | hand | No |
| **Per-row trace to an upstream primitive** in the FR Title (`FR-001 … (F01)`) | hand | No |
| **`## Open Questions`** section | hand | No |
| `## Scope split` | `pareto-scope-cut` | No (correctly — sibling skill) |
| `## Postponed decisions` | `pareto-scope-cut` | No (correctly — sibling skill) |

The first three are the ones `domain-requirements` *should* own, and the reason it does not is exactly
why it reads as ai-mail-specific: the upstream IDs that make the trace possible (`F01`, `M2`, `P01`) are
ai-mail's, so rather than describe a **generic ingestion contract**, the author illustrated it with
ai-mail's instances and stopped.

**The generic contract to add.** Give the skill an optional input — the project's **foundation /
build-order / capability plan** (whatever artifact carries the project's stable upstream IDs:
capabilities, primitives, pains) — resolved by a fallback chain (arg → a conventional plan path →
none/skip-and-note), exactly as the glossary is already resolved. Then add two rules, stated generically:

1. **Header trace line** — the doc opens with a `Source:` line naming the upstream artifacts it derives
   from (the vision + the foundation plan), so traceability is visible at the top.
2. **Per-requirement upstream trace** — where the project's upstream artifact defines stable element IDs,
   each requirement cites the upstream element it realises (in its Title or a trace column). Where no
   such IDs exist (a project without a foundation plan), the rule is a no-op — the skill degrades, it
   does not invent IDs.

This is the mechanism that produced ai-mail's richness, expressed so any project gets it — and it
removes the temptation to bake ai-mail IDs into the body, because the IDs now arrive as *input*.

> Optionally add an **`## Open Questions`** section to the template (a place for an unresolved-but-named
> decision, distinct from a deferred FR or an OOS item). Low cost, generic, and matches the real file.

**Fix:** Finding 3 → **unit G1, change-part (c)** (skill text) + **unit G2** (overview sync).

---

## Finding 4 — `docs/requirements.md` labels its scope with a module ID *(Low — already owned upstream)*

`requirements.md`'s title (`Requirements — M2 · Attachment Auto-Router`) and scope-split heading
(`## Scope split (against M2 · Attachment Auto-Router)`) name **`M2`**, which is a **module**, as the
scope boundary. [`milestone_review.md`](milestone_review.md) §2 already resolved that module (`M#`) and
milestone are distinct concepts that merely coincide in v1, and recommends defining **Milestone** in the
glossary and declaring milestones explicitly (its §7 action list).

**Skill-side consequence (the only part in scope here):** `domain-requirements` must never bind the
catalog to a module/milestone identifier in its own template or examples. Combined with Finding 2 (the
catalog is vision-scoped; the deferral cut is downstream), this is covered by unit G1's change-parts (a) and
(b) — the de-leaked examples carry no module IDs, and the explicit phase boundary keeps scope labelling
out of the skill. The **document-side** relabelling of `requirements.md` (module → milestone) is part of
`milestone_review.md`'s action list, **not** a `domain-requirements` change, and is not duplicated as a
unit here.

---

## What is already correct (recorded so it is not re-investigated)

- The **glossary fallback chain** (arg → `docs/CONTEXT.md` → `docs/glossary.md` → warn+degrade) is
  already generic and exemplary — the new foundation-plan input should mirror its shape exactly.
- The **NFR and Constraint example tables** are already project-neutral; leave them.
- The **`gr_domain_language` L1/L6/L8 consume-only stance**, the **Flagged Terms** hand-off, and the
  **Aln13/Aln15** framing are all generic and load-bearing; do not touch them.
- The skill correctly **does not** cut scope, model entities, or gate ADRs (sibling skills own those).

---

## Adjustment plan — autonomous orchestration (apply G1–G2)

> In a fresh session, tell the agent: *"apply the G1–G2 fixes in
> `skills/skillfactory/skill_genericity_review.md` using sub-agents."* This block is the complete,
> self-contained spec for that run. **Every design choice is already resolved** (de-leak to one neutral
> domain; make the phase boundary explicit; add the generic foundation-plan input + trace rules; cross-
> reference `milestone_review.md` rather than re-deciding the workflow step) so the run — driver **and**
> sub-agents — needs **no user interaction**.

### Orchestration rule (same as `to-prd-review.md` Part A / `create_skills.md`)

These adjustments are carried out **autonomously, by the `create_skills.md` orchestration rule**: a
single **driver session** spawns **one cold sub-agent per unit**, runs them **strictly sequentially in
number order (G1 → G2), never in parallel** — and flips each `- [ ]` to `- [x]` **only after** that
sub-agent reports its POST self-check passed. On a blocker the driver leaves the box `- [ ]`, appends
`> blocked: <reason>` after the heading, continues with the rest, and surfaces all blockers at the end.

G2 reads the SKILL.md that G1 finalises, so the strict-sequential-in-order rule is **load-bearing** here
(not merely write-conflict avoidance): G1 must complete before G2 syncs the overview to it.

Each unit is **self-contained** so its sub-agent runs cold: the driver hands it the matching `G#` block
below, **plus** the matching finding prose (Finding 1/2/3 above, including the "already correct" list),
**plus** [`skills/CLAUDE.md`](../CLAUDE.md) (the genericity rule + self-check) and the named target files
— nothing else.

**No user interaction — anywhere in the run.** These units edit **SKILL.md / overview *text* only — they
do not *run* any skill**, so no run-time HITL gate is ever triggered. Every choice is pre-resolved above;
if a sub-agent nonetheless hits a genuinely unspecified decision, it must **stop and record a `> blocked:`
note** — never ask the user, never guess.

> **Scope — G1–G2 only.** The **Phase-1 `declare-milestone` step** and the **relabelling of
> `docs/requirements.md`** (module `M2` → milestone) are owned by
> [`milestone_review.md`](milestone_review.md) (its §3.5 + the D1–D5 build) and are **not** units in this
> run. Do **not** action them here.

### The adjustment units

**- [x] G1 · `skills/domain-requirements/SKILL.md` — de-leak examples, state the phase boundary, add generic upstream-trace ingestion**
- **File:** [`skills/domain-requirements/SKILL.md`](../domain-requirements/SKILL.md) (and, only if a
  prefix/category table needs it, [`REFERENCE.md`](../domain-requirements/REFERENCE.md) — otherwise leave
  REFERENCE untouched).
- **Change:**
  1. **(a) De-leak the examples (Finding 1).** Replace the FR example table, its italic caption, and the
     OOS example table with equivalents written in **one consistent, project-neutral illustrative domain**
     (e.g. a library catalog: `Member`, `Loan`, `Title` — pick one and use it for every example). Remove
     every ai-mail token: `Proposal`, `Action Plan`, `Staging Area`, `Target Location`, `Target
     Filename`, `Naming Scheme`, `Confidence`, `Mail`/`Mailbox`/`mailbox owner`, `acontis`, `PST`,
     `M2b`, `F32`, `CON-1`. Rewrite the captions to illustrate the **rule** (actors come verbatim from
     the glossary; do not default to generic `User/Admin/System`; nouns verbatim; OOS carries a negative
     decision + its source) **without naming any real project's near-miss or file**.
  2. **(b) State the phase boundary (Finding 2).** Add a short paragraph (near the top, alongside the
     "summary of upstream alignment" framing) stating that this skill emits a **vision-scoped catalog**
     (the slice the vision already chose), and that it neither applies the **milestone deferral cut**
     (`Open`/`Deferred` — `pareto-scope-cut`'s `## Scope split`) nor reaches **beyond the vision** into
     other capabilities — so the skill **never binds the catalog to a module/milestone identifier** in
     its title, examples, or tables. Cross-reference `milestone_review.md` §3.5 for the upstream
     `declare-milestone` step; do not restate it.
  3. **(c) Add the generic upstream-trace ingestion contract (Finding 3).** Add an **optional input** —
     the project's **foundation / build-order / capability plan** (the artifact carrying the project's
     stable upstream IDs) — resolved by a **fallback chain mirroring the glossary's** (arg → a
     conventional plan path → none → note and skip, never invent IDs). Add two generic rules to the
     Workflow + DO-section: a **`Source:` header trace line** naming the upstream artifacts the catalog
     derives from, and a **per-requirement upstream trace** (each requirement cites the upstream element
     it realises, in its Title or a trace column) **where the project defines such IDs** (no-op
     otherwise). Optionally add an **`## Open Questions`** section to the template (generic: a named
     unresolved decision, distinct from a deferred FR or an OOS item).
- **POST:**
  - A grep of `SKILL.md` for `Proposal|Action Plan|Staging Area|Target Location|Target Filename|Naming
    Scheme|Mail|Mailbox|mailbox owner|acontis|PST|M2b|F32|CON-1` returns **0 hits**; every example uses
    one consistent neutral domain; the genericity self-check in [`skills/CLAUDE.md`](../CLAUDE.md) passes.
  - The skill explicitly states it emits a **vision-scoped** catalog, neither applies the deferral cut
    (`pareto-scope-cut`) nor reaches beyond the vision, and binds the catalog to **no** module/milestone ID.
  - The skill names the **generic foundation-plan input + its fallback chain**, the **`Source:` header
    trace-line** rule, and the **per-requirement upstream-trace** rule (with the "no IDs → no-op, never
    invent" degrade); the four glossary-consumption rules, Flagged Terms, Aln13/Aln15 framing, and the
    NFR/Constraint examples are unchanged.

**- [x] G2 · `skills/skills_overview.md` — sync the `domain-requirements` entry to the new SKILL.md**
- **File:** [`skills/skills_overview.md`](../skills_overview.md) (the `## domain-requirements —
  authoring` entry only).
- **Change:** update the entry so its **Input artifacts** list adds the **foundation/build-order plan**
  (with its fallback chain), its **Purpose / Output** text states the catalog is **vision-scoped**
  (deferral cut deferred to `pareto-scope-cut`; nothing beyond the vision) and now carries the
  **`Source:` header + per-requirement upstream trace**, and the entry contains **no ai-mail tokens**.
  Keep the existing gr-relation (L1/L6/L8), the consume-only note, and the Aln13/Aln15 framing — only
  add/adjust what G1 changed, so the overview's claimed coverage stays truthful (a `review-skills` pass
  compares the two).
- **POST:** the `domain-requirements` overview entry names the foundation-plan input + fallback chain,
  states the vision-scoped + downstream-deferral stance and the upstream-trace output, contains none
  of the Finding-1 ai-mail tokens, and matches the finalised `SKILL.md` (no claim the SKILL.md no longer
  supports).
