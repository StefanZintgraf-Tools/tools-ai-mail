# todo

Next step to continue, see unchecked "[ ]" term

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
        - [ ] in case of significant changes: grill-with-docs again (only in respect to the changes)
        /grill-with-docs Grill me ONLY about the change set in `git diff HEAD~1 HEAD`. Treat that diff as the entire plan; read other files only to check consistency, never as new grill subjects.
        - [ ] other skills/guardrails from coding repo?
      - [ ] check below steps with aiup/book-library/tutorial.md
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

