---
name: review-skills
description: >
  Produces a critical review of the project's skills in the `skills/` folder and
  writes it to `skills/skills_refactoring.md` — the refactoring worklist that the
  `refactor-skills` skill later consumes. Spawns one fresh sub-agent per skill
  (clean, un-cross-contaminated context) to assess, for each skill, (1) whether
  its guardrail (`gr_*.md`) rule coverage is complete, (2) whether an agent
  running it will achieve the skill's stated purpose, and (3) whether the
  SKILL.md is written effectively — enough clear input, not bloated. Each
  skill's review is headed by a pending `- [ ] refactored` checkbox. Also runs
  the glossary-resolution guard check across all skills. Use when the user says
  "review skills", "review the skills", "critical skill review", "create
  skills_refactoring.md", "audit the skill set", "check skill guardrail
  coverage", or wants the refactoring worklist. Always asks first whether to
  review a single skill or all skills in the `skills/` folder.
---

# Review Skills

Produces `skills/skills_refactoring.md`: a critical, per-skill review of the
project's skills that doubles as a **refactoring worklist**. Each skill is
reviewed against three dimensions — guardrail coverage, purpose achievability,
and writing effectiveness — by a dedicated fresh sub-agent so findings stay
independent and un-cross-contaminated. Each review is headed by a `- [ ]
refactored` checkbox that `refactor-skills` flips once it has acted on it.

This is project skill-maintenance tooling, not a generic AIUP skill, so it may
name repo-specific paths (`skills/`, the guardrail folder, `skills_refactoring.md`).

## Inputs

- **Scope** — single skill or all skills (resolved by the gate below).
- **The skills** under `skills/*/SKILL.md`. A "skill" is any immediate
  subdirectory of `skills/` that contains a `SKILL.md` (plus its `REFERENCE.md`
  if present). EXCLUDE: `skills/archive/`, the loose `*.md` files directly in
  `skills/` (e.g. `skills_overview.md`, `skills_background_info.md`,
  `create_skills.md`, `workflow.md`), and the meta-skills `review-skills` and
  `refactor-skills` themselves (they implement no `gr` cluster).
- **`skills/skills_overview.md`** — read each reviewed skill's entry to find its
  declared `gr` cluster and its **claimed** coverage (the review verifies and,
  where wrong, challenges those claims).
- **Guardrail rule files** — `c:\PROJ\ai-knowhow\coding\gr\gr_*.md`. The source
  of truth for what each skill must cover. Which files apply to a given skill is
  **discovered, never hard-coded**: read the `gr_*`/rule IDs the skill itself
  cites and the cluster named in its `skills_overview.md` entry, then read those
  files in full.

## Scope gate (ALWAYS ask first)

Before doing anything, ask the user: **review a single skill, or all skills in
the `skills/` folder?**

- **Single** — resolve which skill (from the argument, or ask). Review only that
  one. On write-back, REPLACE that skill's section in an existing
  `skills_refactoring.md` (or create the file with just that section); do not
  disturb other skills' sections.
- **All** — review every enumerated skill (per Inputs), regenerating the whole
  `skills_refactoring.md`.

Never guess the scope; the gate is mandatory.

## Per-skill review — one fresh sub-agent each

For each skill in scope, spawn a **fresh sub-agent** (Agent tool,
`subagent_type: general-purpose`, `model: opus`). Reviews are independent, so
when reviewing "all" you MAY fan them out in parallel. Give each sub-agent a
cold-start brief naming exactly ONE skill and instructing it to:

1. Read **only** that skill's `SKILL.md` (+ `REFERENCE.md` if present) and its
   entry in `skills/skills_overview.md`.
2. From the rule IDs the skill cites and the cluster the overview declares,
   identify the relevant `c:\PROJ\ai-knowhow\coding\gr\gr_*.md` files and read
   them in full.
3. Produce a review section in the exact template below, and **return it as the
   final message** (the sub-agent does NOT write any file — the driver assembles
   the worklist).

Each sub-agent must review **exactly one** skill and must not read other skills'
SKILL.md files (that is what keeps findings un-cross-contaminated).

### Review section template (one per skill)

```markdown
## `<skill-name>` — <tag from overview, e.g. lens | fork>
- [ ] refactored

### 1. Guardrail coverage
Per-rule walk-through of the skill's declared `gr` cluster. For EACH rule:
COVERED / PARTIAL / MISSING / OUT-OF-SCOPE, with the SKILL.md line evidence, and
where the skill's (or overview's) coverage claim is wrong, say so explicitly.
End with an explicit MISSING / PARTIAL summary list.
(If the skill cites no `gr` rules, state "N/A — not a guardrail skill".)

### 2. Will the purpose be achieved?
Will an agent following this SKILL.md achieve the skill's stated purpose? List
concrete failure modes (under-specified steps, ambiguous inputs, stalls, silent
degradation) and where it will succeed.

### 3. Writing effectiveness
Is the SKILL.md clear and actionable without being bloated? Flag redundancy
(rules stated N times), under-specified spots that should be ADDED, and content
that should be cut.

### Recommended refactor actions
1. <ordered, concrete, highest-value first — this is the brief refactor-skills uses>
```

