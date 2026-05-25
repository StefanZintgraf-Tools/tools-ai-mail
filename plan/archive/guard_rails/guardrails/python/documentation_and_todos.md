# Documentation and TODO Hygiene

## Scope
Applies to `PY-MUST-07` and `PY-MUST-08`.

## Requirements
- Add concise docstrings/comments for non-obvious behavior, invariants, or side effects.
- Do not add comments that only restate obvious code.
- TODO items must be actionable and attributable.
- Preferred TODO format: `TODO(<owner-or-ticket>): <specific action>`.
- Remove stale TODOs that are no longer relevant in changed sections.

## Review checklist
- Non-obvious logic is documented where needed.
- Every new TODO has owner/ticket and concrete action.
- No vague TODO markers such as `TODO: fix later`.

## Typical evidence
- `path/to/file.py:line` for docstrings/comments/TODOs.

## Source basis
- `../sources/google_python_style_guide.html`
- `../sources/hitchhikers_python_style.html`

