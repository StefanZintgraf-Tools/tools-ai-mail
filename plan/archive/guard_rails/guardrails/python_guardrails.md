# Python Guardrails

## Priority model
- MUST: required for merge/completion
- SHOULD: expected unless clear reason

## Enforcement model
- Every `MUST` rule has a stable ID (`PY-MUST-*`) and a mapped detail module.
- For Python changes, review the mapped detail files under `python/` before coding and during code review.
- A `MUST` rule can be marked `N/A` only with a short rationale in the compliance matrix.

## MUST rules and detail modules
| Rule ID | Requirement | Detail module |
| --- | --- | --- |
| `PY-MUST-01` | Add type hints to all new/changed public functions and methods. | `python/typing_interfaces.md` |
| `PY-MUST-02` | Keep imports explicit and grouped (stdlib, third-party, local). | `python/imports_structure.md` |
| `PY-MUST-03` | Raise specific exceptions; do not use bare `except:`. | `python/error_and_resource_safety.md` |
| `PY-MUST-04` | Use context managers for file/network/process resources. | `python/error_and_resource_safety.md` |
| `PY-MUST-05` | Avoid mutable default arguments. | `python/function_design_and_state.md` |
| `PY-MUST-06` | Keep functions focused and small enough to review quickly. | `python/function_design_and_state.md` |
| `PY-MUST-07` | Document non-obvious behavior with concise docstrings/comments. | `python/documentation_and_todos.md` |
| `PY-MUST-08` | Keep TODO comments actionable and attributable. | `python/documentation_and_todos.md` |
| `PY-MUST-09` | Code must pass `ruff check`, `ruff format --check`, `mypy`, and relevant tests. | `python/quality_gates.md` |

## SHOULD rules
- Prefer explicit code over clever one-liners.
- Prefer named helper functions over nested complex logic.
- Return early to reduce nesting.
- Use comprehensions/generators where they improve clarity.
- Keep module-level side effects minimal.

## Lint and quality gates
Use (or wire) these commands (canonical source: `../implementation_guardrails.md`):

```bash
ruff check .
ruff format --check .
mypy .
pytest -q
```

## Agent completion checklist
1. Fill the guardrail compliance matrix from `compliance_matrix_template.md`.
2. Confirm every `PY-MUST-*` rule is `PASS` or justified `N/A`.
3. List commands run and outcomes.
4. List deliberate deviations and rationale.

## Source basis
- Google Python Style Guide
- Hitchhiker's Guide to Python (Code Style)

