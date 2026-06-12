# Frame — Product Foundation Vision (load in full; hold the whole run)

> This is the briefing the launcher loads at session start. Fill in **[the product]** /
> **[the problem]** with the product this run is about (resolved in SKILL.md step 2).
> Everything else is pre-set — confirm briefly and begin; do not re-elicit the method.

---

## 0. Read this first — a clean-slate session

This frame is **deliberately unanchored**. It exists *before* and *independent of* any prior
thinking about the product. If earlier conversations, sketches, or technical chats already
committed to a starting point — a particular feature, a platform, a stack, a dropped option,
a candidate scope cut — **none of that may leak into this session.**

The whole point is to ask the open question that anchored thinking skips:

> **If we were free to build *anything* that genuinely helps the people who live with this
> problem — what would we build?**

So when running this session:

- **Forget the first feature.** Whatever idea kicked this off is one idea among hundreds, not
  the center of gravity.
- **Forget the platform.** No client, app type, protocol, hosting, or device — the user does
  not care where it runs and neither do we, yet.
- **Forget every earlier decision.** Nothing from a prior technical chat is a precondition here.
- **Start from the human and their problem**, not from a feature someone already picked.

If an idea sounds suspiciously like "the thing we were already going to build," push *past* it —
the magic is in ideas 50–100, and those only appear once the obvious first answer is spent.

## 1. Topic & Goal

- **Topic:** A **foundation vision** for **[the product]** — the widest possible picture of what
  it *could* do for the people it serves, captured in language those people would recognize.
- **Goal (the why):** Produce a shared, **plain-language** picture of the product, in two parts only:
  1. A **press-release-style vision** from the user's point of view — the future where this already won.
  2. A set of **high-level use-cases**, told from the user's POV — "as someone who deals with
     [the problem], I can finally …" — broad and human, not exhaustive.
- **Audience for the output:** a typical user of **[the product]**. If someone who lives with the
  problem but has no interest in *how* it's solved couldn't follow it, it's pitched wrong.

## 2. Hard scope boundaries

This session is **vision and use-cases only**. The following are explicitly **out of scope** and must
not appear in the output (gently redirect if the session drifts toward them):

- **No software concepts** — no architecture, no data flows, no "the system fetches/parses/processes…".
- **No modules, services, layers, or seams** — not even a coarse map. (A *later, separate* exercise.)
- **No technology, platform, or vendor choices** — no clients, protocols, models, file formats, hosting.
- **No "first version" / MVP / v1 scoping** — no Must/Should/Could, no "what ships first," no tracer
  bullets. We are not narrowing yet; we are opening up.
- **No edge cases or detailed requirements** — those are downstream of a chosen scope.

The output is something a product marketer and a curious user could both read and nod at — **not**
something an engineer would build from. Building comes much later.

**Altitude guard — the operational tripwire (apply to every line you capture).** A stated boundary
is easy to cross mid-flow; this is the line-by-line test that keeps it honest. Every idea, use-case,
or vision line must pass: *would a user who lives with the problem — and has zero interest in how it's
solved — recognize it as their own words?* Concretely:

- **Outcome, never mechanism.** A vision line is a feeling or a future they'd cheer ("I never lose
  track again"); a use-case is "I can now …". Never *"the system/app does X"*, never a noun-feature
  ("a dashboard", "a sync button", "a settings screen").
