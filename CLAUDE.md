# Claude Agent Context — ai-mail

## Off-limits — never read, search, or reference

- `plan/archive/`
- `skills/archive/`
- `outlook-RAG/`
- `todo_ideas.md` — human-only scratch (read `todo.md`, never this)

## Read only when relevant

- `skills/` — read only when creating, refactoring, or debugging a skill.

## Agent skills

### Issue tracker

Issues and PRDs live as GitHub issues in `StefanZintgraf-Tools/tools-ai-mail`, via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Canonical label vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `docs/CONTEXT.md` + `docs/adr/`. See `docs/agents/domain.md`.

## Key planning artifacts

- `docs/CONTEXT.md` — Domain glossary; read before any planning or implementation; update in-session when terms emerge or shift.
- `todo.md` — read when asked "what's next" or to pick up the current task (topmost unchecked `- [ ]` section).
- `plan/painlist_private.md`, `plan/painlist_acontis.md` — read when tracing why a feature exists or prioritizing scope (`P##` private pains, `A##` acontis pains).
- `plan/01-foundation.md` — read when touching namespace/capability boundaries, adding primitives, or questioning build order (`F##` primitives, `M#`/`M2b` capabilities).
- `docs/*.md` — read when working on requirements, entities, or use cases (`vision.md → requirements.md → entity_model.md → use_cases.puml → use_cases/*.md`).
- `docs/adr/` — read when proposing or reviewing structural/architectural decisions.

