---
name: trace-check
description: >
  Verifies cross-artifact consistency and traceability across project artifacts:
  every use case traces to at least one functional requirement, every entity
  named in a spec exists in the entity model, every actor matches the glossary
  verbatim, and every business rule (BR-###) maps to a domain-model invariant.
  Also flags when an upstream artifact (e.g. vision.md) was modified after a
  downstream one it feeds, signalling the downstream may be stale.
  Use when the user asks to "trace check", "check traceability", "verify
  consistency", "find traceability gaps", "check UC to FR coverage", "audit
  cross-artifact consistency", "find orphan use cases", "check that entities
  exist in the entity model", "verify actors against the glossary", "check
  business rules map to invariants", "check upstream freshness", or whenever
  requirements, use case diagram, use-case specs, and entity model may have
  drifted apart. Produces a
  consistency report (pass / list of breaks) and HITL-fixes the offending
  artifact only with explicit human approval. Step-agnostic: usable at
  use-case-diagram, use-case-spec, or any time artifacts drift.
---

# Trace Check

A cross-cutting lens that protects traceability: every downstream artifact must
trace back to something upstream, and every cross-reference must resolve. This
skill reads the project artifact set, runs four consistency checks, produces a
single consistency report (pass or a list of breaks), and — only with explicit
human approval — loops a fix back into the offending artifact. It does NOT
author requirements, model entities, maintain the glossary, gate ADRs, or cut
scope; those are other skills.

These checks are **chain-integrity** findings — they enforce the
discipline that artifacts must not silently drift apart. Most of them map to no
single numbered guardrail rule; only Check C carries a rule ID (`L1`). Do not
overclaim a finding as a code-level rule violation: trace-check reads four
documents, not code, so it can only see *documentation* drift (a rule named in
a spec but absent from the model), never *placement* violations (a rule
enforced in the wrong code layer).

## Inputs

1. **Requirements** (default `docs/requirements.md`) — the functional
   requirement (FR) catalog that use cases must trace to. Accept an override
   path.
2. **Use case diagram** (default `docs/use_cases.puml`) — the PlantUML diagram
   declaring actors and use cases. Accept an override path.
3. **Use-case specs** (default `docs/use_cases/*.md`) — per-use-case
   specification documents containing actors, scenarios, named entities, and
   business rules. Accept an override glob.
4. **Entity model** (default `docs/entity_model.md`) — the domain model with
   entities and their invariants/validation rules. Accept an override path.
5. **Glossary** (optional argument) — path to the project's ubiquitous-language
   file. Resolve in this order, and NEVER hard-code a single filename:
   1. The explicit path the user passed, if any.
   2. `docs/CONTEXT.md`
   3. `docs/glossary.md`
   4. If none exists: **warn** that no glossary was found and run **Check C in
      degraded mode** — actor names are cross-checked for consistency *across*
      the diagram and specs only (intra-artifact), and the report must label
      Check C "intra-artifact consistency only — L1 not run" so a degraded run
      never reads as an L1 pass.
6. **Vision** (default `docs/vision.md`, optional) — the upstream
   vision/goals document. Used **only by Check 0** (upstream freshness); its
   content is not read by Checks A–D. If absent, skip the `vision →
   requirements` freshness pair and continue.

If any non-glossary input is missing, **warn**, skip the checks that need it,
and continue (the skill is step-agnostic and must not crash on a not-yet-created
artifact). A run with any check skipped can never be reported `PASS` — see
**Result states**.

## Discover conventions first

Before running the checks, establish three things from the actual artifacts —
do not assume a fixed format:

- **ID patterns.** Discover the id prefix the requirements catalog actually uses
  (it may be `FR-012`, but it may also be `F22`, `M2`, or another project
  scheme) and the prefix the specs use for business rules (commonly `BR-###`).
  Derive the matching pattern from what is present in the files; do not
  hard-assume `FR-`/`BR-` and silently miss other schemes.

- **Trace convention (gate for Check A).** Determine whether the project carries
  a UC→FR trace convention at all. Scan the specs and diagram for *any* FR
  back-reference: an FR id cited inline, or a `Requirements:` / `Traces to:`
  line, or a UC→FR mapping table in the requirements doc. If **no** use case
  anywhere carries such a reference, the project has no author-time trace
  convention — emit a single finding ("traceability not author-able — no FR-link
  convention found in any spec") and do **not** flag every UC as an orphan. Only
  when a convention is present do you flag the individual UCs that lack a trace.

- **Name normalization (for Checks B and C).** To compare two names
  mechanically rather than by judgment: trim, lowercase, and strip a trailing
  plural (`-s`/`-es`) from both sides. Then:
  - normalized-equal **and** byte-identical → match (silent pass);
  - normalized-equal but **not** byte-identical → **near-match break** (report
    both forms and the canonical one, e.g. `Mailboxes` vs `Mailbox`);
  - not normalized-equal → no match (missing entity / unknown actor).

  Translation drift (e.g. German `Benutzer` for glossary `User`) cannot be
  detected mechanically — flag only a *suspected* translation for human
  confirmation; never assert it as a definite break.

## The checks

Run **Check 0 first**, then Checks A–D in order, accumulating findings into one
consistency report.

### Check 0 — Upstream freshness (pre-check, non-blocking)

A *recency* signal, not a semantic judgment: it never decides whether a change
was "substantial" — that call is the human's. It only detects when an
**upstream** artifact was modified **after** a **downstream** one, which means
the downstream (and every trace built on it) may be stale.

Use the documented artifact chain, upstream → downstream:

> vision → requirements → use-case diagram → use-case specs → entity model

For each adjacent upstream→downstream pair where both files exist, compare
**effective last-modified recency** using git:

1. **Committed recency** — the timestamp of the last commit touching the file
   (`git log -1 --format=%cI -- <path>`).
2. **Uncommitted edits** — if the file has pending working-tree changes
   (`git status --porcelain -- <path>` is non-empty), treat its effective time
   as **now** (more recent than any commit).

If the upstream's effective time is **more recent** than the downstream's, emit
a **stale-downstream warning** naming both files and recommending a
re-grill / re-review of the downstream before its traces are trusted. The
`vision → requirements` link is the highest-value one: vision is otherwise not
read by any check, so this is the only place a vision change surfaces.

This check is **advisory** — it warns and continues, never halts the run and
never counts as a break. But any stale-downstream warning forces the result
state to at least `PARTIAL` (never `PASS`), so a run built on stale upstream can
never read as a clean pass. If the project is not a git repository or git is
unavailable, **skip Check 0**, note it, and continue (→ `PARTIAL`).

### Check A — Every UC traces to ≥1 FR

Only runs if a trace convention was found (see above). Enumerate every use case
as the **union** of the diagram and the spec files (match by normalized name so
a UC is not double-counted). For each UC, confirm it traces to **at least one**
FR in the requirements catalog. A UC that traces to **zero** FRs is an **orphan
use case** — flag it. Also flag: any FR id cited by a UC that does **not** exist
in the catalog (**dangling FR reference**); and any UC present in the diagram
with **no** spec file (**missing spec**).

### Check B — Every entity named in a spec exists in the entity model

Extract every domain entity named in the use-case specs (and, where relevant, in
the requirements). For each, confirm an entity of that name exists in the entity
model, comparing with the normalization rule above. A named entity with **no**
match is a **missing entity** — flag it with the spec location. Report
near-matches (singular/plural, casing) as breaks, not silent passes.

### Check C — Every actor matches the glossary (L1)

Apply `gr_domain_language` rule **L1 — use defined terms exactly**. Collect every
actor named in the use case diagram and the specs. For each, confirm the name
appears **verbatim** in the resolved glossary. Using the normalization rule,
flag any actor that is a near-match (variation, abbreviation, pluralization,
casing) and name the canonical form; flag a suspected translation for human
confirmation. Flag any actor with no glossary entry as an **unknown actor** —
*propose* adding it via the glossary skill; do **not** add it here. If no
glossary was resolved, run the degraded intra-artifact check and label it as
such in the report (L1 not run).

### Check D — Every business rule (BR) maps to a domain-model invariant

Enumerate every business rule (using the discovered BR id pattern) across the
specs. The entity model carries **no** BR-id back-references (by `domain-model`'s
output spec), so "maps to" is a **semantic** match you must perform
deliberately:

1. Identify the entity/aggregate the BR concerns.
2. Look in that entity's attribute table (Validation Rules cells) and its
   `Constraints` note for an invariant whose effect enforces the same rule.
3. Verdict: **mapped** if such an invariant exists; **unenforced business rule**
   if the entity exists but no matching invariant does (flag with the rule text
   and the entity it should constrain); **needs human confirmation** if you
   cannot confidently decide — do *not* guess a pass or a fail.

Also flag any entity-model invariant that **contradicts** a BR (a cross-artifact
conflict). Do not police duplicate/contradictory BR ids *within* a spec — that is
a within-spec concern, not cross-artifact traceability.

> **Worked example.** BR-04 "a thread cannot be both archived and pinned." Entity
> `Thread` exists. Its `Constraints` note reads "not (archived AND pinned)" →
> **mapped**. If `Thread` exists but no such constraint appears → **unenforced**.
> If the model says "archived implies pinned" → **conflict**.

## DO NOT

- Do NOT author or edit requirements, FRs, or NFRs (that is `requirements`).
- Do NOT model entities, define attributes, or draw ER diagrams (that is
  `entity-model` / `domain-model`).
- Do NOT add, define, or rename glossary terms (that is the ubiquitous-language
  skill) — propose, do not write, glossary changes.
- Do NOT gate or author ADRs, and do NOT cut or prioritize scope.
- Do NOT hard-code a single glossary filename, or assume a fixed `FR-`/`BR-` id
  scheme — resolve the fallback chain and discover the actual id patterns.
- Do NOT flag every UC as an orphan when the project has no trace convention —
  emit the single "no trace convention" finding instead.
- Do NOT report `PASS` when any check was skipped — use `PARTIAL`.
- Do NOT judge whether an upstream change was "substantial" — Check 0 reports
  recency only; the substance call and the decision to re-grill are the human's.
- Do NOT halt the run or block Checks A–D on a Check 0 warning — warn, force
  `PARTIAL`, and continue.
- Do NOT write any fix into an artifact without explicit per-change human
  approval (see HITL gate).
- Do NOT silently invent traces, rename entities/actors, guess a fix, or assert a
  translation you cannot prove — flag it and let the human decide.
- Do NOT crash or stop when an input artifact is missing — warn, skip the
  affected check, and continue.
- Do NOT bake any one project's domain specifics into your judgments — apply the
  checks generically.

## Workflow

1. **Resolve inputs.** Resolve each artifact path (defaults above, honoring
   overrides) and the glossary via the fallback chain. State which files you are
   using and which are missing.
2. **Read all available artifacts** and **discover conventions** — the id
   patterns, whether a trace convention exists, and confirm the normalization
   rule. Extract: requirement ids; actors and use cases from the diagram;
   per-spec actors, named entities, and BR ids; entity names and invariants from
   the model; canonical terms from the glossary. Also capture the git
   modification recency (last-commit time and uncommitted status) of the chain
   artifacts, for Check 0.
3. **Run Check 0, then Checks A–D** (above), accumulating findings.
4. **Assemble the consistency report** with the correct **Result state**.
5. **HITL fix loop (gate).** For each break the human wants fixed: name the
   **candidate offending artifact(s)** and, where ambiguous, let the human pick
   which to change rather than assuming. (An orphan UC may be the spec's fault —
   add a trace line — *or* the requirements doc's — a missing FR; present both.)
   Show the **exact proposed change** (precise before/after diff or new line) and
   ask "approve / edit / skip". Apply only approved changes, preserving the
   artifact's structure. Re-run the affected check to confirm resolution. Never
   write without approval.
6. **Deliver.** Output the final report and a summary of which breaks were fixed
   (and into which artifact) and which remain.

### Result states

- **PASS** — every check ran (no input missing, trace convention present), no
  break was found, **and** Check 0 raised no stale-downstream warning.
- **PARTIAL** — one or more checks were skipped (missing input, no trace
  convention for Check A, or Check 0 skipped for lack of git); **or** Check 0
  raised a stale-downstream warning. List which and why. No break found among
  the checks that *did* run. A partial run is never `PASS`.
- **BREAKS FOUND (N)** — N breaks across the run checks, listed by check. A
  Check 0 stale-downstream warning is reported alongside but is **not** counted
  in N (it is advisory, not a break).

## Consistency Report Template

```markdown
# Trace Check — Consistency Report

Vision: <path | MISSING — Check 0 vision→requirements pair skipped>
Requirements: <path | MISSING>   (id pattern: <discovered, e.g. FR-### | F##>)
Use case diagram: <path | MISSING>
Use-case specs: <glob → N files | MISSING>   (BR id pattern: <discovered>)
Entity model: <path | MISSING>
Glossary: <resolved path | NONE — Check C intra-artifact only, L1 not run>
Trace convention: <found | NOT FOUND — Check A not author-able>

Result: <PASS | PARTIAL (checks X,Y skipped) | BREAKS FOUND (N)>  <⚠ upstream stale: <pair(s)> | not git — Check 0 skipped>

## Check 0 — Upstream freshness
| Upstream → downstream | Upstream newer? | Status |
|-----------------------|-----------------|--------|
<rows per chain pair; stale-downstream warnings flagged with a re-grill recommendation>

## Check A — UC → ≥1 FR
| Use case | Traces to FR(s) | Status |
|----------|-----------------|--------|
<rows; orphan UCs, dangling FR refs, and diagram-UCs-with-no-spec flagged>

## Check B — Entity-in-spec → entity_model.md
| Entity named in spec | Spec location | In entity model? | Status |
|----------------------|---------------|------------------|--------|
<rows; missing entities and near-match breaks flagged>

## Check C — Actor ↔ glossary (L1)
| Actor used | Source artifact | Canonical glossary term | Status |
|------------|-----------------|-------------------------|--------|
<rows; near-match deviations, suspected translations, unknown actors flagged>

## Check D — BR → domain-model invariant
| BR id | Rule (short) | Mapped invariant in entity model | Status |
|-------|--------------|----------------------------------|--------|
<rows; unenforced, conflict, and needs-confirmation flagged>

## Proposed fixes (await per-change approval)
- <break> — candidate offending artifact(s): <A | B>; <before/after diff or new line>
```

## Notes

- **Guardrail basis.** Only **L1** (`gr_domain_language.md`, use defined terms
  exactly) is carried over by ID, in Check C, scoped to actors — and trace-check
  *proposes*, never writes, glossary changes (L2/L4/L6/L8/L9 stay with
  `ubiquitous-language-guard`). The other checks embody guardrail **intent**
  without a numbered rule: Check D's BR→invariant mapping reflects the spirit of
  `gr_ddd.md` D1/D9 (a business rule should be enforced as a domain invariant),
  but trace-check only verifies the mapping *exists between two documents* — it
  cannot see code, so it cannot detect a D1 *placement* violation (a rule
  enforced in a controller). Checks A and B are structural cross-artifact integrity
  findings (no `gr_*.md` defines "every UC traces to an FR"); they serve the
  same anti-drift purpose as the documentation guardrails but are reported as
  chain-integrity, not as Doc4/Doc5 rule violations.
- **Check 0 is git-based and advisory.** It reads commit times and working-tree
  status — not content — so it detects *recency* drift only, never whether a
  change was meaningful. It maps to no `gr_*.md` rule; it is a chain-integrity
  signal in the same anti-drift spirit as Checks A and B. It is the only check
  that touches `vision.md`, closing the otherwise-invisible top link
  (vision → requirements) of the artifact chain. It never blocks: a warning
  forces `PARTIAL`, and a non-git repo skips it.
- **Step-agnostic.** Run it at use-case-diagram time, use-case-spec time, or any
  time artifacts may have drifted; missing inputs degrade to `PARTIAL` rather
  than blocking.
