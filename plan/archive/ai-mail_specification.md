# ai-mail — Design Specification (Grilling Snapshot)

**Status:** Draft snapshot from design grilling session.
**Date:** 2026-05-08
**Owner:** Stefan Zintgraf
**Phase:** Pre-implementation. Some smaller branches still open (see §3).

This document captures decisions reached during the design grilling. It is a checkpoint — the grilling can resume later from §3 (Open branches).

---

## 1. Vision & Phasing

AI-driven mail handling for a single user, locally on a Win11 box. Goals: search mails by NL prompt, draft replies, use mail content as a knowledge base for Q&A.

Phases:

- **Prototype (current target)** — single-user, local, PST-only ingest, no PII anonymization, CLI front-end. Same stack as the acontis ai-support project: Ollama + AnythingLLM + Claude API + direct Python orchestrator.
- **Step 2 (before quality phase)** — PII anonymization at the LLM-call boundary.
- **Quality phase (later)** — distill mails into Q/A pairs (same approach as ai-support strategy), aggressive LLM-based cleaning, OCR + archive expansion for attachments, reranker.
- **Future** — multi-user, optionally user-specific datasets (private mail PSTs etc.), IMAP/Outlook live sources, possibly Outlook add-in.

---

## 2. Resolved Decisions

### 2.1 Scope and Stack

| #   | Decision                                                                                                                                                                                                                                                                                                                                 |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q1  | **Deployment scope:** single user, local, on this Win11 machine. Multi-user / per-user datasets deferred.                                                                                                                                                                                                                                |
| Q2  | **Stack:** same as acontis ai-support — Ollama (local) + AnythingLLM (local RAG) + Claude API (cloud reasoning) + direct Python orchestrator. Treated as a future C2 module candidate of the deployable AI modules platform, but built standalone for now. Stack chosen for extensibility; prototype prioritises a quick working result. |
| Q13 | **Orchestrator:** direct Python (no n8n in prototype). Each pipeline = plain Python module callable from the CLI; later wrappable as HTTP endpoints if n8n is re-introduced.                                                                                                                                                             |

### 2.2 Ingestion

| #   | Decision                                                                                                                                                                                                                                                                                         |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Q3  | **Source priority:** PST only for prototype. Develop against a small test PST first. IMAP and live Outlook deferred.                                                                                                                                                                             |
| Q4  | **PST parsing approach:** Path B — pre-convert PST → `.eml` + extracted attachments via `libpff-tools`/`readpst` (WSL), then ingest from `.eml`. Normalises pipeline for future IMAP/Outlook sources, debuggable, re-indexable without re-parsing PST.                                           |
| Q5  | **Thread handling:** option C — per-mail document with quote stripping (so each mail stands alone) + `thread_id` metadata derived from `Message-ID` / `In-Reply-To` / `References`. Per-thread merging deferred.                                                                                 |
| Q6  | **Noise stripping:** standard heuristic — strip HTML, drop `<blockquote>`, drop reply markers (`____` separators, `From: … Sent: …` blocks), drop common DE/EN legal footers. Reuse + extend the ai-support Python preprocessing script.                                                         |
| Q7  | **Chunking:** option C — header-aware chunks. For each mail, prepend a header block (Subject / From / To / Date / Folder) to each body slice. Slice ~800–1500 chars with ~100 char overlap. Each chunk independently retrievable and always knows its parent mail.                               |
| Q8  | **Attachments:** Tier 2 — extract text from PDF / docx / xlsx / txt / html / nested eml; store binary attachments to disk and index them as separate docs with `parent_message_id` + `attachment_name` metadata; failed/unsupported types still searchable by filename. OCR + archives deferred. |
| Q15 | **Incremental ingest:** content-hash idempotent from day one. Persistent SQLite ingest log keyed by `message_id` + `content_sha256` + `pipeline_version`. Re-run = no-op if nothing changed. Bump `pipeline_version` to invalidate when chunking/cleaning logic changes.                         |

### 2.3 Index schema

| #   | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q9  | **Base metadata fields:** `message_id`, `thread_id`, `subject`, `from_email`, `from_name`, `to_emails[]`, `to_names[]`, `cc_emails[]`, `date_iso`, `date_epoch`, `folder`, `pst_source`, `direction`, `has_attachments`, `attachment_names[]`, `doc_type` (`mail_body`/`attachment_text`), `parent_message_id`, `attachment_name`, `chunk_index`. Outlook categories/labels deferred.                                                                       |
| Q20 | **Direction metadata (4 axes, To and Cc kept separate, Bcc ignored):** sender — `from_is_me`, `from_is_internal`, `from_email`. To recipients — `to_includes_me`, `to_internal_count`, `to_external_count`, `to_emails[]`. Cc recipients (separate, same axes) — `cc_includes_me`, `cc_internal_count`, `cc_external_count`, `cc_emails[]`. `from_is_me` matches `MAIL_OWN_ADDRESSES`; `*_internal_*` matches `MAIL_OWN_DOMAINS`. All addresses lowercased. |

