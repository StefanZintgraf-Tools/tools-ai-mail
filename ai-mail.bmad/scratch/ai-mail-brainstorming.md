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

## 3. Starting Point — Architecture seed (starting input, not a target)

> These are *prior* and first ideas from an earlier technical chat. Use the **module cut below as the candidate
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

## 4. Session Setup (shared defaults — confirm, don't re-elicit)

The three goals are tackled in **three separate sessions, one per act** — a single session covers
**one act only**, to keep each context clean and avoid context rot. Each session's output is a tight,
written input to the next; do not chain them in one conversation.

- **Stance (all sessions):** **Creative Partner** (coach facilitates *and* contributes ideas; authorship tracked)
- **Participant:** Stefan (solo + AI)
- **Always loaded:** this file (§1–3 = topic, vision, seed); optionally `bmad_brainstorming.md` for technique mechanics
- **Per-session skill + extra inputs:** see each session in §5

## 5. The Three Sessions (run in order — one act each)

The three goals in §1 are different *modes* of thinking (generative → structural → convergent), so
they form a **funnel across three runs**: diverge on the vision, structure it into a map, then
converge on the first slice. Each session starts fresh, loads only the previous session's output as
its new input, and ends with a single named artifact.

### Session 1 — Vision *(Goal 1: the press-release)*

- **Skill:** `bmad-brainstorming`
- **Extra inputs:** none beyond the shared defaults
- **Lead technique — Sci-Fi Artifact From the Future** *(speculative-future, signature)*: write the artifact
  from the world where this already won — a future **press release / fake 5-star user review** of the
  full AI mail assistant in daily use (archiving + Lookeen-style search + triage + summarize +
  smart-reply + whatever else surfaces). This *is* the press-release vision — Working-Backwards in one
  move. Optionally pre-seed ambition with a quick **1000x Budget** or **What If Scenarios** pass so the
  vision isn't pre-shrunk by v1 worries.
- **Output → feeds Session 2:** the **press-release-style vision** of the full assistant.

### Session 2 — Map the territory *(Goal 2: use-cases + module/seam map)*

- **Skill:** `bmad-brainstorming`
- **Extra input:** Session 1's press-release vision
- **Technique 1 — Lotus Blossom** *(structured, classic)*: center = the Session 1 vision; the 8 petals
  = the coarse high-level **use-cases** from the user POV; bloom any petal that's rich. Expands the
  vision into the use-case set without designing anything yet.
