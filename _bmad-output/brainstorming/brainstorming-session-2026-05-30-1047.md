---
stepsCompleted: [1, 2, 3]
inputDocuments: ['plan/painlist_acontis.md', 'plan/painlist_private.md']
session_topic: 'Best next module to start coding — useful & fun, needed whatever acontis decides is most important'
session_goals: 'Shortlist of candidate starter modules grounded in the two painlist files; reusable sub-modules / evaluation prototypes; strict Pareto'
selected_approach: 'ai-recommended'
techniques_used: ['First Principles Thinking', 'Morphological Analysis', 'Resource Constraints']
ideas_generated: ['29 primitives (F01-F29)', '6 capabilities (M1-M6)', 'Reach scoring model', 'Decision: build M2 first']
decision: 'Start with M2 · Attachment Auto-Router (functions F01-F04, F22, F06)'
technique_execution_complete: true
context_file: ''
---

# Brainstorming Session Results

**Facilitator:** Stefan
**Date:** 2026-05-30

## Session Overview

**Topic:** What's the best possible *next step* — a module worth building now that will be needed no matter which pain point acontis ultimately decides is most important?

**Goals:** Leave with a shortlist of candidate starter modules to begin coding — useful and fun, grounded in the two painlist files. Outputs may be reusable sub-modules or evaluation prototypes.

**Guardrails:** Spare-time, unpaid, fun-first; quick results that can be enhanced; strict Pareto (minimum work, maximum result); final solution shape undefined.

### Context Guidance

- **acontis painlist** — 4 roles (Inside Sales, Pre-Sales Engineer, Management, Order Processing) + cross-cutting Attachments/Documents. Per-role 🔥 priorities still pending acontis's decision.
- **Private painlist** — 3 themes with 🔥 priorities marked: (1) attachments → right Google Drive folder, (2) manual archiving after reading, (3) rescuing important mail from trash. Cross-cutting: sender/document-type pattern recognition, auto-vs-manual decision boundary.

## Technique Selection

**Approach:** AI-Recommended Techniques

**3-Phase Flow:**
1. **First Principles Thinking** (deep) → decompose every pain into atomic capabilities (primitives). Output: deduplicated vocabulary of reusable verbs.
2. **Morphological Analysis** (deep) → grid of pains × candidate sub-modules across both painlists. Output: candidate sub-modules ranked by cross-cutting frequency.
3. **Resource Constraints** (structured) → "three fun evenings only" squeeze. Output: ranked shortlist of starter modules honoring Pareto + fun guardrails.

**AI Rationale:** The module "needed whatever acontis decides" is the primitive that reappears when unrelated pains are decomposed to equal granularity. Decompose → cross-map to surface reuse winners → constrain to enforce Pareto/fun.

## Technique Execution — Phase 1: First Principles Thinking

**Outcome:** 28 deduplicated atomic primitives, grouped into 7 layers. These are the reusable "verbs" beneath the pains; recurrence across unrelated pains is the signal for "needed whatever acontis decides."

### Namespaces (ubiquitous language)
- **A## / P##** = pains (acontis / private) — stable global IDs, canonical in the painlist files.
- **F01–F29** = primitives (headless, reusable software modules / "functions") — *renamed from earlier P1–P29 to avoid collision with private pain IDs*.
- **M1–M6** = capabilities (user-facing application modules, composed of primitives, sharing primitives).
- **Product** = deployable bundle of capabilities (out of scope for now).

### Primitive Vocabulary (deduplicated)

**Layer 1 — I/O & provenance**
- **F01 detect-attachment** — notice a mail carries attachment(s)
- **F02 extract-attachment** — pull a file out as a standalone object
- **F22 write-to-external-system(target)** — push a result (file/fields/mail) into Drive / ERP / Pipedrive *(merged old F05 write-to-store)*
- **F06 record-provenance** — remember "this came from that mail" for later findability

**Layer 2 — Understanding & classification**
- **F03 classify-attachment-type** — what kind of *file* (invoice/contract/photo…)
- **F17 classify-mail-type** — what kind of *mail* (intent/sender/purpose); *falls back to F03 when body intent is low-confidence*
- **F18 parse-structured-fields** — extract typed data (qty/SKU/price/VAT-ID/address)
- **F07 understand-query** — turn a question into a searchable intent

