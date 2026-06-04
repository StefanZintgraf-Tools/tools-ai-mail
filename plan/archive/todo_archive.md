# todo (archived, to be ignored!)

- [x] Brainstorming Prompt 1
    acontis is selling software for industrial customers. Many mails (new ones, historical ones) with customer specific technical and commercial questions etc. exist. Mails exist in personal mailboxes as well as in shared mailboxes and even in historical PST files.
    The CRM used is Pipedrive. In Pipedrive potential and existing customers are managed. 
    Mails are currently not sent/received/stored within Pipedrive. A MCP server exists for Pipedrive.
    Goal is to think about tools and features that help our inside sales, technical sales, order processing, management staff etc. to speed up and/or automate their daily work.
    I want to work on such tools/featuers in my spare time without getting paid.
    My goal is to have fun working on this project. I want quickly create results that can be enhanced.
    These results may be re-usable parts of the solution (e.g. independent sub-modules, GUIs etc. for other projects) or testing/evaluation prototypes.
    IMPORTANT: the Pareto principle has to be utilized (do minimum work with maximum results).

- [x] Brainstorming Prompt 2
  
  1. acontis is selling software for industrial customers. Many mails (new ones, historical ones) with customer specific technical and commercial questions etc. exist. 
     Mails exist in personal mailboxes as well as in shared mailboxes and even in historical PST files.
      The CRM used is Pipedrive. In Pipedrive potential and existing customers are managed. 
      Mails are currently not sent/received/stored within Pipedrive. A MCP server exists for Pipedrive.
      Goal is to think about tools and features that help our inside sales, technical sales, order processing, management staff etc. to speed up and/or automate their daily work.
      These results may be re-usable parts of the solution (e.g. independent sub-modules, GUIs etc. for other projects) or testing/evaluation prototypes.
      A first brainstorming result is stored in plan/painlist_acontis.md
      Next step: acontis has to decide the most important point per topic. This may take some time.
  2. My private mail painlist is stored in plan/painlist_private.md
  3. General and important guardrails:
     I want to work on such tools/features in my spare time without getting paid.
     My goal is to have fun working on this project. I want quickly create results that can be enhanced.
     IMPORTANT: the Pareto principle has to be utilized (do minimum work with maximum results).
  4. How the final solution will look like is not yet defined. 
     I want to brainstorm about the possible next step (working on something that is needed whatever acontis decides is most important)

