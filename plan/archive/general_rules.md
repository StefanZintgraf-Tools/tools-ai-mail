# Claude Agent Context — ai-mail

This file briefs any AI agent picking up work on this project. Read it before doing anything else.

## What this project is

Single-user, local Win11 AI-driven mail handling tool. Goals: search PST mails by NL prompt, draft replies, use mail content as a knowledge base for Q&A. Built with the same stack as the acontis ai-support project — Ollama + AnythingLLM + Claude API + direct Python orchestrator. Prototype-first, with later phases for PII anonymization and quality (Q&A distillation).

## Where to start

**Read [plan/ai-mail_specification.md](plan/ai-mail_specification.md) first.** It is the binding design specification produced from a grilling session. It contains:

- §1 Vision and phasing.
- §2 25 resolved design decisions (Q1–Q25). Treat as binding unless the user explicitly reopens a decision.
- §3 Open branches still to grill (implementation order, dates/tz, failure handling, AnythingLLM workspace strategy, ingest concurrency, review of prior `outlook-RAG/email_vector_db_pipeline.md`).
- §4 Backlog.

If the user says "continue grilling", resume at §3.

## Standing rules for this project

### TDD is mandatory

Every feature is implemented test-first.

- Layered tests: unit (pure-function, fast), integration-mocked (HTTP fakes for AnythingLLM/Ollama/Claude — default run), integration-live (real services, gated by env `MAIL_TEST_LIVE=1`), golden acceptance (synthetic PST + golden Q&A; emits `assertion` events to logs).
- Default `pytest -q` must pass without live services.
- Cycle per feature: write failing pytest test → implement minimum to pass → refactor.

### Acontis Python coding conventions apply

Authoritative project-local copy: [plan/guard_rails/](plan/guard_rails/) (committed with the repo, no external dependency). Upstream source on the original dev machine: `C:\PROJ\acontis\acontis-ai\Coding\CodingConventions\Python_Bash\` — re-sync manually if changed there.

- Mandatory tooling: `ruff check .`, `ruff format --check .`, `mypy .`, `pytest -q`.
- PY-MUST rule IDs: see [plan/guard_rails/guardrails/python_guardrails.md](plan/guard_rails/guardrails/python_guardrails.md). Detail modules under [plan/guard_rails/guardrails/python/](plan/guard_rails/guardrails/python/).
- Output conventions: diagnostics → stderr, machine-readable → stdout/file, exit codes 0/1/2.
- Workflow gate per step: implement scoped requirements → run static checks → run code review per [plan/guard_rails/code_review.md](plan/guard_rails/code_review.md) → fix blocking findings → only then run step tests → record compliance matrix using [plan/guard_rails/guardrails/compliance_matrix_template.md](plan/guard_rails/guardrails/compliance_matrix_template.md).
- Bash is **not in scope** for this project. Ignore "if Bash is in scope" sections in the templates.

### Configuration via `.env` only

No CLI flags for configuration. Use `python-dotenv` to load `.env`; process environment overrides for ad-hoc switching. Keys defined in §2.6 of the specification.

### Logging is agent-verifiable

Per run: one JSONL file under `work/logs/<cmd>-<run_id>.jsonl` with stable stage names and payload schema. Required content per run is defined in §2.7 (Q23). Mail content lands in logs → `work/` is gitignored.

### Repository layout follows acontis Tools projects

Layout defined in §2.10 of the specification. Python 3.12. `.venv` via `py -3.12 -m venv .venv`. Venv scripts mirror `c:\PROJ\acontis\acontis-ai\Tools\kerio_mail` and `c:\PROJ\acontis\acontis-ai\Tools\marker`.

## Important context

- **Prior artefact** at [outlook-RAG/email_vector_db_pipeline.md](outlook-RAG/email_vector_db_pipeline.md) predates this design. Review and either fold in or explicitly supersede in §3 of the spec.
- **Test PST policy:** real PST subset goes under `testdata/real/` (gitignored, never committed); tiny synthetic PST under `testdata/synthetic/` (committed) for unit tests.
- **No PII anonymization in prototype** — acceptable risk on test PST only. Step 2 (PII anonymization at LLM-call boundary) is mandatory before touching the real 20 GB business PST.
