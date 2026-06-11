# Typing and Interfaces

## Scope
Applies to `PY-MUST-01`.

## Requirements
- Add annotations for parameters and return values on all new or changed public functions/methods.
- Public means externally callable module-level functions, class methods, and exported helpers.
- Use explicit optionality (`T | None` or `Optional[T]`) when `None` is valid.
- Avoid introducing `Any` unless unavoidable; if used, document why in a short comment.
- Keep type aliases and protocols close to where they are used unless widely shared.

## Review checklist
- Signature includes types for all changed public callables.
- Return type is explicit and accurate.
- No hidden type holes (`Any`, broad casts) without rationale.

## Typical evidence
- `path/to/file.py:line` for annotated signatures.
- `mypy` output in quality gate record.

## Source basis
- `../sources/google_python_style_guide.html`
- `../sources/hitchhikers_python_style.html`

