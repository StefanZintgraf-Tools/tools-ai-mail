# ai-mail

An AI-assisted **email & attachment automation** project: it ingests incoming mail, proposes actions
(routing, filing, attachment handling) with a confidence score, and records every action in a
provenance ledger. The first capability under construction is **M2**. The authoritative product vision
lives in [docs/vision.md](docs/vision.md).

This repo is also a **live workflow experiment**: the planning runs through the AI Unified Process
(AIUP) augmented with a family of custom guardrail/authoring skills. The end-to-end order is documented
in [plan/workflow.md](plan/workflow.md).

## Key planning artifacts

### `plan/` — strategy, scope, and the skills sub-project

| File | What it is |
|------|-----------|
| [plan/painlist_private.md](plan/painlist_private.md) | Raw private pains, IDs `P01`–`P16`. |
| [plan/painlist_acontis.md](plan/painlist_acontis.md) | Raw acontis (work) pains, IDs `A01`–`A36`. |
| [plan/01-foundation.md](plan/01-foundation.md) | **Source of truth for scope.** Capability ↔ Pain coverage matrix: the namespace catalog (`F##` primitives, `M#`/`M2b` capabilities), which capability covers which pains, the "build **M2** first" decision, and the M2b auto-router (`F30`/`F31`). |
| [plan/workflow.md](plan/workflow.md) | **The authoritative end-to-end sequence** — inception → vision → glossary → requirements → model/spec spine → post-spec — tagging each step stock / fork / lens / external / HITL. |
| [plan/create_skills.md](plan/create_skills.md) | Build plan for the generic AIUP guardrail skills (Family A lenses) + the modified authoring skills (`domain-requirements`, `domain-model`). Self-contained per-skill build specs. |
| [plan/skills_background_info.md](plan/skills_background_info.md) | The reasoning/handoff behind `create_skills.md` — why the design landed where it did (the "bridge → generic peer skills" pivot, the two authoring forks, what was considered and rejected). |

> `01-foundation.md` supersedes an earlier `00-foundation.md`. Pain IDs (`P##`/`A##`), function
> primitives (`F##`), and capabilities (`M#`) are the cross-cutting identifiers traced throughout the
> `docs/` artifacts.

### `docs/` — AIUP artifacts (each derived from the previous)

Derivation chain: `vision → requirements → entity_model → use_cases.puml → use_cases/*.md`, with the
glossary and ADRs as cross-cutting ground truth. All trace back to `F##`/`M#`/`P##`/`A##`.

| File | What it is |
|------|-----------|
| [docs/vision.md](docs/vision.md) | AIUP vision for M2. |
| [docs/requirements.md](docs/requirements.md) | Requirements catalog — functional (`FR-###`), non-functional, constraints. |
| [docs/CONTEXT.md](docs/CONTEXT.md) | **The glossary / ubiquitous language.** Ground truth for all domain terms; seeded before the requirements step. |
| [docs/adr/0001-external-provenance-ledger.md](docs/adr/0001-external-provenance-ledger.md) | ADR — the Provenance Ledger as its own aggregate. |
| [docs/adr/0002-approval-surface-as-adapter.md](docs/adr/0002-approval-surface-as-adapter.md) | ADR — the approval surface modelled as an adapter. |
| [docs/adr/0003-sender-only-routing-m2.md](docs/adr/0003-sender-only-routing-m2.md) | ADR — sender-only routing for M2. |

*(`docs/entity_model.md`, `docs/use_cases.puml`, and `docs/use_cases/*.md` are produced later in the
spec spine — see `plan/workflow.md` Phase 3.)*

### Guardrail & authoring skills

Built and run as ai-mail **project skills** in [skills/](skills/) (the sandbox; ported back to the
coding project later). See `plan/create_skills.md` for specs and `plan/workflow.md` for when each runs.

- **Lenses (Family A):** `ubiquitous-language-guard`, `pareto-scope-cut`, `adr-threshold-gate`,
  `hidden-constraint-sweep`, `trace-check`.
- **Authoring forks (Family B):** `domain-model` (built), `domain-requirements` (**not yet built** —
  the one skill still to create, build spec #7 in `create_skills.md`).

### Work tracking

- [todo.md](todo.md) — the live work log. The current task is the topmost unchecked `- [ ]` section.

## Not for planning (off-limits)

The following exist in the tree but are **superseded, generated, or human-only** — do not use them as
planning input:

- `plan/archive/` — archived, superseded material.
- `outlook-RAG/` — out of scope.
- `todo_ideas.md` — human-only scratch (use [todo.md](todo.md) instead).
