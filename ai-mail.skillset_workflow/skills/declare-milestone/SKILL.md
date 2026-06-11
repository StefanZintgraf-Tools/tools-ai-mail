---
name: declare-milestone
description: >
  Selects and durably declares the next milestone — the single in-scope slice
  one delivery iteration will ship — up front, before the vision step, instead
  of reconstructing it late from a status column. Reads the project's
  capability / build-order plan plus what has already shipped, picks the next
  milestone by honouring build-order dependencies, the Pareto / one-slice-at-a-
  time discipline (one slice, never a roadmap), and the already-shipped state,
  HITL-confirms the choice, and records it (name, the capability/primitive set
  it commits to, predecessor) in a project-designated register. Use when the
  user asks to "declare the next milestone", "select the milestone", "pick the
  milestone", "what ships next", "what's the next milestone", "scope the next
  delivery", "what do we build next", or is starting a new delivery iteration
  and needs the scope-defining input the vision step is written against. Re-run
  on loop-back when a milestone ships to declare its successor.
---

# Declare Milestone

The up-front step that picks and durably records the **next milestone** — the in-scope slice
of the spec spine that **one** delivery iteration (one vision → one PRD → one test plan → its
tracer-bullet issues) will ship. A milestone is a **delivery** boundary, not a *functionality*
boundary: it MAY coincide with a single capability/module, but one milestone can bundle several,
or split one across iterations.

Because the vision is already milestone-bound (it narrows the product to one capability), the
milestone must be declared **before** the vision, so the vision is written against a *declared*
milestone rather than an implicit one. This skill adds only that up-front declaration — it does
**not** fork the spec spine (no per-milestone requirements / entity model / use cases), author
the vision or requirements, or perform the item-level scope cut (that stays the downstream scope-
cut lens). It selects, HITL-confirms, and records the milestone, and nothing more.

## Inputs

1. **The capability / build-order plan** (required) — the project's planning doc that names the
   candidate capabilities (and any primitives they compose), their reach/effort, their
   **dependencies** (what must exist before what), and a build order. Resolve it by a fallback
   chain — **never** a hard-coded path or marker name:
   - an explicit plan path passed as an argument →
   - a conventional plan location in the repo (a `plan/` doc, a roadmap/build-order doc) →
   - if neither resolves, **ask** the user which doc defines the build order.
   Never guess the plan silently. If no plan with an ordering exists at all, ask the user to name
   the next deliverable directly rather than inventing one.
2. **Already-shipped state** (required) — what previous iterations have already delivered: the
   predecessor milestone(s) and the capabilities/primitives now shipped. Read it from the durable
   declaration register (output of a previous run) and/or the plan's status column. If it cannot
   be determined, ask the user rather than assuming nothing has shipped.
3. **The durable register location** — where declared milestones are recorded. Resolve generically:
   an existing register section if one exists (re-use it), else propose a project-designated
   location to the user (e.g. a `## Milestones` section in an existing planning doc — **additive,
   never a per-milestone fork of the spine**). Confirm the location before writing.

## Procedure

1. **Resolve inputs** — the build-order plan, the already-shipped state, and the register location
   (§Inputs). Stop and ask rather than guess any of the three.
2. **Determine eligibility.** From the plan, list the capabilities **not yet shipped** whose
   build-order **dependencies are all satisfied** by the shipped state. A capability whose
   predecessor has not shipped is **not** eligible — never declare a milestone ahead of an unshipped
   dependency.
3. **Pick the Pareto-minimal next slice.** Among the eligible candidates, select the **single**
   next milestone the build order calls for — the smallest slice that delivers concrete value now
   (G10), deferring everything cheaper-to-decide-later (G3). Declare **exactly one** milestone — a
   single slice, never a multi-release roadmap. The slice MAY be one capability, a bundle of
   capabilities that ship together, or a sub-slice of one capability — whatever the next deliverable
   actually is.
