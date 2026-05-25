# Guardrails Folder

## Contents
- `python_guardrails.md`: enforceable Python rules with `PY-MUST-*` IDs.
- `python/`: Python detail modules referenced by rule ID.
- `compliance_matrix_template.md`: required evidence template for implementation and review.
- `sources/`: local snapshots of external style guide sources (Python only).

> Bash is **not in scope** for the ai-mail project. The bash guardrails and detail modules from the canonical conventions repo were intentionally omitted from this copy.

## Required workflow
1. Read `../implementation_guardrails.md`.
2. Identify changed language(s) and load global guardrails.
3. Load mapped detail module files for all applicable `MUST` IDs.
4. Fill compliance matrix with `PASS`, `N/A`, or `FAIL` plus evidence (`file:line` or command output).
5. Run `../code_review.md` gate before testing.

Use with:
- `../implementation_guardrails.md` as top-level policy and workflow.
- `../code_review.md` as mandatory pre-test gate.

