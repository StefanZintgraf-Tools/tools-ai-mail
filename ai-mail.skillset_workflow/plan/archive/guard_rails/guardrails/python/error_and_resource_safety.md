# Error and Resource Safety

## Scope
Applies to `PY-MUST-03` and `PY-MUST-04`.

## Requirements
- Catch only expected exceptions; avoid bare `except:`.
- Raise specific exception types that match the failure mode.
- Preserve context when re-raising (for example, `raise CustomError(...) from exc`).
- Use context managers for resources with lifecycle (`with open(...)`, managed network/process handles).
- Ensure cleanup is guaranteed on success and failure paths.

## Anti-patterns

```python
# WRONG: bare except swallows everything including KeyboardInterrupt
try:
    data = json.loads(raw)
except:
    data = {}

# RIGHT: catch the specific exception
try:
    data = json.loads(raw)
except json.JSONDecodeError as exc:
    raise ValueError(f"Invalid JSON in {path}") from exc
```

```python
# WRONG: manual open without context manager -- leak on exception
f = open(path)
content = f.read()
f.close()

# RIGHT: context manager guarantees cleanup
with open(path) as f:
    content = f.read()
```

## Review checklist
- No bare `except:` in changed code.
- Exception classes are specific and meaningful.
- Resource acquisition in changed code is paired with context manager or equivalent safe pattern.

## Typical evidence
- `path/to/file.py:line` around try/except and resource handling.
- Test cases for failure paths where applicable.

## Source basis
- `../sources/google_python_style_guide.html`
- `../sources/hitchhikers_python_style.html`

