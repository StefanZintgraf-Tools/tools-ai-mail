# Brainstorming Session Brief — AI-Mail v1 Scope

> **Purpose of this file:** Session briefing for an AI brainstorming coach. When the user
> starts a brainstorming session (e.g. via `bmad-brainstorming`), load this file as the
> session's starting context — topic, goal, inputs, stance, and technique batch are
> already decided. Do not re-ask for them; confirm briefly and begin.
> 
> Companion reference: [bmad_brainstorming.md](bmad_brainstorming.md) (full method catalog & chooser).
> Created: 2026-06-11.

---

## 1. Topic & Goal

- **Topic:** A first **product overview** of AI-supported mail handling — the long-term vision, the user-facing use-cases, and a coarse map of the modules the full solution may need. Within that frame, a first cut at what belongs in the *first version (v1)* and what is deferred, and the one thin first module (**Module1**) of **attachment handling/archiving**.
- **Goal (the why):** Produce a shared, high-level picture of the product:
  1. A **press-release-style vision** of the full AI mail assistant from the user's point of view.
  2. A **rough overview of high-level use-cases** (user POV) and the **coarse set of independent modules** the final solution may have.
  3. A first **v1 / later split**, and the irreducible **Module1** that proves the idea.
- **Stay high-level on features, but think architecture-wide on seams:** Keep modules and use-cases coarse and user-facing — *don't* design internals or pick technology. But the *set of architecturally-significant seams* must be drawn from the **whole vision**, not just Module1's feature, so the first slice isn't scoped too narrowly to survive later modules.
- **Out of Scope:** Detailed requirements, technology/language choices, and final internal design of any module.

### Tracer Bullets — and why the whole vision shapes the first slice

