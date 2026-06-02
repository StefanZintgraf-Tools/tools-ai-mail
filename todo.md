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
        - [ ] human review/edit/adjust requirement.md (see tutorial.md from aiup/book-library)
        - [ ] in case of significant changes: grill-with-docs again (only in respect to the changes)
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

- [ ] M2 build setup (00-foundation.md) — pick ONE proven spine + Pocock skills as power tools (= proven method, not free-style). The golden corpus + TDD gate are method-agnostic and apply under either option. Technical substance carried from the retired entry below (still authoritative): golden corpus FIRST, F06 + F22 contracts, F04→existing-folders-only, per-slice spec floor, unvalidated-acontis-pains + M3-danger-zone risks.

  - [ ] first grilling session — `/grill-me` on M2 scope (do this in a FRESH session; input below)

      **Why grilling now (not another brainstorm):** the option space is already abundant (M1–M6, F01–F29, ~50 pains, Reach + finalist squeeze). The need is CONVERGENT (resolve the decision tree, surface hidden assumptions), not DIVERGENT (more ideas). Another comparison round = the analysis-paralysis trap the Pareto guardrail exists to prevent ("trying beats another comparison round"). grill-me is the right tool; the language/app-type CHOICE is then nailed later, inside the chosen spine's plan step (`/speckit.plan` / `/create_plan`) — NOT grill-me's job.

      **Key finding from the 2026-05-31 pre-grill discussion — M2 is NOT a headless fire-and-forget tool.** It is human-in-the-loop. It splits into TWO layers:
      - (1) **headless propose-pipeline** `F01 detect → F02 extract → F03 classify → F04 derive-folder` — stays individually testable; this is what the golden corpus grades. It only *proposes*.
      - (2) **human approval surface** — where the human decides before anything commits via `F22 write`. This is the part the coverage matrix glossed over.
      "Headless" was wrong about the *capability*; still right about the *core primitives*.

      **The human-decision points that force layer (2)** (Stefan's examples — all sit at commit time):
      - rename the file (e.g. `scan.pdf` → `insurance_policy.pdf`)
      - target folder unclear / undefined / does-not-exist → approve, pick, or create
      - not every attachment should be filed → user selects which
      - file already exists → human resolves the conflict

      **This = the `require_approval` / human-as-tool pattern already banked (todo.md:33), in its LIGHT weight class.** M2's actions are low-stakes & reversible (files a COPY) → needs a *review/approve* surface, NOT M3's heavy deterministic-gate + undo + audit-log. Same pattern, different weight.

      **Substrate consequence (revises the matrix):** F16-style confirmation is SHARED substrate — needed by M2, not M3-only as 00-foundation.md currently has it. And "rename" + "conflict-resolution" may be NEW primitives not yet in the F-catalog. Confirm during grilling.

      **Straw-man to walk in and defend (plan/apply, terraform-style):** phase 1 = pipeline emits a *reviewable list of proposed actions* (suggested rename · target folder · conflict flag · confidence); human edits/approves the list; phase 2 = execute only the approved rows. Honors all four decision points, needs NO GUI (the "UI" is an editable file), and the proposed-actions list IS the artifact the golden corpus grades. No-GUI ≠ no-human — it's *asynchronous* human-in-the-loop. Bring this as the position to attack, not a blank slate.

      **Branches to push hardest in the grill:**
      - Shape of the approval surface: sync per-file CLI prompt · batch `_review/` queue · plan/apply list · HumanLayer-style channel approval — which, and why (Pareto)?
      - What earns "primitive" status — are rename & conflict-resolution F-primitives, or just surface behaviour?
      - Mail-access surface for the private mailbox: IMAP · Graph API · local PST?
      - The EXISTING-folder taxonomy (local/network filesystem) that makes F04 a gradeable closed set.
      - F22 idempotency mechanism (content-hash / provenance-keyed dedupe — no double-filing/overwrite).
      - Deferred ON PURPOSE to the spine's plan step, NOT grilled here: programming language / stack (Python vs TS).

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

  **Option C (alternative) — HumanLayer RPI + Pocock skills.** Why pick instead: the MOST Claude-Code-native of the three — drop-in `.claude/commands` + research subagents, zero install (Apache-2, just `cp -r`). Its `implement_plan` + `validate_plan` is a genuinely **stack-agnostic execution half** (binds to conventions you give it, not a language) — closing the same gap A leaves (Java-locked `/implement`) and B leaves (Python/TS-only autonomous half). Phase-gated human verification (pause + split automated/manual success criteria after every phase) is baked in. Trade-off: a 7-step pipeline = more ceremony than A's 4 commands, and its killer feature — FIC (Frequent Intentional Compaction, brownfield 300k-LOC context discipline) — is largely **wasted on greenfield M2**. Repo cloned locally at `C:\PROJ\github\humanlayer`.
  - [ ] copy `.claude/commands/` + `.claude/agents/` from the humanlayer repo into ai-mail; use the `_nt` (no-thoughts) command variants — skip the `thoughts/` infra + `humanlayer thoughts sync` for a solo greenfield project
  - [ ] Pocock `/grill-me` on M2 scope first (same as A/B — RPI's `create_plan` is skeptical but not adversarial; grill-me hardens, RPI executes)
  - [ ] `/research_codebase` — light for greenfield (map only the Pipedrive-MCP + Drive surface + existing folder taxonomy)
  - [ ] `/create_plan` — M2 plan; bake in F06 provenance + F22 idempotency as constraints; F04 → existing folders only; no open questions in the final plan
  - [ ] build the golden corpus (~50–100 real anonymized attachments → {type, folder}) + accuracy gate **before** implement (method-agnostic, same as A/B)
  - [ ] `/implement_plan <plan>` — phase-gated; pauses for human verification each phase; TDD discipline inside the loop; gate on the corpus
  - [ ] `/validate_plan` + Pocock `/review` — fresh-context review of the diff

  - [ ] decision: try Option A first (~30 min to first `/speckit.specify`); fall back to B if it feels too heavy. **C is the strongest "Claude-Code-native" contender** — worth a parallel ~30-min look (it's a zero-install `cp -r`) before committing, since its stack-agnostic execution half is exactly the gap A/B each leave. Pick ONE spine (running two = the free-style trap). (Pareto: trying beats another comparison round.)

- [ ] M2 build setup (retired) — outcome of the 2026-05-30 multi-role roundtable review (see memory: ai-mail-namespaces-and-direction). A fresh-session agent should start here.
      Workflow (decided): keep ONLY AIUP's principle — "no code without a use case; no merge without a test traceable to a pain ID" (nearly free, the pain IDs already exist). Drop AIUP's 4 phases. Do NOT adopt BMAD wholesale (team-coordination ceremony a solo dev doesn't need — use one /code-review pass on the diff instead). Loop per slice: thin ½-page spec → minimal docs/tickets/ queue (tickets = autonomy fuel for /ralph, NOT handoff artifacts) → autonomous TDD → /verify on the live private mailbox.
      Build M2 first — justification = LOW BLAST RADIUS (files a copy; safe for an autonomous loop) + SUBSTRATE LEVERAGE (bottom of the dependency DAG: F03 gates M3/M4, F02 cheapens M1). NOT because it is "deterministic" (F03 classify + F04 derive-folder are LLM-judgment nodes with a fuzzy oracle) and NOT because of the Reach score.
      FIRST deliverable is NOT code: build a labelled golden corpus of ~50–100 real (anonymized) attachments → {correct type, correct folder} + an accuracy gate (≥~90% exact-folder match, 0 silent low-confidence files). Without it the TDD loop self-grades tautologically = vibe-coding with a green badge.
      Then design two substrate contracts BEFORE any module code: F06 record-provenance (cross-cutting — constrains every primitive's interface) and F22 write-to-external-system (MUST specify idempotency — no double-filing/overwrite into target folder; e.g. content-hash / provenance-keyed dedupe).
      Constrain F04 v1 to choose only from EXISTING target folders on local/network filesystem (no folder creation) → turns "which folder?" into gradeable closed-set classification; anything that doesn't fit → _review/ staging. F03/F04 must emit a confidence score; below threshold → _review/, never auto-file.
      Per-slice spec floor (the anti-vibe-code contract, ~½ page): (1) pain ID(s) · (2) function contract (I/O types from 00-foundation.md) · (3) the closed set of valid outputs (folder taxonomy enum) · (4) test oracle + pass threshold + golden-set path · (5) confidence/abort branch (→ _review/) + non-destructive guarantee · (6) done = a pain-ID-traceable test is green.
      Open risk to honor: acontis pains (M3/M5/M6) are Stefan imagining 4 other roles' work ("nur eine Annahme") — gate any acontis-targeted capability behind a 30-min check with a real role-holder before it earns a ticket. M3 (F15 learn-rule + irreversible mail actions) is the danger zone — needs F16 confirmation + undo/audit log; don't carry M2's light process into it.
      On 00-foundation.md: treat the Reach scoring as a coverage map, NOT a decision ruler (under-determined — 3 sections lack 🔥 markers; the ÷🔥-per-role divisor rewards terse sections).

- [ ] M2, siehe 00-foundation.md
      Design the F22 / F03 interfaces first (the substrate) so M1/M3 reuse is clean — small, high-leverage.
      Vertical tracer slice: one hard-coded sender → one target folder, end-to-end, then generalize.
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
