# Function Catalog (Primitives) & Module Composition

**Date:** 2026-05-30
**Source:** Brainstorming session `_bmad-output/brainstorming/brainstorming-session-2026-05-30-1047.md`
**Related:** [capability_pain_matrix.md](capability_pain_matrix.md) · pains in [painlist_acontis.md](painlist_acontis.md) / [painlist_private.md](painlist_private.md)

## What this document is

- **F01–F29** = *primitives* = independent, reusable software modules ("functions"): headless, well-defined interface, individually testable.
- **M1–M6** = *capabilities* = user-facing application modules, **composed of** primitives and **sharing** them.
- A primitive may be used by several capabilities — that reuse is the whole point. The **Used by** column makes the sharing explicit.
- **Status** tracks implementation: ☐ not started · ◐ in progress · ☑ done. (All ☐ today.)

---

## 1. Master Function Catalog

### Layer 1 — I/O & provenance
| ID | Function | Contract (rough) | Used by | Status |
|---|---|---|---|---|
| **F01** | detect-attachment | mail → bool / list of attachment refs | M2 | ☐ |
| **F02** | extract-attachment | mail + ref → standalone file object | M2, M4 | ☐ |
| **F22** | write-to-external-system(target) | object + target → persisted (Drive/ERP/Pipedrive/mail action) | M2, M3, M4 | ☐ |
| **F06** | record-provenance | object + origin → provenance link (for findability/citation) | M1, M2 *(substrate: all)* | ☐ |

### Layer 2 — Understanding & classification
| ID | Function | Contract (rough) | Used by | Status |
|---|---|---|---|---|
| **F03** | classify-attachment-type | file → type (invoice/contract/photo/log…) | M2, M4 | ☐ |
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
| **F04** | derive-target-location | item context → destination (folder/store) | M2, M3 | ☐ |
| **F13** | decide-action | mail → action (archive/delete/keep/route/escalate) | M3 | ☐ |
| **F14** | match-rule | mail → matching sender/type rule (or none) | M3 | ☐ |
| **F15** | learn-rule | repeated human decisions → induced rule | M3 | ☐ |
| **F16** | request-confirmation | low-confidence case → human prompt → decision | M3 | ☐ |

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

---

## 2. Per-Module Function Breakdown

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
| Shared substrate | F04 derive-target-location (with M3), F22 write-to-external-system (with M3/M4), F06 record-provenance |
| Notes | Lowest effort; non-destructive (files a copy). Establishes substrate F22/F06/F03/F04 reused by M1, M3, M4. |

### M3 · Mail Triage Engine — *classify a mail, decide & do the action, learn the rule*
**Pipeline:** `F17 classify-mail-type → F14 match-rule → F13 decide-action → (F04 derive-target-location) → F22 write` · `F16 request-confirmation` on low confidence · `F15 learn-rule` from corrections
| Role | Functions |
|---|---|
| Core | F17, F13, F14, F15, F16 |
| Shared substrate | F04 derive-target-location (with M2), F22 write-to-external-system (with M2/M4) |
| Notes | Acts destructively on real mail → F16 confirmation layer is mandatory before trust. F15 learn-rule is the hard/risky part. |

### M4 · Document Data Extractor — *parse structured docs, reconcile, flag gaps*
**Pipeline:** `F02 extract-attachment → F03 classify-attachment-type → F18 parse-structured-fields → (F19 reconcile-against-reference | F20 detect-missing-fields) → F22 write`
| Role | Functions |
|---|---|
| Core | F18, F19, F20 |
| Shared substrate | F02 extract-attachment (with M2), F03 classify-attachment-type (with M2), F22 write-to-external-system |
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

---

## 3. Reuse Hotspots (substrate to design carefully first)

These primitives are shared across the most capabilities — getting their interfaces right early pays off most:

| Function | Used by | Why it's substrate |
|---|---|---|
| **F22 write-to-external-system** | M2, M3, M4 | every "act/persist" step funnels through it |
| **F03 classify-attachment-type** | M2, M4 | file typing reused by routing and extraction |
| **F04 derive-target-location** | M2, M3 | "where does this belong" judgment, shared |
| **F02 extract-attachment** | M2, M4 | get-the-file, reused |
| **F06 record-provenance** | M1, M2 (effectively all) | findability/citation backbone |

> **Design implication (from session):** building **M2 first** implements F01–F04 + F22 + F06 — i.e. most of the shared substrate — so M1, M3, M4 become cheaper afterwards. M2 doubles as a tracer bullet that validates the substrate interfaces.
