---
name: tracker-trace-check
description: >
  Audits drift between the in-repo spec spine and the issue tracker — a repo-to-tracker
  drift audit that runs after a PRD/issues were published, to catch divergence that
  appears later (issues edited on the tracker, or the spine changed after publish).
  Runs three checks: a dangling-ref check (every FR/UC/BR/ADR id cited on the tracker
  resolves to a real spine artifact), a forward-coverage check (every in-scope
  requirement is on the tracker), and a semantic-divergence check (a tracker item
  contradicts its linked spine artifact). The first two are mechanical PASS/FAIL; the
  third is flagged needs-human-confirmation, never auto-decided.
  Use when the user asks to "tracker trace check", "audit the tracker against the
  spine", "check tracker consistency", "repo to tracker drift audit", "find dangling
  tracker references", "check forward coverage on the tracker", "verify issues match
  the spec", "tracker traceability check", "did the spine drift from the published
  PRD", "are the issues still in sync with the requirements", or whenever a published
  PRD / set of issues and the in-repo spine may have drifted apart. Produces a
  consistency report (pass / list of breaks) and an HITL fix loop — repo-side and
  tracker-side fixes are PROPOSED, never auto-applied; tracker writes are gated on
  explicit human approval. The tracker-aware sibling of the offline trace-check.
---

# Tracker Trace Check

A cross-cutting lens that protects traceability **across the repo↔tracker boundary**:
every traceability ref published on the tracker must resolve back to a real artifact
in the in-repo spine, and every in-scope requirement in the spine must have reached
the tracker. This skill reads the in-repo spine and the published PRD/issues for a
milestone, runs three consistency checks, produces a single consistency report (pass
or a list of breaks), and — only with explicit human approval — proposes fixes back
into the offending side (repo artifact OR tracker item). It does NOT author
requirements, model entities, maintain the glossary, publish PRDs, or cut scope;
those are other skills.

**This is the tracker-aware sibling of `trace-check`.** Where `trace-check` compares
in-repo artifacts to each other and stays strictly offline/repo-only, this skill
compares the in-repo spine to the **tracker** (a network dependency). `trace-check`
itself is left **unmodified** — it never gains a tracker dependency. This skill
**reuses `trace-check`'s convention-discovery *method*** (derive id prefixes from the
actual files — never hard-assume — plus the name-normalization rule) rather than
reinventing it, and **extends** that method with the **UC and ADR id families that
`trace-check` does not discover** (`trace-check` discovers only the requirements-id and
BR-id patterns; it matches use cases by name and never reads ADRs). Its
semantic-divergence check is modelled on `trace-check`'s Check D (a
`needs-human-confirmation` verdict, never an auto-decided break).

**Temporal role — this is the complement of `spec-to-prd`'s forward-coverage POST
check.** `spec-to-prd` asserts forward coverage **at publish time** (every in-scope
requirement reached the tracker when the PRD was published). `tracker-trace-check` is
run **later** to catch **post-publish drift** — the two ways the sides can diverge
after publish:

- an **issue was edited on the tracker** (its content, or a ref it cites, changed); or
- the **spine changed after the PRD was published** (a requirement added, renamed,
  re-scoped, or an artifact a tracker ref pointed at was removed).

So a clean `spec-to-prd` publish does not make this skill redundant: it guards the
window *between* publishes.

These checks are **chain-integrity** findings — they enforce the discipline that the
repo spine and the tracker must not silently drift apart. They map to no single
numbered guardrail rule (like `trace-check`); only the actor part of the
semantic-divergence check carries a rule ID (`L1`). Do not overclaim a finding as a
code-level rule violation: this skill reads documents and tracker items, not code, so
it can only see *documentation/tracker* drift, never code *placement* violations.

## Inputs

The **in-repo spine** (the authoritative side) plus the **published PRD/issues** (the
projected side), for one milestone.

1. **Requirements** (default `docs/requirements.md`) — the functional requirement (FR)
   catalog. The source of truth for forward coverage and for resolving cited FR ids.
   Accept an override path.
2. **Use case diagram** (default `docs/use_cases.puml`) — the PlantUML diagram
   declaring actors and use cases (UC ids). Accept an override path.
