# Python Quality Gates

## Scope
Applies to `PY-MUST-09`.

## Required commands
```bash
ruff check .
ruff format --check .
mypy .
pytest -q
```

## Requirements
- Run applicable checks for the changed Python scope.
- Any failing required check blocks test readiness.
- If a tool is unavailable in the environment, record that explicitly and treat as an open risk until resolved.

## Review checklist
- Command list is recorded.
- Exit status/outcome is recorded for each command.
- Failures are fixed or explicitly accepted in writing.

## Typical evidence
- Command transcript summary with pass/fail outcome.

## Source basis
- `../sources/google_python_style_guide.html`

