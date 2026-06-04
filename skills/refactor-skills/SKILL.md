---
name: refactor-skills
description: >
  Refactors the project's skills according to the worklist in
  `skills/skills_refactoring.md` (produced by `review-skills`). In a single
  invocation it sequentially spawns one fresh sub-agent per pending skill — each
  applies that skill's "Recommended refactor actions" to its `SKILL.md` (and
  `skills_overview.md` where needed), runs the POST self-check, and the driver
  flips the skill's `- [ ] refactored` checkbox to `- [x]`. When every pending
  skill is done, it archives the worklist to
  `skills/archive/skills_refactoring_YYYYMMDDHHMM.md`. Use when the user says
  "refactor skills", "refactor the skills", "apply skills_refactoring.md", "run
  the skill refactoring", or wants to act on the review worklist. Refactors ALL
  pending skills in one run, not just one.
---

# Refactor Skills

Consumes `skills/skills_refactoring.md` and refactors every skill still marked
`- [ ] refactored`, one sub-agent per skill, **sequentially**, in a single
invocation. After all pending skills are refactored, the worklist is archived
with a timestamp. This is project skill-maintenance tooling, not a generic AIUP
skill, so it may name repo-specific paths.

## Inputs

- **`skills/skills_refactoring.md`** (required) — the review worklist from
  `review-skills`. If it is absent, STOP and tell the user to run `review-skills`
  first. Do not invent a worklist.
- For each pending skill (read by its sub-agent, not the driver):
  - that skill's review section in `skills_refactoring.md` — the **Recommended
    refactor actions** are the brief;
  - the skill's own `SKILL.md` (+ `REFERENCE.md` if present);
  - the `gr_*.md` rule files it cites (`c:\PROJ\ai-knowhow\coding\gr\`);
  - the skill's build spec in `skills/create_skills.md` and its entry in
    `skills/skills_overview.md`.

## Sequential, not parallel

Refactor sub-agents run **one at a time, in worklist order** — never in parallel.
Reason: multiple skills' refactors edit shared files (especially
`skills/skills_overview.md`), so concurrent sub-agents would clobber each other's
writes. Wait for each sub-agent to finish (or report a blocker) before starting
the next.

## Model & reasoning

Spawn each refactor sub-agent with the Agent tool, `subagent_type:
general-purpose`, `model: opus`, and instruct it in the prompt to use maximum
reasoning depth. NOTE: "high thinking mode" and "fast mode off" are interactive
runtime toggles a skill cannot set programmatically — if the user requires those
exact settings, they enable them before running this skill; the skill itself only
pins the model and asks for deep reasoning.

## Per-skill refactor — the sub-agent brief

For each pending skill, give a fresh sub-agent a cold-start brief instructing it to:

1. Read its review section in `skills/skills_refactoring.md` (the **Recommended
   refactor actions** are the to-do list), its `SKILL.md` (+ `REFERENCE.md`), the
   cited `gr_*.md` files, its `create_skills.md` build spec, and its
   `skills_overview.md` entry.
2. Apply the Recommended refactor actions to the `SKILL.md` (and `REFERENCE.md`),
   and adjust `skills/skills_overview.md` if the refactor changes a coverage
   claim or boundary the overview states.
3. Run the skill's POST self-check / cross-validation (if it defines one) and any
   coverage claims it now makes.
4. Report back what changed (files touched, which Recommended actions are done,
   any it could not complete and why).

A sub-agent refactors **exactly one** skill. It must not touch other skills'
SKILL.md files. (The shared `skills_overview.md` is the only cross-skill file it
may edit, and only for its own skill's entry — which is why runs are sequential.)

## Driver: checkbox bookkeeping & archival

- After a sub-agent reports **success**, flip that skill's heading checkbox in
  `skills/skills_refactoring.md` from `- [ ] refactored` to `- [x] refactored`.
- On a **blocker**, leave the box `- [ ]`, append a one-line `> blocked: <reason>`
  after the heading, and continue with the next skill. Surface all blockers at
  the end.
- **Archive only when nothing is left pending.** Once every skill in the worklist
  is `- [x]` (no `- [ ]` and no blocked entries remain), move the file:
  `skills/skills_refactoring.md` → `skills/archive/skills_refactoring_YYYYMMDDHHMM.md`
  (UTC-or-local timestamp `YYYYMMDDHHMM`, e.g. `skills_refactoring_202606041530.md`).
  If any skill is still pending or blocked, DO NOT archive — leave the worklist in
  place for another pass and say so.

## DO NOT

- Do NOT proceed without `skills/skills_refactoring.md` — direct the user to
  `review-skills` first.
- Do NOT run refactor sub-agents in parallel — they share `skills_overview.md`.
- Do NOT re-refactor a skill already marked `- [x] refactored`.
- Do NOT let a sub-agent edit a skill other than the one it was assigned (except
  that one skill's entry in `skills_overview.md`).
- Do NOT review or re-score skills here — this skill only applies the existing
  worklist's Recommended actions. Reviewing is `review-skills`.
- Do NOT archive the worklist while any skill is still pending or blocked.
- Do NOT delete the worklist — archival is a move/rename into `skills/archive/`.

## Workflow

1. **Load the worklist.** Read `skills/skills_refactoring.md` (STOP if absent →
   tell the user to run `review-skills`). Parse the per-skill sections and their
   `- [ ] / - [x] refactored` checkboxes; build the ordered list of **pending**
   skills.
2. **For each pending skill, in order:** spawn one `general-purpose` / `opus`
   sub-agent with the per-skill brief; wait for it to finish.
   - success → flip its checkbox to `- [x] refactored`;
   - blocker → leave `- [ ]`, append `> blocked: <reason>`, continue.
3. **Archive** (only if no pending/blocked remain): move
   `skills/skills_refactoring.md` → `skills/archive/skills_refactoring_YYYYMMDDHHMM.md`.
4. **Report** to the user: which skills were refactored, files touched per skill,
   any blockers left pending, and whether the worklist was archived (and to what
   path).
