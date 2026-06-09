# Skills — authoring rules

These skills are **portable artifacts** meant to work in any project. They live in the
ai-mail repo only for convenience; nothing here may assume ai-mail exists.

## Hard rule: keep every skill project-agnostic

When creating or editing any skill, **never** insert anything specific to this project:

- No project names — not "ai-mail", "acontis", "tools-ai-mail", "zintgraf", etc.
- No project paths — not `docs/CONTEXT.md`, `plan/01-foundation.md`, `painlist_*`, etc.
- No domain terms or identifiers — not `P##`/`A##` pains, `F##` primitives, `M#` capabilities, etc.
- No references to this repo's issues, ADRs, or file layout.

Refer to such things only through **generic placeholders** the user supplies or the skill
discovers at runtime (e.g. "the project's context doc", "the issue tracker", `<repo>`).

## Self-check before saving a skill

1. Search your edit for the forbidden terms above. If any appear, replace with a generic
   placeholder or remove.
2. Ask: "If I dropped this skill into an unrelated repo, would it still make sense?" If not,
   it has leaked project specifics — fix it.

If a skill genuinely needs project-specific configuration, expose it as an **input/argument**
the caller provides — never hard-code it.
