# Capability ↔ Pain Coverage Matrix

**Date:** 2026-05-30
**Source:** Brainstorming session `_bmad-output/brainstorming/brainstorming-session-2026-05-30-1047.md`
**References:** pains from [painlist_acontis.md](painlist_acontis.md) (`A01`–`A36`) and [painlist_private.md](painlist_private.md) (`P01`–`P16`).

## Namespaces

- **A## / P##** — pains (acontis / private), stable global IDs.
- **F01–F29** — primitives (headless reusable software modules / "functions").
- **M1–M6** — capabilities (user-facing application modules, composed of and sharing primitives).

## Candidate Capabilities

| Capability                       | Primitives                     | Purpose                                                                  |
| -------------------------------- | ------------------------------ | ------------------------------------------------------------------------ |
| **M1 · Semantic Mail Q&A**       | F07 F08 F09 F10 F11 F12 (+F06) | ask a question → answer synthesized from the archive (incl. attachments) |
| **M2 · Attachment Auto-Router**  | F01 F02 F03 F04 F22 (+F06)     | extract a file, classify it, decide where, file it                       |
| **M3 · Mail Triage Engine**      | F17 F13 F14 F15 F16 (+F04)     | classify a mail, decide the action, learn the rule, ask when unsure      |
| **M4 · Document Data Extractor** | F18 F19 F20 (+F02 F03)         | parse structured docs, reconcile vs reference, flag missing fields       |
| **M5 · Drafting Assistant**      | F21 F23 F24 F25                | summarize, draft, adapt, generate outgoing content                       |
| **M6 · Watchtower**              | F26 F27 F28 F29                | track open loops, surface due items, detect anomalies, roll up metrics   |

## Full Coverage Matrix (all pains)

Legend: **bold** = ■ primary capability for that pain · plain = □ supporting · 🔥 = pain marked "Wichtigster Punkt".
Cells list the pain IDs each capability addresses, grouped by pain source.

| Capability                       | Private (P01–P13)                   | Inside Sales (A01–A10)          | Pre-Sales (A11–A16)         | Mgmt (A17–A23)                | Order (A24–A31)                   | X-cut Attach (A32–A36)    | X-cut Patterns (P14–P16) |
| -------------------------------- | ----------------------------------- | ------------------------------- | --------------------------- | ----------------------------- | --------------------------------- | ------------------------- | ------------------------ |
| **M1 · Semantic Mail Q&A**       | **P03 P11🔥 P12 P13** · P06 P08🔥   | **A03 A06 A08** · A02🔥 A04 A07 | **A11🔥 A12 A13** · A14 A15 | **A17🔥 A20** · A21 A22 A23   | A29                               | **A32** · A33             | —                        |
| **M2 · Attachment Auto-Router**  | **P01🔥 P02🔥** · P15               | —                               | —                           | —                             | **A27**                           | **A35 A36** · A32 A33 A34 | P15                      |
| **M3 · Mail Triage Engine**      | **P04🔥 P05 P06 P07 P08🔥 P09 P10** | **A01🔥**                       | —                           | —                             | —                                 | —                         | **P14 P15 P16**          |
| **M4 · Document Data Extractor** | —                                   | —                               | A13                         | A23                           | **A24 A25 A26 A29 A30 A31** · A27 | A36                       | —                        |
| **M5 · Drafting Assistant**      | —                                   | **A02🔥 A04 A07** · A12         | **A14** · A12               | A17🔥                         | **A25** · A30                     | **A34**                   | —                        |
| **M6 · Watchtower**              | P10                                 | **A05 A10**                     | **A15 A16**                 | **A18🔥 A19🔥 A21 A22** · A23 | **A28**                           | —                         | —                        |

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
| P01 (2.0) →Drive folder | M2 | — |
| P02 (2.0) target-folder | M2 | — |
| P04 (2.0) archive-after-read | M3 | — |
| P08 (2.0) rescue-important | M3 | M1 |
| P11 (2.0) topic-search | M1 | — |

**Reach scores:**
| Capability | ■ contributions | □ contributions | **Reach** |
|---|---|---|---|
| **M1 · Semantic Mail Q&A** | A11 1.0 + A17 0.333 + P11 2.0 = 3.333 | A02 0.25 + P08 1.0 = 1.25 | **4.58** |
| **M3 · Mail Triage Engine** | A01 0.5 + P04 2.0 + P08 2.0 = 4.5 | — | **4.50** |
| **M2 · Attachment Auto-Router** | P01 2.0 + P02 2.0 = 4.0 | — | **4.00** |
| **M5 · Drafting Assistant** | A02 0.5 | A17 0.167 | **0.67** |
| **M6 · Watchtower** | A18 0.333 + A19 0.333 = 0.667 | — | **0.67** |
| **M4 · Document Data Extractor** | — | — | **0.00** |

**Finalists:** M1 (4.58), M3 (4.50), M2 (4.00) — near three-way tie, all dogfoodable on the private mailbox.

**Open items that would change scores:** fill 🔥 for Order role (would lift **M4**), X-cut Attachments (would lift **M2/M1**), and X-cut Patterns (would lift **M3**).

## Phase 3 — Resource-Constraints Squeeze (finalist comparison)

Constraint: *"three fun evenings — which one capability ships, running on the private mailbox?"* Reach narrowed the field to three finalists (M1, M3, M2); effort + fun + tracer-value + risk break the tie. "All pains" rows list the full footprint (primary + supporting) from the coverage matrix; the Dogfood row lists only 🔥 pains.

|                             | **M2 · Attachment Router**       | **M3 · Triage Engine**                           | **M1 · Semantic Mail Q&A**                                                                    |
| --------------------------- | -------------------------------- | ------------------------------------------------ | --------------------------------------------------------------------------------------------- |
| **Reach (🔥-weighted)**     | 4.00                             | 4.50                                             | 4.58                                                                                          |
| **All acontis pains (A##)** | A27, A32, A33, A34, A35, A36     | A01                                              | A02, A03, A04, A06, A07, A08, A11, A12, A13, A14, A15, A17, A20, A21, A22, A23, A29, A32, A33 |
| **All private pains (P##)** | P01, P02, P15                    | P04, P05, P06, P07, P08, P09, P10, P14, P15, P16 | P03, P06, P08, P11, P12, P13                                                                  |
| **Dogfood pain (🔥)**       | P01, P02                         | P04, P08, (A01)                                  | P11, (A11, A17)                                                                               |
| **Effort**                  | 🟢 lowest                        | 🟡 medium (F15 learn-rule)                       | 🔴 highest (index/embeddings)                                                                 |
| **Fun / wow**               | 🟡 satisfying, narrow            | 🟡 satisfying, choreish                          | 🟢 the "magic"                                                                                |
| **Tracer value**            | 🟡 F01–F04, F22, F06 (substrate) | 🟢 F13–F17 (decision engine)                     | 🟢 F07–F12 (richest)                                                                          |
| **Risk**                    | 🟢 low (non-destructive)         | 🔴 high (destructive on real mail)               | 🟡 medium (scope creep)                                                                       |

**Decision (2026-05-30): start with M2 · Attachment Auto-Router.** Rationale: only finalist that genuinely ships within the constraint, non-destructive (files a copy), scratches the confirmed 🔥 private pains P01/P02, and implements the shared substrate (F01–F04 + F22 + F06) that M1/M3/M4 later reuse — so M2 doubles as the tracer bullet that validates the substrate interfaces.