- **Technique 2 — Morphological Analysis** *(deep, classic)*: decompose the use-cases into the coarse
  set of **independent modules** — the problem's independent parameters. Generate the candidate module
  set the *whole* vision implies (not just Module1's), then validate against the §3 candidate module
  cut: confirm, rename, add, or drop. Produces the *modules*; Technique 3 finds the *seams between* them.
- **Technique 3 — Entanglement Thinking** *(quantum, signature)*: with the module set in hand, hunt the
  **architecturally-significant seams** — the cross-module couplings where a change in one forces a
  change in another. This is the technique that directly surfaces the §2.3 scoping tension (the v1
  analyzer/classification layer entangled with future Lookeen-style search). The seams it names *are*
  the reach map Session 3's tracer-bullet check (§1, §5) walks Module1 across.
- **Output → feeds Session 3:** the **use-case list + coarse module/seam map**.

### Session 3 — Find the first slice *(Goal 3: v1/later split + Module1)*

- **Skill:** `bmad-brainstorming`
- **Extra input:** Session 2's use-case + module/seam map
- **Technique 1 — Backcasting** *(structured, classic)*: fix the end-state vividly (the Session 1
  vision), then walk backward to the one move **v1 / Module1** must make first. Probe inline with
  **Job to Be Done** ("what is attachment handling really *hired* for?" — e.g. "never lose an invoice
  again" vs. "make mail content findable", the latter already overlapping future search → scoping
  tension) to keep v1 honest.
- **Technique 2 — One Feature Only** *(constraint, signature)*: if v1 kept exactly ONE capability and
  made it unbelievably good, which is it? (Auto-filing by sender? LLM classification? Manual one-click
  archive?) Lands the irreducible **Module1** core and fights the urge to build every module at full
  depth at once.
- **Converge (in-session, after divergence — see §6):** MoSCoW the v1 scope, then walk Module1 / the
  first tracer bullet across the Session 2 seam map and confirm it **pierces every architecturally-
  significant seam** (stubs fine) rather than omitting any — the §1 / Tracer-Bullet check.
- **Output:** the **v1 scope statement** + **tracer-bullet reach note**.

> **Cut from all three sessions:** *Cursed Genie* *(absurdist)* — its edge-case sweep. Edge cases are detailed
> requirements — explicitly **Out of Scope** per §1 ("stay high-level, don't design internals"). Defer
> the seed cases (locked PST, 50 MB / 20-attachment mails, duplicate filings, misclassified invoices,
> signature images, mid-job token expiry) to a later requirements / test-design pass once Module1's
> scope is fixed.

### Handoff between sessions

Because each session runs in a **fresh context**, the link between them is a **file on disk**, not
conversation memory. The BMM config places artifacts under
`_bmad-output/planning-artifacts/` (project `ai-mail`). Save each session's artifact there and name
the next session's **extra input** by path:

| Session | Saves artifact | Loads as extra input |
|---|---|---|
| **1 — Vision** | `_bmad-output/planning-artifacts/brainstorming-s1-vision.md` | — |
| **2 — Map** | `_bmad-output/planning-artifacts/brainstorming-s2-modulemap.md` | Session 1's artifact |
| **3 — First slice** | `_bmad-output/planning-artifacts/brainstorming-s3-v1scope.md` | Session 2's artifact (+ Session 1 for the end-state in Backcasting) |

At the start of each session, the coach **reads only the prior artifact(s)** named above — never the
full transcript of the earlier run — keeping context lean while carrying the decisions forward. If a
session revises something upstream (e.g. Session 2 adds a seam not in §3), record it in *that*
session's artifact rather than editing this brief mid-flow; reconcile this brief at the end.

## 6. Convergence (Session 3's converge phase — after its divergence is spent)

- **MoSCoW** — sort the use-cases *and* the modules into **Must / Should / Could / Won't (this
  version)**: which modules are **v1-real**, which are **stubs** (present only for tracer reach), and
  which are **later**.
  - The *Won'ts* become the documented "later" roadmap (AI/Lookeen search, more frontends, triage…).
  - If candidates pile up, pre-filter with an **Impact–Effort matrix** first.

## 7. Expected Outputs

1. Three brainstorming session documents (the skill's standard artifact per run, saved to the output folder).
2. **Press-release vision** (Session 1 / Goal 1): the Working-Backwards artifact for the full assistant.
3. **Use-case + module/seam map** (Session 2 / Goal 2): coarse user-facing use-cases and the independent
   modules with their architecturally-significant seams (validated against the §3 cut).
4. **v1 scope statement** (Session 3 / Goal 3): the one job v1 does, its Must/Should/Could list, explicit
   Won'ts, and which modules are v1-real vs. stub vs. deferred.
5. **Tracer-bullet reach note** (Session 3): confirmation that Module1 pierces every seam from output 3
   (stubs allowed), or the revisions needed so it does.
6. Hand-off pointer: results feed `bmad-product-brief` / `bmad-prd` (BMAD Phase 1 → 2).

---

*Coach instructions (per session): greet, confirm this brief and the session's specific goal in two
sentences, load the prior session's output as input, then run that session's technique(s) only — do
not bleed into the next act. Keep divergence pure; converge only where §6 says (Session 3). Log
everything to the memlog. Aim for high idea volume within the act; the magic happens in ideas 50–100.*
