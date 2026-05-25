# Imports and Module Structure

## Scope
Applies to `PY-MUST-02`.

## Requirements
- Imports must be explicit; do not use wildcard imports.
- Group imports in this order: standard library, third-party, local project imports.
- Separate groups with one blank line.
- Keep imports at module top unless delayed import is needed; if delayed, add a brief reason.
- Remove unused imports in changed files.

## Anti-patterns

```python
# WRONG: wildcard import -- pollutes namespace, hides origins
from json import *
from pathlib import *

# RIGHT: explicit imports, grouped and ordered
import json
from pathlib import Path
```

```python
# WRONG: ungrouped, unordered imports
from pathlib import Path
import subprocess
import json
from typing import Any

# RIGHT: stdlib grouped together, blank line between groups
import json
import subprocess
from pathlib import Path
from typing import Any
```

## Review checklist
- Import grouping/order is correct in each changed Python file.
- No wildcard import in changed code.
- Delayed imports are justified and minimal.

## Typical evidence
- `path/to/file.py:line` for import blocks.
- `ruff check` result for import/unused checks.

## Source basis
- `../sources/google_python_style_guide.html`

