# todo

Next step to continue, see unchecked "[ ]" term

- [x] create new skills to align aiup and the coding project: see `skills/create_skills.md`
      call order once built: `ubiquitous-language-guard` → `pareto-scope-cut` → `domain-model` → `adr-threshold-gate` → `hidden-constraint-sweep` → `/use-case-diagram` (stock + lenses) → `/use-case-spec` (stock + lenses) → `trace-check`

- [x] new domain-requirements skill (directory link!)

- [x] skill overview 
      create skills_overview.md in the skills folder that provide an overview of all the skill there. It shall include at least:
      - purpose of the skill
      - input artifacts the skill must use
      - output artifacts or results the skill will produce
      - how the skill is related to the guardrail items located in the various coding/gr_XXXX.md files
      - if skills_overview.md exists, re-use it
      - run the analysis that generates the overview content for a single unchecked skill in todo.md section "skill overview and review" in a fresh sub-agent and insert its result in skills_overview.md
      - each of the sub-agents must only create such overview info for a single skill 
      - check the skill, if done. Here is the skill list:
      - [x] `ubiquitous-language-guard` — **lens** · enforce the glossary on `requirements.md`; write approved new/changed terms back into `CONTEXT.md` (HITL).
      - [x] `pareto-scope-cut` — **lens** · cut imagined/future scope (ai-mail: defer M2b/M3/M4); append a Postponed-decisions log.
      - [x] `domain-model` — **fork** · produce the conceptual model (glossary-aware, VO/aggregate-aware) → `docs/entity_model.md`.
      - [x] `domain-requirements`
      - [x] `adr-threshold-gate` — **lens** · catch any irreversible modelling decision → `docs/adr/####-*.md` (proposed; HITL to accept).
      - [x] `hidden-constraint-sweep` — **lens** · the 8-class sweep (retention / concurrency / PII / …) the model implies.
      - [x] `trace-check`

- [x] critical skill review
      create skills_review.md in the skills folder that contains a critical review of all the skill there. 
      This file shall later be used to refactor the skills one for one in fresh agent sessions.
      Each skill review shall start with a "- [ ] " term to signal that the refactoring is pending.
      The review for each skill shall at least:
      - check if the skill related guardrail items located in the various coding/gr_XXXX.md files are fully covered (are there items missing?)
      - check if the purpose of the skill will likely be achieved
      - if the skill is generally written effectively, so an AI agent gets sufficient and clear input, but not too much input
      - run each review that generates the review content for a single unchecked skill in todo.md section "skill review" in a fresh sub-agent and insert its result in skills_review.md
      - each of the sub-agents must only create such review content for a single skill 
      - Here is the skill list:
      - [x] `ubiquitous-language-guard` — **lens** · enforce the glossary on `requirements.md`; write approved new/changed terms back into `CONTEXT.md` (HITL).
      - [x] `pareto-scope-cut` — **lens** · cut imagined/future scope (ai-mail: defer M2b/M3/M4); append a Postponed-decisions log.
      - [x] `domain-model` — **fork** · produce the conceptual model (glossary-aware, VO/aggregate-aware) → `docs/entity_model.md`.
      - [x] `domain-requirements`
      - [x] `adr-threshold-gate` — **lens** · catch any irreversible modelling decision → `docs/adr/####-*.md` (proposed; HITL to accept).
      - [x] `hidden-constraint-sweep` — **lens** · the 8-class sweep (retention / concurrency / PII / …) the model implies.
      - [x] `trace-check`

