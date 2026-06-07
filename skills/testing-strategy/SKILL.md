---
name: testing-strategy
description: >
  Authors the project-specific how-to-test artifact for one milestone:
  module/test-surface priorities, the test-double policy at the real boundaries
  (what to fake vs. use real), and prior art (existing test patterns) — writing
  ONE docs/testing/<milestone>.md per milestone. Every entry opens
  `Re: NFR-###` / `Re: C-###`, referencing the threshold by ID and adding only
  the test method — it never restates the bar (that stays in requirements) and
  never duplicates universal red-green-refactor philosophy (that stays in the
  `tdd` skill, referenced not copied). Invoked by spec-to-prd right after its
  in-session module sketch so it sees the just-decided modules; also runs
  standalone. Use when the user asks to "create a testing strategy", "write a
  test strategy", "author testing.md", "define test surfaces", "set the
  test-double policy", "decide how to test this milestone", "write the initial
  testing strategy", "what should we test and how", "pick which modules to
  test", or "produce docs/testing/<milestone>.md". Stack-agnostic when the stack
  is undeclared (flags the dependency); tailored to the stack when one is fixed.
---

# Testing Strategy

Authors **one `docs/testing/<milestone>.md` per milestone**: the project-specific
*how-to-test* — which modules and test surfaces to prioritize, what to fake vs.
use real at the **real boundaries**, and existing **prior art** (test
patterns/conventions, immediately relevant in brownfield). It owns the
how-to-test artifact for the milestone and **nothing else**.

It holds the **how**, never the **bar** and never the **universal philosophy**:

- **Thresholds stay in the requirements catalogue.** Each strategy entry opens
  `Re: NFR-###` / `Re: C-###`, references the threshold **by ID**, and adds only
  the test method. It **never restates** the threshold value
  (`gr_documentation` **Doc5** — link to the authoritative source, never copy
  it).
- **Universal test philosophy stays in the `tdd` skill** (red-green-refactor,
  test behavior through public interfaces). This artifact **references** the
  `tdd` skill and carries only the project-specific parts. It never restates
  that philosophy (Doc5 again).