**Layer 3 — Retrieval & knowledge**
- **F08 retrieve-similar** — semantically find past mails/passages; *indexes attachment contents (default-on toggle)*
- **F09 rank-relevance** — order candidates by how well they answer
- **F10 extract-passage** — pull one answer span from one thread
- **F11 check-freshness** — flag whether an answer may be stale
- **F12 synthesize-answer** — combine scattered facts from many mails into one answer

**Layer 4 — Decision & automation engine**
- **F04 derive-target-location** — decide where an item belongs
- **F13 decide-action** — choose what to do (archive/delete/keep/route/escalate)
- **F14 match-rule** — test a mail against a known sender/type rule
- **F15 learn-rule** — induce a rule from repeated human decisions (core of "Mustererkennung")
- **F16 request-confirmation** — surface borderline cases for human judgment (auto-vs-manual boundary)

**Layer 5 — Comparison & validation**
- **F19 reconcile-against-reference** — compare two things for discrepancy (order↔quote, promise↔delivery, forecast↔activity)
- **F20 detect-missing-fields** — spot required data that's absent → must chase

**Layer 6 — Generation** *(automation-trust tiered)*
- **F21 generate-artifact** — deterministic, verifiable output (license key, status line); fully automatable, no LLM
- **F23 summarize-thread** — condense a thread into N bullets
- **F24 draft-reply** — generative prose; review-gated, LLM
- **F25 adapt-to-recipient** — rewrite a found answer for this customer/tone

**Layer 7 — Monitoring & time**
- **F26 track-open-loop** — which threads await a reply/action, and for how long
- **F27 surface-due** — raise something when a time condition hits (renewal, overdue follow-up)
- **F28 detect-anomaly** — spot deviation (silence on key account, changing tone, complaint)
- **F29 aggregate-metric** — roll up numbers across mail (response time, topic trends)

### Reusable design decisions captured
- F08 retrieve-similar indexes attachment contents, exposed as a default-on toggle (GUI/param/flag).
- F17 classify-mail-type → confidence-driven escalation to F03 classify-attachment-type when body is ambiguous.
- Generation primitives split by automation-trust tier: F21 (fire-and-forget, testable) vs F24 (review-gated).

### Early cross-cutting signals
- **Retrieval cluster (F07–F12)** appears in BOTH private (P11–P13) and work (A03, A06, A08, A11, A12, A17) — strongest "needed whatever acontis decides" candidate.
- **Decision engine (F14–F16)** serves private archiving (P04) + trash-triage (P08, P09) + acontis sales-mail auto-sort (A01) + private patterns (P14–P16).
- **Reconcile (F19)** quietly underlies order-check (A26) + forecast plausibility (A23) + compliance (A20).

## Technique Execution — Phase 2: Morphological Analysis

**Target layer decision:** Build **a user-facing capability (a thin demoable vertical slice)** — chosen for *quick visible results + fun*, and explicitly **as a tracer bullet to validate whether the underlying primitives are designed/defined correctly.** Scoring criterion added for Phase 3: a winning capability must exercise enough primitives to prove the design.

### Candidate Capabilities (clusters of primitives)

| Capability | Primitives | Purpose |
|---|---|---|
| **M1 · Semantic Mail Q&A** | F07 F08 F09 F10 F11 F12 (+F06) | ask a question → answer synthesized from the archive (incl. attachments) |
| **M2 · Attachment Auto-Router** | F01 F02 F03 F04 F22 (+F06) | extract a file, classify it, decide where, file it |
| **M3 · Mail Triage Engine** | F17 F13 F14 F15 F16 (+F04) | classify a mail, decide the action, learn the rule, ask when unsure |
| **M4 · Document Data Extractor** | F18 F19 F20 (+F02 F03) | parse structured docs, reconcile vs reference, flag missing fields |
| **M5 · Drafting Assistant** | F21 F23 F24 F25 | summarize, draft, adapt, generate outgoing content |
| **M6 · Watchtower** | F26 F27 F28 F29 | track open loops, surface due items, detect anomalies, roll up metrics |

**Shared substrate:** F06 record-provenance, F22 write-to-external-system, classify-* (F03/F17) — used by several capabilities; candidate tiny foundation layer.

### Reach (🔥-only, weighted)

**Formula:** Reach = (Σ private 🔥 pains × 2) + (Σ acontis 🔥 pains × 1/[🔥-count in role]). Only pains listed in a "Wichtigster Punkt" section participate. ■ primary = full weight, □ supporting = ×0.5.