- [ ] skill refactoring
      refactor all skills in the skills folder according to skills_review.md
      Each refactoring shall be done in a separate sub-agent using opus 4.8 model with high thinking mode enabled. 
      The orchestrator session then mark the refactoring done, when the subagents have finished their work.
      - each of the sub-agents must only refactor a single skill 
      - Here is the skill list:
      - [ ] `ubiquitous-language-guard` — **lens** · enforce the glossary on `requirements.md`; write approved new/changed terms back into `CONTEXT.md` (HITL).
      - [ ] `pareto-scope-cut` — **lens** · cut imagined/future scope (ai-mail: defer M2b/M3/M4); append a Postponed-decisions log.
      - [ ] `domain-model` — **fork** · produce the conceptual model (glossary-aware, VO/aggregate-aware) → `docs/entity_model.md`.
      - [ ] `domain-requirements`
      - [ ] `adr-threshold-gate` — **lens** · catch any irreversible modelling decision → `docs/adr/####-*.md` (proposed; HITL to accept).
      - [ ] `hidden-constraint-sweep` — **lens** · the 8-class sweep (retention / concurrency / PII / …) the model implies.
      - [ ] `trace-check`


- [ ] analyse, run and test the newly created skills.
      - [ ] `ubiquitous-language-guard` — **lens** · enforce the glossary on `requirements.md`; write approved new/changed terms back into `CONTEXT.md` (HITL).
      - [ ] `pareto-scope-cut` — **lens** · cut imagined/future scope (ai-mail: defer M2b/M3/M4); append a Postponed-decisions log.
      - [ ] `domain-model` — **fork** · produce the conceptual model (glossary-aware, VO/aggregate-aware) → `docs/entity_model.md`.
      - [ ] `adr-threshold-gate` — **lens** · catch any irreversible modelling decision → `docs/adr/####-*.md` (proposed; HITL to accept).
      - [ ] `hidden-constraint-sweep` — **lens** · the 8-class sweep (retention / concurrency / PII / …) the model implies.


- [ ] review workflow.md (specifically: what about the aiup artifacts and the pocock skills?)
      resolve which of the created artifacts are needed by the pockock skills and how to achieve this.
      **GATE before running any pocock skill** (`prototype`/`to-prd`/`to-issues`/`tdd`). Risk = two sources of truth.
      Finding (2026-06-03, read the SKILL.md bodies): the pocock skills are **context-driven, not file-driven** — none
      reads the AIUP spine artifacts by path. They formally consume only TWO of our outputs, by convention:
      - the **glossary** (`docs/CONTEXT.md`→`docs/glossary.md`) — "use the project's domain glossary vocabulary"
      - **`docs/adr/*`** — "respect any ADRs in the area you're touching"
      The rest — `docs/requirements.md` (FR-###), `docs/use_cases.puml`, `docs/use_cases/*.md` (UC-###/BR-###),
      `docs/entity_model.md` — are NOT ingested; they reach `to-prd`/`to-issues` only as whatever is loaded in the
      live conversation, and `to-prd` re-synthesises its own PRD + user-stories rather than deriving from them.
      `prototype` reads surrounding code, not AIUP docs; it feeds OUT (snippet → ADR/issue/NOTES.md).
      So the spine's traceable work (FR/UC/BR/entity model) risks being silently re-derived → divergence.
      Resolve which of these to pursue (Pareto — likely just the bridge, not all of it):
        a) **Lean on the shared substrate**: keep glossary + ADRs as the single source of truth that both families read;
           accept that requirements/use-cases/entity_model are build-time scaffolding the human carries in by context.
        b) **Enhance the pocock skills** (or fork copies as ai-mail project skills) to read the AIUP artifacts by path
           — e.g. `to-prd` seeds its user-stories from `requirements.md` FRs + `use_cases/*.md`, links BR-### → invariants.
        c) **New bridge skill** (`aiup-to-prd` / `spec-to-issues`) that maps the hardened AIUP docs → PRD/issues with
           traceability preserved, leaving upstream pocock skills untouched (mirrors the create_skills.md approach).
      Decide a/b/c (or mix) and HOW the no-two-sources-of-truth invariant is enforced, BEFORE the first pocock run.