3. **Use-case specs** (default `docs/use_cases/*.md`) — per-use-case specs carrying
   UC and business-rule (BR) ids, actors, scenarios. Accept an override glob.
4. **Entity model** (default `docs/entity_model.md`) — the domain model; used when a
   semantic divergence concerns a named entity or invariant. Accept an override path.
5. **ADRs** (default `docs/adr/*`, optional) — used to resolve cited ADR ids. If
   absent, ADR refs cannot be resolved → those resolve attempts degrade (warn).
6. **Glossary** (optional argument) — path to the project's ubiquitous-language file.
   Resolve in this order, and NEVER hard-code a single filename:
   1. The explicit path the user passed, if any.
   2. `docs/CONTEXT.md`
   3. `docs/glossary.md`
   4. If none exists: **warn** that no glossary was found and run the **actor part of
      the semantic-divergence check in degraded mode** — actor names on the tracker
      are cross-checked against the spine's actors only (no verbatim L1 check against
      a glossary). The report must label this "L1 not run" so a degraded run never
      reads as an L1 pass.
7. **Tracker** — the published PRD/issues for the milestone, read **abstractly via the
   project's tracker wiring** (`docs/agents/issue-tracker.md`; triage-role label
   strings via `docs/agents/triage-labels.md`). NEVER bake in GitHub or any specific
   tracker — follow whatever `docs/agents/issue-tracker.md` says "fetch the relevant
   ticket" / "list issues" means for this project. The published items carry the
   `FR/UC/BR/ADR` traceability refs that `spec-to-prd` emitted.
8. **Scope marker** (the milestone) — resolve: explicit arg → the requirements doc's
   declared milestone / Status scope split (in-scope = non-deferred, non-out-of-scope
   at the marker) → ask only if genuinely ambiguous (multiple undelimited milestones).
   Same convention as the other AIUP-chain skills.

If any non-glossary spine input is missing, **warn**, skip the checks that need it,
and continue. If the **tracker is unreachable** (network down, auth missing, no PRD
published for the milestone yet), **warn, skip the tracker-dependent checks, and
continue** — never crash. A run with any check skipped can never be reported `PASS` —
see **Result states**.

## Discover conventions first (reuse `trace-check`'s method, extend it for UC/ADR)

Before running the checks, establish the conventions from the actual artifacts — do
not assume a fixed format. **Reuse `trace-check`'s convention-discovery *method*** —
derive id prefixes from what is actually in the files (never hard-assume a scheme) plus
its name-normalization rule — **do not reinvent it.** But note `trace-check`'s own
discovery covers only the **requirements-id** and **BR-id** patterns (it matches use
cases by name and never reads ADRs); this skill **extends** that method to the **UC and
ADR id families** it alone needs. So: reuse the *method*, extend the *coverage* —
neither duplicate nor diverge from the shared method (per the POST self-check).

- **ID patterns.** Discover the id prefix schemes actually present in the spine — the
  requirements catalog (it may be `FR-012`, but it may also be `F22`, `M2`, or another
  scheme) and business rules (`BR-###`), exactly as `trace-check` does; **and**, as this
  skill's own extension, use cases (`UC-###`) and ADRs (`ADR-####`). Derive each matching
  pattern from what is present in the files; do **not** hard-assume
  `FR-`/`UC-`/`BR-`/`ADR-` and silently miss other schemes. Use the **same** discovered
  patterns when scanning the tracker text for cited refs, so a dangling-ref scan and a
  spine lookup speak the same id language.

- **Name normalization (for the semantic-divergence check).** To compare two names
  mechanically rather than by judgment, apply `trace-check`'s rule: trim, lowercase,
  and strip a trailing plural (`-s`/`-es`) from both sides. Then:
  - normalized-equal **and** byte-identical → match (silent pass);
  - normalized-equal but **not** byte-identical → **near-match** (report both forms and
    the canonical one, e.g. `Mailboxes` vs `Mailbox`);
  - not normalized-equal → no match.

  Translation drift (e.g. German `Benutzer` for glossary `User`) cannot be detected
  mechanically — flag only a *suspected* translation for human confirmation; never
  assert it as a definite break.