## Driver: assemble `skills/skills_refactoring.md`

Collect every sub-agent's returned review and write the file with this structure
(single-skill mode: splice/replace just the one `## <skill>` section):

```markdown
# Skills Review

Critical review of the project skills in this `skills/` folder. This file is the
**refactoring worklist**: each skill is reviewed against (1) guardrail rule
coverage (the `gr_*.md` items in `c:\PROJ\ai-knowhow\coding\gr\`), (2) whether an
agent running it achieves the skill's stated purpose, and (3) whether the
SKILL.md is written effectively. Each entry begins with `- [ ] refactored`; work
the list one skill at a time and flip the box once refactored.

Guardrail file legend (only clusters referenced by the reviews below):
- <gr_file.md> — <rule range / short description>
- ...

## Contents
1. [`<skill>`](#<anchor>)
2. ...

---

<each skill's review section, in Contents order>

---

## Glossary resolution guard
<see "Glossary-resolution guard check" below>
```

## Glossary-resolution guard check (driver, ALWAYS all skills)

This cross-cutting check runs in the driver — NOT in a per-skill sub-agent — and
**always scans every `skills/*/SKILL.md`** (the full set, regardless of review
scope), excluding `skills/archive/` and the meta-skills `review-skills` /
`refactor-skills`. (The meta-skills are excluded because this very SKILL.md
documents the banned phrases below as the patterns to flag — scanning it would be
a false positive. They resolve no glossary, so they are `N/A` anyway.)

The canonical glossary-resolution chain every glossary-reading skill must use:

```
explicit argument → docs/CONTEXT.md → docs/glossary.md → warn/degrade
```

For each skill that resolves a glossary, FLAG it if it deviates — specifically if
it mentions any of:
- `context.md` at the repo/repository root, or "at the root of each bounded context";
- a "context map", "per-bounded-context", or "per-context" `context.md`;
- "several `context.md` files" / "multiple `context.md` files";
- a bare `context.md` used as a resolution location (not prefixed `docs/`);
- any resolution order other than `docs/CONTEXT.md` before `docs/glossary.md`.

A skill that does NOT read a glossary (e.g. `adr-threshold-gate`,
`pareto-scope-cut`) is **correctly exempt** — record it as `N/A (no glossary)`,
not a violation. Emit a table:

```markdown
| Skill | Reads glossary? | Resolution chain found | Verdict |
|-------|-----------------|------------------------|---------|
| <skill> | yes/no | <chain or —> | PASS / FLAG: <reason> / N/A (no glossary) |
```

State a one-line overall verdict: `clean` (all PASS/N/A) or `drift` (one or more
FLAG, listed).

## DO NOT

- Do NOT skip the single-vs-all scope gate.
- Do NOT let a review sub-agent read more than its one assigned skill's SKILL.md,
  or read another skill's body — that defeats the un-cross-contamination.
- Do NOT hard-code which `gr_*.md` files map to which skill — discover the
  mapping from the skill's own citations + its `skills_overview.md` entry.
- Do NOT have the review sub-agents write `skills_refactoring.md` — only the
  driver writes it (so single-skill mode can splice cleanly).
- Do NOT run the glossary guard inside a per-skill sub-agent — it is a driver-level
  cross-cutting check over all skills.
- Do NOT refactor any skill here — this skill only reviews and writes the
  worklist. Refactoring is `refactor-skills`.

## Workflow

1. **Scope gate.** Ask single vs all (mandatory). Resolve the target skill(s).
2. **Enumerate** the in-scope skills per Inputs (exclude archive, loose `*.md`,
   and the two meta-skills).
3. **Fan out review sub-agents** — one fresh `general-purpose` / `opus` agent per
   skill, each with the cold-start brief and the review template; collect the
   returned review sections.
4. **Run the glossary-resolution guard check** in the driver across all skills.
5. **Assemble & write** `skills/skills_refactoring.md` (full regen for "all";
   splice the one section for "single"), appending the glossary-guard section.
6. **Report** to the user: which skills were reviewed, the count of MISSING/PARTIAL
   findings, and the glossary-guard verdict (`clean`/`drift`). Point them at
   `refactor-skills` to act on the worklist.
