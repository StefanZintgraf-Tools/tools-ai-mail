# Skills Review

Critical review of the project skills in this `skills/` folder. This file is the
**refactoring worklist**: each skill is reviewed against (1) guardrail rule
coverage (the `gr_*.md` items in `c:\PROJ\ai-knowhow\coding\gr\`), (2) whether an
agent running it achieves the skill's stated purpose, and (3) whether the
SKILL.md is written effectively. Each entry begins with `- [ ] refactored`; work
the list one skill at a time and flip the box once refactored.

Guardrail file legend (only clusters referenced by the reviews below):
- `gr_greenfield.md` — G1–G10 greenfield over-engineering / build-discipline rules
  (G1 boring-explicit-first, G3 defer expensive decisions, G5 no premature
  abstraction, G6 no premature framework, G9 record postponed decisions,
  G10 smallest architecture for next known requirement).

## Contents
1. [`pareto-scope-cut`](#pareto-scope-cut--lens)

---

## `pareto-scope-cut` — lens
- [x] refactored

### 1. Guardrail coverage
Declared cluster: `gr_greenfield.md` (10 rules G1–G10). The skill explicitly claims G1/G3/G5/G6/G9/G10 and explicitly scopes out G2/G4/G7/G8 (overview line 179). Walk-through:

- **G1 — Boring, Explicit, Replaceable First.** COVERED. Classification table row G1 (line 73): "clever, generalized, or 'future-proof' design where a simpler explicit one meets the current need." Verbatim faithful to gr line 18.
- **G2 — First Vertical Slice Before Layers.** OUT-OF-SCOPE (legitimately). Overview line 179 declares it out of scope as a build-sequencing concern; a single-artifact scope cut cannot enforce build order. Correct exclusion.
- **G3 — Defer Expensive Decisions.** COVERED. Table row G3 (line 74): "multi-tenancy, internationalization, advanced patterns — with no concrete requirement at the current marker." Matches gr line 24. Note: gr also lists "plugin systems" under G3, but the skill routes plugin systems to G6 (line 76) — a reasonable, non-conflicting split.
- **G4 — Establish Conventions Once.** OUT-OF-SCOPE (legitimately). A conventions concern, not a scope-cut concern. Correctly excluded.
- **G5 — No Premature Abstraction.** COVERED. Table row G5 (line 75): "abstraction… extracted with fewer than two concrete cases demanding it. Extract shared structure ONLY when reused twice." Matches gr lines 29–30. Reinforced by the concrete "Abstraction" definition in procedure step 2 (lines 49–50).
- **G6 — No Premature Framework.** COVERED. Table row G6 (line 76): "framework, ORM, message bus, or plugin/extension system the current scope does not require." Verbatim faithful to gr lines 32–33.
- **G7 — Initial Domain Vocabulary Recorded.** OUT-OF-SCOPE (legitimately). Owned by `ubiquitous-language-guard` (overview line 179); DO NOT block at line 126 reinforces "Do NOT … maintain a glossary." Correct.
- **G8 — Initial Testing Strategy.** OUT-OF-SCOPE (legitimately). Testing concern, not scope-cut. Correct.
- **G9 — Record Postponed Decisions.** COVERED. Dedicated §"Postponed-decision record (G9)" (lines 85–98) with canonical one-line format and a mandatory output section. Matches gr lines 41–42.
- **G10 — Smallest Architecture for Next Known Requirement.** COVERED. Table row G10 (line 77): "sized for a multi-release roadmap rather than the next concrete requirement at the scope marker." Matches gr lines 44–45.

**Coverage-claim accuracy issue (must fix):** There is a real inconsistency between SKILL.md and its overview entry on which rules G9 records cite. SKILL.md is internally consistent that postponed-decision records cite **G1/G3/G5/G6/G10** (lines 51, 62, 91, 116, 128). But the overview's G9-format example (line 168) drops G6: `Reason: <why, cites G1/G3/G5/G10>`. The overview is wrong — it omits G6 from the cite set even though it separately declares G6 as covered (line 175). Flag for correction in the overview, not the SKILL.md.

**MISSING summary:** None among the claimed rules. All of G1/G3/G5/G6/G9/G10 are COVERED.
**PARTIAL summary:** None.
**OUT-OF-SCOPE (correctly excluded):** G2, G4, G7, G8 — each with a stated, defensible reason.

This is a clean, faithful executable form of the over-engineering subset of `gr_greenfield.md`. The only guardrail-coverage defect is the overview's G6-dropping example line, not a SKILL.md gap.

### 2. Will the purpose be achieved?
Stated purpose: take a planning artifact + scope marker, flag imagined/future work, split in-scope vs deferred, append a postponed-decisions log behind a HITL gate. An agent following this SKILL.md will largely achieve it. Strengths:

- Inputs §1–3 are unusually rigorous: it refuses to classify against a marker *name* alone (lines 33–36, restated in DO NOT line 125), demands the marker's actual requirement set, and handles sequential "at or before" ordering (lines 38–41). This is the single biggest correctness risk in a scope-cut and it is well guarded.
- Procedure is a clean 8-step pipeline with a hard HITL gate (step 6, line 54) and explicit idempotency/replace-in-place handling (step 7, lines 57–59).
- The Validate step (lines 60–65) gives concrete post-conditions (every item classified exactly once; every deferred item has a G9 line; marker named in heading; no duplicate sections).
- The "neither now nor future — leave untouched" escape hatch (lines 81–83) prevents the classic forced-bucket failure where dead/irrelevant content gets mislabeled.

Concrete failure modes / weak spots:

- **Enumeration completeness is unverifiable.** Step 2 (lines 46–50) says "Enumerate every scopeable item" but there is no mechanism to confirm completeness against the artifact. The Validate check (line 61) only verifies that *enumerated* items are classified once — an item the agent never enumerated silently escapes. On a large requirements doc this is a silent-degradation risk: items simply omitted from the split. No "cross-check the count against the artifact's headings/FR-ids" step exists.
- **Ordering resolution can stall ambiguously.** Lines 38–41 say if ordering "cannot be determined," treat only the named marker as now and ask about earlier-marker items. This is good, but "any item that looks like it belongs to an earlier marker" is judgment-based with no heuristic — on a flat artifact with no marker tags this degrades to guesswork.
- **No guidance for "no scope marker exists at all."** Inputs assume a marker can be named or asked for. If the project genuinely has no milestone/phase structure, the skill has no defined behavior — it would loop on asking the user. Minor, but a real edge.
- **"Scopeable item" vs the artifact type is loosely matched.** Step 2 lists entities, FRs, actors, use cases, flows, attributes, abstractions — a union across all artifact types. On a `.puml` use-case diagram, "attributes" and "FRs" don't exist; the agent must silently infer which item kinds apply. Not fatal, but under-specified per artifact type.

Net: purpose is achieved for the common case (a requirements/entity doc with a named milestone). The main residual risk is silent enumeration gaps on large artifacts.

### 3. Writing effectiveness
Clear, well-structured, and notably tight for the amount of contract it carries. The classification table is the right format. But there is measurable redundancy — several invariants are stated 3–4 times:

- **HITL-before-write** appears at step 6 (line 54), step 7 (line 58 "Write nothing before approval"), output header (line 102 "behind the HITL approval gate"), and DO NOT line 122. Four statements.
- **Replace-in-place / no duplicate sections** appears at step 7 (lines 57–59), Validate (line 65), output header (line 102), and DO NOT line 123. Four statements.
- **Don't classify against marker name alone** appears at Inputs §3 (lines 33–36) and DO NOT line 125.
- **Every deferred item needs a G9 line** appears at step 4, Validate (line 62), and DO NOT line 128.
- **The G9 one-line format is shown twice verbatim** — §G9 (line 91) and Output format (line 116). The skill even notes "This is the one canonical format" (line 88) yet then duplicates it.

The DO NOT section (lines 120–129) is almost entirely a restatement of constraints already in Procedure/Inputs. It adds emphasis but ~80% is duplication. Could be cut to the 2–3 non-obvious prohibitions (don't model entities/glossary/ADR — line 126; don't hard-code milestone names — line 127) and a pointer.

Under-specified spots that should be ADDED (small): (a) an enumeration-completeness cross-check in Validate; (b) one line on per-artifact-type item kinds (which of entities/FRs/flows apply to a `.puml` vs a requirements doc); (c) defined behavior when no scope marker exists.

### Recommended refactor actions
1. **Fix the overview G9 cite inconsistency:** update `skills_overview.md` line 168 example from `cites G1/G3/G5/G10` to `cites G1/G3/G5/G6/G10` so it matches the SKILL.md and the G6-covered claim.
2. **Add an enumeration-completeness guard** to Validate (step 8): cross-check the enumerated item list against the artifact's headings / id patterns so silently-omitted items are caught — close the only real correctness gap.
3. **Cut DO NOT-section redundancy:** collapse lines 120–129 to the non-duplicative prohibitions (no entity-modeling/glossary/ADR/constraint-sweep; no hard-coded milestone names/paths) and drop restatements of HITL-before-write, replace-in-place, and the G9-required rule already covered in Procedure/Validate.
4. **De-duplicate the G9 format:** keep the canonical block in §"Postponed-decision record (G9)" and have the Output-format section reference it instead of repeating it verbatim (line 116).
5. **Add brief per-artifact-type item-kind guidance** to step 2 (which item kinds apply to requirements vs entity model vs `.puml` vs use-case spec) and a one-line fallback for "no scope marker exists," to remove the remaining ambiguity.

---

## Glossary resolution guard

Cross-cutting check across **every** `skills/*/SKILL.md` (excluding `skills/archive/`
and the meta-skills `review-skills` / `refactor-skills`). Canonical chain:
`explicit argument → docs/CONTEXT.md → docs/glossary.md → warn/degrade`.

| Skill | Reads glossary? | Resolution chain found | Verdict |
|-------|-----------------|------------------------|---------|
| adr-threshold-gate | no | — | N/A (no glossary) |
| domain-model | yes | argument → `docs/CONTEXT.md` → `docs/glossary.md` → warn | PASS |
| domain-requirements | yes | argument → `docs/CONTEXT.md` → `docs/glossary.md` → warn | PASS |
| hidden-constraint-sweep | yes | argument → `docs/CONTEXT.md` → `docs/glossary.md` | PASS |
| pareto-scope-cut | no | — | N/A (no glossary) |
| trace-check | yes | argument → `docs/CONTEXT.md` → `docs/glossary.md` | PASS |
| ubiquitous-language-guard | yes | argument → `docs/CONTEXT.md` → `docs/glossary.md` → warn | PASS |

Note on `hidden-constraint-sweep:68`: it mentions a bare `context.md`, but only as a
quotation of the source rule's original wording ("the relevant transcript entry or
`context.md` term"), which the skill then explicitly re-maps to artifact-resident
pointers. Its actual resolution location (line 49) is `docs/CONTEXT.md` → `docs/glossary.md`,
and line 96 forbids hard-coding a single context filename. Not a deviation.

**Overall verdict: `clean`** (all PASS / N/A).
