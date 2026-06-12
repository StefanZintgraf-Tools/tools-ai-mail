# Brainstorming Session Brief — AI-Mail Foundation Vision

> **Purpose of this file:** Session briefing for an AI brainstorming coach. When the user
> starts a brainstorming session (e.g. via `bmad-brainstorming`), load this file as the
> session's starting context — topic, goal, stance, and technique batch are already chosen.
> Confirm briefly and begin; do not re-elicit.
>
> Created: 2026-06-12.

---

## 0. Read this first — a clean-slate session

This brief is **deliberately unanchored**. It exists *before* and *independent of* any prior
thinking about this product. There is a sibling brief — [ai-mail-brainstorming.md](ai-mail-brainstorming.md) —
that is already committed to one starting point (attachment handling/archiving, an Outlook add-in,
a dropped-PST decision, a candidate module cut). **None of that may leak into this session.**

The whole point of this session is to ask the open question that the sibling brief skips:

> **If we were free to build *anything* that makes email better for the people who live in it —
> what would we build?**

So when the coach runs this session:

- **Forget attachment archiving.** It is one idea among hundreds, not the center of gravity.
- **Forget the platform.** No Outlook, no add-in, no webapp, no PST, no IMAP/Graph — the user does
  not care where it runs and neither do we, yet.
- **Forget every earlier decision.** Nothing from the prior technical chat is a precondition here.
- **Start from the human and their inbox**, not from a feature someone already picked.

If an idea sounds suspiciously like "the thing we were already going to build," push *past* it —
the magic is in ideas 50–100, and those only appear once the obvious first answer is spent.

## 1. Topic & Goal

- **Topic:** A **foundation vision** for AI-supported email — the widest possible picture of what an
  AI assistant *could* do for everyday email users, captured in language those users would recognize.
- **Goal (the why):** Produce a shared, **plain-language** picture of the product, in two parts only:
  1. A **press-release-style vision** of the AI mail assistant from the user's point of view — the
     future where this already won.
  2. A set of **high-level use-cases**, told from the user's POV — "as someone who gets too much
     email, I can finally …" — broad and human, not exhaustive.
- **Audience for the output:** a typical mail user. If your aunt who uses email for appointments,
  invoices, and family photos couldn't follow it, it's pitched wrong.

## 2. Hard scope boundaries

This session is **vision and use-cases only**. The following are explicitly **out of scope** and must
not appear in the output (the coach should gently redirect if the session drifts toward them):

- **No software concepts** — no architecture, no data flows, no "the system fetches/parses/indexes…".
- **No modules, services, layers, or seams** — not even a coarse map. (That is a *later, separate*
  exercise once the vision is agreed.)
- **No technology, platform, or vendor choices** — no clients, protocols, models, file formats, hosting.
- **No "first version" / MVP / v1 scoping** — no Must/Should/Could, no "what ships first," no tracer
  bullets. We are not narrowing yet; we are opening up.
- **No edge cases or detailed requirements** — those are downstream of a chosen scope.

Think of the output as something a product marketer and a curious user could both read and nod at —
**not** something an engineer would build from. Building comes much later.

## 3. The user-first framing (the only "input")

There is no architecture seed and no prior-decision input for this session — that is intentional.
The only frame we carry in is **the user and their relationship with email**. Useful angles for the
coach to provoke breadth (not a checklist, just fuel):

- **The feelings:** overwhelm, dread of the unread count, fear of missing the one that mattered,
  guilt about not replying, the archaeology of "where did that message go."
- **The jobs people quietly use email for:** receipts & proof, scheduling, decisions & approvals,
  newsletters, notifications, shipping & travel, relationships, a de-facto to-do list, a personal archive.
- **The many kinds of user:** the swamped professional, the freelancer chasing invoices, the parent
  juggling school and bills, the student, the support agent, the founder, the person who just wants
  email to stop being a chore.
- **The whole life of a message:** before it arrives (anticipation), the moment it lands, triage,
  acting on it, finding it again months later, and everything that should have happened automatically.

Use these to keep the idea-collection *wide* — across emotion, across user types, across the message
lifecycle — so the vision isn't quietly narrowed to one persona or one moment.

## 4. Session Setup (shared defaults — confirm, don't re-elicit)

- **Stance:** **Creative Partner** — the coach facilitates *and* contributes ideas; authorship tracked.
- **Participant:** Stefan (solo + AI).
- **Always loaded:** this file — §0–3 set the frame, and §5 sets the **technique running order**, so a
  resuming coach knows which technique comes next.
- **Two sessions (A → B); run one technique per window.** Run a technique to completion, then **stop the
  window without wrapping up** and open a **fresh context** for the next technique, resuming the same
  session. One technique per window is deliberate — it keeps each context lean and rot-free, and the
  resumed log still carries the whole pile forward, so nothing is lost. (This is a chosen deviation from
  running a long batch in one sitting.)
- **Stop ≠ finish.** Leave the session open and resumable between techniques; only its **final** window
  wraps up and produces the artifact.
- **Between sessions, hand off the artifact, not the session.** Session B starts **fresh**, loading *only*
  Session A's vision artifact as input — never resuming Session A (which would drag A's whole idea-pile
  into B). This single clean break is the one place a file handoff is correct.
- **Full technique catalog available:** the installed `bmad-brainstorming` skill ships all 108
  techniques, so every method named below can be run as-is. The coach may still swap in an equivalent
  from the same goal row of the skill's own technique chooser if the session's energy calls for it, or
  use `you choose N` for the stated goal.

## 5. The Two Sessions (run in order; one technique per window)

The goal is generative, so this is a short **diverge → distill** funnel: collect widely, then shape
the catch into the two required artifacts. No convergence into modules or scope — only into *narrative*
(the vision) and *user stories at a high level* (the use-cases).

