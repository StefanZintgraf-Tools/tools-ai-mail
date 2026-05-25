# ai-mail — Local Copy of Acontis Coding Conventions

This folder is a project-local copy of the Python parts of `C:\PROJ\acontis\acontis-ai\Coding\CodingConventions\Python_Bash\`. It travels with the repo so the project is self-contained on any machine.

## What was copied

- `code_review.md` — mandatory pre-test review gate.
- `impl_guidelines_template.md`, `impl_guidelines_project.md` — cross-cutting rules and per-project checklist.
- `impl_guardrails_template.md`, `impl_guardrails_project.md` — agent execution contract and per-project checklist.
- `guardrails/python_guardrails.md` — `PY-MUST-*` rule IDs.
- `guardrails/python/` — detail modules referenced by rule ID.
- `guardrails/compliance_matrix_template.md` — evidence format.
- `guardrails/sources/` — local snapshots of Python style guide sources only.

## What was intentionally omitted

- All Bash content (`bash_guardrails.md`, `guardrails/bash/`, bash-only style-guide sources). **Bash is not in scope for ai-mail.** Wherever the canonical templates mention "if Bash is in scope", treat as not applicable.

## Authoritative source

The canonical conventions live at `C:\PROJ\acontis\acontis-ai\Coding\CodingConventions\Python_Bash\` on the developer's machine. If that source is updated upstream, this local copy must be re-synced manually.

## Snapshot date

2026-05-08
