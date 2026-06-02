# Claude Agent Context — ai-mail

## Off-limits directories

The following directories must never be read, searched, or referenced by the AI agent:

- `plan/archive/` — archived material, not relevant to current work.
- `outlook-RAG/` — legacy artefact, superseded by the current design.

## Key planning artifacts

Read these (and how they relate) before planning or building:

- `todo.md` — live work log + decision journal. Current task: the topmost unchecked " - [ ]" section.
- `plan/painlist_private.md`, `plan/painlist_acontis.md` — raw pains (`P##` private, `A##` acontis) from brainstorming sessions (`_bmad-output/brainstorming/`).
- `plan/01-foundation.md` — source of truth: distils the painlists into the namespace catalog (`F##` primitives, `M#`/`M2b` capabilities), the "build M2 first" decision, and M2b (intelligent auto-router, `F30`/`F31`).
- `docs/*.md` — AIUP artifacts for M2, each derived from the previous: `vision.md → requirements.md → entity_model.md → use_cases.puml → use_cases/*.md`. They trace back to the `F##`/`M#`/`P##`/`A##` IDs in the plan docs.