- **Ref-extraction from the tracker.** Each published item (PRD body, issue body,
  issue title, or a `Traces to:` / `Requirements:` line) may cite spine refs. Using the
  discovered id patterns, extract every `FR/UC/BR/ADR` ref cited anywhere on the
  tracker for the milestone, recording which tracker item cited it (so a break can name
  the offending item).

## The checks

Run the two **mechanical** checks (Check 1, Check 2) first as deterministic PASS/FAIL,
then the **semantic** check (Check 3) as `needs-human-confirmation`. Accumulate
findings into one consistency report.

### Check 1 — Dangling-ref check (mechanical PASS/FAIL)

Every `FR/UC/BR/ADR` id **cited on the tracker** must resolve to a real artifact in the
in-repo spine. For each ref extracted from the tracker:

1. Look it up in the matching spine source by its discovered id pattern (FR → the
   requirements catalog; UC → diagram/specs; BR → the specs; ADR → `docs/adr/*`).
2. **Resolved** if a spine artifact with that id exists; **dangling reference** (a
   **break**) if no matching spine artifact exists — name the tracker item that cited it
   and the unresolved id.

A cited id whose *type* cannot be resolved because the spine source is missing (e.g. an
ADR ref but no `docs/adr/`) is reported as **unresolvable — input missing** (skip, not a
break) and forces `PARTIAL`, not a false dangling-ref break.

### Check 2 — Forward-coverage check (mechanical PASS/FAIL)

Every **in-scope** requirement in the spine must appear on the tracker. Resolve the
in-scope set from the scope marker (non-deferred, non-out-of-scope requirements at the
marker). For each in-scope requirement id:

1. Confirm the id appears on the tracker for this milestone (cited in the PRD or on an
   issue, by the discovered id pattern).
2. **Covered** if present; **coverage gap** (a **break**) if an in-scope requirement is
   absent from the tracker — name the missing requirement id.

This is the *post-publish* counterpart of `spec-to-prd`'s publish-time forward-coverage
assertion: it re-checks coverage now, catching a requirement added to the spine after
the PRD was published (or a tracker item deleted).

### Check 3 — Semantic-divergence check (needs-human-confirmation, NOT auto-decided)

A tracker item whose **content contradicts** the spine artifact it links to — e.g. an
issue edited on the tracker so it now says something different from the FR/UC/BR it
cites. The ref still **resolves** (Check 1 passes) and the requirement is **covered**
(Check 2 passes), but the *meaning* has diverged. Like `trace-check`'s Check D, this is
a **semantic** judgment you must perform deliberately and **never** assert as a definite
mechanical break or auto-fix:

1. For each resolved ref, read the linked spine artifact and the tracker item's content.
2. Verdict: **aligned** if the tracker item still says what the spine artifact says;
   **suspected divergence — needs human confirmation** if the tracker item appears to
   contradict it (a changed acceptance condition, a flipped scope, an actor swapped, a
   threshold altered); do **not** guess "definitely diverged" or "definitely fine."
