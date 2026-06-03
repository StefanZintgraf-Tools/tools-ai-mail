# todo (ideas, not yet fixed)

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