### 2.4 Privacy

| #   | Decision                                                                                                                                                                                                                                                                                                 |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q10 | **PII anonymization:** none in prototype (acceptable risk on small test PST). Step 2 (before quality phase, mandatory before touching real 20 GB business PST) — anonymize only at the LLM-call boundary using Ollama/Presidio to tokenize, then de-tokenize Claude's response. Index stays raw locally. |

### 2.5 Workflow & UI

| #   | Decision                                                                                                                                                                                                                                                                                                                                                                                      |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q11 | **Workflow shape:** option B — per-goal CLI subcommands `mail search`, `mail ask`, `mail draft`. Each has its own prompt template, top-k, and filter parsing. Single-chat (A) and agent-with-tools (C) avoided in prototype.                                                                                                                                                                  |
| Q12 | **UI:** CLI primary (Python + Typer). A simple local web GUI may be added at implementation time for easier human testing — decision deferred to that point. AnythingLLM's chat UI not used; AnythingLLM driven headlessly via API. Outlook add-in much later.                                                                                                                                |
| Q21 | **Search prompt parsing:** option B — a cheap LLM intent parser turns the NL prompt into `{semantic_query, filters}` JSON (fields: `to_emails`, `cc_emails`, `from_email`, `from_is_me`, `from_is_internal`, date range, etc.). Parsed filter is printed alongside results for transparency. Falls back to pure semantic search if no filters extracted.                                      |
| Q22 | **Output formats:** `mail search` — pretty table on stdout (date / from / subject / snippet); JSON via `MAIL_OUTPUT_FORMAT=json`. `mail ask` — Markdown answer + `Sources:` list with msg id, subject, date. `mail draft` — save to `work/drafts/<msg_id>-<timestamp>.md` + print path and body to stdout (no editor open in prototype). `mail ingest` — progress on stderr, stats on stdout. |

### 2.6 Configuration

| #    | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q18  | **Models (config-driven, swappable):** Embeddings = `bge-m3` via Ollama. Reasoning LLM default = `claude-haiku-4-5` (cheap dev) or local `ollama/qwen2.5:7b` for $0 dev. Hero/eval LLM = `claude-sonnet-4-6` (rare: `claude-opus-4-7`). Reranker — none in prototype (`bge-reranker-v2-m3` deferred). Local LLM only for step 2 anonymization (Llama 3.1 8B Q4). Vector store — AnythingLLM default (LanceDB); Qdrant only if scale/filtering demands later. Multi-LLM dispatch via `litellm` Python SDK. |
| Q18b | **Configuration mechanism:** all configuration via `.env` (loaded with `python-dotenv`). No CLI flags. Process env overrides `.env` for ad-hoc switching. Example keys: `MAIL_LLM_MODEL`, `MAIL_EMBED_MODEL`, `MAIL_OLLAMA_URL`, `MAIL_ANTHROPIC_API_KEY`, `ANYTHINGLLM_URL`, `ANYTHINGLLM_API_KEY`, `MAIL_OWN_ADDRESSES`, `MAIL_OWN_DOMAINS`, `PST_PATHS`, `WORK_DIR`, `MAIL_OUTPUT_FORMAT`, `MAIL_LOG_DIR`, `MAIL_LOG_TO_FILE`, `MAIL_LOG_TO_CONSOLE`, `MAIL_LOG_LEVEL`.                                |

### 2.7 Hardware & ops

| #   | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q14 | **Hardware (this box):** Intel i5-13500 (14 cores), 64 GB RAM, integrated UHD 770 (no usable GPU for Ollama), ~360 GB free. Prototype runs entirely on this CPU-only box. Embedding the full 20 GB PST is a long batch job; quality-phase 70 B distillation needs the Mac Mini M2 64 GB (per ai-support spec) or similar — out of scope for prototype.                                                                                                                                                                                                                                                                                                                       |
| Q23 | **Logging:** designed so an AI agent can verify implementation correctness from logs. Per run: one JSONL file under `work/logs/<cmd>-<run_id>.jsonl` (default on, toggleable). Stable stage names + payload schema (`docs/logging_schema.md`). Required content: full query/prompt, parsed filter, retrieved chunk ids + scores + snippets + metadata, full system+user prompt sent to LLM, full LLM response, returned output, run summary (`{run_id, status, stage_durations_ms, retrieved_count, llm_calls, errors[]}`), optional `assertion` events for golden tests. Mail content in logs → sensitive → `work/` gitignored. Console gets brief progress + summary line. |

### 2.8 Acceptance & test data

| #   | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Q16 | **Definition of "prototype done":** all five criteria pass on the small test PST: (1) **Search** — top-5 precision ≥ 60 % on representative prompts, filters work (date range, sender). (2) **Ask** — correct answers with citations on ~10 golden Q&A. (3) **Draft** — coherent reply referencing prior thread + similar past replies on ~5 cases (manual judgement). (4) End-to-end re-ingest of the test PST in < 10 min on this box. (5) Logs/diagnostics let you see which chunks were retrieved and which prompt was sent to Claude. |
| Q17 | **Test PST source:** option C (mix). Day-to-day dev on (A) a real subset exported from your own PST(s), kept under `testdata/real/` (gitignored, off-network, never committed). Plus (B) a tiny synthetic PST checked in under `testdata/synthetic/` for unit tests / CI.                                                                                                                                                                                                                                                                  |

