# Implementation Guardrails -- Agent Instructions (Template)

> **This file is a configurable template.** Adopt or remove sections to match
> the project's scope. Project-specific values are shown as `<placeholders>`.
> Section numbers match those used in `impl_guidelines_template.md` where
> topics overlap; guardrail-specific sections use their own numbering (G1-G6).

## G1 Mandatory Applicability

These instructions are mandatory for any coding or testing activity in the
project. Every implementation and test step must follow this file.

Primary references (adapt paths to the project layout):

- `<project>_implementation_guidelines.md` (cross-cutting rules -- see
  template sections 1-12)
- `<project>_run_config.json` (effective execution controls -- optional, see
  template section 3)
- `<project>_run_config.schema.json` (validation schema -- optional)
- `<project>_config.md` (configuration parameter contract -- optional)
- `implementation_guardrails.md` (this file)
- `code_review.md` (mandatory pre-test review gate)
- `guardrails/python_guardrails.md` (Python rule IDs and module mapping)
- `guardrails/bash_guardrails.md` (Bash rule IDs and module mapping -- if Bash
  is in scope, see template section 4)
- `guardrails/compliance_matrix_template.md` (mandatory evidence format)

If a change touches both Python and Bash, both language guardrails apply.

## G2 Execution Contract for Agents

### G2.1 For each implementation step

1. Read the implementation guidelines, run configuration (if used), the
   relevant step file, and this guardrail file.
2. Identify changed language(s) and load the applicable rule set(s):
   - Python: all `PY-MUST-*` rules in `guardrails/python_guardrails.md`
   - Bash *(if in scope)*: all `SH-MUST-*` rules in
     `guardrails/bash_guardrails.md`
3. Load mapped detail modules from the language guardrail files under
   `guardrails/python/` and/or `guardrails/bash/`.
4. If the project uses execution configuration, resolve the effective step
   settings (profile, limits, stop points) from the run configuration file.
5. If no explicit step is requested, select the first incomplete enabled step
   in the active profile.
6. If an explicit step is requested, execute only that step.
7. Implement only the scoped requirements of the current step and honor any
   configured sampling limits.
8. If the project uses progress tracking, update progress state at every
   sub-step boundary and append configured events.
9. If a configured stop point is reached, stop execution and mark progress
   accordingly.
10. Run required static checks for changed files (see G4).
11. Execute the code review workflow in `code_review.md`.
12. Fix all blocking review findings.
13. Only then run the step test(s).
14. Record a completed guardrail compliance matrix with evidence (see G5).

### G2.2 For each test run

1. Execute `code_review.md` first.
2. Do not run tests if blocking findings remain.
3. Run test script(s) defined in the step/test specification.

## G3 Non-Negotiable Rules

- MUST satisfy all `MUST` rules in the applicable language guardrails.
- MUST read mapped detail modules for all applicable `MUST` IDs.
- MUST not skip code review before testing.
- MUST not suppress lint/type/static issues without a short justification.
- MUST preserve existing behavior unless the current step requires a change.
- MUST keep changes scoped, traceable, and testable.
- MUST follow the test isolation rules (see guidelines template section 11.1)
  for all test code.
- MUST provide evidence (`file:line` or command result) for each applicable
  `MUST` ID.

*If the project uses execution configuration, also:*

- MUST validate the run configuration against its schema before execution.
- MUST honor active profile limits and step overrides.
- MUST honor configured stop points and persist progress state.

## G4 Required Checks Baseline

All tools below are **mandatory prerequisites** (see guidelines template
section 5). They must be installed before implementation begins. It is not
acceptable to skip checks because of missing packages.

Run the checks relevant to modified files. The commands listed here are the
canonical baseline -- language-specific guardrail files and `code_review.md`
repeat them for self-containment. If a command needs to change, update it here
first and then align the other files.

### G4.1 Python baseline

```bash
ruff check .
ruff format --check .
mypy .
pytest -q
```

### G4.2 Bash baseline (when Bash is in scope)

```bash
shfmt -d .
find . -type f -name '*.sh' -print0 | xargs -0 shellcheck
```

The `find | xargs` command above omits the GNU-specific `-r` flag for
portability across development hosts.

### G4.3 Repository-specific overrides

Use repository-specific equivalents (e.g., via `pyproject.toml` or
`.editorconfig`) when configured. If a repository-specific equivalent differs
from the baseline commands, document it in the completion report.

## G5 Guardrail Compliance Matrix

Use `guardrails/compliance_matrix_template.md`.

Rules:

- Each applicable rule ID must have `PASS`, `N/A`, or `FAIL`.
- `N/A` requires a brief rationale.
- `FAIL` is blocking until fixed or explicitly accepted in writing.

## G6 Completion Report Template

Every implementation completion report must include:

1. Guardrails referenced
2. Files changed
3. Checks run and results
4. Code review status (from `code_review.md`)
5. Guardrail compliance matrix (or link to it)
6. Test execution status
7. Remaining risks/deviations

---

## Revision History
<!-- Latest entries first. Add new rows directly below the header row. -->
<!-- Same-day revisions: append .2, .3, ... to the date (e.g. 2026-02-20.2). -->

| Date | Change |
|------|--------|
| 2026-02-20 | Generalized from SBOM-specific guardrails into a reusable project template. Added section numbers (G1-G6, G2.x, G4.x). Made Bash sections conditional. Replaced concrete filenames with placeholders. Marked optional topics. |
