---
name: product-foundation-brainstorming
description: Run a product-agnostic foundation brainstorming session that produces a press-release-style vision and a high-level use-case list for ANY new product — before any design, tech, or scoping. Use when the user wants a foundation vision for a new product, asks to brainstorm "what this product could be," or says "product foundation brainstorming."
---

# Product Foundation Brainstorming

## What this skill is

A **launcher**, not a new brainstorming engine. It carries a fixed, product-agnostic
*frame* — stance, goal, scope boundaries, and a two-session technique running order — and
runs it on the installed [`bmad-brainstorming`](#dependency) engine. The frame is the value
this skill adds; the running, logging, and resume are all bmad-brainstorming's machinery.

Use it when someone wants the widest-possible picture of what a brand-new product *could*
be — a robot controller, a trading tool, a fitness app, anything — captured in the user's
language, with **no** architecture, tech, modules, or "what ships first."

## On activation — run this protocol

1. **Load the frame.** Read `references/frame.md` in full and hold it for the whole run.
   That file is §0–§6 of the briefing; do not re-derive or re-elicit what it already fixes
   (stance, goal, boundaries, technique order).

2. **Resolve the product.** The frame uses `[the product]` / `[the problem]` placeholders.
   Take the product from the user's kickoff, args, or open files; if it's genuinely unclear,
   ask **once** ("what product is this foundation vision for, and what problem does it solve
   for its users?"), then substitute throughout. Everything else in the frame is pre-set.

3. **Check for resume FIRST (this is how re-running continues where it stopped).** Before
   starting anything, locate this project's brainstorming output dir and glob its
   `*/.memlog.md` sessions (bmad-brainstorming writes one per run, with a `status`
   frontmatter field). Offer to resume any product-foundation session whose `status` is not
   `complete`, using bmad-brainstorming's own resume flow (its `references/resume.md`). See
   **Sequence & resume routing** below for *which technique comes next*.

4. **Run on the bmad-brainstorming engine.** Drive the session through `bmad-brainstorming` —
   its memlog (`scripts/memlog.py`), its stance/mode references, and its 108-technique
   catalog — supplying the frame's pre-set inputs so it does **not** re-elicit them:
   - **stance:** Creative Partner,
   - **goal:** the §1 goal,
   - **technique batch + order:** §5 (one technique per window; stop without wrapping up
     between techniques; only the final window of each session wraps up),
   - **boundaries:** §0, §2, §3 held firmly — enforced by the frame's **Altitude Guard** (§2), the
     line-by-line test that keeps feature-leaning techniques (Empathy Map, Lotus Blossom, Job to Be Done)
     from drifting into screens/modules/tech/scope. Apply it as each line is captured *and* over every
     artifact before it's emitted.
   Log every idea/decision/technique-switch to the memlog as bmad-brainstorming normally does.

## Sequence & resume routing — the part this skill enforces

bmad-brainstorming resumes a *session*; this skill adds the **ordering** on top, soft-enforced
via the memlog (an LLM coach can't be a hard state machine — the memlog is the cursor):

- **Within a session — find where it stopped.** On resume, read the memlog's `(technique)`
  entries (each logged as "started <name>"). Match the **last** one against the §5 running
  order for that session, then run the **next** technique in that order. Never re-run a
  completed technique or skip ahead.

- **Between Session A and Session B — the clean break (do NOT skip this).** When Session A's
  memlog is `status: complete`, **do not resume it** for Session B. The default resume would
  drag A's entire idea-pile into B, which §4 forbids. Instead **`init` a fresh memlog** for
  Session B, seeded *only* by Session A's vision artifact. A and B are two separate sessions /
  two separate memlogs by design.

- **Stop ≠ finish.** Between techniques, stop the window **without** wrapping up; leave the
  memlog `status: active` so the next run resumes it. Only the final window of each session
  flips `status: complete` and emits that session's artifact.

## Outputs

1. **Press-release vision** (Session A) — a future press release and/or 5-star user review of
   the product, entirely in user language. No software, modules, tech, or v1.
2. **High-level use-case list** (Session B) — coarse "I can now…" use-cases grouped into a few
   named themes. No prioritization, scoping, or implementation detail.

Let bmad-brainstorming resolve its own artifact output paths; don't invent any here.

## Dependency

Requires `bmad-brainstorming` to be installed in the active project (this skill drives its
engine and reuses its memlog/resume/technique machinery). If it isn't present, tell the user
and stop — this launcher does not run a session on its own.
