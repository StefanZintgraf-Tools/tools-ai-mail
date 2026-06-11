# Code Review Gate (Mandatory Before Testing)

## Purpose
This file defines the mandatory code review workflow that must be executed:
- after each implementation step
- before each test run (step tests and main test runner)

Testing must not start until this review gate passes.

## Inputs
Before review, gather:
- Current step specification (`plan/sbom_impl_step*.md` or equivalent)
- Relevant test specification (`plan/sbom_test*.md`)
- Changed files for the current step
- Guardrail compliance matrix based on `plan/guardrails/compliance_matrix_template.md`

## Review Workflow
1. Scope validation
- Confirm changes are limited to the current step requirements.
- Confirm no unintended file or behavior drift.

2. Correctness and failure behavior
- Validate core logic against the step objective.
- Validate error handling and exit behavior.
- Check edge cases and invalid input handling.

3. Guardrail compliance and evidence
- Apply `plan/guardrails/python_guardrails.md` for Python changes.
- Apply `plan/guardrails/bash_guardrails.md` for Bash changes.
- Verify every applicable `MUST` rule ID has matrix status and evidence.
- Missing evidence for a `MUST` rule is a `BLOCKER`.
- `N/A` requires explicit rationale.

4. Static/tool checks
Run applicable checks and capture results. All tools are mandatory prerequisites
(see `sbom_implementation_guidelines.md` "Development Host Prerequisites").
The canonical command list is in `implementation_guardrails.md` "Required Checks Baseline".

Python:
```bash
ruff check .
ruff format --check .
mypy .
pytest -q
```

Bash:
```bash
shfmt -d .
find . -type f -name '*.sh' -print0 | xargs -0 shellcheck
```

5. Test readiness decision
- PASS: no blocking findings -> tests may run.
- BLOCKED: one or more blocking findings -> fix first, then re-review.

## Finding Severity
- `BLOCKER`: correctness/safety/security issue or missing required `MUST` evidence that invalidates test readiness.
- `MAJOR`: significant defect or likely regression; treat as blocking by default.
- `MINOR`: non-blocking maintainability/readability issue.

## Exit Criteria
Review gate passes only when:
- No `BLOCKER` findings remain.
- No unresolved `MAJOR` findings remain (unless explicitly accepted in writing).
- Required static checks pass, or failures are explicitly documented and accepted.
- Guardrail matrix is complete for all applicable rule IDs.

## Mandatory Review Record
Record this in the implementation/test notes each time:

```md
Code Review Gate Result
- Step: <step id>
- Scope: <short summary>
- Files reviewed: <list>
- Checks run: <commands>
- Findings:
  - BLOCKER: <count>
  - MAJOR: <count>
  - MINOR: <count>
- Guardrail matrix: <path or embedded table>
- Decision: PASS | BLOCKED
- Reviewer: <agent/user>
```

---

## Revision History
<!-- Latest entries first. Add new rows directly below the header row. -->
<!-- Same-day revisions: append .2, .3, ... to the date (e.g. 2026-02-14.2). -->

| Date | Change |
|------|--------|
| 2026-02-14.2 | Added canonical source reference for quality gate commands. Removed GNU-specific `xargs -r` for portability. |
| 2026-02-14 | Initial version. |
