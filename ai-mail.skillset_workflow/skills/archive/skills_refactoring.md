# Skills Review

Critical review of the project skills in this `skills/` folder. This file is the
**refactoring worklist**: each skill is reviewed against (1) its guardrail rule coverage
(the `gr_XXXX.md` items in `ai-knowhow/coding/gr/`), (2) whether an AI agent running it
will actually achieve the skill's stated purpose, and (3) whether the SKILL.md is written
effectively — enough clear, actionable input, but not bloated.

Each skill entry begins with a `- [ ] refactor pending` checkbox. Work the list one skill
at a time in a **fresh agent session**, using that skill's "Recommended refactor actions"
as the brief; flip the box to `- [x]` once the skill has been refactored.

Each review below was produced by a dedicated fresh sub-agent that read **only** that one
skill's `SKILL.md` plus its specific guardrail files — so findings are independent and
un-cross-contaminated. The reviews verify (and where wrong, challenge) the coverage claims
recorded in [`skills_overview.md`](skills_overview.md).

Guardrail file legend (referenced below):
- `gr_domain_language.md` — rules `L1`–`L9` (ubiquitous language).
- `gr_greenfield.md` — rules `G1`–`G10` (greenfield design discipline).
- `gr_ddd.md` — rules `D1`–`D9` (tactical domain-driven design).
- `gr_architecture.md` — rules `A1`–`A11` (architecture / infrastructure isolation).
- `gr_adr.md` — rules `Adr1`–`Adr10` (architectural decision records).
- `gr_algn.md` — `Aln#` rules (alignment; incl. `Aln6` hidden-constraint checklist).
- `gr_idea.md` — idea→PRD distillation arc (requirements/specification step).
- `gr_rev.md` — `Rev#` rules (review checklist; mirrors `Aln6` at review time).
- `gr_documentation.md` — `Doc#` rules (docs stay aligned, no duplicated sources).

---

## Contents