3. **Actor sub-case (L1).** Where a tracker item names an **actor**, apply
   `gr_domain_language` rule **L1 — use defined terms exactly**: the actor must appear
   **verbatim** in the resolved glossary (and match the spine's actor). Using the
   normalization rule, flag a near-match (variation, abbreviation, pluralization,
   casing) and name the canonical form; flag a suspected translation for confirmation.
   If no glossary was resolved, run the degraded actor check (against the spine's actors
   only) and label it "L1 not run."

Every Check 3 finding is reported **alongside** the mechanical results as
`needs-human-confirmation` and is **not** counted in the mechanical break total `N`.

> **Worked example.** An issue cites `FR-001` ("detect mails carrying at least one
> attachment"). Check 1: `FR-001` exists → resolves. Check 2: `FR-001` is in scope and on
> the tracker → covered. Check 3: the issue body was later edited to read "detect mails
> over 5 MB" — that contradicts `FR-001` → **suspected divergence, needs human
> confirmation** (do not auto-decide which side is right; propose both fixes in the loop).

## DO NOT

- Do NOT auto-apply **any** fix. Tracker-side edits **especially** must be gated on
  explicit per-change human approval; repo-side edits the same. Propose, never write.
- Do NOT auto-decide a semantic divergence — flag it `needs-human-confirmation`; never
  assert a definite break and never auto-fix it.
- Do NOT reinvent or diverge from the **shared convention-discovery *method*** — derive
  id prefixes from the files (never hard-assume) and apply `trace-check`'s
  name-normalization rule. (`trace-check` discovers only the requirements-id and BR-id
  patterns; this skill legitimately **extends** the same method to the UC and ADR id
  families it alone needs — that is not divergence.)
- Do NOT modify `trace-check` or add a network/tracker dependency to it — it stays
  offline/repo-only; the tracker dependency lives **only** in this skill.
- Do NOT hard-code a tracker (no baked-in GitHub or other tracker) — go through
  `docs/agents/issue-tracker.md`. Do NOT hard-code a single glossary filename — resolve
  the fallback chain.
- Do NOT count a Check 3 (semantic) finding as a mechanical break in `N`.
- Do NOT report `PASS` when any check was skipped (missing spine input, unreachable
  tracker, no glossary for the actor part) — use `PARTIAL`.
- Do NOT crash or stop when the tracker is unreachable or a spine input is missing —
  warn, skip the affected check, and continue (→ `PARTIAL`).
- Do NOT author or edit requirements, model entities, add/rename glossary terms,
  publish PRDs, or cut scope — those are other skills. Propose, do not write, glossary
  changes.
- Do NOT silently invent traces, rename entities/actors, guess a fix, or assert a
  translation you cannot prove — flag it and let the human decide.
- Do NOT bake any one project's domain specifics into your judgments — apply the checks
  generically; the project's values arrive via args / fallback chains.

## Workflow

1. **Resolve inputs.** Resolve the spine paths (defaults above, honoring overrides), the
   glossary via the fallback chain, the tracker wiring via `docs/agents/issue-tracker.md`,
   and the **scope marker**. State which spine files you are using, which are missing, and
   whether the tracker is reachable.
2. **Read the spine and discover conventions** — reuse `trace-check`'s discovery *method*
   (derive id prefixes from the files; its name-normalization rule) for the requirement-id
   and BR-id patterns, and **extend** that method to the UC-id and ADR-id families
   `trace-check` does not discover. Extract: requirement ids (and their in-scope
   status at the marker); UC ids; BR ids; entity names and invariants; ADR ids; canonical
   terms from the glossary.
3. **Fetch the tracker** for the milestone (abstractly, via the tracker wiring) and
   **extract every cited `FR/UC/BR/ADR` ref**, recording which item cited each.
4. **Run Check 1 and Check 2** (mechanical PASS/FAIL), then **Check 3** (semantic,
   `needs-human-confirmation`), accumulating findings.
5. **Assemble the consistency report** with the correct **Result state**.
6. **HITL fix loop (gate).** For each break (and each confirmed semantic divergence the
   human chooses to act on): name the **candidate offending side** — the **repo
   artifact** OR the **tracker item** — and, where ambiguous, let the human pick which to
   change rather than assuming. (A dangling ref may be the tracker's fault — fix the cited
   id — *or* the spine's — the artifact was removed/renamed; present both. A coverage gap
   may need the requirement published to the tracker *or* re-scoped in the spine.) Show
   the **exact proposed change**:
   - **repo-side:** a precise before/after diff or new line into the offending artifact;
   - **tracker-side:** the exact proposed edit (the new title/body/ref), described as a
     tracker operation per `docs/agents/issue-tracker.md` — **proposed only**.
   Ask "approve / edit / skip". Apply only approved changes, preserving structure. For a
   **tracker** write, require explicit human approval before issuing any tracker
   operation. Re-run the affected check to confirm resolution. Never write without
   approval.
7. **Deliver.** Output the final report and a summary of which breaks were fixed (and on
   which side), which semantic divergences were confirmed/dismissed, and what remains.

### Result states

- **PASS** — every check ran (no spine input missing, tracker reachable, milestone PRD
  present), no mechanical break was found, **and** no semantic divergence was flagged.
- **PARTIAL** — one or more checks were skipped (missing spine input, tracker
  unreachable / no published PRD for the milestone, no glossary for the actor part); or a
  ref was unresolvable because its spine source is missing; or a semantic divergence is
  outstanding as `needs-human-confirmation`. List which and why. No mechanical break among
  the checks that *did* run. A partial run is never `PASS`.
- **BREAKS FOUND (N)** — N **mechanical** breaks (dangling refs + coverage gaps) across
  the checks that ran, listed by check. Semantic divergences are reported **alongside** as
  `needs-human-confirmation` but are **not** counted in `N`.

## Consistency Report Template

```markdown
# Tracker Trace Check — Repo↔Tracker Consistency Report

Scope marker (milestone): <resolved marker>
Requirements: <path | MISSING>   (id pattern: <discovered, e.g. FR-### | F##>)
Use case diagram: <path | MISSING>   (UC id pattern: <discovered>)
Use-case specs: <glob → N files | MISSING>   (BR id pattern: <discovered>)
Entity model: <path | MISSING>
ADRs: <dir → N files | MISSING — ADR refs unresolvable>   (ADR id pattern: <discovered>)
Glossary: <resolved path | NONE — actor check degraded, L1 not run>
Tracker: <reachable — PRD/issues for milestone fetched | UNREACHABLE — tracker checks skipped | NO PRD PUBLISHED for milestone>

Result: <PASS | PARTIAL (checks X,Y skipped) | BREAKS FOUND (N)>  <+ M semantic divergences need human confirmation>

## Check 1 — Dangling refs (tracker ref → spine artifact)
| Ref cited | Cited by (tracker item) | Resolves in spine? | Status |
|-----------|-------------------------|--------------------|--------|
<rows; dangling references flagged as breaks; unresolvable-input-missing flagged as skip>

## Check 2 — Forward coverage (in-scope requirement → tracker)
| In-scope requirement | On tracker? | Status |
|----------------------|-------------|--------|
<rows; coverage gaps flagged as breaks>

## Check 3 — Semantic divergence (tracker item ↔ linked spine artifact)  [needs-human-confirmation]
| Ref | Tracker item | Spine artifact says | Tracker item says | Verdict |
|-----|--------------|---------------------|-------------------|---------|
<rows; aligned | suspected divergence (needs human confirmation); actor L1 near-matches flagged here>

## Proposed fixes (await per-change approval — never auto-applied)
- <break / divergence> — candidate offending side: <repo artifact <path> | tracker item <ref>>;
  <repo-side: before/after diff or new line>  OR  <tracker-side: proposed edit, PROPOSED ONLY>
```

## Notes

- **Guardrail basis.** Only **L1** (`gr_domain_language.md`, use defined terms exactly)
  is carried over by ID, in the actor sub-case of Check 3 — and this skill *proposes*,
  never writes, glossary changes. The mechanical checks (Check 1, Check 2) embody
  chain-integrity intent without a numbered rule (no `gr_*.md` defines "every tracker ref
  resolves" or "every in-scope requirement reaches the tracker"); they serve the same
  anti-drift purpose as the documentation guardrails but are reported as repo↔tracker
  integrity findings, not as rule violations. This mirrors `trace-check`'s "AIUP-native
  traceability, no single gr cluster" stance.
- **Tracker dependency is contained here.** This skill is the one that gains the network
  (tracker) dependency; `trace-check` (#6) stays unmodified, offline, and repo-only. The
  two are deliberate siblings: the **same convention-discovery method** (this skill
  extends it with the UC/ADR id families `trace-check` does not discover), different
  second source (repo artifacts vs. the tracker).
- **Temporal complement of `spec-to-prd`.** `spec-to-prd` asserts forward coverage at
  *publish* time; this skill re-audits *after* publish, catching edited issues and a
  spine that changed after the PRD shipped. Run it after `spec-to-prd` in the Phase-4
  chain, and any time you suspect the published PRD/issues and the spine have drifted.
- **Step-agnostic / fail-soft.** Missing spine inputs, an unreachable tracker, or a
  not-yet-published milestone degrade the run to `PARTIAL` rather than blocking. Never
  crash on a missing input or a network failure — warn, skip, continue.