4. **Compose the declaration:** the milestone's **name**, the **capability / primitive set it
   commits to**, and its **predecessor** (the already-shipped milestone it builds on, or "none" for
   the first).
5. **HITL gate** — present the chosen milestone with its reasoning (which dependencies it satisfies,
   why it is the Pareto-minimal next slice, what it defers) and STOP for explicit approval. Write
   nothing before approval. If the user picks a different eligible candidate, honour that — but never
   accept a candidate whose dependencies are unmet (surface the conflict instead).
6. **Record on approval** — write the declaration to the register location as one durable entry
   (name, committed capability/primitive set, predecessor), then confirm what was written.
   **Idempotency:** if this milestone is already declared in the register, update that entry in
   place rather than appending a duplicate; if a *different* milestone is being declared on a fresh
   run (loop-back), append it after the existing entries — never overwrite shipped history.
7. **Emit the scope input** — report the declared milestone as the scope-defining input the vision
   step is to be written against ("Generate the vision *for this declared milestone*").
8. **Validate (POST self-check):**
   - **Exactly one** milestone declared — not a roadmap, not zero.
   - Build-order **dependencies respected** — no milestone declared ahead of an unshipped predecessor.
   - The entry records **name + committed capability/primitive set + predecessor** in the
     project-designated register.
   - The choice was **HITL-confirmed** before writing.
   - **No spine fork** — only the register was written; no per-milestone requirements / entity model
     / use-case files were created.
   - **Generic body** — no project-specific capability / primitive / milestone identifiers leaked
     into this skill; all such values arrived via the argument, the fallback chain, or the register.

## Loop-back (one milestone ≡ one vision ≡ one PRD)

When the declared milestone ships, **re-run** this skill. The shipped state now includes it, so
step 2 unlocks the capabilities that depended on it; step 3 picks the next slice (N+1). That
declared successor seeds a fresh vision, and the spine chain repeats — keeping milestone ≡ one
vision ≡ one PRD clean end-to-end.

## Selection rules (greenfield build-order discipline)

This skill is the executable form of the Pareto / one-slice-at-a-time discipline — carried over
verbatim, not restated:

| Rule | Apply when… |
|------|------------|
| G10 | Size the milestone to the **next concrete slice** the build order calls for — the smallest delivery that produces value now, not a five-year roadmap. One slice is committed at a time. |
| G3  | **Defer** candidates whose dependencies are unmet, or that belong to a later slice — leave them for a future iteration rather than pulling them forward into the current milestone. |

## Output format

A single durable register entry, written behind the HITL gate. Use the register's existing format
if one exists; otherwise the canonical one-line form is:

```markdown
## Milestones

- **<milestone name>** — commits: <capability / primitive set it delivers>. Builds on: <predecessor milestone, or "none">.
- ...
```

Each declared milestone is **one** line/entry. Earlier entries (shipped milestones) are never
overwritten — the register is the durable, append-only record of the delivery sequence.

## DO NOT

(The one-milestone rule, dependency check, HITL-before-write, and generic-body requirement are
enforced in Procedure/Validate above; the prohibitions below are the ones not otherwise covered.)

- Do NOT declare a roadmap. Exactly one milestone per run — the next slice only.
- Do NOT declare a milestone whose build-order dependencies have not shipped, even if the user asks
  — surface the unmet dependency instead.
- Do NOT fork the spec spine. This skill writes only the milestone register; it never creates
  per-milestone requirements / entity-model / use-case files (that breaks the single-source-of-truth
  spine).
- Do NOT author the vision, the requirements, or perform the item-level scope cut — those are
  downstream/sibling skills. This skill only declares the milestone.
- Do NOT hard-code any project's capability / primitive / milestone identifiers or plan paths. Read
  them generically from the argument, the fallback chain, or by asking.
- Do NOT write to the register without explicit HITL approval, and never overwrite an already-
  shipped milestone's recorded entry.
