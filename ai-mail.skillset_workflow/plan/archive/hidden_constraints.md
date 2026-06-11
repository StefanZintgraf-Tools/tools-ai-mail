# Hidden-Constraint Sweep — M2 · Attachment Auto-Router

**Artifact swept:** `docs/entity_model.md` (Conceptual domain model, M2)
**Context source:** `docs/CONTEXT.md` (glossary named in the model header)
**Date:** 2026-06-05
**Sweep verdict:** **blocked** — 4 of 8 classes `missing`
**Rev11 mapping:** **block** (a hard-safety class — Security/PII — is among the missing)

This file records the 8-class hidden-constraint sweep, a suggested way to handle
each gap, and a **recommendation of where each fix belongs** so a human can sign
off. The sweep itself writes nothing into the model — acting on these follow-ups
is a separate step (`domain-model` for the Constraints-note invariants,
`pareto-scope-cut` for any formal deferral, the use-case spec / an ADR for
physical-form decisions).

> **A note on "M2 vs M2b".** M2b is a *specific* deferred scope: **Document Type**
> and **Naming Scheme** (ADR-0003). None of the gaps below are M2b features. The
> real choice for each is **"state the decision/invariant now in M2"** (usually a
> cheap Constraints note, because the behaviour is already happening) **vs "defer
> the heavier mechanism"** (automated retention, rich metrics, real locking) to a
> later iteration or an NFR. The recommendation column uses those buckets, not a
> forced M2/M2b split.

---

## 1. Missing findings

Only the `missing` classes are recorded here; the four passing classes
(2·Permissions `covered`, 4·Migrations `not-applicable`, 6·Public-API
`not-applicable`, 8·Out-of-scope `covered`) are omitted. Original class numbers
are kept for traceability to the 8-class sweep.

| # | Class | Verdict | Pointer / Reason / Follow-up |
|---|-------|---------|------------------------------|
| 1 | Security / PII | **missing** | PII is captured and persisted (SENDER = From address; PROVENANCE_LEDGER maps sender→filed-document-location; PROVENANCE_BACK_LINK stamps Message-ID/date/Sender on every filed copy) but no entity carries a "this is sensitive personal data" invariant. The ledger is described as an *external greppable* artifact — a plaintext index of who-sent-what-filed-where — with no siting/access invariant. |
| 3 | Data retention | **missing** | No lifecycle for STAGING_AREA (`_review/`); no keep/discard rule for ACTION_PLAN per-run files; PROVENANCE_LEDGER says "Append-only" but never states "never purged" as a decision. |
| 5 | Observability | **missing** | `ATTACHMENT ‖--‖ PROPOSAL` (exactly one) leaves no representation of a processing failure, and there is no per-run outcome tally (filed / staged / conflicted / errored). A headless filing pipeline needs this to be operable and trustworthy. |
| 7 | Concurrency | **missing** | Re-run idempotency is defined *only for filed copies* (content-hash dedup, NFR-002). Two gaps remain: (a) the "Append-only" ledger has no single-writer rule for concurrent runs; (b) staged-but-unfiled Attachments aren't in the ledger, so a re-run re-proposes/re-stages them. |

---

## 2. The four gaps — detail, handling, and recommendation

### Gap 1 — Security / PII  *(hard-safety class)*

**What's missing.** The model stores real personal data — sender email
addresses (SENDER), mail subjects/dates, content fingerprints, and a
PROVENANCE_LEDGER that is effectively a *plaintext index of who sent what and
where it was filed* — but never classifies any of it as sensitive or constrains
where it may live. Separately, reading the mailbox requires **credentials**
(C-006/C-007 leave mail-access TBD), an unmodeled secret.

**Why it matters.** The ledger and the PROVENANCE_BACK_LINK travel *with* filed
copies into Target Locations the User may later sync to the cloud. An unprotected
sender→document map is a meaningful privacy exposure even for a single-user
system.

**Suggested handling.**
1. Add a **Constraints note** classifying PROVENANCE_LEDGER and
   PROVENANCE_BACK_LINK as **PII-bearing, owner-private**. *(cheap, doc-only)*
2. Add an invariant that — per ADR-0001's deferral of physical form — the
   **use-case spec must site the ledger outside any cloud-synced / shared path**.
