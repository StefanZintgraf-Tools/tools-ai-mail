# Capability ↔ Pain Coverage Matrix

**Date:** 2026-05-30 (amended 2026-06-01)
**Source:** Brainstorming sessions `_bmad-output/brainstorming/brainstorming-session-2026-05-30-1047.md`, `_bmad-output/brainstorming/brainstorming-session-2026-06-01-1213.md`
**References:** pains from [painlist_acontis.md](painlist_acontis.md) (`A01`–`A36`) and [painlist_private.md](painlist_private.md) (`P01`–`P16`).

## Contents

- [Namespaces](#namespaces)
- [Candidate Capabilities](#candidate-capabilities)
- [Function Catalog (Primitives)](#function-catalog-primitives)
- [Per-Module Function Breakdown](#per-module-function-breakdown)
- [Reuse Hotspots](#reuse-hotspots-substrate-to-design-carefully-first)
- [Full Coverage Matrix](#full-coverage-matrix-all-pains)
- [Reach (🔥-only, weighted)](#reach--only-weighted)
- [Phase 3 — Resource-Constraints Squeeze](#phase-3--resource-constraints-squeeze-finalist-comparison)

## Namespaces
- **A## / P##** — pains (acontis / private), stable global IDs.
- **F01–F31** — primitives (headless reusable software modules / "functions").
- **M1–M6, M2b** — capabilities (user-facing application modules, composed of and sharing primitives).

## Candidate Capabilities

| Capability | Primitives | Purpose |
|---|---|---|
| **M1 · Semantic Mail Q&A** | F07 F08 F09 F10 F11 F12 (+F06) | ask a question → answer synthesized from the archive (incl. attachments) |
| **M2 · Attachment Auto-Router** | F01 F02 F03 F04 F22 (+F06) | extract a file, classify it, decide where, file it |
| **M2b · Intelligent Auto-Router** | F30 F31 F32 (+F01–F04 F22 F06) | extends M2: LLM-assisted routing for unknown senders/destinations, sender→location knowledge base, and folder-naming-scheme inference for suggested filenames |
| **M3 · Mail Triage Engine** | F17 F13 F14 F15 F16 (+F04) | classify a mail, decide the action, learn the rule, ask when unsure |
| **M4 · Document Data Extractor** | F18 F19 F20 (+F02 F03) | parse structured docs, reconcile vs reference, flag missing fields |
| **M5 · Drafting Assistant** | F21 F23 F24 F25 | summarize, draft, adapt, generate outgoing content |
| **M6 · Watchtower** | F26 F27 F28 F29 | track open loops, surface due items, detect anomalies, roll up metrics |

## Function Catalog (Primitives)

- **F01–F31** = *primitives* = independent, reusable software modules ("functions"): headless, well-defined interface, individually testable.
- A primitive may be used by several capabilities — that reuse is the whole point. The **Used by** column makes the sharing explicit.
- **Status** tracks implementation: ☐ not started · ◐ in progress · ☑ done. (All ☐ today.)

### Layer 1 — I/O & provenance
| ID | Function | Contract (rough) | Used by | Status |
|---|---|---|---|---|
| **F01** | detect-attachment | mail → bool / list of attachment refs | M2, M2b | ☐ |
| **F02** | extract-attachment | mail + ref → standalone file object | M2, M2b, M4 | ☐ |
| **F22** | write-to-external-system(target) | object + target → persisted (local/network folder / ERP / Pipedrive / mail action) | M2, M2b, M3, M4 | ☐ |
| **F06** | record-provenance | object + origin → provenance link (for findability/citation) | M1, M2, M2b *(substrate: all)* | ☐ |

### Layer 2 — Understanding & classification
| ID | Function | Contract (rough) | Used by | Status |
|---|---|---|---|---|
| **F03** | classify-attachment-type | file → type (invoice/contract/photo/log…) | M2, M2b, M4 | ☐ |
| **F17** | classify-mail-type | mail → type/intent; *falls back to F03 when body intent low-confidence* | M3 | ☐ |
| **F18** | parse-structured-fields | doc → typed fields (qty/SKU/price/VAT-ID/address) | M4 | ☐ |
| **F07** | understand-query | NL question → searchable intent | M1 | ☐ |

### Layer 3 — Retrieval & knowledge
| ID | Function | Contract (rough) | Used by | Status |
|---|---|---|---|---|
| **F08** | retrieve-similar | intent → candidate mails/passages; *indexes attachment contents (default-on toggle)* | M1 | ☐ |
| **F09** | rank-relevance | candidates → ordered by answer quality | M1 | ☐ |
| **F10** | extract-passage | one thread → the one answer span | M1 | ☐ |
| **F11** | check-freshness | answer → stale? (prices/terms changed) | M1 | ☐ |
| **F12** | synthesize-answer | many mails → one combined answer | M1 | ☐ |

### Layer 4 — Decision & automation engine
| ID | Function | Contract (rough) | Used by | Status |
|---|---|---|---|---|
| **F04** | derive-target-location | item context → destination (folder/store) | M2, M2b, M3 | ☐ |
| **F13** | decide-action | mail → action (archive/delete/keep/route/escalate) | M3 | ☐ |
| **F14** | match-rule | mail → matching sender/type rule (or none) | M3 | ☐ |
| **F15** | learn-rule | repeated human decisions → induced rule | M3 | ☐ |
| **F16** | request-confirmation | low-confidence case → human prompt → decision | M3 | ☐ |
| **F30** | maintain-sender-map | read/write the sender→location knowledge base | M2b | ☐ |
| **F31** | infer-target-location | LLM-based folder inference for unknown senders/types | M2b | ☐ |
| **F32** | infer-filename | LLM-based filename suggestion from a target folder's naming scheme (sibling of F31) | M2b | ☐ |

### Layer 5 — Comparison & validation
| ID | Function | Contract (rough) | Used by | Status |
|---|---|---|---|---|
| **F19** | reconcile-against-reference | A + B → discrepancies (order↔quote, promise↔delivery) | M4 | ☐ |
| **F20** | detect-missing-fields | doc + schema → list of absent required fields | M4 | ☐ |

### Layer 6 — Generation *(automation-trust tiered)*
| ID | Function | Contract (rough) | Used by | Status |
|---|---|---|---|---|
| **F21** | generate-artifact | data/rules → deterministic output (license key, status line); no LLM, fully automatable | M5 | ☐ |
| **F23** | summarize-thread | thread → N bullets | M5 *(also M1 briefing)* | ☐ |
| **F24** | draft-reply | context → prose reply; review-gated, LLM | M5 | ☐ |
| **F25** | adapt-to-recipient | answer + recipient → re-toned answer | M5 | ☐ |

### Layer 7 — Monitoring & time
| ID | Function | Contract (rough) | Used by | Status |
|---|---|---|---|---|
| **F26** | track-open-loop | mailbox → threads awaiting reply/action + age | M6 | ☐ |
| **F27** | surface-due | items + time conditions → due alerts (renewals, overdue) | M6 | ☐ |
| **F28** | detect-anomaly | account history → deviations (silence, tone, complaint) | M6 | ☐ |
| **F29** | aggregate-metric | mail set → rolled-up numbers (response time, topic trends) | M6 | ☐ |

## Per-Module Function Breakdown

Each module lists its **core** functions and the **shared substrate** it borrows (functions also used by other modules). Pipeline shows the typical call flow.

### M1 · Semantic Mail Q&A — *ask a question, get an answer from the archive*
**Pipeline:** `F07 understand-query → F08 retrieve-similar → F09 rank-relevance → (F10 extract-passage | F12 synthesize-answer) → F11 check-freshness`
| Role | Functions |
|---|---|
| Core | F07, F08, F09, F10, F11, F12 |
| Shared substrate | F06 record-provenance (cite sources) |
| Notes | Heaviest module: needs an index over the mailbox + attachment text. F08 toggle decides attachment inclusion. |

### M2 · Attachment Auto-Router — *file an attachment into the right place*
**Pipeline:** `F01 detect-attachment → F02 extract-attachment → F03 classify-attachment-type → F04 derive-target-location → F22 write-to-external-system` (F06 throughout)
| Role | Functions |
|---|---|
| Core | F01, F02, F03 |
| Shared substrate | F04 derive-target-location (with M2b/M3), F22 write-to-external-system (with M2b/M3/M4), F06 record-provenance |
| Notes | Lowest effort; non-destructive (files a copy). Establishes substrate F22/F06/F03/F04 reused by M1, M2b, M3, M4. |

### M2b · Intelligent Auto-Router — *LLM-assisted routing for unknown destinations*
**Pipeline:** `F01 detect-attachment → F02 extract-attachment → F03 classify-attachment-type → F04 derive-target-location → [if low-confidence] F30 maintain-sender-map → F31 infer-target-location → F32 infer-filename → F22 write-to-external-system` (F06 throughout)
| Role | Functions |
|---|---|
| Core | F30, F31, F32 |
| Shared substrate | F01, F02, F03, F04 (with M2), F22 write-to-external-system (with M2/M3/M4), F06 record-provenance |
| Notes | Depends on M2's substrate. Activates only when F04 confidence falls below threshold. User corrections feed back into the sender→location mapping. Folder *creation* (not just routing) is in scope. **F32 infers a suggested Target Filename** from the target folder's naming scheme (M2 supports only manual rename via the editable Action Plan). Local/network folder is the v1 write target. Status: ☐ not started — M2 must ship first. |

### M3 · Mail Triage Engine — *classify a mail, decide & do the action, learn the rule*
**Pipeline:** `F17 classify-mail-type → F14 match-rule → F13 decide-action → (F04 derive-target-location) → F22 write` · `F16 request-confirmation` on low confidence · `F15 learn-rule` from corrections
| Role | Functions |
|---|---|
| Core | F17, F13, F14, F15, F16 |
| Shared substrate | F04 derive-target-location (with M2/M2b), F22 write-to-external-system (with M2/M2b/M4) |
| Notes | Acts destructively on real mail → F16 confirmation layer is mandatory before trust. F15 learn-rule is the hard/risky part. |

### M4 · Document Data Extractor — *parse structured docs, reconcile, flag gaps*
**Pipeline:** `F02 extract-attachment → F03 classify-attachment-type → F18 parse-structured-fields → (F19 reconcile-against-reference | F20 detect-missing-fields) → F22 write`
| Role | Functions |
|---|---|
| Core | F18, F19, F20 |
| Shared substrate | F02 extract-attachment (with M2/M2b), F03 classify-attachment-type (with M2/M2b), F22 write-to-external-system |
| Notes | Order-processing focused; needs ERP/quote reference data to reconcile against. |

### M5 · Drafting Assistant — *summarize, draft, adapt, generate*
**Pipeline:** `(F23 summarize-thread | F21 generate-artifact) → F24 draft-reply → F25 adapt-to-recipient`
| Role | Functions |
|---|---|
| Core | F21, F23, F24, F25 |
| Shared substrate | — (F23 also serves M1 briefing) |
| Notes | Split automation tiers: F21 fire-and-forget/testable vs F24 review-gated/LLM. |

### M6 · Watchtower — *track, alert, detect, measure*
**Pipeline:** parallel monitors over the mailbox/CRM: `F26 track-open-loop`, `F27 surface-due`, `F28 detect-anomaly`, `F29 aggregate-metric`
| Role | Functions |
|---|---|
| Core | F26, F27, F28, F29 |
| Shared substrate | — |
| Notes | Work-only (not dogfoodable on private mailbox); benefits from Pipedrive MCP for deal context. |

## Reuse Hotspots (substrate to design carefully first)

These primitives are shared across the most capabilities — getting their interfaces right early pays off most:

| Function | Used by | Why it's substrate |
|---|---|---|
| **F22 write-to-external-system** | M2, M2b, M3, M4 | every "act/persist" step funnels through it |
| **F03 classify-attachment-type** | M2, M2b, M4 | file typing reused by routing and extraction |
| **F04 derive-target-location** | M2, M2b, M3 | "where does this belong" judgment, shared |
| **F02 extract-attachment** | M2, M2b, M4 | get-the-file, reused |
| **F06 record-provenance** | M1, M2, M2b (effectively all) | findability/citation backbone |

> **Design implication (from session):** building **M2 first** implements F01–F04 + F22 + F06 — i.e. most of the shared substrate — so M1, M2b, M3, M4 become cheaper afterwards. M2 doubles as a tracer bullet that validates the substrate interfaces.

## Full Coverage Matrix (all pains)

Legend: **bold** = ■ primary capability for that pain · plain = □ supporting · 🔥 = pain marked "Wichtigster Punkt".
Cells list the pain IDs each capability addresses, grouped by pain source.

| Capability | Private (P01–P13) | Inside Sales (A01–A10) | Pre-Sales (A11–A16) | Mgmt (A17–A23) | Order (A24–A31) | X-cut Attach (A32–A36) | X-cut Patterns (P14–P16) |
|---|---|---|---|---|---|---|---|
| **M1 · Semantic Mail Q&A** | **P03 P11🔥 P12 P13** · P06 P08🔥 | **A03 A06 A08** · A02🔥 A04 A07 | **A11🔥 A12 A13** · A14 A15 | **A17🔥 A20** · A21 A22 A23 | A29 | **A32** · A33 | — |
| **M2 · Attachment Auto-Router** | **P01🔥 P02🔥** · P15 | — | — | — | **A27** | **A35 A36** · A32 A33 A34 | P15 |
| **M2b · Intelligent Auto-Router** | **P01🔥 P02🔥** · P15 | — | — | — | **A27** | **A35 A36** · A32 A33 A34 | P15 |
| **M3 · Mail Triage Engine** | **P04🔥 P05 P06 P07 P08🔥 P09 P10** | **A01🔥** | — | — | — | — | **P14 P15 P16** |
| **M4 · Document Data Extractor** | — | — | A13 | A23 | **A24 A25 A26 A29 A30 A31** · A27 | A36 | — |
| **M5 · Drafting Assistant** | — | **A02🔥 A04 A07** · A12 | **A14** · A12 | A17🔥 | **A25** · A30 | **A34** | — |
| **M6 · Watchtower** | P10 | **A05 A10** | **A15 A16** | **A18🔥 A19🔥 A21 A22** · A23 | **A28** | — | — |

*Uncovered pain:* **A09** (meeting scheduling) — niche; no capability currently targets it.

> Note: 🔥-marked cells are session-validated. Non-🔥 cells are best-effort primary/support assignments and may shift as pains are sharpened. Only 🔥 pains feed the Reach score below.

## Reach (🔥-only, weighted)

**Formula:** `Reach = (Σ private 🔥 pains × 2) + (Σ acontis 🔥 pains × 1 / [🔥-count in that role])`. Only pains in a "Wichtigster Punkt" section participate. ■ primary = full weight; □ supporting = ×0.5.

**Qualifying 🔥 pains & base weights:**
- Acontis: A01 (0.5), A02 (0.5), A11 (1.0), A17 (0.333), A18 (0.333), A19 (0.333). *(Role 4 Order + both X-cut sections have no 🔥 marker yet → excluded.)*
- Private (×2): P01 (2.0), P02 (2.0), P04 (2.0), P08 (2.0), P11 (2.0).

**Pain → capability:**
| Pain (weight) | ■ primary | □ support |
|---|---|---|
| A01 (0.5) auto-sort | M3 | — |
| A02 (0.5) drafting | M5 | M1 |
| A11 (1.0) tech-fact | M1 | — |
| A17 (0.333) briefing | M1 | M5 |
| A18 (0.333) critical-deals | M6 | — |
| A19 (0.333) response-time | M6 | — |
| P01 (2.0) →target folder | M2, M2b | — |
| P02 (2.0) target-folder | M2, M2b | — |
| P04 (2.0) archive-after-read | M3 | — |
| P08 (2.0) rescue-important | M3 | M1 |
| P11 (2.0) topic-search | M1 | — |

**Reach scores:**
| Capability | ■ contributions | □ contributions | **Reach** |
|---|---|---|---|
| **M1 · Semantic Mail Q&A** | A11 1.0 + A17 0.333 + P11 2.0 = 3.333 | A02 0.25 + P08 1.0 = 1.25 | **4.58** |
| **M3 · Mail Triage Engine** | A01 0.5 + P04 2.0 + P08 2.0 = 4.5 | — | **4.50** |
| **M2 · Attachment Auto-Router** | P01 2.0 + P02 2.0 = 4.0 | — | **4.00** |
| **M2b · Intelligent Auto-Router** | P01 2.0 + P02 2.0 = 4.0 | — | **4.00** *(extends M2; scores overlap)* |
| **M5 · Drafting Assistant** | A02 0.5 | A17 0.167 | **0.67** |
| **M6 · Watchtower** | A18 0.333 + A19 0.333 = 0.667 | — | **0.67** |
| **M4 · Document Data Extractor** | — | — | **0.00** |

**Finalists:** M1 (4.58), M3 (4.50), M2 (4.00) — near three-way tie, all dogfoodable on the private mailbox.

**Open items that would change scores:** fill 🔥 for Order role (would lift **M4**), X-cut Attachments (would lift **M2/M1**), and X-cut Patterns (would lift **M3**).

## Phase 3 — Resource-Constraints Squeeze (finalist comparison)

Constraint: *"three fun evenings — which one capability ships, running on the private mailbox?"* Reach narrowed the field to three finalists (M1, M3, M2); effort + fun + tracer-value + risk break the tie. "All pains" rows list the full footprint (primary + supporting) from the coverage matrix; the Dogfood row lists only 🔥 pains.

| | **M2 · Attachment Router** | **M3 · Triage Engine** | **M1 · Semantic Mail Q&A** |
|---|---|---|---|
| **Reach (🔥-weighted)** | 4.00 | 4.50 | 4.58 |
| **All acontis pains (A##)** | A27, A32, A33, A34, A35, A36 | A01 | A02, A03, A04, A06, A07, A08, A11, A12, A13, A14, A15, A17, A20, A21, A22, A23, A29, A32, A33 |
| **All private pains (P##)** | P01, P02, P15 | P04, P05, P06, P07, P08, P09, P10, P14, P15, P16 | P03, P06, P08, P11, P12, P13 |
| **Dogfood pain (🔥)** | P01, P02 | P04, P08, (A01) | P11, (A11, A17) |
| **Effort** | 🟢 lowest | 🟡 medium (F15 learn-rule) | 🔴 highest (index/embeddings) |
| **Fun / wow** | 🟡 satisfying, narrow | 🟡 satisfying, choreish | 🟢 the "magic" |
| **Tracer value** | 🟡 F01–F04, F22, F06 (substrate) | 🟢 F13–F17 (decision engine) | 🟢 F07–F12 (richest) |
| **Risk** | 🟢 low (non-destructive) | 🔴 high (destructive on real mail) | 🟡 medium (scope creep) |

**Decision (2026-05-30): start with M2 · Attachment Auto-Router.** Rationale: only finalist that genuinely ships within the constraint, non-destructive (files a copy), scratches the confirmed 🔥 private pains P01/P02, and implements the shared substrate (F01–F04 + F22 + F06) that M1/M3/M4 later reuse — so M2 doubles as the tracer bullet that validates the substrate interfaces. M2b follows after M2 ships, extending routing intelligence with F30/F31.