- [~] use-case first workflow (AIUP) — START HERE in a fresh session (decided 2026-05-31)
  
      **Decision: run the canonical AIUP chain for M2, faithfully.** This project is also a live test of the workflow + skills themselves, so follow AIUP even where it feels heavier than strictly Pareto-necessary — the friction IS data about the method. Source of truth for the flow: `C:\PROJ\github\marketplace\README.md` (+ its CLAUDE.md). Skills are in the `aiup-core` plugin.
      
      **Premise (why use-case-first, not grill-first):** M2 is chosen (00-foundation.md:232) but it is greenfield — nothing exists. What is NOT yet defined is the thing a user actually USES: the interaction surface (CLI? GUI? editable file?), how mails are selected to work on, what triggers a run. That is the USE CASE, not scope-internals. Grilling is a stress-test tool — it needs a concrete substrate to bite into. So: derive the use case via AIUP FIRST, then grill it.
      
      **Key correction about AIUP (why this is a CHAIN, not a cold `/use-case-spec`):** in real AIUP, use cases are DERIVED, not invented. Each skill reads the file the previous one produced: `vision → /requirements → /entity-model → /use-case-diagram → /use-case-spec`. `/use-case-spec` literally reads `docs/use_cases.puml` + `docs/requirements.md` to scope itself; running it cold gives it nothing to read. So we run the upstream chain, not just the last step. (Construction-phase skills `/implement` `/flyway-migration` `/*-test` are Vaadin/jOOQ-locked → NOT usable for ai-mail's Python/TS stack — AIUP gives us the SPEC spine only; the build half comes from the chosen Option A/B/C spine below.)
      
      **Pareto flag to carry IN (decide consciously, don't default):** a GUI is the expensive answer. The cheapest viable surface is file-based / CLI — the plan/apply straw-man's "the editable file IS the UI" (~todo.md:64). The use case must make the interaction-surface choice deliberately, against the "fun · minimal effort · dogfood on the private mailbox" constraint — not back into a GUI because it feels complete.
      
      **AIUP chain for M2 (each step produces a file the next one reads; review/edit between steps):**
      - [x] (1) Write `docs/vision.md` for M2 — by hand. The one human input AIUP can't derive. Use the marketplace README's recommended structure (Mission · Target Users · Goals · Scope in/out · Constraints). Seed it from: the M2 decision (00-foundation.md:232), pains P01🔥/P02🔥, the Pareto + "fun, unpaid, dogfood private mailbox" guardrails, and the HumanLayer light-approval product constraint (todo.md ~:42). Keep the interaction surface + mail-selection as OPEN questions here — don't pre-decide them.
      - [x] (2) `/requirements` → `docs/requirements.md` — mostly a RE-FORMAT: the existing pains (P01, P02, A##) already ARE functional requirements. Map them to FR-### / NFR-### / CON-### and KEEP the trace back to the P/A IDs (don't lose the existing namespace).
        - [x] grill-with-docs conflict resolution (ubiquitous language? glossary?). What is missing in AIUP? (2026-06-02)
              13-question grill → built `docs/CONTEXT.md` (18 terms, kernel + M2 section), 2 ADRs
              (`docs/adr/0001-external-provenance-ledger.md`, `0002-approval-surface-as-adapter.md`).
              **Method-test finding:** AIUP ships no ubiquitous-language artifact and no ADR mechanism —
              grill-with-docs supplies both; that's the gap it fills over a cold AIUP chain.
              Key decisions: Proposal (object) vs Approval Request (gate); Sender = From address;
              Document Type = editable closed enum; min(type,location) confidence gate; dedup keys on
              content-hash (Conflict = same-path/different-content, human-resolved); external Provenance
              Ledger; Message-ID mail identity; plan/apply YAML Action Plan as first Approval-Surface
              adapter (GUI later); Routing Roots define F04's closed set; Run Scope is an adapter concern.
        - [x] review/edit/adjust requirement.md (2026-06-02) — folded all grill decisions into
              `docs/vision.md` + `docs/requirements.md` (new FR-011..014, C-008..010, ADR refs),
              added F32·infer-filename (M2b) to `plan/01-foundation.md`, fixed stale 00→01 links.
        - [x] human review/edit/adjust requirement.md (see tutorial.md from aiup/book-library)
        - [x] challenge the FR-### items using a good model with thinking and optionally apply the Pareto principle (e.g. to move some features to a later step) (2026-06-03)
              Four Pareto cuts applied across `docs/requirements.md` + `docs/vision.md` + `docs/CONTEXT.md`
              + `plan/01-foundation.md` (+ `docs/adr/0002`):
              (1) **Sender-only routing** — F03 attachment-type classification deferred to M2b; Routing Key
                  drops to Sender alone; confidence gate becomes location-only (type-confidence +
                  min(type,location) return in M2b). FR-003→Deferred; FR-004/NFR-001/NFR-003 reduced; F03
                  moved M2→M2b in the namespace catalog.
              (2) **Conflict → `_review/`** — same-path/different-content collision routes to staging like any
                  uncertain item; the in-plan rename/overwrite/skip resolution workflow is deferred.
                  FR-013→Superseded by FR-005; `clear-conflict` action dropped from every surface.
              (3) **Findability = ledger inspection** — no dedicated Mail→Copy lookup tool in v1; the greppable
                  Provenance Ledger IS the artifact. FR-010/NFR-005 reduced.
              (4) **Run Scope = folder only** — optional date range dropped (dedup makes full re-scans safe).
                  FR-014 reduced.
              Also banked this session (pre-challenge): NFR-005/G4/CONTEXT note that findability survives the
              User moving/archiving the source mail — lookups key on `Message-ID`, never on folder location.
        - [x] in case of significant changes: grill-with-docs again (only in respect to the changes)
        /grill-with-docs Grill me ONLY about the change set in `git diff HEAD~1 HEAD`. Treat that diff as the entire plan; read other files only to check consistency, never as new grill subjects.
      
      - [x] other skills/guardrails from coding repo (before or after entity-model skill)?
        - PROMPT:
            The gr_xxx.MD documents in the coding/gr folder contain various guardrails (multiple items per gr_xxx.md document). 
            These shall later be covered by skills that do not yet exist (see the "Phase Skills table" section in coding/coding_plan.md).
            The next step according to the aiup workflow would be to run the entity-model skill.
            I wonder which of the various items in the gr_xxx.md document should be challenged to the current planning documents before running the entity-model skill.
      
      - [x] create new skills to align aiup and the coding project
            ➜ SUPERSEDED (2026-06-03): see `plan/skills.md` — the authoritative, self-contained spec
              (generic peer skills + a modified `domain-model`, built by hand as ai-mail project
              skills, NOT via `/make-skill`). The detail below is retained as background only.
            GOAL: generic (NOT ai-mail-specific) "bridge" skills invoked at AIUP-step boundaries,
            each injecting the `gr_*.md` guardrails that the generic `aiup-core` skills lack.
            ai-mail is the first test case, not the audience. Guardrail source of truth:
            `C:\PROJ\ai-knowhow\coding\gr\*.md`. Build each via the coding toolchain
            (`/make-skill <name>`; source docs = the cited gr items + the target aiup-core
            SKILL.md body at `~/.claude/plugins/.../aiup-core/skills/<step>/SKILL.md`).
      
            WHY (the gap — confirmed by reading the aiup-core bodies 2026-06-03): the aiup-core
            skills are thin and storage/CRUD-flavored, carrying zero domain discipline:
            - `entity-model` reads ONLY `requirements.md` — NOT `CONTEXT.md`. It makes every term
              an entity-with-an-`id` (no value-object / aggregate concept) and invents DB datatypes
              (`Long`/`Decimal`/`Sequence`). Collides with gr_ddd D5/D2/D3, gr_domain_language L4/L8.
            - `use-case-diagram` / `use-case-spec` read requirements (+ puml) only: generic actors,
              no ubiquitous-language enforcement, no hidden-constraint sweep, no ADR threshold,
              no Pareto/scope discipline.
      
            DESIGN: two layers (mirrors coding_plan's B-cross-cutting + A-per-phase split). Each
            bridge runs PRE (challenge source docs, hand aiup-core a constrained brief) and POST
            (verify the produced artifact against its gr cluster, loop fixes back into CONTEXT/ADR).
      
        --- Layer 1: reusable LENS skills (one gr cluster each; called by the Layer-2 preps) ---
      
        - [x] `ubiquitous-language-guard`  [gr_domain_language L1,L2,L4,L6,L8,L9 + gr_greenfield G7]
              WHY: the single highest-value bridge — aiup-core ignores CONTEXT.md; this re-injects it
              as ground truth and keeps it current. Fixes the entity-model "never reads CONTEXT" gap.
              IN: any AIUP artifact (requirements.md / entity_model.md / *.puml / use_cases/*.md) + docs/CONTEXT.md.
              DOES: flag forbidden synonyms (L2, e.g. the `_Avoid_` lists), storage-shaped names (L4),
              and silently-invented terms (L6); on lexical/semantic near-match halt-and-ask
              "same / refinement / new" (Aln17 #4); confirm each domain name appears verbatim (L1).
              OUT: term-diff report; HITL-approved new/changed terms written BACK into CONTEXT.md (L8 loop);
              CLAUDE.md pointer check (L9).
      
        - [x] `hidden-constraint-sweep`  [gr_algn Aln6 + B5]
              WHY: aiup-core never surfaces the commonly-missed NFR/edge classes; this makes them explicit.
              IN: a requirements doc or a use-case spec + grilling/CONTEXT context.
              DOES: run the 8-class Aln6 checklist — security/PII, permissions, data-retention, migrations,
              observability, public-API-compat, concurrency, out-of-scope — each → `covered` (pointer) |
              `not-applicable` (recorded reason) | `missing` (blocks).
              OUT: per-class table; `missing` classes become new FR/NFR or use-case alt-flows, or G9 deferrals.
      
        - [x] `adr-threshold-gate`  [gr_adr Adr1, Adr5, Adr8]
              WHY: hard-to-reverse modeling/design decisions otherwise get buried in an ERD cell or UC step.
              IN: an artifact (pre or post) + docs/adr/*.
              DOES: scan for decisions crossing Adr1 (hard-to-reverse AND surprising AND real-tradeoff);
              per hit, HITL ask "ADR-worthy?" naming the 3 criteria; draft per Adr5 (Context/Decision/
              Consequences/Alternatives); status `proposed`→`accepted` HITL only (Adr8).
              OUT: new `docs/adr/NNNN-*.md` (proposed) + a one-line "no-ADR, why" note for sub-threshold ones.
      
        - [x] `pareto-scope-cut`  [gr_greenfield G1, G3, G5, G9, G10]
              WHY: the project's Pareto floor; stops aiup-core modelling future/imagined scope (e.g. M2b terms).
              IN: any planning artifact + the project's scope marker (here: M2 vs M2b/M3/M4).
              DOES: flag entities/FRs/flows built for imagined needs (G1/G3/G5/G10); push them to a deferred
              list with a one-line postponed-decision record each (G9).
              OUT: in-scope vs deferred split; a "Postponed decisions" log appended to the artifact.
              NOTE (G5): may be embedded inline in the preps first; extract to a standalone skill only once a
              second prep actually reuses it.
      
        --- Layer 2: per-step PREP orchestrators (invoke these right before each aiup-core skill) ---
      
        - [x] `prep-entity-model`  (before `/entity-model`)
              [gr_ddd D2,D3,D5,D7,D9 + gr_architecture A9 | calls: ubiquitous-language-guard, pareto-scope-cut
               | watch: adr-threshold-gate, hidden-constraint-sweep(retention/concurrency/PII)]
              WHY: without it, entity-model makes everything a table, ignores CONTEXT.md, and models M2b.
              IN: docs/CONTEXT.md, docs/requirements.md, docs/adr/*.
              DOES (pre): classify EACH CONTEXT term as Entity | Value-Object | Aggregate-root (D5/D2 — e.g.
              Confidence/RoutingKey/Sender = VO; Mail/Attachment/Proposal/Ledger-entry = entity; pin the
              Ledger as its own aggregate per ADR-0001); turn implied invariants into validation-rules
              (D3/D9 — Confidence∈[0,1], Attachment∈exactly-one-Mail); mark in-scope vs deferred (G3/G9 —
              defer Document Type, Naming Scheme, F32); keep infra out of the model (A9 — key on Message-ID,
              never IMAP-UID).
              OUT (pre): a "model brief" (entity/VO/aggregate table + invariant list + in/out-of-scope list)
              handed to /entity-model; POST: verify the ERD uses CONTEXT names verbatim, leaked no storage
              datatypes, contains no deferred (M2b) entities, and looped any genuinely-new structural entity
              (F22 dedup key) back into CONTEXT.md.
      
        - [x] `prep-use-case-diagram`  (before `/use-case-diagram`)
              [gr_domain_language L1 + gr_greenfield G2 + gr_mod M6,M10 | calls: ubiquitous-language-guard, pareto-scope-cut]
              WHY: aiup-core invents generic actors ("Administrator") and has no slice/scope discipline.
              IN: docs/requirements.md, docs/CONTEXT.md (actor terms).
              DOES (pre): fix the actor set from CONTEXT (here: one `User` role, no fabricated Admin); pick the
              minimal first vertical slice of use cases (G2); map each UC → ≥1 FR; seed the module-map (M6/M10).
              OUT (pre): actor list + UC slice + UC→FR trace table handed to /use-case-diagram; POST: verify
              every UC traces to an FR, actors match CONTEXT, no implementation detail in UC names, scope not
              ballooned past M2.
      
        - [x] `prep-use-case-spec`  (before `/use-case-spec`)
              [gr_ddd D1,D3,D9 | calls: hidden-constraint-sweep, adr-threshold-gate, ubiquitous-language-guard]
              WHY: aiup-core writes generic alt-flows and never forces the irreversible interaction decisions.
              IN: docs/requirements.md, docs/use_cases.puml, docs/CONTEXT.md, docs/adr/*.
              DOES (pre): enumerate alternative flows from the hidden-constraint sweep + the branches already
              banked (~todo.md:91 — file-already-exists, conflict, below-confidence→staging, not-every-
              attachment, rename); turn domain invariants into Business Rules (BR-###, D1/D3/D9); FORCE the
              interaction-surface + mail-selection decision here (Adr1-class → adr-threshold-gate).
              OUT (pre): alt-flow checklist + BR/invariant list + resolved-surface decision handed to
              /use-case-spec; POST: verify every error/edge branch has an alt-flow, BRs map to CONTEXT
              invariants, and the surface decision is captured (ADR or CONTEXT term).
      
        BUILD ORDER (fresh sessions, value-first):
        1. `ubiquitous-language-guard`  — highest reuse; fixes the CONTEXT-ignored gap; standalone.
        2. `prep-entity-model`          — the immediate next AIUP step; calls #1.
        3. `hidden-constraint-sweep` + `adr-threshold-gate`  — needed by the spec prep; retroactively useful.
        4. `prep-use-case-diagram`, `prep-use-case-spec`.
        5. `pareto-scope-cut`           — embed inline in the preps first; extract only if reused (G5).

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
      create skills_refactoring.md in the skills folder that contains a critical review of all the skill there. 
      This file shall later be used to refactor the skills one for one in fresh agent sessions.
      Each skill review shall start with a "- [ ] " term to signal that the refactoring is pending.
      The review for each skill shall at least:
      - check if the skill related guardrail items located in the various coding/gr_XXXX.md files are fully covered (are there items missing?)
      - check if the purpose of the skill will likely be achieved
      - if the skill is generally written effectively, so an AI agent gets sufficient and clear input, but not too much input
      - run each review that generates the review content for a single unchecked skill in todo.md section "skill review" in a fresh sub-agent and insert its result in skills_refactoring.md
      - each of the sub-agents must only create such review content for a single skill 
      - Here is the skill list:
      - [x] `ubiquitous-language-guard` — **lens** · enforce the glossary on `requirements.md`; write approved new/changed terms back into `CONTEXT.md` (HITL).
      - [x] `pareto-scope-cut` — **lens** · cut imagined/future scope (ai-mail: defer M2b/M3/M4); append a Postponed-decisions log.
      - [x] `domain-model` — **fork** · produce the conceptual model (glossary-aware, VO/aggregate-aware) → `docs/entity_model.md`.
      - [x] `domain-requirements`
      - [x] `adr-threshold-gate` — **lens** · catch any irreversible modelling decision → `docs/adr/####-*.md` (proposed; HITL to accept).
      - [x] `hidden-constraint-sweep` — **lens** · the 8-class sweep (retention / concurrency / PII / …) the model implies.
      - [x] `trace-check`

- [x] sequential skill refactoring
      refactor a skill in the skills folder according to skills_refactoring.md
      Each refactoring shall be done using opus 4.8 model with high thinking mode enabled and fast mode off. 
      Mark the refactoring done, when finished the work.
      If needed, adjust skills_overview.md also.
      - only refactor the next unchecked skill, ignore any other task in todo.md that is related to the same skill 
      - Here is the skill list:
      - [x] `ubiquitous-language-guard` — **lens** · enforce the glossary on `requirements.md`; write approved new/changed terms back into `CONTEXT.md` (HITL).
      - [x] `pareto-scope-cut` — **lens** · cut imagined/future scope (ai-mail: defer M2b/M3/M4); append a Postponed-decisions log.
      - [x] `domain-model` — **fork** · produce the conceptual model (glossary-aware, VO/aggregate-aware) → `docs/entity_model.md`.
      - [x] `domain-requirements` — **fork** · glossary-aware `docs/requirements.md` (actors/nouns verbatim) + Out-of-Scope/Non-Goals carried from the vision (Aln15) + Flagged-Terms hand-off → `ubiquitous-language-guard` (L6).
      - [x] `adr-threshold-gate` — **lens** · catch any irreversible modelling decision → `docs/adr/####-*.md` (proposed; HITL to accept).
      - [x] `hidden-constraint-sweep` — **lens** · the 8-class sweep (retention / concurrency / PII / …) the model implies.
      - [x] `trace-check`