3. Resolve **mail-access credential handling** in the use-case spec (where do
   IMAP/Graph secrets live? OS keychain? env? never in the ledger/plan).

**Recommendation:**
- Items (1) is a free Constraints note → **do in M2 now** (`domain-model`).
- Item (2) is already an ADR-0001 deferral → **M2 use-case spec** (not M2b).
- Item (3) is unavoidable in M2 (you cannot read mail without it) → **M2
  use-case spec / implementation**, possibly a new ADR.
- **None of this is M2b.** Credential handling especially must not be deferred —
  M2 cannot run without it.

**Human decision:**
- [x] Accept invariant (1) into the model now — PII-bearing/owner-private Constraints notes on PROVENANCE_LEDGER & PROVENANCE_BACK_LINK + **C-012** (2026-06-05)
- [x] Confirm ledger-siting (2) is a use-case-spec obligation — **NFR-007** (testable siting check) + C-012; use-case spec fixes the concrete location (2026-06-05)
- [x] Confirm credential handling (3) is resolved in M2 (spec/ADR), not deferred — **ADR-0005 (proposed)** + **NFR-006** + **C-011** (2026-06-05)

---

### Gap 3 — Data retention

**What's missing.** Three accumulating artifacts have no stated lifecycle:
- **STAGING_AREA (`_review/`)** — who drains it, and what happens to a
  staged-but-never-filed Attachment on the next run? (overlaps Gap 7)
- **ACTION_PLAN** per-run files — kept as an audit trail, or discarded?
- **PROVENANCE_LEDGER** — "Append-only" is stated, but "never purged" is not
  recorded as a deliberate retention *decision*.

**Why it matters.** Without a stance, `_review/` grows unboundedly and the User
has no documented expectation of what is safe to delete.

**Suggested handling.** State the **v1 stances** as Constraints notes — these
are decisions, not mechanisms:
- "`_review/` is **manually managed by the User**; M2 never auto-deletes from it."
- "Action Plans are **retained** per run as the plan/apply audit trail."
- "The ledger is **append-only and never purged** in v1."

Defer any *automated* retention (TTL on `_review/`, plan rotation/GC) to a later
iteration or an NFR.

**Recommendation:**
- Stating the three v1 stances → **M2 now** (cheap Constraints notes;
  `domain-model`). They cost nothing and remove ambiguity.
- Automated retention/TTL mechanism → **defer** (later iteration / NFR), via
  `pareto-scope-cut` if you want it logged as a postponed decision.

**Human decision:**
- [x] Adopt the three v1 retention stances into the model now — **C-013** + Retention (v1) Constraints notes on STAGING_AREA, ACTION_PLAN, PROVENANCE_LEDGER (2026-06-05)
- [x] Confirm automated retention/GC is deferred — Postponed decision logged under C-013 in `requirements.md` (2026-06-05)

---

### Gap 5 — Observability