### 2.9 Workflow rules

| #   | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Q24 | **TDD:** every feature implemented test-first. Layers: unit (pure functions, fast), integration-mocked (HTTP fakes for AnythingLLM/Ollama/Claude — default run), integration-live (real services, gated by `MAIL_TEST_LIVE=1`), golden acceptance (synthetic PST + golden Q&A; emits `assertion` events to logs). Default `pytest -q` must pass without live services.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| Q25 | **Acontis coding conventions:** project must follow `C:\PROJ\acontis\acontis-ai\Coding\CodingConventions\Python_Bash\`. Mandatory tooling: `ruff check .`, `ruff format --check .`, `mypy .`, `pytest -q`. Mandatory project files under `plan/`: `ai-mail_implementation_guidelines.md`, `implementation_guardrails.md`, `code_review.md`, `guardrails/python_guardrails.md` (+ `python/` detail modules), `compliance_matrix_template.md`. Per-step plan: `impl_step<N>.md` + `test_step<N>.md`. Workflow gate: code review (`code_review.md`) MUST run before tests; blocking findings stop. PY-MUST rules: type hints on public APIs, explicit imports grouped (stdlib / third-party / local), specific exceptions, context managers, no mutable defaults, focused functions, docstrings for non-obvious behaviour, actionable TODOs. Output conventions: diagnostics → stderr, machine-readable → stdout/file, exit codes 0/1/2. Each change records a compliance matrix with evidence per `PY-MUST-*`. |

### 2.10 Repository layout

```
ai-mail/
  .env.example  .gitignore  pyproject.toml
  requirements.txt  requirements-dev.txt
  README.md  ai-mail.code-workspace
  venv_install.{ps1,bat}  venv_activate.{ps1,bat}  venv_deactivate.{ps1,bat}

  ai_mail/                       # Python package, flat under root (mirrors kerio_mail)
    __init__.py  cli.py  config.py
    ingest/  pipelines/  llm/  rag/  util/

  plan/
    ai-mail_specification.md     # this document
    ai-mail_implementation_plan.md
    ai-mail_implementation_guidelines.md
    implementation_guardrails.md
    code_review.md
    guardrails/
      python_guardrails.md
      python/...                  # detail modules
      compliance_matrix_template.md
    impl_step1.md  impl_step2.md  ...
    test_main.md   test_step1.md  ...
    progress/  reviews/

  tests/
    run_all_tests.py
    test_step1.py  ...
    unit/  integration/  golden/

  work/                          # gitignored: extracted eml, attachments, sqlite ingest log, logs, drafts
  testdata/synthetic/            # tiny synthetic PST + golden Q&A (committed)
  testdata/real/                 # real PST subset (gitignored)
```

Conventions: Python 3.12. `.venv` via `py -3.12 -m venv .venv`. Venv scripts mirror `c:\PROJ\acontis\acontis-ai\Tools\kerio_mail` and `c:\PROJ\acontis\acontis-ai\Tools\marker`.

---

## 3. Open Branches (resume grilling here)

Smaller branches not yet resolved:

- **Implementation order under TDD** — which feature first; mapping to `impl_step<N>.md`.
- **Date / timezone handling** — UTC vs local in storage; how the LLM filter parser handles "last quarter" / "letztes Quartal".
- **Failure handling** — corrupted `.eml`, failed attachment parses, missing references; do they block ingest, get logged-and-skipped, or land in a quarantine folder?
- **AnythingLLM workspace strategy** — single workspace vs one per goal vs one per source.
- **Ingest concurrency** — parallel parsing/embedding given CPU-only Ollama and 14-core CPU.
- **Existing artefact** — review `c:\PROJ\ai-mail\outlook-RAG\email_vector_db_pipeline.md` for prior thinking that should be folded in or explicitly superseded.

---

## 4. Backlog

- **P1 — Optional simple local web GUI** for human testing.
- **Step 2 (before quality phase) — PII anonymization** at the LLM-call boundary (Ollama/Presidio tokenize ↔ de-tokenize).
- **Quality phase — distill mails into Q/A pairs** (same approach as ai-support strategy; route 70 B distillation to Mac Mini M2 if available).
- **Quality phase — LLM-aggressive cleaning** of mail body.
- **Quality phase — OCR + archive expansion** for attachments.
- **Quality phase — reranker** (`bge-reranker-v2-m3`) if retrieval quality demands.

---

## Revision History

| Date       | Change                                                                                                      |
| ---------- | ----------------------------------------------------------------------------------------------------------- |
| 2026-05-08 | Initial snapshot from grilling session — 25 branches resolved (Q1–Q25); 6 smaller branches still open (§3). |
