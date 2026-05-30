# todo

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

- [ ] analyse https://github.com/humanlayer - anything useful (for the workflow/method or for the implementation)?

- [ ] M2 build setup — pick ONE proven spine + Pocock skills as power tools (= proven method, not free-style). The golden corpus + TDD gate are method-agnostic and apply under either option. Technical substance carried from the retired entry below (still authoritative): golden corpus FIRST, F06 + F22 contracts, F04→existing-folders-only, per-slice spec floor, unvalidated-acontis-pains + M3-danger-zone risks.

  **Option A (recommended) — Spec Kit + Pocock skills.** Why: the only proven spine that covers spec→implement on a Python/TS stack — i.e. it closes the autonomous-coding gap AIUP can't fill on this stack. ~3–10× first-pass success reported on non-trivial tasks.
  - [ ] install GitHub Spec Kit for Claude Code in ai-mail — https://github.com/github/spec-kit
  - [ ] Pocock `/grill-me` on M2 scope first — harden P01/P02 + surface hidden assumptions before specifying
  - [ ] `/speckit.specify` — M2 (attachment auto-router: extract → classify → file a COPY; pains P01/P02)
  - [ ] `/speckit.plan` — choose stack + architecture; bake in F06 provenance + F22 idempotency as constraints; F04 → existing folders only
  - [ ] `/speckit.tasks` — task breakdown (≈ the F01 → F02 → F03 → F04 → F22 slices)
  - [ ] build the golden corpus (~50–100 real anonymized attachments → {type, folder}) + accuracy gate **before** implement
  - [ ] `/speckit.implement` — autonomous, gated by the corpus; TDD discipline inside the loop
  - [ ] Pocock `/review` — fresh-context review of the diff

  **Option B (alternative) — AIUP + Pocock skills.** Why pick instead: if Spec Kit feels too heavy on trial; AIUP's stable-ID artifact format is closest to the existing P/A/F/M style.
  - [ ] install `aiup-core` only — https://github.com/AI-Unified-Process/marketplace (skip `aiup-vaadin-jooq`, it's Java/Vaadin-locked)
  - [ ] Pocock `/grill-me` on M2 scope first (same as A)
  - [ ] write `docs/vision.md` for M2
  - [ ] `/entity-model` — yields the missing domain model (Attachment, RoutingRule, Provenance/F06)
  - [ ] `/use-case-spec` — the M2 spec
  - [ ] EXECUTION is not covered by AIUP on this stack → golden corpus + Pocock `/to-issues` → `/tdd` → `/ralph` → `/verify`
  - [ ] Pocock `/review` — fresh-context review of the diff

  - [ ] decision: try Option A first (~30 min to first `/speckit.specify`); fall back to B if it feels too heavy. (Pareto: trying beats another comparison round.)

- [ ] M2 build setup (retired) — outcome of the 2026-05-30 multi-role roundtable review (see memory: ai-mail-namespaces-and-direction). A fresh-session agent should start here.
      Workflow (decided): keep ONLY AIUP's principle — "no code without a use case; no merge without a test traceable to a pain ID" (nearly free, the pain IDs already exist). Drop AIUP's 4 phases. Do NOT adopt BMAD wholesale (team-coordination ceremony a solo dev doesn't need — use one /code-review pass on the diff instead). Loop per slice: thin ½-page spec → minimal docs/tickets/ queue (tickets = autonomy fuel for /ralph, NOT handoff artifacts) → autonomous TDD → /verify on the live private mailbox.
      Build M2 first — justification = LOW BLAST RADIUS (files a copy; safe for an autonomous loop) + SUBSTRATE LEVERAGE (bottom of the dependency DAG: F03 gates M3/M4, F02 cheapens M1). NOT because it is "deterministic" (F03 classify + F04 derive-folder are LLM-judgment nodes with a fuzzy oracle) and NOT because of the Reach score.
      FIRST deliverable is NOT code: build a labelled golden corpus of ~50–100 real (anonymized) attachments → {correct type, correct folder} + an accuracy gate (≥~90% exact-folder match, 0 silent low-confidence files). Without it the TDD loop self-grades tautologically = vibe-coding with a green badge.
      Then design two substrate contracts BEFORE any module code: F06 record-provenance (cross-cutting — constrains every primitive's interface) and F22 write-to-external-system (MUST specify idempotency — no double-filing/overwrite into Drive; e.g. content-hash / provenance-keyed dedupe).
      Constrain F04 v1 to choose only from EXISTING Drive folders (no folder creation) → turns "which folder?" into gradeable closed-set classification; anything that doesn't fit → _review/ staging. F03/F04 must emit a confidence score; below threshold → _review/, never auto-file.
      Per-slice spec floor (the anti-vibe-code contract, ~½ page): (1) pain ID(s) · (2) function contract (I/O types from functions.md) · (3) the closed set of valid outputs (folder taxonomy enum) · (4) test oracle + pass threshold + golden-set path · (5) confidence/abort branch (→ _review/) + non-destructive guarantee · (6) done = a pain-ID-traceable test is green.
      Open risk to honor: acontis pains (M3/M5/M6) are Stefan imagining 4 other roles' work ("nur eine Annahme") — gate any acontis-targeted capability behind a 30-min check with a real role-holder before it earns a ticket. M3 (F15 learn-rule + irreversible mail actions) is the danger zone — needs F16 confirmation + undo/audit log; don't carry M2's light process into it.
      On capability_pain_matrix.md: treat the Reach scoring as a coverage map, NOT a decision ruler (under-determined — 3 sections lack 🔥 markers; the ÷🔥-per-role divisor rewards terse sections).

- [ ] M2, siehe capability_pain_matrix.md
      Design the F22 / F03 interfaces first (the substrate) so M1/M3 reuse is clean — small, high-leverage.
      Vertical tracer slice: one hard-coded sender → one Drive folder, end-to-end, then generalize.
      Sharpen the open 🔥 markers (Order role + both X-cut sections) — would re-rank M4/M2/M1 if you want the scoring airtight before building.



- [ ] add information from Mat Pococks tutorials (e.g. ubiqitous language)
- [ ] check what ideas from outlook-RAG are missing in the plan that would make sense to add
- [ ] repeat grill-me session
- [ ] check workflow from Matt Pacock (Kanban etc.)
- [ ] check sw-documents mentioned by Matt and add to guardrails
- [ ] create architecture guardrails (deep modules instead of shallow ones)
- [ ] repeat grill-me session with new input
- [ ] how to assure maximum automated coding/testing?
- [ ] experiment workflow, bmad, ec-plan, other ideas?