**What's missing.** Because every Attachment maps to *exactly one* Proposal, an
Attachment that **fails to process** (can't be hashed/parsed/copied) has nowhere
to land — risking a **silent drop**. There is also no per-run outcome summary
(counts of filed / staged / conflicted / errored).

**Why it matters.** A headless pipeline that files people's documents must never
silently lose one, and the User needs to see what a run did without grepping the
ledger.

**Suggested handling.** Split into a *trust* guarantee and a *richness* layer:
1. **No-silent-drop guarantee** — model an explicit outcome for an Attachment
   that errors (e.g. it routes to the Staging Area as an "errored" outcome, or a
   Proposal may carry a failure state). Surface it in the Action Plan.
2. **Run summary / metrics** — counts and structured logs for operability.

**Recommendation:**
- (1) the no-silent-drop guarantee is a **correctness/trust** property →
  **do in M2** (Constraints note or a small outcome state). Cheap and important.
- (2) richer metrics/structured logging → **defer** to a later iteration or
  capture as an **NFR**, not a domain invariant. *Not M2b.*

**Human decision:**
- [x] Adopt the no-silent-drop outcome invariant into M2 — **C-014** (terminal outcome: filed/staged/conflicted/errored; errored routes to Staging Area, surfaced in Action Plan) + Constraints notes on ATTACHMENT, STAGING_AREA, ACTION_PLAN (2026-06-05)
- [x] Confirm rich run-metrics are deferred / handled as an NFR — plain per-run outcome tally adopted as **NFR-008**; richer structured logging/metrics logged as a Postponed decision under NFR-008 in `requirements.md` (2026-06-05)

---

### Gap 7 — Concurrency

**What's missing.** Idempotency is guaranteed only for **filed copies**
(content-hash dedup, NFR-002). Two behavioural questions are unanswered:
- **(a) Concurrent runs** — the "Append-only" ledger has no single-writer or
  serialization rule; a scheduled run overlapping a manual one can interleave
  appends.
- **(b) Staging idempotency** — a staged-but-unfiled Attachment is *not* in the
  ledger, so dedup doesn't cover it; a re-run re-proposes and re-stages it.

**Why it matters.** Both change observable behaviour *now*, in M2 — they are not
hypothetical. (b) in particular interacts with Gap 3's `_review/` lifecycle.

**Suggested handling.** Decide the **v1 stance** (cheap) and defer the hardened
mechanism:
- (a) State "runs are **single-writer**; M2 does not support concurrent runs in
  v1" as a Constraints note/assumption. Real file-locking → defer.
- (b) Decide and record staging idempotency: either "re-staging an unfiled
  Attachment is **idempotent** (content-hash-named write, harmless overwrite)" or
  "staged items are **recorded** so they are not re-proposed." Pick one in M2.

**Recommendation:**
- Stating the single-writer assumption (a) and the staging-idempotency decision
  (b) → **M2 now** — they are behavioural and must be settled to make M2
  deterministic. *Not M2b.*
- Implementing real locking / multi-run support → **defer** (later iteration),
  logged via `pareto-scope-cut`.

**Human decision:**
- [x] Adopt the single-writer (a) and staging-idempotency (b) stances into M2 — **C-015** (single-writer runs; staging is content-hash-addressed → idempotent re-stage, Attachment re-proposed each run until `_review/` drained) + Constraints notes on PROVENANCE_LEDGER (single-writer) & STAGING_AREA (re-stage idempotency); staging idempotency also folded into **NFR-002**. Chose **idempotent re-stage** over recording staged items — cheapest stance, no ledger/entity change, mirrors content-hash dedup (2026-06-05)
- [x] Confirm real locking / concurrent-run support is deferred — Postponed decision logged under C-015 in `requirements.md` (2026-06-05)

---

## 3. Decision summary (for sign-off)

| # | Gap | Recommended bucket | Cost if done now | M2b? |
|---|-----|--------------------|------------------|------|
| 1 | Security/PII — classify ledger/back-link as PII; site outside synced paths; handle credentials | **M2** (invariant now; siting + creds → use-case spec/ADR) | Low (doc) + unavoidable creds work | No |
| 3 | Retention — state `_review/`, Action Plan, ledger v1 stances | **M2** (state decisions); automated GC **deferred** | Low (doc) | No |
| 5 | Observability — no-silent-drop guarantee; run metrics | **M2** for no-silent-drop; metrics **deferred/NFR** | Low–Med | No |
| 7 | Concurrency — single-writer + staging idempotency stance | **M2** (state stance); real locking **deferred** | Low (doc) | No |

**Headline for the human:** every gap has a **cheap "state the decision now"
part that belongs in M2** (mostly Constraints notes, because the behaviour is
already occurring) and a **heavier mechanism that can be deferred** (automated
retention, rich metrics, real file-locking). The only unavoidable *engineering*
work that M2 cannot skip is **mail-access credential handling** (Gap 1, item 3) —
M2 cannot read the mailbox without it. **No gap maps to M2b**, whose scope is
strictly Document Type + Naming Scheme.

---

## 4. Next actions (once decisions are made)

1. `domain-model` — add the approved Constraints-note invariants to
   `docs/entity_model.md` (Gaps 1·1, 3, 5·1, 7).
2. Use-case spec / ADR — ledger siting and mail-access credentials (Gap 1·2, 1·3).
3. `pareto-scope-cut` — record the deferred mechanisms (automated retention,
   rich metrics, real locking) as postponed decisions.
4. Re-run `hidden-constraint-sweep docs/entity_model.md` to confirm a **clean**
   verdict.