It is **strategy, not implementation**: it decides *what makes a good test here*
and *which surfaces to verify*; it does **not** write the tests (that is `tdd`),
author or edit requirements/NFRs (that is the requirements skill), sketch the
modules (that is `spec-to-prd`'s job — this skill *reads* the result), or publish
the PRD. It closes the `gr_greenfield` **G8** gap (an explicit initial testing
strategy), which no other skill owns.

## Guardrail basis

- **`gr_greenfield` G8** — the milestone has an explicit testing strategy from
  the start (which test levels/surfaces it values, applied deliberately). This
  skill produces that artifact.
- **`gr_documentation` Doc5** — no duplication of authoritative sources. Two
  authoritative sources are referenced, never copied: the **NFR/constraint
  thresholds** (in the requirements catalogue) and the **universal testing
  philosophy** (the `tdd` skill).

## Inputs

### Module decomposition (required — the spine of the strategy)

The just-decided module/deep-module breakdown for this milestone: the modules to
build/modify, their public interfaces (the **test surfaces**), and which the
human flagged as wanting tests. Resolve in this order:

1. **In-session, from `spec-to-prd`.** The normal path: invoked right after that
   skill's interactive module sketch, so the modules are **ephemeral context in
   the same session** — read them from there. They are **not** a persisted
   artifact; do not look for a "module model" file.
2. **Standalone — passed as an argument.** If invoked on its own, accept the
   module decomposition as input.
3. **Standalone — neither present.** STOP and **ask** for the module
   decomposition. It is the required input; do not invent modules and do not
   derive them from the entity model (entities are not modules). Without it there
   are no test surfaces to prioritize.

### Requirements catalogue (NFRs + constraints — the thresholds to *reference*)

Default `docs/requirements.md`; accept an override path. Read the **NFRs** and
**constraints** — these hold the measurable thresholds each strategy entry
references **by ID**. The strategy adds the *method* for hitting each bar; the
bar itself stays here. If the requirements doc is missing, **warn** and ask for
it (there is nothing to reference `Re:` without it).

### Chosen stack (if declared — else stack-agnostic + flag)

Discover whether the stack (language/runtime/test framework) is **declared**,
typically as a constraint in the requirements catalogue or an ADR:

- **Declared** → tailor the strategy to it (name the real test framework, the
  real FS/clock/network seams that stack exposes, idiomatic fakes).
- **Undeclared** (e.g. a constraint that explicitly defers the stack) → write
  **stack-agnostic** guidance (talk in terms of boundaries and surfaces, not a
  named framework) **and explicitly flag the stack dependency** so the strategy
  is revisited once the stack is chosen. Do **not** silently bake in a stack.

### Scope marker (the milestone) — resolve in this order

1. **Argument** — an explicit scope marker (milestone) passed by the caller (the
   normal path: `spec-to-prd` passes the milestone it resolved).
2. **The requirements doc's declared milestone / Status scope split** — if the
   catalogue declares a single milestone, or its `Status` column delimits exactly
   one in-scope set (e.g. `Open` vs `Deferred`), use that.
3. **Ask the human** — only if **genuinely ambiguous** (multiple undelimited
   milestones with no scope split). Do not interrogate when the marker is
   unambiguous.

### Prior art (existing test patterns — immediate in brownfield)

Look for existing tests / test conventions / fixtures in the project (test
directories, naming conventions, established fakes/helpers, a test README). In
**brownfield** this is load-bearing — the strategy should align with what
already exists rather than invent a parallel convention. In **greenfield** there
is usually none; note that and the strategy establishes the initial convention
(G8). Its absence is not an error.

## Discover the threshold-ID scheme first

Before writing any `Re:` entry, **discover the ID prefixes the requirements
catalogue actually uses** — do not hard-assume `NFR-`/`C-`. The catalogue may use
`NFR-007` and `C-012`, but another project may use a different scheme. Derive the
pattern from what is present in the file (the NFR-row id prefix and the
constraint-row id prefix), and open each entry with that project's real prefix.
If only one of the two families exists, reference whichever is present. Never
invent an ID that is not in the catalogue.

## What this skill authors (project-specific *how* only)

Three things, all project-specific, all referencing — never restating — the two
authoritative sources:

1. **Module / test-surface priorities.** Which modules to test and in what
   order, driven by risk and by which NFRs/constraints bear on each. Prioritize
   the **deep modules** and the surfaces where an NFR/constraint threshold lives.
   Out-of-scope/deferred modules get **no** entries (see DO NOT).
2. **Test-double policy at the real boundaries.** For each real boundary the
   modules cross (filesystem, clock, network, external service, data store,
   etc.), state **what to use real vs. fake** — e.g. real temp filesystem but a
   faked external source — and *why* that boundary is drawn there. This is the
   project-specific judgment `tdd`'s universal "test through public interfaces"
   rule needs in order to be applied here.
3. **Prior art.** The existing test patterns/conventions/fakes the new tests
   should follow (brownfield), or the initial convention this milestone
   establishes (greenfield).

Each concrete test entry opens `Re: <NFR/C id>` and adds the method only.

## DO NOT

- Do NOT **restate an NFR/constraint threshold** — open with `Re: <id>` and
  reference it; copying the bar duplicates the authoritative source
  (`gr_documentation` Doc5). The threshold value lives in the requirements
  catalogue and is never repeated here.
- Do NOT **duplicate universal `tdd` philosophy** (red-green-refactor, "test
  behavior through public interfaces", test-first discipline) — **reference the
  `tdd` skill** and carry only the project-specific parts.
- Do NOT **invent NFRs, constraints, or thresholds**, or cite an ID that is not
  in the catalogue. Reference only IDs that actually exist; if a needed bar is
  missing, flag it for the requirements skill — do not author it here.
- Do NOT **author requirements, model entities, sketch the modules, or write the
  actual tests** — read the module sketch, reference the requirements; defer
  test-writing to `tdd`.
- Do NOT **bake in a stack when none is declared** — write stack-agnostic
  guidance and **flag** the stack dependency for a later revisit.
- Do NOT **author the strategy for out-of-scope / deferred modules** — only the
  in-scope modules of this milestone get entries; deferred surfaces are noted as
  out of scope, not strategized.
- Do NOT **hard-assume an `NFR-`/`C-` ID scheme** or a single requirements
  filename — discover the actual prefixes and honor the path override.
- Do NOT **write `docs/testing/<milestone>.md` without explicit HITL approval** —
  it is a shared-doc write; show the full draft and get a yes first.
- Do NOT **bake any one project's domain specifics** into the skill's behavior —
  paths/milestones/stack arrive via args, the in-session sketch, and the fallback
  chains; project values appear only at run time.

## Workflow

1. **Resolve the module decomposition** — from the in-session `spec-to-prd`
   sketch (normal path), else an argument, else **ask**. State the modules, their
   test surfaces, and which the human flagged as wanting tests.

2. **Resolve the scope marker** — arg → requirements milestone / Status scope
   split → ask only if genuinely ambiguous. State the resolved milestone (this
   names the output file `docs/testing/<milestone>.md`).

3. **Read the requirements catalogue** (default `docs/requirements.md`, honoring
   an override). **Discover the threshold-ID scheme** (the NFR and constraint
   prefixes actually used). Collect the in-scope NFRs and constraints that bear
   on the modules from step 1. State the resolved path and the discovered ID
   prefixes.

4. **Determine the stack** — declared (constraint/ADR) → tailor; undeclared →
   stack-agnostic + record the **stack-dependency flag**. State which branch you
   took.

5. **Find prior art** — existing tests/conventions/fakes (load-bearing in
   brownfield; usually none in greenfield → note and establish the initial
   convention).

6. **Draft the strategy** into the output template (below):
   - **Module / test-surface priorities** — order the in-scope modules; for each,
     name its test surface(s) and the NFRs/constraints that bear on it.
   - **Test-double policy** — per real boundary, real vs. fake + why.
   - **Per-NFR/constraint entries** — one `Re: <id>` line per relevant threshold,
     each adding the *method* (how to exercise the surface and assert the bar),
     never the bar's value.
   - **Prior art / conventions** — patterns the tests follow.
   - Reference the `tdd` skill once for universal philosophy; flag the stack
     dependency if undeclared.

7. **HITL write (gate).** Show the **full drafted** `docs/testing/<milestone>.md`
   and ask "approve / edit / skip". Write the file only on explicit approval,
   one file per milestone. If multiple in-scope milestones were requested, draft
   and gate each separately.

8. **Run the POST self-check** (below) and report the result item-by-item.

## Output template — `docs/testing/<milestone>.md`

```markdown
# Testing Strategy — <Milestone>

Requirements: <path>   (threshold ID scheme: <discovered, e.g. NFR-### / C-###>)
Stack: <named stack | UNDECLARED — strategy is stack-agnostic; revisit once the
        stack is chosen (depends on <constraint id or "stack decision">)>
Universal testing philosophy: see the `tdd` skill (red-green-refactor, test
        behavior through public interfaces) — referenced here, not restated.

## Module / test-surface priorities
| Order | Module | Test surface (public interface) | Thresholds it bears (NFR/C ids) | Tested? |
|-------|--------|---------------------------------|---------------------------------|---------|
| 1 | <module> | <the public interface to drive in tests> | <Re: NFR-### / C-### ids> | Y/N |

## Test-double policy (the real boundaries)
| Boundary | Real or fake | Why this is the seam |
|----------|--------------|----------------------|
| <e.g. filesystem> | real (temp) | <why> |
| <e.g. external source> | fake | <why> |

## Strategy entries (Re: threshold — method only, never the bar)
- `Re: <NFR-###>` — <how to exercise the surface and assert the threshold;
  which doubles; what to observe>. (Threshold stays in the requirements
  catalogue — referenced, not copied.)
- `Re: <C-###>` — <method for the constraint's testable consequence>.

## Prior art / conventions
<Existing test patterns/fakes the new tests follow (brownfield), OR the initial
 convention this milestone establishes (greenfield, G8).>

## Open dependencies
<Stack-dependency flag if undeclared; any threshold a strategy entry needed but
 the catalogue lacks — flagged for the requirements skill, not authored here.>
```

## Worked example — the `Re: NFR-###` convention (illustrative only)

> The example uses placeholder domain terms purely to show the **convention** —
> it is not a hard-coded assumption about any project. At run time the real
> NFR/constraint IDs and the real boundaries come from the project.

The NFR holds the bar; `testing.md` holds only the *how*. Suppose an NFR with id
`NFR-002` states an idempotency bar (its exact threshold value lives in the
requirements catalogue). The `testing.md` entry references it and adds the
method:

> `Re: NFR-002` — run the batch twice through the apply surface against a temp
> filesystem root + a temp ledger; assert the run produced no new files and
> exactly one new provenance link; **real temp FS, fake mail source**.

The threshold itself (the actual "how many duplicate writes are allowed") is
**not copied** into the entry — it stays in `NFR-002` and is **referenced by
ID**. The entry contributes only the test method and the test-double choice
(real temp FS, fake source).

## POST self-check

Before reporting done, verify each item (PASS / explain):

1. **Every entry cites an NFR/constraint** — each strategy entry opens
   `Re: <id>` with a real ID from the catalogue (discovered scheme); no entry
   floats free of a referenced threshold.
2. **No threshold restated** — no entry copies an NFR/constraint's value; the bar
   is referenced by ID only (Doc5).
3. **No `tdd` philosophy duplicated** — universal red-green-refactor /
   test-through-public-interfaces guidance is referenced via the `tdd` skill, not
   restated.
4. **Stack assumptions flagged** — if the stack is undeclared, the strategy is
   stack-agnostic and the stack dependency is explicitly flagged; if declared,
   the strategy is tailored to it.
5. **In-scope only** — entries cover only the milestone's in-scope modules; no
   deferred/out-of-scope module is strategized.
6. **Generic body** — no hard-coded project specifics in the skill's behavior;
   paths/milestone/stack came via args, the in-session sketch, or the fallback
   chains.
7. **HITL honored** — `docs/testing/<milestone>.md` was shown in full and not
   written without explicit approval.

## Notes

- **Relation to `spec-to-prd`.** The normal invocation is in-session, right after
  `spec-to-prd`'s interactive module sketch, so this skill reads the
  just-decided (ephemeral) modules. `spec-to-prd`'s Testing Decisions section
  then **links** the `docs/testing/<milestone>.md` this skill writes — it does
  not restate it.
- **Relation to `tdd`.** `tdd` is the consumer of this artifact (it implements
  the tests the strategy prioritizes) and the home of the universal philosophy
  this artifact references. Keep the split clean: philosophy + red-green-refactor
  in `tdd`; project-specific surfaces, doubles, and prior art here.
- **One file per milestone.** Mirrors how `docs/use_cases/*.md` fans out — one
  strategy per milestone, named by the scope marker. Re-run per milestone.
- **Why a separate artifact.** The strategy depends on the **module
  decomposition** (decided at PRD time) and the **chosen stack** — neither exists
  at requirements time, so it cannot live in the requirements catalogue. That
  phase/timing mismatch is why it is its own artifact, owned by this skill.
```