### Session A — Wide-open ideation → the Vision *(produces output 1)*

**Aim:** first collect a large, unbounded pile of "what could email-with-AI be," then crystallize it
into one press-release-style vision. Resist concluding before ~50–100 ideas.

**Cadence (per §4):** run each technique below in its **own window** — warm-up, then each diverge
technique, then the distill step — stopping and resuming the same session between them. Do not wrap up
until the distill window.

- **Warm up — ground in real feeling (optional opener):** **Empathy Map** *(structured, classic)* —
  map what the user *says, thinks, does, and feels* about their email today; mine each quadrant for the
  unmet need. This keeps the wild ideas that follow tethered to a real human pain, not novelty for its
  own sake.
- **Diverge — break out of the obvious (the core batch, ~4 techniques):**
  - **Assumption Reversal** *(deep, classic)* — *the anti-anchoring engine for §0.* List email's
    baked-in assumptions (there is an inbox; an unread count; folders; you read top-down; you reply
    by hand; messages live forever; you go to email, it doesn't come to you) and **flip each**, then
    build on the inverted foundation. This is what forces the session past "the thing we'd already build."
  - **What If Scenarios** *(creative, signature)* — detonate one constraint at a time, including
    feasibility itself (assume time, money, and AI capability are free — folds in the ambition pass):
    what if email answered itself? what if you never searched again? what if it knew what mattered
    before you opened it? what if the inbox simply had no unread count?
  - **Cross-Pollination** *(creative, signature)* — how would a concierge, an ER triage nurse, a casino
    host, a personal assistant, or a librarian run your inbox? Steal the pattern, not the setting.
  - **Concept Blending** *(creative, signature)* — fuse email with a different category: email × a
    personal CRM, email × a to-do app, email × a memory vault, email × a feed reader. Name what the
    hybrid *becomes* for the user.
  - *If the pile clusters or stalls:* **Random Stimulation** *(collaborative, classic)* to break fixation.
- **Distill — final window:** resume the session one last time and run **Sci-Fi Artifact From the Future**
  *(speculative-future, signature)* — write from the world where this already won: a **future press
  release** and/or a **glowing 5-star user review** of the assistant in everyday use. This *is* the vision
  (Working-Backwards in one move); keep it entirely in user language — what their email life feels like now
  that this exists. This window also wraps up the session, emitting the vision as its artifact.
- **Output → feeds Session B:** the **press-release-style vision** (1–2 pages, user POV, no tech).

### Session B — High-level use-cases *(produces output 2)*

**Aim:** expand the agreed vision into the coarse set of **user-facing use-cases** — broad "I can now…"
statements, still in plain language, still no software.

**Cadence (per §4):** Session B starts **fresh**, seeded by Session A's vision artifact (never a resume of
Session A). Run Lotus Blossom, Job to Be Done, and Persona Journey each in its **own window**, resuming
this session between them; run Affinity Clustering as its own convergence window; wrap up last.

- **Technique 1 — Lotus Blossom** *(structured, classic)*: center = the Session A vision; the 8 petals
  = the big high-level use-cases from the user's POV; bloom any petal that's rich into sub-uses. This
  turns one vision into a structured spread of user-facing capabilities without designing anything.
- **Technique 2 — Job to Be Done** *(structured, classic)*: pressure-test each use-case — what is the
  user really *hiring* email (and this assistant) to do? Keep the use-cases honest to a real job, not
  a feature in disguise.
- **Technique 3 — Persona Journey** *(theatrical, signature)*: walk a few different §3 users (e.g. the
  swamped professional, the invoice-chasing freelancer, the family organizer) through their day with
  the assistant, to surface use-cases that only one persona would notice.
- **Light convergence — its own window:** use **Affinity Clustering** to group the use-cases into a few
  named themes so the list reads as a coherent map of *what users can do*. **Do not** rank, MoSCoW, or
  mark anything as "first" — that is explicitly out of scope (§2). This final window wraps up the session,
  emitting the use-case list as its artifact.
- **Output:** the **high-level use-case list**, grouped into themes, each phrased from the user's POV.

### Handoff — two kinds

**Within a session (between techniques): resume.** Each technique runs in a fresh context, linked by
resuming the **same** session — one session resumed as many times as there are techniques, never a
separate session per technique.

**Between sessions (A → B): hand off the artifact, not the session.** Session B starts **fresh**, loading
*only* Session A's vision artifact as input — never resuming Session A (which would drag A's whole
idea-pile into B). Keeps context lean while carrying the vision forward.

Artifacts live wherever bmad-brainstorming is configured to write them; let the skill resolve
its own output paths — don't specify or invent any here.

## 6. Expected Outputs

1. **Press-release vision** (Session A): the Working-Backwards artifact — a future press release and/or
   5-star review of the AI mail assistant, entirely in user language. *No* software, modules, tech, or v1.
2. **High-level use-case list** (Session B): coarse, user-facing "I can now…" use-cases grouped into a
   few named themes. *No* prioritization, scoping, or implementation detail.
3. (Optional) The two raw session documents (the skill's standard per-run artifacts), kept for traceability.

> These outputs are intentionally **upstream of all design**. Only after the vision and use-cases are
> agreed does it make sense to ask *which* of them to build, in what order, and how — and that work
> happens in a **separate** session, not here.

---

*Coach instructions (per window): greet, confirm this brief and which session + technique this window runs
in two sentences. Run **one** technique, then **stop without wrapping up** — except the session's final
window, which wraps up and produces the artifact. Starting Session B, load only Session A's vision artifact.
Hold the §2 boundaries firmly — if the session drifts into modules, tech, or "what ships first," name it and
steer back to user-facing vision. Keep divergence pure and wide; the magic is in ideas 50–100.*
