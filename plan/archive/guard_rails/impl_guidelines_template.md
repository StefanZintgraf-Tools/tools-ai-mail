# Implementation Guidelines (Template)

> **This file is a configurable template.** Not every section will apply to every
> project. Adopt sections that match your project's scope and mark inapplicable
> ones as *N/A* or remove them. Project-specific values are shown as
> `<placeholders>` or prefixed with *Example:*.

## 1 Purpose

Define cross-cutting rules that apply to all implementation steps and test
specifications in a project. This document establishes the shared baseline that
individual step files, test specs, and review gates build on.

## 2 Scope and Precedence

- This file is normative for all implementation, test, and review markdown and
  JSON files in the project, for example:
  - `<project>_run_config.json` (effective execution settings)
  - `<project>_run_config.schema.json` (validation schema)
  - `<project>_config.md` (configuration parameter documentation)
  - `impl_step<N>.md` (implementation step specifications)
  - `test_main.md` / `test_step<N>.md` (test specifications)
  - `implementation_guardrails.md`
  - `code_review.md`
- Step files define step-specific behavior. This file defines shared rules.
- If a step file conflicts with this file on a cross-cutting rule, update this
  file first and then align step files. If the conflict concerns step-specific
  domain behavior, the step file is authoritative for that domain detail.

## 3 Execution Configuration Contract

*Adopt this section when the project uses a machine-readable run configuration
to control step execution, profiling, or progress tracking.*

Implementation and test execution settings are controlled by:

- Effective values: `<project>_run_config.json`
- Validation schema: `<project>_run_config.schema.json`
- Parameter documentation: `<project>_config.md`

Precedence rules:

- Step-specific values in `step_overrides` take precedence over profile defaults.
- Profile defaults take precedence over hardcoded assumptions in step or test
  files.
- If no explicit step is requested, select the first incomplete enabled step in
  the active profile.
- If a configured stop point exists, execution must stop at that boundary.
- Progress state and event logs must be persisted under `plan/progress/` as
  configured.

Change-control rule:

- Any change to configuration keys or semantics must update the run
  configuration file, its schema, and its documentation in the same change set.

## 4 Language Strategy

Decide which languages the project uses and document the boundaries here. The
table below shows a typical Python + Bash split; adjust or remove columns as
needed.

> **When to include Bash:** Bash is appropriate when the target environment is
> Linux or WSL and the project needs shell-level orchestration (CLI wrappers,
> tool invocation, process pipelines). For Windows-only or cross-platform
> projects, replace Bash with the relevant orchestration approach (PowerShell,
> Makefile, Python entry-point, etc.) and drop the Bash guardrails.

| Area | Language | Responsibility |
|------|----------|----------------|
| Pipeline entrypoint / orchestration | Bash *(if Linux/WSL)* | Process orchestration, CLI handling, tool invocation |
| Core logic / data transformation | Python 3 | Business logic, data processing, structured output |
| Test suite orchestration | Bash or `pytest` | Run order, aggregation, exit status summary |
| Individual test assertions | Python 3 | Validation logic per step and per requirement |

Global rules:

- Document language boundaries explicitly before implementation begins.
- If Bash is used, it owns orchestration and OS command execution boundaries.
- Python owns structured-data logic and format-specific transformations.
- Adding another mandatory runtime language requires an explicit plan update.
- If the target system has runtime constraints (e.g., stdlib-only Python, no
  `pip`), document them here so that deliverables respect those limits.

## 5 Development Host Prerequisites

Static analysis, linting, and test tooling listed in the quality gates are
**mandatory prerequisites** and must be installed on the development host before
implementation begins. It is not acceptable to skip guardrail checks or tests
because of missing packages.

### 5.1 Python tooling (always applicable)

| Tool | Purpose | Install |
|------|---------|---------|
| `ruff` | Python linter and formatter | `pip install ruff` |
| `mypy` | Python static type checker | `pip install mypy` |
| `pytest` | Python test runner | `pip install pytest` |

