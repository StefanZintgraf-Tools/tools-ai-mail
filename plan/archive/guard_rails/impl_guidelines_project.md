# Implementation Guidelines (Project Checklist)

> **How to use:** Copy this file into your project. Check the sections that
> apply, fill in the project name, and remove or mark *N/A* for sections that
> do not apply. Each item references the corresponding section in
> `impl_guidelines_template.md` where the full rules and examples are defined.

**Project name:** `<project>`

## Applicable Sections

- [ ] **1 Purpose** -- Cross-cutting rules that all step and test files build on.
- [ ] **2 Scope and Precedence** -- This guidelines file is normative for all implementation, test, and review files; conflict-resolution rules.
- [ ] **3 Execution Configuration Contract** -- Machine-readable run config with schema, profiles, precedence, and change-control rules.
- [ ] **4 Language Strategy** -- Defines which languages own which responsibilities (Python, Bash, other).
  - [ ] **4a Bash in scope** -- Target is Linux/WSL; Bash used for orchestration and CLI wrappers.
- [ ] **5 Development Host Prerequisites** -- Mandatory QA tooling that must be installed before implementation.
  - [ ] **5.1 Python tooling** -- `ruff`, `mypy`, `pytest`.
  - [ ] **5.2 Bash tooling** -- `shellcheck`, `shfmt` (only when Bash is in scope).
  - [ ] **5.3 Project-specific tooling** -- Additional tools required by this project (list below).
  - [ ] **5.4 Tool Configuration** -- `pyproject.toml` / `.editorconfig` settings for QA tools.
  - [ ] **5.5 Test Runner Clarification** -- Standalone test scripts alongside `pytest` as secondary runner.
- [ ] **6 Canonical Repository Structure** -- Recommended folder layout for deliverables, plan, guardrails, tests.
- [ ] **7 Stable Interface Contracts** -- Public entry-point CLI contracts and breaking-change rules.
- [ ] **8 Version Pinning and Artifact Verification** -- Pin tool versions; verify downloads with SHA-256.
- [ ] **9 Output Conventions** -- stderr for diagnostics, named files for output, uniform exit codes (0/1/2).
- [ ] **10 Maintainability Decomposition Policy** -- Keep entry points small; decompose internals into helper modules.
- [ ] **11 Testing Architecture Baseline** -- Test orchestrator, per-step scripts, coverage layering.
  - [ ] **11.1 Test Isolation Rules** -- Idempotency, temp directories, cleanup, fixture independence, no shared state.
- [ ] **12 Implementation Readiness Gate** -- Pre-conditions that must hold before implementation may start.

## Project-Specific Notes

*Use this space to record project-specific decisions, tool lists (5.3),
language boundaries (4), runtime constraints, or deviations from the template.*

---

## Revision History
<!-- Latest entries first. Add new rows directly below the header row. -->
<!-- Same-day revisions: append .2, .3, ... to the date (e.g. 2026-02-20.2). -->

| Date | Change |
|------|--------|
| 2026-02-20 | Created as generic project checklist referencing `impl_guidelines_template.md` sections 1-12. |