The end-state architecture is validated with **Tracer Bullets** (see https://www.aihero.dev/tracer-bullets): a slice that runs end-to-end through all layers to prove the approach early. The key property: a tracer bullet is **thin in functionality but complete in architectural reach** — it touches *every* architecturally-significant seam, each module present but minimal or stubbed.

"Reach" here is defined by the **full vision**, not by Module1's narrow feature. A first version scoped to too few modules risks locking in an architecture that a later module (e.g. Lookeen-style search reusing the analyzer/classification layer) breaks. So in *this* session we must, at a coarse level: (a) name the seams the full vision implies, and (b) check that Module1 / the first tracer bullet pierces those seams (stubs are fine) rather than omitting them. We defer *how* each seam is built, not *whether the slice reaches it*.

## 2. Vision (the long-term picture)

An **AI mail assistant** that grows feature by feature:

1. **Module1 — the thin first slice (this session's focus):** the smallest end-to-end move that proves the idea — e.g. user triggers archiving on one mail; backend fetches its attachments and stores them, with classification minimal or stubbed. Thin in *capability*, but it should still **reach through every architecturally-significant seam the full vision implies** (each module present, stubbed where needed), so the architecture it validates isn't too narrow for later modules.

2. **v1 — first usable version of attachment handling:** user triggers archiving of mail attachments from Outlook; backend fetches, classifies (AI/LLM), and stores them at the right target location. Module1 grown out to a real, daily-usable feature.

3. **Later — AI-supported mail search** in the style of *Lookeen* (fast, content-aware search across mailboxes and archives). Note: the v1 analyzer/classification layer likely overlaps with future search indexing — a scoping tension to explore in the session.

4. **Later — further AI mail features** (triage, summarization, smart replies, etc. — open).

## 3. Starting Point — Architecture seed (reference input, not a target)

> These are *prior* ideas from an earlier technical chat. Use the **module cut below as the candidate
> seam map** — the list of architecturally-significant seams to check Module1's reach against (§1). But
> treat the *technical specifics* (ES5, IMAP/Graph, service count) as reference only, not decisions, and
> don't let them pull this overview session into internal design.

Source: [plan/Outlook_Architecture_Discussion.md](../plan/Outlook_Architecture_Discussion.md) (chat transcript). Some ideas already there:

- **Frontend = Office Web Add-in** (TypeScript → ES5 for Outlook 2019 baseline; single codebase for Outlook 2019/2024/365). Thin client: sends *commands only*, no attachment payloads.
- **Heavy backend** with mailbox access (IMAP / Gmail / Graph API — "fetch" model). PST support was **dropped** as a requirement (exclusive file lock makes parallel access impossible).
- **Ports & Adapters (hexagonal) module cut:**
  - *Frontend* (Outlook add-in or later webapp) — selects mails, sends archive requests
  - *Archive-manager* — receives commands (all attachments or subset)
  - *Mail-client backend* — mailbox access adapter (IMAP, Gmail, …)
  - *Storage-backend* — stores attachment at target location (filesystem, DB, …)
  - *Dispatcher* — decides target location based on sender, content, etc.
  - *Analyzer / extraction module (agentic layer)* — OCR/parsing + LLM classification, key-value extraction feeding the dispatcher
  - *State/queue manager* — job states (Pending, Fetching, Stored), retries
- **PoC consolidation option:** 3 physical services (Frontend, Core API, Adapter) carrying the 5+ logical modules.

# Session Brief Review

The remaining parts of this session brief have to be reviewed so they fit to the reworked items 1, 2, 3 above.

## 4. Session Setup (pre-decided — confirm, don't re-elicit)

- **Skill:** `bmad-brainstorming`
- **Stance:** **Creative Partner** (coach facilitates *and* contributes ideas; authorship tracked)
- **Participant:** Stefan (solo + AI)
- **Inputs to load:** this file; the MD above; optionally `bmad_brainstorming.md` for technique mechanics

## 5. Technique Batch (run in this order)

1. **Backcasting** *(structured, classic)* — **lead technique.** Fix the end-state vividly: the full AI mail assistant (archiving + Lookeen-style search + triage + archiving + other ideas found in the brainstorming) working in daily use. Then walk backward step by step to the one move v1,Module1 must make first. Output: what v1 must *prove*, and which architecture pieces are needed now vs. later. Use this to validate the module cut in §3.
2. **Job to Be Done** *(structured, classic)* — what is attachment handling really being *hired* for? Candidate jobs to probe: "save file to folder", "never lose an invoice again", "make mail content findable" (note: the last one already overlaps with future search → scoping tension). Output: the underlying job, and what the AI analyzer must minimally do in v1 to serve it.
3. **One Feature Only** *(constraint, signature)* — if v1 could keep exactly ONE capability and make it unbelievably good, which is it? (Auto-filing by sender? LLM classification? Manual one-click archive?) Output: the irreducible core; fights the temptation to build all five modules at full depth at once.
4. **Cursed Genie** *(absurdist, playful)* — edge-case sweep: make a wish ("archive this mail's attachments"), let the genie grant it disastrously. Seed cases: locked PST (already found in the PDF), 50 MB attachments, mails with 20 attachments, duplicate filings, misclassified invoices, signature images archived as "attachments", token expiry mid-job. Output: edge-case list → v1 requirements vs. accepted limitations.

## 6. Convergence (separate phase, after the batch is spent)

- **MoSCoW** — sort everything generated into **Must / Should / Could / Won't (this version)**.
  - The *Won'ts* become the documented "later" roadmap (AI search, additional frontends, …).
  - If candidates pile up, pre-filter with an **Impact–Effort matrix** first.

## 7. Expected Outputs

1. Brainstorming session document (the skill's standard artifact, saved to the configured output folder).
2. A **v1 scope statement**: the one job v1 does, its Must/Should/Could list, and explicit Won'ts.
3. **Edge-case register** from Cursed Genie (input for requirements/testing).
4. Validation or revision notes on the §3 module cut (which modules are v1-real, which are stubs/deferred).
5. Hand-off pointer: results feed `bmad-product-brief` / `bmad-prd` (BMAD Phase 1 → 2).

---

*Coach instructions: greet, confirm this brief in two sentences, then start technique 1
(Backcasting). Keep divergence pure — no prioritizing until §6. Log everything to the
memlog. Aim past 100 ideas across the batch; the magic happens in ideas 50–100.*