### 5.2 Bash tooling (when Bash is in scope)

| Tool | Purpose | Install |
|------|---------|---------|
| `shellcheck` | Bash static analysis | OS package manager |
| `shfmt` | Bash formatter | OS package manager or `go install` |

### 5.3 Project-specific tooling

*Add rows for any additional tools required by the project (e.g., signing
tools, container builders, code generators). Remove this sub-section if none
apply.*

| Tool | Purpose | Install |
|------|---------|---------|
| *Example:* `cosign` | Artifact signing | [sigstore/cosign](https://github.com/sigstore/cosign/releases) |

### 5.4 Tool Configuration

Project-level configuration for QA tools should be maintained in
`pyproject.toml` at the project root. At a minimum configure:

- `ruff`: target Python version, line length, selected rules.
- `mypy`: Python version, strict mode or selected checks.
- `shfmt` *(if Bash is in scope)*: formatting style via `.editorconfig` or
  command-line flags documented in `implementation_guardrails.md`.

When configuration files are present, all quality gate commands use them
automatically.

### 5.5 Test Runner Clarification

*Adopt this note when the project has both standalone test scripts and `pytest`
as a secondary runner.*

Standalone test scripts (e.g., `tests/test_step<N>.py`) may be designed to run
via a dedicated orchestrator (e.g., `tests/run_all_tests.sh`). The `pytest`
tool is used for quality-gate static analysis and for supplementary
developer-side unit tests -- it is not necessarily the primary test runner. Both
execution paths must produce consistent results.

## 6 Canonical Repository Structure

The tree below is a recommended baseline. Adapt folder names and depth to the
project's needs.

```text
<project>/
  <project>_run_config.json          # execution settings (optional)
  <project>_run_config.schema.json   # config validation schema (optional)
  <entrypoint_script(s)>             # runtime deliverables
  plan/
    <project>_specification.md       # requirements / specification
    <project>_implementation_plan.md # implementation plan
    implementation_guidelines.md     # this file (cross-cutting rules)
    implementation_guardrails.md     # mandatory workflow controls
    code_review.md                   # mandatory pre-test review gate
    guardrails/
      README.md
      python_guardrails.md
      bash_guardrails.md             # omit if Bash not in scope
      compliance_matrix_template.md
      python/                        # Python detail modules
      bash/                          # Bash detail modules (if applicable)
      sources/                       # local snapshots of style guide sources
    progress/                        # progress logs / state (optional)
      events/
      steps/
    reviews/                         # review execution records
    impl_step<N>.md                  # implementation step specs
    test_main.md                     # main test specification
    test_step<N>.md                  # per-step test specifications
  tests/
    run_all_tests.sh                 # test orchestrator (or .py equivalent)
    test_step<N>.py                  # per-step test scripts
```

Folder and artifact rules:

- Runtime deliverables are maintained at the project root.
- Planning files are maintained in `plan/`.
- Guardrail policy and detail modules are maintained under `plan/guardrails/`.
- `implementation_guardrails.md` and `code_review.md` are mandatory workflow
  controls.
- Progress logs/state, if used, are maintained under `plan/progress/`.
- Automated test scripts are maintained in `tests/`.
- Review execution results are stored under `plan/reviews/`.
- Generated/output artifacts are runtime outputs, not planning sources.
- Test executions should use a temp directory or explicit `--output-dir`.

## 7 Stable Interface Contracts

*List the public entry points of the project and their stability guarantees.
Examples:*

| Interface | Owner | Contract |
|-----------|-------|----------|
| *Example:* `<entrypoint>.sh` CLI | Bash entrypoint | Stable user-facing command for input selection, output naming |
| *Example:* `<helper>.py` CLI | Python helper | Stable machine-facing contract for data processing |
| *Example:* `tests/run_all_tests.sh` CLI | Test orchestration | Invokes all test scripts and reports aggregate status |

Contract rules:

- Breaking CLI changes require synchronized updates to implementation and all
  affected test specs.
- Standalone modes used by tests are part of the contract while test specs
  depend on them.

## 8 Version Pinning and Artifact Verification

To keep builds reproducible and auditable:

- Do not use floating installer references such as `main` branches or
  `releases/latest`.
- Pin exact tool versions in implementation scripts for external tools.
- Verify downloaded binaries or installer scripts using SHA-256 values recorded
  in planning or release notes before execution.
- Record effective tool versions in output metadata and in run logs.

## 9 Output Conventions

These rules apply to all runtime scripts and must be followed consistently
across all implementation steps.

- Diagnostic and progress messages go to **stderr** (`>&2`).
- Machine-readable output goes to a **named file** or **stdout** when piping is
  intended.
- Error messages must include the originating script or function name for
  context (e.g., `"<script>: error: <tool> not found"`).
- Exit codes:
  - `0` -- success
  - `1` -- general runtime failure
  - `2` -- usage/argument error
- Python helpers called by Bash (if applicable) must use the same exit code
  convention so the orchestrator can detect and report failures without
  translation.

## 10 Maintainability Decomposition Policy

- Keep the number of public entry-point files small and stable.
- Keep shell entry points as thin orchestrators; avoid domain-specific data
  logic there.
- As complexity grows, Python internals may be decomposed into helper modules
  while preserving the public CLI contract.
- Any new mandatory runtime file must be added to planning docs before
  implementation.

## 11 Testing Architecture Baseline

- A test orchestrator (`tests/run_all_tests.sh` or equivalent) owns test
  ordering and aggregate result reporting.
- Per-step test scripts (`tests/test_step<N>.py`) own assertion logic and
  requirement-level validation.
- Coverage layering (adjust ranges to project size):
  - Early steps: component-level and contract-level checks
  - Middle steps: integration-level artifact checks
  - Late steps: end-to-end and operational behavior checks

### 11.1 Test Isolation Rules

- **Idempotency**: every test script must produce the same result regardless of
  how many times it runs in sequence. Tests must not depend on side effects from
  a previous run.
- **Temp directory usage**: tests that produce output artifacts must write to a
  temporary directory (created per run) or to an explicit `--output-dir`
  argument. Tests must not write to the repository working tree.
- **Cleanup**: tests must remove their temporary directories and files on both
  success and failure paths (`trap` in Bash, `try/finally` or `atexit` in
  Python).
- **Fixture dependencies**: if a later step's tests require input artifacts from
  an earlier step, the test script must either generate the required fixture
  itself or accept its path via a CLI argument. Tests must never assume that a
  previous step's test has already run.
- **No shared mutable state**: tests must not modify global configuration,
  environment variables, or files outside their temporary directory.

## 12 Implementation Readiness Gate

Implementation work may start only when all conditions hold:

1. Language boundaries are accepted.
2. Repository structure is accepted.
3. Interface contracts are accepted.
4. Guardrail workflow controls are accepted (`implementation_guardrails.md`,
   `code_review.md`, `guardrails/*`).
5. Development host prerequisites are installed (see tables above).
6. Step and test specs explicitly reference this guideline baseline.
7. If execution configuration is used, the config file, schema, and
   documentation are present and aligned.

---

## Revision History
<!-- Latest entries first. Add new rows directly below the header row. -->
<!-- Same-day revisions: append .2, .3, ... to the date (e.g. 2026-02-20.2). -->

| Date | Change |
|------|--------|
| 2026-02-20.2 | Added section numbers (1-12, subsections 5.x, 11.x) for unambiguous cross-referencing. |
| 2026-02-20 | Generalized from SBOM-specific guidelines into a reusable project template. Made Bash conditional on Linux/WSL target. Replaced concrete filenames with placeholders. Marked optional sections. |