- **Banned vocabulary = you've already drifted.** *system, fetch/parse/process, module/service/layer/
  API/database, client/app/platform/protocol, screen/button/UI/dashboard, MVP/v1/must/should/could,
  first/ship/phase.* The instant a line needs one of these, **stop** — name it in one breath ("that's a
  *how*, not a *what* — out of scope here") and re-ask at the user's level: *"what does that let the
  user finally do or feel?"*
- **One redirect, then move on.** Don't argue the boundary or delete the spark — restate it in user
  language, log the user-level version, and continue. Drift is normal; catching it fast is the skill.

## 3. The user-first framing (the only "input")

There is no architecture seed and no prior-decision input — that is intentional. The only frame we
carry in is **the user and their relationship with the problem**. Useful angles to provoke breadth
(fuel, not a checklist):

- **The feelings:** the frustration, the dread, the fear of getting it wrong, the friction of the
  manual workaround, the guilt of falling behind, the relief they'd feel if it just worked.
- **The jobs people quietly use today's tools (or workarounds) for:** recurring tasks, decisions,
  record-keeping, coordination — the things they patch together with spreadsheets, notes, or sheer
  memory because nothing does it well.
- **The many kinds of user:** the swamped professional, the harried beginner, the demanding expert,
  the occasional dabbler, the person responsible for others, the person who just wants the chore to
  stop being a chore. Each lives the problem differently.
- **The whole lifecycle:** before the moment that matters (anticipation), the moment itself, acting
  on it, the follow-through, returning to it later, and everything that should have happened automatically.

Keep idea-collection *wide* — across emotion, user types, and the whole lifecycle — so the vision
isn't quietly narrowed to one persona or one moment.

## 4. Session setup (pre-set — confirm, don't re-elicit)

- **Stance:** **Creative Partner** — facilitate *and* contribute ideas; authorship tracked.
- **Engine:** the installed `bmad-brainstorming` skill — its memlog, mode references, and 108-technique
  catalog do the running. This frame supplies stance, goal, boundaries, and order.
- **Two sessions (A → B); one technique per window.** Run a technique to completion, then **stop the
  window without wrapping up** and open a **fresh context** for the next technique, resuming the same
  session (same memlog). One technique per window keeps each context lean; the resumed memlog carries
  the whole pile forward, so nothing is lost.
- **Resume = the memlog is the cursor.** On any resume, read the memlog's `(technique)` entries, find
  the last one in §5's order for that session, and run the **next** one. Never re-run or skip ahead.
- **Stop ≠ finish.** Leave the session `active` and resumable between techniques; only its **final**
  window flips `complete` and produces the artifact.
- **A → B is a clean break — hand off the artifact, not the session.** When Session A is `complete`,
  **init a NEW memlog** for Session B seeded *only* by A's vision artifact — never resume A's memlog
  (that would drag A's whole idea-pile into B). This single file handoff is the one correct break.
- **Full catalog available:** all 108 bmad-brainstorming techniques run as-is; the coach may swap in an
  equivalent from the same goal row if energy calls for it, or use `you choose N` for the stated goal.

## 5. The two sessions (run in order; one technique per window)

A short **diverge → distill** funnel: collect widely, then shape the catch into the two artifacts. No
convergence into modules or scope — only into *narrative* (the vision) and *high-level user stories*
(the use-cases).

### Session A — Wide-open ideation → the Vision *(produces output 1)*

**Aim:** collect a large, unbounded pile of "what could this product be," then crystallize it into one
press-release-style vision. Resist concluding before ~50–100 ideas.

Run each in its **own window**, stopping/resuming the same memlog between them; wrap up only at distill:

- **Warm up (optional opener):** **Empathy Map** *(structured, classic)* — map what the user *says,
  thinks, does, and feels* about the problem today; mine each quadrant for the unmet need.
  *↳ Altitude guard: stay in emotional/behavioral language — the instant a "feels" becomes "needs a
  feature that…", you've left the map; re-ask what they feel, not what tool would fix it.*
- **Diverge — the core batch (~4 techniques):**
  - **Assumption Reversal** *(deep, classic)* — *the anti-anchoring engine for §0.* List the baked-in
    assumptions of how this problem is handled today (the user must do X by hand; one obvious way in;
    you work top-down; nothing happens until you act; the tool waits for you instead of coming to you)
    and **flip each**, then build on the inverted foundation.
  - **What If Scenarios** *(creative, signature)* — detonate one constraint at a time, including
    feasibility (assume time, money, and AI capability are free): what if the product did the task
    itself? what if the user never had to search or set up again? what if it knew what mattered before
    the user even looked? what if the hardest step simply vanished?
  - **Cross-Pollination** *(creative, signature)* — how would a concierge, an ER triage nurse, a casino
    host, a personal assistant, or a librarian run this for the user? Steal the pattern, not the setting.
  - **Concept Blending** *(creative, signature)* — fuse the product with a different category:
    [the product] × a personal coach, × a to-do app, × a memory vault, × a live feed, × a game. Name
    what the hybrid *becomes* for the user.
  - *If the pile clusters or stalls:* **Random Stimulation** *(collaborative, classic)* to break fixation.
- **Distill — final window:** **Sci-Fi Artifact From the Future** *(speculative-future, signature)* —
  write from the world where this already won: a **future press release** and/or a **glowing 5-star user
  review** of the product in everyday use. This *is* the vision (Working-Backwards in one move); keep it
  entirely in user language. **Before emitting:** run the Altitude Guard over every line of the artifact —
  rewrite or drop any that names a screen, system, module, tech, or "v1". This window wraps up the session
  and emits the vision artifact.
- **Output → feeds Session B:** the **press-release-style vision** (1–2 pages, user POV, no tech).

### Session B — High-level use-cases *(produces output 2)*

**Aim:** expand the agreed vision into the coarse set of **user-facing use-cases** — broad "I can now…"
statements, plain language, no software.

Session B starts **fresh** (new memlog), seeded by Session A's vision artifact (never a resume of A). Run
each in its own window, resuming this memlog between them; run convergence as its own window; wrap up last.

- **Technique 1 — Lotus Blossom** *(structured, classic)*: center = the Session A vision; the 8 petals =
  the big high-level use-cases from the user's POV; bloom any rich petal into sub-uses.
  *↳ Altitude guard (this technique's native pull is feature-decomposition): every petal and sub-petal
  must read as "I can now …", not as a component or screen. If a petal names a thing the product has
  rather than something the user can do, it's drifted — restate it as the user's outcome.*
- **Technique 2 — Job to Be Done** *(structured, classic)*: pressure-test each use-case — what is the user
  really *hiring* this product to do? Keep each honest to a real job, not a feature in disguise.
  *↳ Altitude guard: the "job" is the user's, never the product's — phrase it as their progress
  ("stop losing track of what matters"), never as a capability the product ships.*
- **Technique 3 — Persona Journey** *(theatrical, signature)*: walk a few different §3 users (e.g. the
  swamped professional, the demanding expert, the occasional dabbler) through their day with the product,
  to surface use-cases only one persona would notice.
- **Light convergence — its own window:** **Affinity Clustering** to group the use-cases into a few named
  themes so the list reads as a coherent map of *what users can do*. **Do not** rank, MoSCoW, or mark
  anything "first" — out of scope (§2). **Before emitting:** run the Altitude Guard over every use-case and
  theme name — rewrite any that slid into a feature, screen, or scope label. This final window wraps up the
  session and emits the use-case list.
- **Output:** the **high-level use-case list**, grouped into themes, each phrased from the user's POV.

## 6. Expected outputs

1. **Press-release vision** (Session A): a future press release and/or 5-star review of the product,
   entirely in user language. *No* software, modules, tech, or v1.
2. **High-level use-case list** (Session B): coarse, user-facing "I can now…" use-cases grouped into a
   few named themes. *No* prioritization, scoping, or implementation detail.
3. (Optional) The two raw session memlogs, kept for traceability.

> These outputs are intentionally **upstream of all design**. Only after the vision and use-cases are
> agreed does it make sense to ask *which* to build, in what order, and how — in a **separate** session.

---

*Per window: greet, confirm this frame and which session + technique this window runs in two sentences.
Run **one** technique, then **stop without wrapping up** — except a session's final window, which wraps up
and produces the artifact. Starting Session B, load only Session A's vision artifact. Hold the §2 boundaries
firmly via the **Altitude Guard** — apply it to every line as it's captured, and again over the whole
artifact before emitting; name drift in one breath and steer back. Keep divergence pure and wide; the magic
is in ideas 50–100.*
