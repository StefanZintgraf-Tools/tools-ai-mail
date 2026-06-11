# Function Design and State

## Scope
Applies to `PY-MUST-05` and `PY-MUST-06`.

## Requirements
- Do not use mutable default arguments (`[]`, `{}`, `set()`). Use `None` then initialize inside.
- Keep functions focused on one clear responsibility.
- Reduce deeply nested logic with guard clauses or helpers.
- Keep side effects explicit; avoid hidden state mutation in utility helpers.

## Anti-patterns

```python
# WRONG: mutable default -- shared across all calls
def collect_modules(modules: list[str] = []) -> list[str]:
    modules.append(find_next())
    return modules

# RIGHT: use None sentinel and initialize inside
def collect_modules(modules: list[str] | None = None) -> list[str]:
    if modules is None:
        modules = []
    modules.append(find_next())
    return modules
```

```python
# WRONG: function does too many unrelated things
def process(path):
    data = json.loads(open(path).read())
    filtered = [c for c in data["components"] if c["type"] == "firmware"]
    for c in filtered:
        c["hashes"] = [compute_sha256(c["name"])]
    with open(path, "w") as f:
        json.dump(data, f)
    print(f"Done: {len(filtered)} components")

# RIGHT: decompose into focused helpers
def load_sbom(path): ...
def filter_firmware(components): ...
def add_hashes(components): ...
def save_sbom(path, data): ...
```

## Review checklist
- No mutable defaults in changed signatures.
- Changed functions remain reviewable in size/complexity.
- Complex branches are split into helper functions when needed.

## Typical evidence
- `path/to/file.py:line` for signatures and helper extraction.
- Unit tests for refactored branch behavior.

## Source basis
- `../sources/google_python_style_guide.html`
- `../sources/hitchhikers_python_style.html`