**Qualifying 🔥 pains & weights:**
- Acontis: A01 (0.5), A02 (0.5), A11 (1.0), A17 (0.333), A18 (0.333), A19 (0.333). *(Role 4 + X-cut Attachments have no 🔥 yet → excluded.)*
- Private (×2): P01 (2.0), P02 (2.0), P04 (2.0), P08 (2.0), P11 (2.0).

**Pain → capability mapping:**
| Pain (weight) | ■ primary | □ support |
|---|---|---|
| A01 (0.5) auto-sort | M3 | — |
| A02 (0.5) drafting | M5 | M1 |
| A11 (1.0) tech-fact | M1 | — |
| A17 (0.333) briefing | M1 | M5 |
| A18 (0.333) critical-deals | M6 | — |
| A19 (0.333) response-time | M6 | — |
| P01 (2.0) →Drive folder | M2 | — |
| P02 (2.0) target-folder | M2 | — |
| P04 (2.0) archive-after-read | M3 | — |
| P08 (2.0) rescue-important | M3 | M1 |
| P11 (2.0) topic-search | M1 | — |

**Recomputed Reach:**
| Capability | ■ contributions | □ contributions | **Reach** |
|---|---|---|---|
| **M1 · Semantic Mail Q&A** | A11 1.0 + A17 0.333 + P11 2.0 = 3.333 | A02 0.25 + P08 1.0 = 1.25 | **4.58** |
| **M3 · Mail Triage Engine** | A01 0.5 + P04 2.0 + P08 2.0 = 4.5 | — | **4.50** |
| **M2 · Attachment Auto-Router** | P01 2.0 + P02 2.0 = 4.0 | — | **4.00** |
| **M5 · Drafting Assistant** | A02 0.5 | A17 0.167 | **0.67** |
| **M6 · Watchtower** | A18 0.333 + A19 0.333 = 0.667 | — | **0.67** |
| **M4 · Document Data Extractor** | — | — | **0.00** |

**Result:** The 2× private weighting + 🔥-only filter pulls **M1, M3, M2 into a near three-way tie (4.58 / 4.50 / 4.00)** — all three are dogfoodable on Stefan's own mailbox. M4/M5/M6 fall away (work-only, and their pains aren't 🔥-marked yet). Finalists for Phase 3: **M1, M3, M2.**

*Caveat: Role 4 and both X-cut 🔥 markers are still empty; filling them would lift M4 (order) and M2/M1 (attachments) respectively.*

## Technique Execution — Phase 3: Resource Constraints (Pareto squeeze)

Constraint applied: *"three fun evenings — which one capability ships, running on the private mailbox?"* Full finalist comparison table and function-level breakdown persisted in [plan/00-foundation.md](../../plan/00-foundation.md).

**Finalists scored:** M2 (effort 🟢 / risk 🟢 / fun 🟡 / tracer 🟡-substrate), M3 (effort 🟡 / risk 🔴 destructive / tracer 🟢), M1 (effort 🔴 index / fun 🟢 magic / tracer 🟢).

### 🏆 Decision: Start with **M2 · Attachment Auto-Router**

**Functions to build:** F01 detect-attachment · F02 extract-attachment · F03 classify-attachment-type · F04 derive-target-location · F22 write-to-external-system · F06 record-provenance.

**Why M2 won the squeeze:**
- Only finalist that genuinely **ships within three evenings** (M1's index is too heavy; M3 acts destructively and needs a trust/confirmation layer first).
- **Non-destructive** — files a copy, lowest risk for a first build.
- Scratches Stefan's **confirmed 🔥 private pains P01/P02** ("häufig und lästig") → fast dogfooding on his own Google Drive.
- **Tracer-bullet payoff:** implements the shared substrate (F01–F04 + F22 + F06) that M1, M3, M4 later reuse → validates the most-shared interfaces early and makes the next capabilities cheaper.

**Carry-forward design notes for M2:**
- F08-style attachment indexing is *not* needed yet, but F03/F06 should be designed so M1 can later reuse them.
- F22 write-to-external-system(target) interface should be generic from day one (Drive now; ERP/Pipedrive later).
- F17 classify-mail-type fallback pattern doesn't apply yet, but F03 classify-attachment-type is the seed of it.