- [ ] Verify if these are reasonable next steps:
      AFTER `trace-check` (spec spine done): NOT an aiup skill — aiup Construction skills are
      Vaadin/jOOQ-locked, unusable for this stack (see step 7). Next is a matt_pocock skill, by intent:
      - `prototype` — RECOMMENDED. Throwaway runnable terminal app to resolve ai-mail's #1 open
        design unknown (interaction surface + plan/apply state machine). Cheap, disposable, Pareto.
        Skip only if the surface is truly already decided (plan/apply YAML per ADR-0002).
      - `to-prd` → `to-issues` — when crossing into execution: slice the hardened spec into
        tracer-bullet vertical slices (serves step 7 + the tracer-bullets question below).
      - `tdd` (+ `improve-codebase-architecture`) — construction-time: carries deep-modules +
        interface-design (the "deep modules" question below). Only once code exists.

- [ ] where would humanlayer/riptide fit in this process? how to assure deep modules and tracer-bullets?
- [ ] (3) `/entity-model` → `docs/entity_model.md` — the genuinely NEW value. Yields the missing M2 domain model: Attachment, RoutingRule, Provenance (= F06), and the idempotency key F22 needs. Watch that it surfaces these.
- [ ] (4) `/use-case-diagram` → `docs/use_cases.puml` — actors + UC-### IDs, each tracing to ≥1 FR. This is where the M2 actor(s) + the slice into use cases gets pinned (likely a small set, e.g. "review & file proposed attachments").
- [ ] (5) `/use-case-spec UC-XXX` → `docs/use_cases/UC-XXX-*.md` — the detailed spec: actor · preconditions · main success scenario (numbered) · alternative flows (file-already-exists, target-folder unclear/undefined, not-every-attachment-should-be-filed, rename) · postconditions · business rules. Resolve interaction-surface + mail-selection HERE as explicit decisions.
- [ ] (6) Grill the written use case — fresh session, `/grill-me` (or `/grill-with-docs` to harden docs inline). Ammunition = branches banked below (~todo.md:64-69): approval-surface shape, what earns "primitive" status (rename/conflict-resolution?), mail-access surface (IMAP/Graph/PST), existing-folder taxonomy (local/network), F22 idempotency. Defer the programming-language/stack choice to the spine's plan step.
- [ ] (7) Into the chosen build spine (Option A/B/C below) at its specify/plan step, carrying the hardened AIUP docs in. Spine choice stays deferred to the plan step; AIUP itself can't build on this stack. Golden corpus + accuracy gate before implement (method-agnostic).

      **Method-test notes to capture as you go** (this project IS a workflow experiment): where did AIUP feel like overhead vs. where did it earn its keep? Did `/entity-model` surface anything the brainstorm missed? Did the P/A→FR re-format lose fidelity? Did running the full chain beat starting mid-chain? Log findings against the "experiment workflow" todo at the bottom.

- [~] analyse https://github.com/humanlayer - anything useful (for the workflow/method or for the implementation)?
  
      Outcome (2026-05-31): "HumanLayer" is FOUR things on TWO axes — don't conflate them.
      BUILD-TIME axis (how we build ai-mail): (1) **RPI workflow + FIC** = `.claude/commands` + research subagents, a drop-in Research→Plan→Implement spec-driven spine → now Option C below. (2) **CodeLayer** = open-source Claude-Code-orchestration IDE (multi-claude/worktrees), waitlist/early, a harness not a method → skip for now.
      RUNTIME/PRODUCT axis (what ai-mail itself does — NOT covered by Spec Kit/AIUP/Pocock, which are all build-time): (3) **HumanLayer SDK** `require_approval` / `human_as_tool` = deterministic human-in-the-loop gates for high-stakes tool calls. SDK is DEPRECATED (removed in PR #646) → borrow the PATTERN, not the dependency. Its function-stakes ladder maps onto ai-mail almost verbatim: read mail = medium stakes, **send/reply on my behalf = high stakes requiring a deterministic human gate**. (4) **12-factor agents** = runtime design principles (own your prompts, own your control flow, small focused agents, human-in-loop as a first-class tool). → Bank (3)+(4) as a PRODUCT-DESIGN constraint for the M-capabilities, esp. anything that SENDS (M3 danger zone already flagged); independent of which build spine wins.

- [ ] potential next steps: see todo_ideas.md