1. [`ubiquitous-language-guard` — lens](#ubiquitous-language-guard--lens)
2. [`pareto-scope-cut` — lens](#pareto-scope-cut--lens)
3. [`domain-model` — fork](#domain-model--fork)
4. [`domain-requirements` — fork](#domain-requirements--fork)
5. [`adr-threshold-gate` — lens](#adr-threshold-gate--lens)
6. [`hidden-constraint-sweep` — lens](#hidden-constraint-sweep--lens)
7. [`trace-check` — lens](#trace-check--lens)

---

## `ubiquitous-language-guard` — lens
- [x] refactored

### 1. Guardrail coverage

Per-rule walk-through of `gr_domain_language.md` (L1–L9) plus `gr_greenfield.md` G7. The overview claims **L1, L2, L4, L6, L8, L9 + G7 covered** and **L5 deliberately excluded**. It is silent on L3 and L7 in its "covered" list (L7 is folded into the near-match gate; L3 is mentioned only as an overlap with L4).

- **L1 — Use Defined Terms Exactly — COVERED.** SKILL.md §L1 (lines 48–54) explicitly checks verbatim usage and enumerates the deviation classes (variation, abbreviation, pluralization, casing, translation). Good match to rule text. Has a report table.

- **L2 — No Forbidden Synonyms — COVERED, but with a hidden dependency.** §L2 (57–62) keys entirely off a glossary **`_Avoid_` list** ("or equivalent 'synonyms to avoid' / 'do not use' entries"). The actual `context.md` convention in L8 of the rule (lines 53–67) says nothing about an `_Avoid_` field — it only requires defining terms in plain language. So if a real glossary has no `_Avoid_` section (the common case), **L2 silently does nothing** and produces an empty table, while still appearing "covered." The rule's intent ("Purchase"/"Transaction" must not appear for "Order") is broader than "appears on an `_Avoid_` list." Gap: L2 has no fallback to flag a plausible synonym when no `_Avoid_` list exists.

- **L3 — Separate Domain Terms from Technical Terms — PARTIALLY COVERED / NOT NAMED.** L3 is a distinct rule ("InvoiceDTO", "InvoiceRow" in the domain layer). SKILL.md never names L3; the overview hand-waves it as "overlaps gr L3." §L4's smell list does catch `DTO`, `Row`, `Record`, `Entity`-suffix, so the *mechanics* partly cover L3, but the **layer-awareness that is the heart of L3 ("technical suffixes belong to technical layers only") is absent** — the skill would wrongly flag a legitimately technical-layer name, and it never states L3 as a covered rule. Either claim L3 explicitly (with the layer caveat) or state it's out of scope; right now it's ambiguous.

- **L4 — Naming Reflects Behavior, Not Storage — COVERED.** §L4 (64–71) gives a concrete smell list and asks for a behavior-oriented replacement. Strong match. (Risk: false positives on a legitimately physical/storage artifact — but this skill audits conceptual AIUP artifacts, so acceptable.)

- **L5 — Renaming Is a Domain Change — DELIBERATELY EXCLUDED — claim VERIFIED.** SKILL.md never mentions L5; the overview note (130–132) explains it's a code-wide refactor concern. Consistent. One soft gap: when the near-match gate returns **refinement** (a rename of the glossary definition), nothing warns the human about L5 propagation consequences. Minor.

- **L6 — Introduce New Terms Explicitly — COVERED.** §L6 (73–78) + the near-match gate (80–95). Solid, with the HALT/ask flow. Good.

- **L7 — Match Language Across Bounded Contexts Deliberately — PARTIALLY COVERED.** The overview claims the near-match gate "enforces gr L7." It does **not, fully**. L7 is specifically about the *same word legitimately meaning different things in different bounded contexts* (a context map / per-context `context.md`). The near-match gate handles lexical/semantic *near*-matches (`Customer` vs `Client`) within one glossary, and its `new` branch says "per L7 note the boundary" (line 92) — but the skill assumes **a single glossary** and has no notion of multiple bounded contexts / context map at all. The "same word, two contexts" case (the actual L7 scenario) is not handled. So L7 is partial at best; the overview overstates it.

- **L8 — `context.md` is the UL artifact + write-back — COVERED in mechanism, but the FILE RESOLUTION CONTRADICTS THE RULE.** This is the most important coverage defect. Rule L8 (lines 53–67) is explicit: the ubiquitous language lives in **`context.md` at the root of each bounded context** (repo root for a single-domain repo). The SKILL.md fallback chain (lines 32–40, and again in Workflow/Inputs) resolves **only** `docs/CONTEXT.md` → `docs/glossary.md`. It does **not** look for `context.md` at the repo root or per-context — i.e., it will **miss the exact file the rule mandates** and fall through to "no glossary found / report-only" on a correctly-set-up project. The casing (`CONTEXT.md` vs `context.md`) is also off on case-sensitive filesystems. The write-back HITL flow itself (per-change approval, show exact text, preserve structure) is well-specified and matches "L8 is the source of truth," but pointed at the wrong filename. This must be fixed.

- **L9 — CLAUDE.md Points to the Domain Docs — COVERED.** §L9 (120–128) verifies the pointer, proposes a fix, refuses to auto-edit. Matches the rule. Two minor gaps vs rule text: (a) the rule prescribes a specific one-line role string ("read before any planning… update in-session when terms emerge or shift") — SKILL.md just says "one-line role description" without the canonical wording; (b) the rule says the pointer is required only **when `context.md` exists** — SKILL.md runs the L9 check "as a final check even when nothing changed" (line 122), which could nag about a missing pointer on a project that legitimately has no glossary.

- **G7 — Initial Domain Vocabulary Is Recorded (`gr_greenfield.md`) — COVERED, but thin/redundant.** §G7 (97–102) restates "record newly confirmed terms" and routes them to the L8 write-back. It adds no new mechanism beyond L6+L8 — it's essentially a pointer paragraph. Defensible as traceability, but it's the weakest/most padding-like section.

**MISSING / PARTIAL summary:**
- L8 file resolution does not look for `context.md` (rule-mandated name) at repo/context root — **functional miss**.
- L2 collapses to a no-op when no `_Avoid_` list exists — **partial**.
- L3 layer-awareness absent and rule never named — **partial / unstated**.
- L7 multi-context / context-map case not handled; only intra-glossary near-matches — **overstated as covered, actually partial**.
- L9 missing the canonical role-string wording and the "only when glossary exists" precondition — **minor partial**.

### 2. Will the purpose be achieved?

Stated purpose: audit one AIUP artifact against the glossary, produce a term-diff report, and (HITL) evolve the glossary. Mostly achievable, with these failure modes:

- **Most likely real-world failure: the glossary is never found.** Because the fallback chain (`docs/CONTEXT.md`, `docs/glossary.md`) doesn't include root `context.md`/`CONTEXT.md`, on a properly-configured project the agent drops into "report-only mode" and **skips L1 verbatim and L8 write-back entirely** — defeating the skill's core value while reporting success. High-severity.
- **L2 false-confidence.** As above, an empty `_Avoid_`-driven L2 table reads as "no synonym problems found," masking real synonym drift. The agent has no instruction to fall back to judgment when no `_Avoid_` list is present.
- **Underspecified "domain-significant" (L6).** §L6 says flag every "domain-significant term … not in the glossary" but never defines the bar. An agent will either over-flag every noun or under-flag — non-deterministic. Needs a heuristic (e.g., capitalized nouns / actors / status values / entities, excluding common English).
- **Near-match gate can stall a batch run.** The gate says "HALT and ask … Wait for the human's choice before proceeding for that term." With many near-matches this is many sequential interrupts; there's no batching guidance and no behavior defined for non-interactive runs. Could make the skill impractical on a large artifact.
- **Ordering inversion risk.** Workflow runs L6 + the near-match gate (steps 3–4) *before* assembling the report and the L8 write-back, but L1/L2 fixes that come out of a near-match "same" decision aren't fed back into the L1/L2 report tables — the report could under-count. The data flow between the gate decisions and the report sections isn't wired.
- **L8 "no glossary → recommend creating it" has no creation path.** Fine as a boundary, but combined with the wrong fallback chain, the common outcome is "I couldn't find a glossary, here's report-only" even when one exists.

Where it will succeed: single artifact + an explicitly-passed glossary path + a human present to answer gates → L1, L4, L6, near-match, L8 write-back, L9 all execute as written. The HITL write-back contract (show exact text, per-change approve, preserve structure) is genuinely well-specified.

### 3. Writing effectiveness

Generally clear and well-structured (Inputs / per-rule Instructions / DO NOT / Workflow / Template). Concrete problems:

- **Redundancy: the check list is stated three times.** Once as Instructions (§L1–L9), once compressed in Workflow step 3 (151–155), and the report template repeats the section names again (172–204). The Workflow step-3 bullets duplicate the Instructions headers nearly verbatim and could be cut to a one-line "run §L1–L9 in order."
- **G7 section is near-empty padding** (97–102): it adds no mechanism over L6+L8. Compress to one line under L8, or drop the standalone heading.
- **Fallback chain is specified twice** (Inputs 32–40 and Workflow step 1, 146–148) with slightly different wording — single-source it.
- **"domain-significant" undefined** (L6, line 75) — the single biggest under-specification; needs an explicit heuristic.
- **L2's `_Avoid_` dependency is buried** — the skill should state up front "if the glossary has no avoid-list, fall back to flagging plausible synonyms by judgment," otherwise the instruction is silently inert.
- **Filename casing/location** — `docs/CONTEXT.md` vs the rule's `context.md`; pick the rule-correct form and add the root/per-context location.
- **L9 role string** — quote the canonical one-liner from the rule rather than "a one-line role description."
- **Minor contradiction** — Inputs step 4 says report-only mode "can still flag storage-shaped and inconsistent names," but L1 (verbatim) is inherently impossible without a glossary; the text acknowledges this ("L1 verbatim checks are limited") but the two statements sit awkwardly. Tighten to: without a glossary, run L4 only; L1/L2/L6/L8 are degraded/skipped.

Length is otherwise reasonable; the bloat is concentrated in the triple-stated checklist and the G7 stub.

### Recommended refactor actions
1. **Fix the glossary fallback chain (highest priority):** add root-level / per-bounded-context `context.md` (rule-correct name and casing) ahead of `docs/CONTEXT.md`/`docs/glossary.md`, so the skill actually finds the L8-mandated file. This is what makes or breaks the skill.
2. **Make L2 robust without an `_Avoid_` list:** add an explicit fallback to flag plausible synonyms by judgment when no avoid-list exists; stop reporting an empty table as "clean."
3. **Define "domain-significant" for L6** with a concrete heuristic (actors, entities, status values, capitalized domain nouns; exclude generic English) so flagging is deterministic.
4. **Correct the L7 claim:** either add real bounded-context/context-map handling (same word, different context) or downgrade the overview claim from "enforces L7" to "partial — intra-glossary near-matches only."
5. **Name L3 explicitly** with its layer caveat ("technical suffixes are allowed in technical layers"), or state L3 is out of scope — remove the current ambiguity.
6. **Wire the near-match gate decisions back into the L1/L2 report tables**, and add batching + a defined non-interactive fallback so the HALT loop doesn't stall large or AFK runs.
7. **Cut redundancy:** collapse Workflow step-3 bullets and the duplicated fallback chain into single sources; reduce the G7 section to one line folded under L8.
8. **L9 polish:** quote the canonical pointer role-string from the rule, and gate the L9 check on "a glossary exists" so it doesn't nag on glossary-less projects.

---

## `pareto-scope-cut` — lens
- [x] refactored

### 1. Guardrail coverage

Going rule-by-rule through `gr_greenfield.md` (G1–G10) against the actual SKILL.md text:

- **G1 (Boring, Explicit, Replaceable First)** — **COVERED.** Classification table row G1 (line 39) restates the rule faithfully: "clever, generalized, or 'future-proof' design where a simpler explicit one meets the current need." Matches rule text (line 18). Claim verified.

- **G2 (First Vertical Slice Before Layers)** — **OUT OF SCOPE, correctly.** Not in the skill. Overview claims it's deliberately excluded. Verified — G2 is build-sequencing, not a single-artifact scope-cut concern. Reasonable. (Minor: one could argue a "this whole artifact is layers before any slice exists" smell is detectable in a planning doc, but excluding it is defensible.)

- **G3 (Defer Expensive Decisions)** — **COVERED.** Row G3 (line 40) names the canonical examples (plugin systems, multi-tenancy, i18n, advanced patterns) verbatim from rule text (line 24). Claim verified.

- **G4 (Establish Conventions Once)** — **OUT OF SCOPE, correctly.** Not present; correctly excluded — convention-setting is not deferrable scope.

- **G5 (No Premature Abstraction)** — **COVERED.** Row G5 (line 41) restates "Extract shared structure ONLY when reused twice" / "fewer than two concrete cases." Matches rule text (line 30). Claim verified.

- **G6 (No Premature Framework)** — **PARTIAL / GAP vs. claim.** Overview says G6 is "deliberately out of scope." But the skill's G3 row *already pulls in* "plugin systems" — which `gr_greenfield.md` lists under **G6** (line 33), not G3. So the skill silently absorbs part of G6 under the G3 label. This is a real misalignment: an agent flagging a premature ORM/message-bus/framework has no rule ID to cite (G6 isn't in the table), yet "plugin system" appears under G3. Either G6 belongs in scope (frameworks/ORMs are a classic gold-plating deferral and squarely in this skill's purpose) or the "plugin systems" example should be removed from the G3 row to keep the claimed boundary clean. **This is the most substantive coverage finding.**

- **G7 (Initial Domain Vocabulary Recorded)** — **OUT OF SCOPE, correctly.** Owned by `ubiquitous-language-guard`. Verified.

- **G8 (Initial Testing Strategy)** — **OUT OF SCOPE, correctly.** Verified.

- **G9 (Record Postponed Decisions)** — **COVERED**, and it is the skill's spine. Dedicated section (lines 46–58), format line, example, and a DO-NOT (line 86) forbidding deferral without a G9 record. Claim verified and well-realized.

- **G10 (Smallest Architecture for Next Known Requirement)** — **COVERED.** Row G10 (line 42): "sized for a multi-release roadmap rather than the next concrete requirement." Matches rule text (line 44). Claim verified.

**Summary:** Claimed coverage G1/G3/G5/G9/G10 is delivered. Claimed exclusions G2/G4/G7/G8 are clean. **The one defect is G6:** claimed out-of-scope but partially smuggled in via the "plugin systems" example under G3, leaving framework/ORM/message-bus deferrals citable to no rule despite being core to this skill's stated purpose ("flag premature abstraction," "build only what we need now").

### 2. Will the purpose be achieved?

Mostly yes — the in-scope/deferred split, G9 log format, and HITL append are concrete and runnable. But several failure modes:

- **Scope-marker resolution is under-specified (highest risk).** Step 1 (line 26) says the marker is "typically a milestone or phase marker named in a planning doc" and to "ask the user … otherwise." But the skill never says *where to look* or *how to read* the marker's contents. To classify "needed by the current marker," the agent must know **what the marker actually requires** — yet the skill only resolves the marker's *name*, never its *requirement set*. An agent given marker "M2" but not M2's requirement list cannot reliably decide in-scope vs. deferred; it will fall back to guessing despite the "NEVER guess" instruction. Missing input: the concrete requirement(s) the marker commits to.

- **"Concrete requirement at or before the current scope marker" assumes an ordering the skill never establishes.** Line 44 uses "at or before," implying markers are ordered (phases/milestones in sequence). The skill provides no way to determine ordering, so "before" is undecidable on a bare marker name.

- **Redundancy between "Instructions" and "Workflow" risks divergence.** The two numbered lists (lines 24–31 and 89–102) describe the same procedure. They're currently consistent, but an agent reading both spends effort reconciling them, and future edits can desync them. The Workflow list is the more complete one (adds the validation block).

- **Classification of non-deferred-but-also-not-needed items is ambiguous.** The model is strictly binary (line 28: "either in-scope or deferred"). An item that is *neither* required now *nor* a future/imagined feature (e.g., genuinely dead/irrelevant content) has no bucket. Minor, but the binary forcing plus "when unsure, ask" (line 44) can stall on edge items.

- **Append-only on every re-run will accumulate duplicate sections.** Output is appended to the END of the artifact (line 62, 97). Re-running the skill on an already-cut artifact produces a *second* "## Scope split" and "## Postponed decisions" block. The skill has no idempotency/update path and its DO-NOT (line 87) only addresses re-deciding a postponed line, not duplicate section headers. Real failure mode for the "step-agnostic, re-runnable lens" framing.

- **The validation step (lines 98–102) is solid** — exactly-once classification, every deferred item has a G9 line, no in-scope deletion, marker named in heading. This is the strongest part and will catch most agent slips.

Net: it will achieve the purpose **only when the agent is also handed the marker's requirement contents**. As written, the marker is resolved by name alone, which undercuts the core classification step.

### 3. Writing effectiveness

- **Duplication: "Instructions" (24–31) vs "Workflow" (89–102) are ~90% the same.** This is the biggest verbosity issue — two near-identical 6–8 step procedures. Recommend collapsing to one numbered procedure (keep the Workflow version with its validation block) and deleting the other, or making "Instructions" a 2-line intent statement.

- **G9 format duplicated three times with drift.** The postponed-decision line appears at line 51 (`Reason: <imagined/future need, not at <marker>>`), and again at line 76 inside the Output template (`Reason: <why, cites G1/G3/G5/G10>`). These two templates are *not identical* — line 51 doesn't mention citing a rule ID, line 76 requires it. Pick one canonical format. The line-76 version (with rule-ID citation) is better and should win, because the validation step (line 100) requires the citation.

- **"Source" column in the classification table (lines 37–42) is low-value.** It restates a paraphrase of each rule's title ("Boring, explicit, replaceable first") that duplicates the "Flag when" cell. The rule ID already links to the source. Cuttable.

- **Under-specified, should be ADDED, not cut:** how to obtain the marker's requirement set (see §2). One sentence — "Also read the requirements the marker commits to (from the planning doc that names it); classify against those, not against the marker name alone" — would close the biggest gap.

- **"abstraction/structure" / "any introduced abstraction" (lines 27, 92)** is vague as an enumeration target. For a *planning artifact* (requirements/entity model/use-case diagram), "abstraction" is fuzzy — concrete examples (a generic base entity, a catch-all "Item" supertype, an interface actor) would make enumeration actionable.

- **Good and worth keeping:** the worked example (lines 56–58), the DO-NOT block (largely — see G6 note), and the explicit HITL gate phrasing.

### Recommended refactor actions

1. **Resolve the G6 inconsistency** (highest priority): either bring G6 into the classification table (frameworks/ORM/message-bus deferral — fits the skill's purpose) and update the overview, **or** remove "plugin systems" from the G3 row to honor the claimed G3-only boundary. Currently the skill and overview contradict the rule file.
2. **Add marker-content resolution to Step 1:** require reading the *requirements the marker commits to*, not just its name; state how ordering ("at or before") is determined. This closes the top failure mode.
3. **Merge "Instructions" and "Workflow"** into one procedure (keep the validation block); delete the duplicate.
4. **Make the G9 line format canonical once** (use the rule-ID-citing version from line 76); remove the divergent line-51 variant or align it.
5. **Add an idempotency rule:** on re-run, *replace* existing "## Scope split" / "## Postponed decisions" sections rather than appending duplicates.
6. **Cut the "Source" column** from the classification table; the rule ID already carries provenance.
7. **Make "abstraction/structure" enumeration concrete** with 2–3 planning-artifact-level examples.

---

## `domain-model` — fork
- [x] refactored

### 1. Guardrail coverage

**gr_ddd (D1–D9):**

- **D1 — Keep Domain Rules Inside the Domain.** Overview claims this is "left to code-level skills." This is the central misclassification. D1 says business invariants belong in *domain types* — and a conceptual domain-model document is precisely the artifact that declares *which* domain type owns each invariant. The skill already does the substance of D1: lines 73–84 turn implied business rules into explicit validation rules and lines 80–83 assign cross-member invariants to the **aggregate-root** ("the boundary is where consistency is enforced") rather than to a controller/repository/helper. That IS D1 placement at the conceptual level. **Verdict: covered in substance but unattributed.** D1 should be cited alongside D3/D9; claiming it is out of scope is wrong. The skill never names D1.

- **D2 — Respect Aggregate Boundaries.** Covered. Lines 67–69 (relationships point to the root), 82–83, Mermaid rule line 183, cross-validation line 256.

- **D3 — Enforce Invariants at Construction.** Covered conceptually. Lines 79–81 frame Constraints as "construction-time invariants" so "an instance cannot exist in an invalid state." Appropriate translation of a runtime rule into the model artifact.

- **D4 — Domain vs Application Services.** Correctly out of scope (no services in a conceptual ER model). Fine.

- **D5 — Value Objects Are Immutable.** Covered. Classification table line 56–59, rules line 64–66 (immutable, no identity, no surrogate column), cross-validation line 252.

- **D6 — Domain Events Describe Facts.** Out of scope. Defensible (no events in this artifact), but see note below — the skill silently excludes events. If the glossary names a domain event, the skill gives no guidance on how to model/exclude it. **Minor gap, acceptable.**

- **D7 — Bounded Context Boundaries.** Claimed out of scope. Mostly defensible, BUT the skill is single-document and assumes one context. It never asks whether the glossary spans multiple bounded contexts (cf. L7, L8 "one context.md per context"). If terms from two contexts collide, the skill would silently merge them. **Partial gap** — at minimum the skill should note it models a single bounded context.

- **D8 — No Generic Helper Code.** Correctly out of scope (code-structure rule).

- **D9 — Validation Lives Where the Invariant Lives.** Covered. Lines 73–84, "Never leave a Validation Rules cell empty," reference table lines 186–199.

**gr_architecture (A9 + others):**

- **A9 — Keep Infrastructure Out of Domain.** Strongly covered — the skill's backbone. Lines 87–92, DO NOT lines 99–103, Conceptual/Physical mode, cross-validation line 255. Best-covered rule.

- **A10 — No Speculative Extension Points.** Relevant but uncited. The cross-validation line 260 ("No out-of-scope or deferred term was pulled in") and DO NOT line 96 ("Force a surrogate id onto every term") are A10-shaped (no speculative entities/columns "in case"). **Partial / uncredited** — worth a one-line A10 citation since it disciplines against modeling future-need entities.

- **A1/A2** (layering, dependency direction) — out of scope for a conceptual artifact; fine to omit.

**gr_domain_language (L1,L2,L4,L6):**

- **L1 Use Defined Terms Exactly** — Covered (lines 46–49, 181, 258).
- **L2 No Forbidden Synonyms** — Covered (lines 48–49, DO NOT line 104).
- **L4 Naming Reflects Behavior Not Storage** — Covered *implicitly* via the A9/anti-storage-name machinery, but **L4 is never cited by ID** and there is no explicit "do not name a term after its storage shape (e.g. `MessageRow`, `OrderDTO`)" instruction. The skill bans storage *datatypes* and *infra fields* but does not explicitly ban storage-shaped *names*. **Partial.**
- **L6 Introduce New Terms Explicitly** — Covered (DO NOT lines 104–106).

**Explicit MISSING / partial list:**
- D1 — covered in substance, **wrongly disclaimed** as out of scope; must be cited.
- L4 — partial: storage-shaped *naming* ban not explicit, ID not cited.
- A10 — partial/uncited: anti-speculation discipline present but uncredited.
- D7/L7 — partial gap: no single-bounded-context assumption stated; multi-context glossary collision unhandled.
- D6 — minor: domain events silently unaddressed.

### 2. Will the purpose be achieved?

Largely yes — the skill is concrete and an agent following the Workflow (lines 228–260) would produce a structurally correct conceptual model. But several failure modes:

- **Classification is the hard step and is under-supported.** The Entity/VO/Aggregate test table (lines 56–60) is sound, but the genuinely difficult decisions — *which entity is the aggregate root*, *where do aggregate boundaries fall* — get one sentence (line 67–69) and no procedure or example. An agent will likely under-aggregate (flatten everything to standalone entities) or mark every entity a root. No worked example of a non-root member exists. **Primary failure mode.**

- **"Implied invariant" extraction is unbounded and unguided.** Line 75 lists four sample phrasings, but there is no procedure for scanning requirements/ADRs systematically. Different runs will surface different invariants; recall is luck-dependent. The companion `hidden-constraint-sweep` is the discipline here, but the skill doesn't point to it.

- **"Never leave a Validation Rules cell empty" (line 84) invites cargo-culting.** An agent will stamp every optional/unknown field `Not Null` or `Optional` to satisfy the rule, manufacturing invariants that weren't in requirements. The mandate to fill every cell can conflict with "don't invent."

- **Mode detection is fragile.** "storage target is explicitly declared" (line 125) is judgment-heavy. An ADR mentioning "PostgreSQL" in passing (not as a persistence decision for these entities) could wrongly flip the whole model to physical. No tie-breaker / default-to-conceptual-on-doubt rule. (The default *is* conceptual, but the switch criterion is vague.)

- **Glossary-absent path is weak.** When no glossary exists (lines 41–42), the skill warns then derives terms from `requirements.md` — but gives no method for extracting candidate terms from prose, and verbatim-naming guarantees evaporate. The output quality silently degrades with no flag in the document beyond the header line.

- **Missing input handling.** No instruction for when `docs/requirements.md` itself is absent (the *required* input). Only the glossary has a fallback chain; the required source does not.

### 3. Writing effectiveness

Generally tight and actionable, but with notable redundancy and a few gaps:

- **Heavy redundancy across sections.** The conceptual-vs-physical / no-storage-datatype rule is stated at least five times: lines 31–33, 87–92, DO NOT 99–103, "Conceptual vs Physical Mode" 114–136, Type Reference 206–220, and cross-validation 253–254. The same for "no surrogate id / VO no identity" (lines 64–66, 97–98, 109, 244, 252). This is the bulk of the document and could be consolidated ~30%.

- **Document-structure spec is stated three times.** "Required Format for Each Term" (168–177) restates the embedded markdown template (140–163) which restates the per-term workflow step (240–247). Pick one canonical place.

- **Two validation-rules reference tables drift risk.** Lines 186–199 (Validation Rules Reference) and 206–220 (Conceptual Type Reference) are adjacent and overlapping in spirit; fine to keep both but the physical-mode carve-outs are repeated in each.

- **Under-specified, concrete spots:**
  - Aggregate-root selection — no procedure/example (see §2).
  - "Identifier (natural)" type vs "Identity (natural)" validation value (lines 215 vs 196) — two near-identical strings for related-but-different roles; an agent will conflate them. Clarify.
  - Line 162/226 use a Reservation example ("end after start") that is unrelated to the ai-mail domain shown in the ER example (ACCOUNT/MESSAGE, line 150–151). Inconsistent examples; pick one domain.

- **Good, keep:** the DO NOT block (94–112) is crisp; the cross-validation checklist (248–260) is genuinely useful and self-checking; the mode/glossary header convention (143–144) is clean.

### Recommended refactor actions
1. **Cite D1 and stop disclaiming it.** Add D1 to the invariant section (lines 73–84) and correct the overview's "left to code-level skills" claim — assigning invariants to the owning domain type *is* D1 at the conceptual level.
2. **Add an aggregate-root selection procedure + one worked non-root-member example.** This is the skill's weakest operational step and primary failure mode.
3. **Make L4 explicit:** add a one-line ban on storage-shaped *names* (`MessageRow`, `OrderDTO`) distinct from the existing datatype/field bans, and cite L4 by ID.
4. **Tighten the "never leave a cell empty" rule** so it cannot manufacture invariants — e.g. "use `Optional` only when requirements are silent; do not invent `Not Null`/ranges not implied by the source."
5. **De-duplicate the conceptual-vs-physical and no-surrogate-id material** (currently 5–6 restatements each) into one authoritative section; collapse the three document-structure restatements into one.
6. **Harden mode detection:** define "storage target declared" precisely (a persistence decision for *these* entities, not an incidental tech mention) and default to conceptual on doubt.
7. **Add handling for missing `docs/requirements.md`** (the required input has no fallback) and a stronger flag when proceeding glossary-less.
8. **State the single-bounded-context assumption** (D7/L7) and resolve the `Identifier (natural)` vs `Identity (natural)` naming collision; unify the example domain.
9. Optionally cite **A10** on the anti-speculative-entity check and point the invariant-extraction step at `hidden-constraint-sweep` for recall.

---

## `domain-requirements` — fork
- [x] refactored

### 1. Guardrail coverage

**gr_idea (distillation arc — `ide`→`prd`).** PARTIAL/MISSED. The overview claims this skill "operationalizes the requirements/specification step of gr_idea." But gr_idea is explicitly *not a PRD/spec* skill: Idea1 says output is "3–6 major goals," Idea2 forbids acceptance criteria, module names, NFRs. gr_idea ends at `idea.md`; it does not define requirements.md at all. The skill never reads `idea.md`, never references the 3–6 goals, never traces FRs back to goals. So the gr_idea linkage in the overview is largely a category error — the skill sits at the `prd` step, not the `ide` step. The one genuine touch point that *should* be honored — Idea3 negative goals → Aln15 negative decisions → out-of-scope — is not wired in (see Aln15 below). Net: the claimed gr_idea coverage is overstated; the actual relevant carry-forward (negative goals → out-of-scope) is MISSED.

**Aln13 (PRD summarizes alignment, does not replace it).** MISSED in substance, despite the overview claiming it. Aln13's content is: the requirements/PRD doc is a *destination summary* of the alignment transcript (`<artifacts>/<WI>/algn_transcript.md`), not the source of truth. The skill derives requirements from `docs/vision.md` only — it never reads or references an alignment transcript, never positions requirements.md as a summary, never warns against treating it as the design concept. Line 22–24 calls the file "the AIUP-chain contract," which is the opposite framing (source-of-truth, not summary). The overview asserts Aln13 coverage; the SKILL.md does not deliver it. CLAIMED-BUT-NOT-DELIVERED.

**Aln15 (negative decisions carried into out-of-scope).** MISSED. This is the most concrete gap. Aln15 requires that decisions *not* to do something are carried forward into the PRD's out-of-scope section. The skill has FR/NFR/Constraints tables but **no Out-of-Scope / Non-Goals section at all**, and no instruction to capture negative decisions. The "Constraints (C)" table is about technical/business *limitations* (Java 21, budget, deadline), not deliberate scope exclusions — they are not the same thing. The overview explicitly claims "Aln15 out-of-scope/constraints carried forward," but neither SKILL.md nor REFERENCE.md contains an out-of-scope construct. CLAIMED-BUT-NOT-DELIVERED — the single highest-value missing item.

**gr_domain_language L1 (use defined terms exactly).** COVERED, and this is the fork's real, well-executed change. Verbatim use is stated in the intro (lines 28–31), the Instructions (40–43), the Consume section (64–66, with the explicit "no casual variation, abbreviation, translation, pluralization, or re-casing"), the DO-NOT list, a dedicated "Verbatim" quality check (line 144), and the POST self-check (185, 189–190). Genuinely solid.

**L6 (introduce new terms explicitly).** COVERED on the read/consume side. Lines 70–72, the DO-NOT bullet (85–87), Error Recovery "Concept not in the glossary" (157–158), and POST self-check (191–192) all say: do not silently coin; flag for the `ubiquitous-language-guard` write-back loop. This correctly *stops at flagging* and does not itself write back, which respects the consume-only boundary. One weakness: the "flag" has no defined output shape — there is no section, list, or template where flagged terms land (see §2).

**L8 (CONTEXT.md as source of truth — read side).** COVERED on read side, and correctly *not* on write side. Lines 30–31, 74–76, and the overview's note all keep write-back with `ubiquitous-language-guard`. The Glossary Resolution block (47–55) treats the resolved file as ground truth. Minor inconsistency: the POST self-check cites "(L8)" at line 191–192 for the *write-back flag*, but L8 is the artifact/source-of-truth rule; the flag-for-write-back behavior is L6. Mild mis-citation.

**Glossary fallback / degrade-to-stock.** COVERED and specified well — arguably the cleanest part. Resolution order (argument → `docs/CONTEXT.md` → `docs/glossary.md` → warn) appears three times consistently (lines 49–53, 162, plus Error Recovery 155–156), the warn string is concrete, "never hard-code a single filename" is explicit, and the degrade path (generic roles, terms from vision, re-run advice) is spelled out. This matches the overview claim exactly.

**Consume-only boundary (the intended fork limit).** COVERED — the skill stays consume-only and does not overreach. It repeatedly disclaims enforcing, evolving, flagging forbidden synonyms, halting on near-matches, or writing back (lines 29–31, 74–76, 88, 159). No underreach on consumption either. The boundary discipline is the skill's strongest dimension.

**MISSING / PARTIAL summary:**
- MISSING: Out-of-Scope / Non-Goals section (Aln15) — claimed, not delivered.
- MISSING: any link to the alignment transcript / "summary not source" framing (Aln13) — claimed, not delivered.
- MISSING: negative-goals carry-forward from gr_idea Idea3 → Aln15.
- PARTIAL/overstated: gr_idea "requirements step" framing (skill is `prd`-stage, gr_idea is `ide`-stage).
- PARTIAL: flagged-new-term output has no defined shape.
- Minor: L6/L8 citation swap at lines 191–192.

### 2. Will the purpose be achieved?

For the narrow fork purpose — *produce a requirements.md whose actors and domain nouns come verbatim from the glossary* — yes, an agent following this skill will very likely succeed. The verbatim instruction is stated in 6+ places, the resolution chain is unambiguous, and the quality-check + POST-self-check loops reinforce it. The fork delivers its one intended change.

Failure modes:

1. **Actor extraction is undefined.** The skill says "draw FR roles from the glossary's actor / role terms" but never says *how to identify which glossary entries are actors*. Real glossaries (CONTEXT.md per L8) define entities, status values, relationships, and actors all together. With no heuristic ("an actor is a term that initiates a use case / is a human or system role"), an agent may treat domain nouns like "Order" or "Invoice" as actors, or miss the real ones. This is the most likely silent failure of the core purpose.

2. **The flag-for-write-back loop has no landing place.** L6 flagging is instructed repeatedly but there is no output section ("Flagged terms for ubiquitous-language-guard") in the document template. An agent told to "flag it and note it for user review" with nowhere to write it will most likely just inline-coin the term anyway — exactly the silent-invention the rule forbids. The consume-only intent is correct but the mechanism to honor it is missing.

3. **Vision-only input contradicts the alignment chain.** Because the skill reads only `docs/vision.md` + glossary (never `idea.md` or the alignment transcript), negative goals and rejected options decided during grilling cannot reach the requirements doc. This is the structural cause of the Aln13/Aln15 gaps above — not just a missing section but a missing *input*.

4. **No Out-of-Scope output means scope cannot be defended.** Even if the user states "we are explicitly not doing X," the skill has no row/section to record it. It will be dropped.

5. **Quality-check enforcement is advisory.** The "Verbatim" check and POST self-check are good, but there's no instruction to *halt* on a verbatim violation the way the consume-only sibling does — it's a self-review, easily skipped under load. Acceptable for a consume-only fork, but worth noting the verbatim guarantee is soft.

### 3. Writing effectiveness

Generally clear and actionable; the fork-specific additions are well-signposted. Concerns:

- **SKILL.md vs REFERENCE.md split is fine but stale.** REFERENCE.md is identical to the stock reference (ID prefixes, priority, status, categories) — pure lookup tables, correctly offloaded. Good progressive disclosure. But REFERENCE.md was *not* updated for the fork: it has no Out-of-Scope category, no actor-identification guidance, no flagged-term format. If the refactor adds those constructs, REFERENCE.md is where the enumerations belong.

- **Significant redundancy inside SKILL.md.** The verbatim/consume-only instruction is repeated in five places: intro (28–31), Instructions (40–43), "Consume the glossary" (59–76), DO-NOT (84–88), and POST self-check (186–192). The "Consume the glossary" section and the DO-NOT bullets and the POST self-check substantially restate each other. This is more than emphasis — it's ~3x duplication of the same four points. One canonical "Consume the glossary" block plus a one-line DO-NOT pointer would be tighter.

- **Error Recovery duplicates Workflow/Consume content.** "Missing stakeholder roles," "Missing glossary," and "Concept not in the glossary" (153–158) repeat what's already in Glossary Resolution and the Consume section. Consolidatable.

- **Example tables are stock and slightly off-message.** The FR examples use "project manager"/"team member" and the constraints use generic Java/PostgreSQL/budget rows. For a *glossary-aware* skill, at least one worked example showing a glossary-actor-derived role (vs. the generic "User/Admin/System" it warns against) would teach the one behavior that matters far better than re-showing the stock tables.

- **"AIUP-chain contract" framing (22–24) sits in tension with Aln13.** As written it tells the agent requirements.md is *the* contract downstream reads — fine for chain mechanics, but it should also note the doc is a *summary* of upstream alignment, not the origin of the design, or it actively pushes against Aln13.

### Recommended refactor actions

1. **Add an Out-of-Scope / Non-Goals section** (table or list) to the document template and Workflow — this closes the Aln15 gap that the overview already claims. Add an `Out-of-Scope` enumeration to REFERENCE.md. (Highest value.)
2. **Add a "Flagged terms for ubiquitous-language-guard" output section** so L6/L8 flagging has a concrete landing place; otherwise the consume-only boundary leaks into silent coining.
3. **Specify actor identification**: one or two sentences (or a REFERENCE.md note) on how to recognize actor/role terms within a CONTEXT.md-style glossary, so the core fork behavior doesn't misfire.
4. **Wire in the alignment inputs**: read `idea.md` negative goals and/or the alignment transcript, and reframe requirements.md as a *summary* of alignment (Aln13) carrying negative decisions forward (Aln15/Idea3). At minimum, soften the "AIUP-chain contract" line to acknowledge the summary role.
5. **De-duplicate the consume-only messaging**: collapse the five restatements into one canonical block + short pointers; fold the redundant Error Recovery glossary bullets into Glossary Resolution.
6. **Fix the L6/L8 citation** at the POST self-check (flag-for-write-back is L6, not L8).
7. **Re-cast at least one worked example** to show a glossary-derived actor, demonstrating the anti-"User/Admin/System" behavior.
8. **Correct the overview** (`skills_overview.md`) to stop claiming full gr_idea "requirements step" and delivered Aln13/Aln15 coverage until the skill actually implements out-of-scope + alignment-summary framing — today those are claimed-but-not-delivered.

---

## `adr-threshold-gate` — lens
- [x] refactored

### 1. Guardrail coverage

Per-rule walk through gr_adr.md (Adr1–Adr10):

- **Adr1 — Three-Part Threshold: COVERED.** The skill carries all three criteria verbatim into a table (SKILL.md lines 46–50) and states the AND-gate ("Write an ADR only when all three hold", line 44). The out-of-scope examples (interchangeable / easily-reversible / routine style) and the "ADR noise dilutes signal" rationale are reproduced (lines 52–54). The "if any fails, one-line no-ADR note naming the failed criterion" loop (lines 39–40, 147–148) is a genuine, faithful operationalization. Solid.

- **Adr2 — Durable, In-Tree / NNNN numbering: PARTIAL.** The path shape `docs/adr/NNNN-<kebab-slug>.md`, zero-padded monotonic integer, and the explicit ban on date-numbering are all present (lines 105, 119–120, 128–131). **Missing:** the *durability* half of Adr2 — "ADRs are not retired like PRDs/research; an ADR persists as long as the decision is in force; superseded, never deleted silently." The skill never states ADRs are durable/non-retired. In practice this matters little for a single-artifact gate (the skill only ever *creates* `proposed` ADRs, never retires), so the omission is low-risk, but the claim "Adr2 covered" is only ~half true.

- **Adr3 — ADR vs Aln15 rejected-option: MISSED (claimed out of scope).** See assessment below — **this punt is NOT safe.**

- **Adr4 — ADR vs PRD: MISSED (claimed out of scope).** See assessment below — **also not fully safe.**

- **Adr5 — Required Sections: PARTIAL, with two real defects.**
  1. The skill's template (lines 75–98) lists **5** body sections (Title / Status / Context / Decision / Consequences / Alternatives). Adr5 mandates the section be titled **"Alternatives Considered"** (line 58); the skill renames it to **"Alternatives"** (line 95). Minor, but it is a verbatim-divergence from the guardrail and from the slug-grep discipline the skills_overview claims is "carried over verbatim."
  2. **Status enum is silently narrowed.** Adr5.2 requires Status be one of `proposed | accepted | superseded by NNNN | deprecated`. The skill's template hardcodes `proposed` (line 80) and never tells the agent the legal enum. Combined with the DO-NOT on flipping status, an agent has no vocabulary for `superseded`/`deprecated` at all. Acceptable for a create-only gate, but the template should at least comment the legal values.
  3. The skill correctly enforces Alternatives as mandatory and explains why (lines 100–101, 118) — that part is good.

- **Adr6 — Author at decision time: MISSED (claimed out of scope).** Reasonable: the skill is step-agnostic and explicitly handles both pre-decision plans and post-decision diffs, so timing-preference is genuinely orthogonal. Safe punt.

- **Adr7 — Supersede, Don't Mutate: PARTIAL.** The skill forbids editing an already-`accepted` ADR's body and names supersession as the rule (lines 124, 123). But it stops at "out of scope here" — it never gives the agent the *mechanism* (flip original to `superseded by NNNN`, write a new ADR referencing it). That is defensible for a gate whose only write is a fresh `proposed` ADR. The skills_overview claim ("refuses to edit an already-accepted ADR's body, deferring supersession") matches what's delivered. Acceptable.

- **Adr8 — Agent May Draft, Human Must Accept: COVERED.** The `proposed`→`accepted` flip is declared human-only, never silent (lines 113–115, 149–150), and there are two distinct gates: the "ADR-worthy?" ask before drafting (lines 56–69) and the approval-to-write gate (line 144). This is the skill's strongest part and faithfully realizes Adr8.

- **Adr9 — ADRs as pull-source for implementation: MISSED (claimed out of scope).** Correct — this is an afk-loop/arch-review concern. Safe punt.

- **Adr10 — Review Verifies ADR Coverage: PARTIAL/COVERED.** The skill's post-decision (diff) mode does realize the coverage question ("did any decision cross the threshold without an ADR?"). But there is a gap: the input list (lines 27–28, 135) reads `docs/adr/*` only to derive the next NNNN — the skill **never instructs the agent to compare extracted decisions against already-captured ADRs to skip ones already covered.** The skills_overview *claims* this ("avoid re-drafting an already-captured decision", overview line 197), but SKILL.md does not say it. So Adr10's "without an ADR" qualifier is asserted in the overview but **not delivered in the skill body** — a claimed-but-not-delivered gap. As written, the agent could re-draft an ADR for a decision already recorded.

**Critical assessment of the Adr3 / Adr4 punts:**

The overview frames Adr3/Adr4 as "alignment/PRD/implementation-loop concerns outside a single-artifact threshold gate." This is the **weakest reasoning in the whole skill**, and the review disagrees for Adr3:

- **Adr3 (ADR vs Aln15 rejected-option) is exactly the distinction the agent needs to avoid drafting noise ADRs.** The skill's whole job is to separate "chosen non-obvious decision" (→ ADR) from everything else. A rejected option is the single most likely false-positive: an agent scanning a plan or grilling transcript will see "we considered X but went with Y" and is strongly tempted to draft an ADR *about X*. Adr3's anti-pattern ("Capturing a rejected option in an ADR") is precisely the failure mode the threshold gate exists to prevent — yet the skill drops it. The skill *does* require that the *chosen* decision's Alternatives section name the rejected option, which partially guards against this, but it never tells the agent "the ADR is about the road taken, not the road rejected." This punt is **not safe**; the distinction belongs in the skill as a one-line guard.

- **Adr4 (ADR vs PRD) is moderately important.** Its value is preventing the agent from drafting an ADR that just restates *what* was decided (PRD's job) instead of *why* (ADR's job). The skill partially covers this implicitly: the template's Context/Decision/Consequences shape and "stated imperatively"/"why" framing nudge toward rationale. But there is no explicit "an ADR captures *why*, not *what*" guard, and that is a real recurring failure mode (drafting a fat restatement-of-decision ADR). Lower priority than Adr3 but worth one line.

### 2. Will the purpose be achieved?

Mostly yes for gating, but several failure modes:

- **Over-drafting from rejected options (highest risk).** As above — without the Adr3 distinction, the agent will tend to spin up ADRs for considered-but-rejected alternatives, the exact noise the gate is meant to suppress.

- **Under-skipping already-captured decisions (Adr10 gap).** The skill reads `docs/adr/*` only for numbering, never for dedup. On a repo that already has ADRs, re-running the skill over a diff will happily re-draft an ADR for a decision an existing ADR already covers. The "avoid re-drafting" behavior exists only in the overview, not the skill.

- **Decision extraction is under-specified.** Step 1 (line 30) says "extract every distinct design decision … not a routine style or wording choice." There is no guidance on granularity — is "use Postgres + use JSONB columns + partition by tenant" one decision or three? Mis-granularity directly drives both over- and under-drafting, and the skill gives the agent nothing to calibrate on.

- **Numbering race within a single run is handled, but cross-run collision is not.** Lines 145/146 increment NNNN per qualifier within one run; fine. But there's no note about concurrent/parallel runs or uncommitted prior drafts — minor.

- **Two-gate flow is sound.** The "ADR-worthy?" ask + approval-to-write + never-flip-to-accepted chain is well-formed and will reliably keep a human in the loop. No failure mode here.

- **No input-resolution / missing-artifact handling.** Unlike sibling lenses (trace-check, hidden-constraint-sweep) which specify a fallback chain and a "ask which artifact" behavior, this skill assumes the artifact and `docs/adr/` are simply given. If `docs/adr/` is absent it says start at 0001 (good), but if no artifact is named it has no "ask first" instruction. Minor.

### 3. Writing effectiveness

Generally tight and actionable. Concrete issues:

- **Redundancy: the Instructions block (lines 25–40) and the Workflow block (lines 134–152) are near-duplicates.** Both enumerate: read artifact + list ADRs → extract decisions → apply threshold → HITL ask → draft → gate write → no-ADR note. This is ~40 lines saying the same thing twice. One of them should go (keep Workflow, which is the more complete numbered procedure; cut Instructions or reduce it to a one-line orientation).

- **"Alternatives" vs "Alternatives Considered" inconsistency** (template line 95 vs guardrail Adr5 / overview which both say "Alternatives Considered"). Pick one; match the guardrail.

- **Status enum under-specified** (line 80 hardcodes `proposed` with no comment on the legal set) — see Adr5 above.

- **The DO-NOT list (lines 110–124) overlaps heavily with the inline prose.** "Draft an ADR without an Alternatives section" appears at lines 101, 118; the interchangeable/reversible/style exclusion appears at lines 52–54, 116–117; the no-flip rule at 113–115 and 149–150. Some reinforcement is fine for a hard rule, but three copies of the Alternatives rule is bloat.

- **Good, keep:** the threshold table, the HITL ask template (the `> Decision: … Is this ADR-worthy?` block is concrete and copy-usable), and the draft template fenced block. These are the load-bearing, well-written parts.

### Recommended refactor actions

1. **Add the Adr3 guard (highest priority):** one line stating an ADR captures the *chosen* non-obvious decision, not a rejected option — rejected options live in the alignment transcript (Aln15) and appear only inside the ADR's Alternatives section. This is the main defense against noise ADRs and is currently missing.
2. **Deliver the Adr10 dedup the overview already claims:** instruct the agent to compare each extracted decision against existing `docs/adr/*` and skip (with a one-line "already captured: NNNN" note) any decision an existing ADR already covers — not just read ADRs for numbering.
3. **Add a one-line Adr4 guard:** an ADR records *why* a surprising choice was made, not *what* was decided (that's the PRD/plan) — to prevent restatement-fat ADRs.
4. **Fix Adr5 fidelity:** rename template section to "Alternatives Considered" to match the guardrail, and add the legal Status enum (`proposed | accepted | superseded by NNNN | deprecated`) as a comment even though the skill only ever writes `proposed`.
5. **Add a decision-granularity sentence** to extraction (step 1) so the agent splits/merges decisions consistently — the single biggest driver of over/under-drafting.
6. **Cut the Instructions/Workflow duplication** (~40 lines → keep Workflow, reduce Instructions to one orienting line) and de-duplicate the thrice-stated Alternatives and exclusion rules in the DO-NOT list.
7. **Optional:** add a brief "if no artifact is named, ask which to gate" line and a one-liner that ADRs are durable/never silently deleted (the dropped half of Adr2), to match sibling-lens robustness.

---

## `hidden-constraint-sweep` — lens
- [x] refactored

### 1. Guardrail coverage

**Aln6 (source rule) — well covered, with verified deviations:**
- All 8 classes present and enforced (SKILL.md lines 70–81). Names match Aln6 (gr_algn.md 57–66) verbatim.
- "Fires always at close, regardless of whether the topic plausibly engaged a class" — operationalized strongly: instruction #3 ("Examine all 8 classes — always"), the lead paragraph (lines 18–22), and DO-NOT line 57. Good.
- Three outcomes with mandatory evidence — fully mirrored: `covered`→pointer (line 39–40), `not-applicable`→recorded reason (41–43), `missing`→routed follow-up that **blocks** (44–47). The Verdicts table (85–89) restates the mandatory-evidence rule. This is faithful to Aln6.
- "No silent passes, no 'documented gap' closes that defer to `rev`" — explicitly carried over (line 47: "no deferring the gap to a later review phase as a 'documented gap' that closes the sweep"). Good.

**Partial / weakened items:**
- **Pointer-class mismatch with the source.** Aln6 says a `covered` pointer cites "the relevant transcript entry or `context.md` term" (alignment-time evidence). The skill's pointer kinds are FR/NFR id, section, flow, or glossary term (lines 40, 87). This is a reasonable step-agnostic adaptation (the skill runs on docs, not a grilling transcript), but it is a silent substitution — the SKILL.md never states it is re-mapping Aln6's "transcript entry" to "artifact section/flow." Worth one explicit line so a reader doesn't think a class is being weakened.
- **Aln6's "grill it now" resolution path is dropped.** In Aln6, a `missing` class can be resolved two ways: grill the branch now, OR downgrade to `not-applicable` with reason. The skill only offers *routing to a follow-up* (FR/NFR/alt-flow/deferral) — it never offers the "resolve it in place and re-verdict to covered" path. For a doc-sweep this is defensible (the skill surfaces, it doesn't author), but it means a `missing` can never become `covered` within one run; every `missing` necessarily ends the run `blocked`. That is arguably stricter than Aln6, not weaker — but it should be stated as a deliberate choice, because an agent may otherwise rationalize re-classifying a just-fixable gap as `not-applicable` to avoid a `blocked` verdict (see §2).

**Rev7 (review mirror) — coverage thin:**
- Rev7 (gr_rev.md 75–87) lists 7 conceptual classes (it pairs "Data retention and migrations" on one line and omits out-of-scope) and mandates "A 'not applicable' verdict is **stated, not assumed**." The skill enforces the stated-not-assumed rule well (every `not-applicable` needs a recorded reason). But the SKILL.md body never references Rev7 by ID in its instructions — only the Notes (line 148–154) mentions gr_rev via the reconciliation. The skill is positioned purely as the Aln6 sweep; its role as the Rev7/Rev11 review-time checklist is asserted only in the overview, not surfaced in the skill itself. Since this skill is the *shared* checklist for both phases (coding_plan.md B5: "alignment + review"), the SKILL.md should at minimum name Rev7/Rev11 as the review-side consumers.

**Rev11 (output format) — covered in substance, not in shape:**
- Rev11 (gr_rev.md 110–120) requires an explicit per-class "covered / not applicable / missing" statement. The skill's per-class table (lines 107–116) delivers exactly this and is in fact richer than Rev11 requires. Substantively compliant.
- Gap: Rev11's full reviewer output also wants a top-level **Verdict** (approve/request-changes/block) and **Routing applied**. The skill emits `clean`/`blocked` (its own verdict vocabulary) — fine for a standalone lens, but if this skill is meant to feed a Rev11 review block, the SKILL.md doesn't say how `clean`/`blocked` maps onto approve/block. Minor, but it's the one place the two output formats don't line up and it's unaddressed.

**Reconciliation note (Aln6 8-class vs Rev7 7-class) — verified accurate:**
- Checked all three sources. Aln6 = 8 classes (retention and migrations separate, plus out-of-scope). Rev7 = 7 conceptual (retention+migrations paired, no out-of-scope). coding_plan.md B5 = 7 (security, perms, retention, migrations, observability, API compat, concurrency — no out-of-scope). The SKILL.md Notes (lines 148–154) correctly states "Aln6 enumerates 8 … B5 summary line and Rev7 list 7 (they omit out-of-scope and pair retention+migrations)." **The overview's reconciliation note (skills_overview.md 238) is accurate and matches the rule files.** One nit: the SKILL.md Note cites coding_plan.md B5 as a *source rule* alongside Aln6, while the overview cites only gr_algn/gr_rev. Harmless but inconsistent provenance.

### 2. Will the purpose be achieved?

The skill's purpose — defeating agent judgment so all 8 run every time — is **mostly** achieved, but there are real rationalization escape hatches:

- **The `not-applicable` loophole is the central failure mode.** The skill forbids *omitting* a class but freely permits downgrading any class to `not-applicable` with a one-line reason (lines 41–43, 59). An agent that wants a `clean` verdict can satisfy the letter of the rule by writing a plausible-sounding reason for every borderline class ("Concurrency: N/A — single-user request") without genuinely probing. Aln6 has the same structural risk, but Aln6 is HITL — a human hears the reason and can push back. This skill runs on a doc with no human gate built in, so the only guard against a lazy `not-applicable` is the agent's own honesty — precisely the judgment the skill claims to defeat. **The skill needs a quality bar on `not-applicable` reasons** (e.g. the reason must cite a concrete fact in the artifact/context, not a generic assertion), otherwise "defeats agent judgment" is overstated.
- **`missing` always → `blocked` creates pressure to avoid `missing`.** Because there is no in-run path from `missing` back to `covered` (see §1), and because `blocked` reads as a failure, an agent optimizing for a clean-looking result is incentivized to classify gaps as `not-applicable` rather than `missing`. This compounds the loophole above. Consider stating explicitly that `blocked` is the *expected and good* outcome of a useful sweep, not a failure — to remove the incentive to under-report.
- **No HITL gate stated.** Sibling lenses (`ubiquitous-language-guard`, `pareto-scope-cut`, `trace-check`, `adr-threshold-gate`) all foreground "only with explicit human approval." This skill's overview entry never claims HITL and the SKILL.md has none — which is arguably fine (it writes nothing), but it also means nobody validates the verdicts. The skill produces a table and stops; whether a human must accept the `blocked` verdict before the artifact is "complete" is unspecified. That ambiguity weakens the blocking guarantee.
- **Step-agnostic pointer guidance is thin.** Notes (line 146) says "the kind of pointer or follow-up varies (FR/NFR at requirements, alt-flow at use-case)" but the Routing table (93–98) is FR/NFR/alt-flow-centric. On a **domain-model** sweep (an explicitly supported stage, line 144) what does a `covered` pointer or a `missing` follow-up look like? Undefined. An agent sweeping `entity_model.md` has no concrete routing target, which invites improvisation.
- **TodoWrite step is a genuine strength.** Instruction #4/Workflow step 4 (one todo per class, mark complete) is the best anti-skip mechanism in the skill — it makes an omitted class visibly incomplete. This materially raises the odds all 8 actually run.

### 3. Writing effectiveness

- **Redundancy: three near-identical procedure blocks.** "Instructions" (24–53), "Workflow" (127–140), and the DO-NOT list (55–68) all restate the same rules. Workflow steps 1–8 are essentially Instructions 1–6 re-numbered with TodoWrite inserted. This is ~40 lines of duplication; the only *new* content in Workflow is the TodoWrite step. Recommend folding TodoWrite into Instructions and deleting the Workflow section, or making Workflow a 3-line pointer.
- **The Verdicts table (85–89) duplicates instruction #4 (37–47)** almost verbatim (meaning + mandatory evidence + effect). One of the two should go; the table is the clearer form, so trim the prose in #4.
- **Good, load-bearing clarity:** the worked Output Format example (102–125) is concrete and unambiguous — an agent can pattern-match it directly. Keep it. The 8-class table (72–81) with "What to look for" is the single most actionable block; it is well-sized.
- **Under-specified:** "domain-model stage" pointer/follow-up shape (see §2); the `clean`/`blocked` → Rev11 verdict mapping; the quality bar for `not-applicable` reasons.
- **Minor contradiction in scope claims.** Description/Notes say "works at requirements, use-case-spec, and domain-model stages" (lines 13, 144), but instruction #1 names only "the requirements doc or use-case spec" (line 26) — domain-model is dropped from the input-resolution step. Align these.
- **Provenance line is slightly noisy.** Notes lines 148–154 cite Aln6 *and* coding_plan.md B5 *and* Rev7 with the full reconciliation. It's accurate but dense; the B5 citation adds little for a skill user and could be trimmed to "Aln6 (source) / Rev7 (review mirror)."

### Recommended refactor actions
1. **Close the `not-applicable` loophole** — require each `not-applicable` reason to cite a concrete fact in the artifact/context, not a generic assertion. This is the highest-leverage fix; without it "defeats agent judgment" is not actually enforced on a doc with no human in the loop.
2. **State that `blocked` is the expected, valuable outcome** (not a failure) to remove the incentive to under-report `missing` as `not-applicable`.
3. **Name Rev7 and Rev11 in the SKILL.md body**, not just the Notes — declare this skill as the shared alignment+review checklist, and map `clean`/`blocked` onto the Rev11 verdict vocabulary.
4. **Specify domain-model-stage routing** — give concrete `covered` pointer kinds and `missing` follow-up types for an entity/domain-model sweep (currently FR/NFR/alt-flow only).
5. **De-duplicate**: merge the TodoWrite step into Instructions and delete the redundant Workflow block; trim the Verdicts-table/instruction-#4 overlap.
6. **Fix the scope inconsistency** in instruction #1 (add domain-model to the input-resolution step to match the description/Notes).
7. **State the pointer-class adaptation explicitly** (Aln6's "transcript entry" → this skill's "artifact section/flow") so it doesn't read as a silent weakening.
8. **Clarify the HITL posture** — does a human accept the `blocked` verdict before the artifact is "complete," or is this a pure report? Either is fine, but it should be stated.

---

## `trace-check` — lens
- [x] refactored

### 1. Guardrail coverage

**Check C / L1 (actor verbatim) — covered, with two gaps.** Check C cites `gr_domain_language` L1 by name and correctly scopes it to actors only (line 82-92), correctly PROPOSES glossary additions rather than writing them ("propose adding it via the glossary skill — do NOT add it here", line 90), and correctly leaves L2/L4/L6/L8/L9 to `ubiquitous-language-guard` (DO NOT line 109, and the overview note line 286). That boundary is right. Two gaps:
- **L1's "translation" clause is named but not operationalized.** Check C lists "translation of a glossary term" (line 89) as a flag class but gives the agent zero mechanism to detect a translation (e.g. German "Benutzer" vs glossary "User"). Casing/plural drift is mechanically detectable; translation is not, without naming the glossary's language or a synonym table. Either drop the translation claim or tell the agent to flag only *suspected* translations for human confirmation.
- **No-glossary degrade mode is under-specified.** Line 91-92 says "cross-check actor names for consistency across the diagram and specs." That is a *different* check (intra-artifact consistency) silently substituted for L1 (glossary-verbatim). Fine as a fallback, but the report should label it as such — otherwise a report-only PASS reads as an L1 pass when L1 was never actually run.

**Check D / D1, D9 (BR→invariant) — intent-mapped, correctly bounded but weakly specified.** The overview's claim (lines 282-284) that D has *no carried-over rule ID* and only *backstops* D1/D9 is sound: `gr_ddd.md` D1/D9 govern where invariants live in *code/domain types*, not a cross-artifact mapping audit, so there is genuinely no numbered rule for "every BR-### maps to an entity-model invariant." The skill correctly verifies the mapping exists without authoring the invariant (line 99-102; DO NOT line 107). Weaknesses:
- **"Maps to" is undefined.** Check D (line 97-98) asks the agent to confirm a BR "maps to a domain-model invariant... that enforces the same rule" but gives no matching procedure. With no explicit BR-id→invariant linkage in `entity_model.md` (the entity model has no `BR-` references per `domain-model`'s output spec), the agent must *semantically* judge whether a Constraints note "enforces the same rule." This is the single highest false-pass/false-fail risk in the skill and is left entirely to agent judgment.
- **D1 backstop is half-realized.** D1 says invariants belong *inside the domain*. A BR that is enforced only in a controller/app-layer (the D1 violation) would still be invisible to trace-check, which only reads the four artifacts — so the skill cannot actually backstop D1 at the artifact level. The overview overclaims here; the skill really only backstops "BR exists in spec but nowhere in entity_model," which is a documentation-drift finding, not a D1 finding.

**Checks A, B / Doc4, Doc5 (drift) — intent-mapped, defensible but the citation is loose.** It is *right* that A and B map to no numbered rule — no `gr_*.md` defines "every UC traces to an FR" or "every spec entity exists in the model." But the Doc4/Doc5 framing (overview line 284) is a stretch: Doc4 is "update docs when *behavior* changes" and Doc5 is "don't duplicate authoritative sources" — neither is really about *cross-artifact reference resolution*. The honest basis for A/B is structural traceability (AIUP chain integrity), not the documentation guardrail. The intent-not-ID basis is sound in principle, but the *specific* Doc4/Doc5 attribution is weaker than the overview presents; A/B stand on their own as chain-integrity checks and don't need the Doc cite.

**Missing-input handling — claimed and adequately specified.** Lines 53-55 and DO NOT line 118 cover warn+skip+continue; the report template has `| MISSING` slots (lines 157-161). This is the best-specified part. One gap: the skill never says what **Result** to emit when checks were *skipped* — is a run with Check A skipped still eligible for "PASS"? A PASS over a partial run is a false pass. The template needs a `PARTIAL` / "PASS (checks X,Y skipped)" state.

### 2. Will the purpose be achieved?

Partially. The four checks will catch the *obvious* breaks (an orphan UC with no `Requirements:` line, an entity named in a spec with no entity-model entry, an actor "Users" vs glossary "User"). Failure modes:

- **Check A depends on an undefined trace convention.** Line 67-70 accepts "an FR id cited in the spec, a `Requirements:`/`Traces to:` line, or a documented mapping." But neither `domain-requirements` nor `use-case-spec` is stated to *emit* such a line. If specs don't carry FR references (very likely, since the use-case-spec template centers on actors/scenarios/BR-###, not FR back-links), **every UC is an orphan** → a wall of false-positive breaks. The skill needs to handle "no trace convention present in this project" as a distinct outcome (warn: traceability not author-able), not flag all UCs.
- **FR-id vs BR-id format coupling.** Check A uses `FR-012`, Check D uses `BR-###`, but `domain-requirements` output is described with **"unique ID"** of unspecified prefix. If requirements emit `F##`/`M#` style ids (per this project's `01-foundation.md` namespace), the regex-style `FR-###` assumption silently misses them. The skill should discover the id pattern, not assume `FR-`/`BR-`.
- **Near-match handling is asserted but not procedural.** Check B (line 80) and Check C (line 89) both say singular/plural and casing are "breaks, not silent passes," which is good, but there is no normalization step telling the agent *how* to detect them (e.g. "lowercase + singularize both sides; if equal but not byte-identical → near-match break"). Left to judgment, an agent may silently pass "Mailbox"/"Mailboxes."
- **No de-dup across diagram vs specs.** Check A says enumerate UCs "from the use case diagram and/or the use-case specs" (line 65). If a UC exists in both, the agent may double-count or, worse, miss a UC present in the `.puml` but with no spec file (a real break that should be flagged) — the skill never explicitly says "a UC in the diagram with no spec is itself a finding."
- **HITL loop is sound.** Step 5 (lines 143-148) correctly identifies the offending artifact, shows before/after, asks approve/edit/skip, applies only approved edits, re-runs the affected check, never writes without approval. This matches the "fix only the offending artifact, never invent traces" requirement well. One ambiguity: it never says *which* artifact is "offending" for a Check A orphan — is the fix adding a trace line to the spec, or is the missing FR the requirements doc's fault? The skill should make the agent state the candidate offending artifact and let the human pick, not assume.

### 3. Writing effectiveness

Generally tight and well-structured; the four checks, workflow, and template are clear and non-redundant. Concrete issues:

- **Redundancy between Instructions, Workflow, and the overview.** The four checks are stated three times: as `### Check A–D` (lines 63-102), again compressed in Workflow step 3 (lines 134-139), and again in the overview. Workflow step 3 is near-pure restatement and could be cut to "Run Checks A–D (above), accumulating findings."
- **"Documented mapping" (line 70) is vague** — undefined what artifact/format constitutes one. Either define it or drop it.
- **Check D crams four findings into one paragraph** (unenforced BR, invariant↔BR conflict, duplicate BR ids, contradictory BR ids — lines 99-102). The duplicate/contradictory-BR-id check is a *within-spec* concern, not a *cross-artifact* trace, and sits oddly in a traceability lens; it inflates scope. Consider splitting it out or dropping it.
- **Inputs section (29-55) and Workflow step 1-2 (125-132)** restate the same resolution/extraction logic. Mild duplication; acceptable but trimmable.
- **No worked example.** For the highest-ambiguity check (D's "maps to / enforces the same rule"), one concrete before/after example would de-risk the agent's semantic matching far more than the prose does.

### Recommended refactor actions

1. **Fix Check A's trace-convention assumption** (highest priority): detect whether specs actually carry FR back-references; if no trace convention exists project-wide, emit a single "traceability not author-able — no FR-link convention found" warning instead of flagging every UC as an orphan.
2. **Make id-pattern discovery explicit** for both FR and BR ids — don't hard-assume `FR-###`/`BR-###`; discover the catalog's actual id prefix.
3. **Add a normalization procedure** for near-matches (lowercase + singularize, compare) in Checks B and C so plural/casing drift is mechanically caught, not judgment-dependent.
4. **Add a `PARTIAL` result state** and forbid "PASS" when any check was skipped due to a missing input.
5. **Specify Check D's matching method** and add one worked BR→invariant example; consider moving duplicate/contradictory-BR-id detection out of a traceability lens.
6. **Label the no-glossary Check C fallback** in the report as "intra-artifact consistency only (L1 not run)" so a degraded run never reads as an L1 pass.
7. **Soften/correct the overview's D1 and Doc4/Doc5 attributions** — state A/B/D as chain-integrity findings that *embody* drift-prevention intent, and drop the implication that Check D backstops D1's domain-layer-placement rule (trace-check cannot see code).
8. **Trim Workflow step 3** to a cross-reference and de-duplicate the Inputs↔Workflow resolution prose.
