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

- **Topic:** Scope of the *first version (v1)* of AI-supported mail handling, focused on a subset - one single testable module (Module1) - of the mail **attachment handling/archiving**. VERY IMPORTANT: besides this Module1, the architecture must be approved using Tracer Bullets (see https://www.aihero.dev/tracer-bullets). The Tracer Bullet concept means, that the result must also include a very thin slice through all parts of the architecture (prototype or mocked modules). 
- **Goal (the why):** Decide what belongs in v1 and what is deferred — while making sure the v1 architecture does not paint the future vision into a corner.
  Also, a (press-release like) rough overview of possible high-level use-cases from a user point of view must be generated. All independent modules the final solution may have should be included. The architecture decisions made (see §3) are just a starter/idea and not finally decided. A final vision of the product shall be generated (press-release, arhcitecture, modules overview) and also what can be v1, Module1 and what the very first Tracer Bullet slice must include.
- **Out of Scope:** Any detailled decisions like specific requirements, programming language decision etc.

### Tracer Bullets Rule

When building features, build a tiny, end-to-end slice of the feature first, seek feedback, then expand out from there.
When building systems, you want to write code that gets you feedback as quickly as possible. Tracer bullets are small slices of functionality that go through all layers of the system, allowing you to test and validate your approach early. This helps in identifying potential issues and ensures that the overall architecture is sound before investing significant time in development.

## 2. Vision (the long-term picture)

An **AI mail assistant** that grows feature by feature:

1. **Module1 — First module of the Attachment handling (this session):** the first module of this use-case: user triggers archiving of mail attachments from Outlook; backend fetches, classifies (AI/LLM), and stores them at the right target location.

2. **Later — All modules for v1:** the first usable version of this use-case: user triggers archiving of mail attachments from Outlook; backend fetches, classifies (AI/LLM), and stores them at the right target location.

3. **Later — Enhanced version of v1 and then AI-supported mail search and more** in the style of *Lookeen* (fast, content-aware search across mailboxes and archives). Note: the v1 analyzer/classification layer likely overlaps with future search indexing — a scoping tension to explore in the session.

4. **Later — AI-supported mail search and more** in the style of *Lookeen* (fast, content-aware search across mailboxes and archives). Note: the v1 analyzer/classification layer likely overlaps with future search indexing — a scoping tension to explore in the session.

5. **Later — further AI mail features** (archiving, triage, summarization, etc. — open).

## 3. Starting Point — Initial (restricted) brainstorming

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
