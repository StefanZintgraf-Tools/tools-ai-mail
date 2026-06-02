---
stepsCompleted: [1, 2]
inputDocuments: ['plan/00-foundation.md', 'docs/vision.md']
session_topic: 'M2 · Attachment Auto-Router — Goals review and refinement'
session_goals: 'Review, enhance, adjust the Goals section in vision.md. Add or delete goals as needed. Maximum 10 goals. Pareto principle throughout.'
selected_approach: 'ai-recommended'
techniques_used: ['Assumption Reversal', 'SCAMPER (Eliminate + Combine)', 'Reversal Inversion']
ideas_generated: []
context_file: 'docs/vision.md'
---

# Brainstorming Session Results

**Facilitator:** Stefan
**Date:** 2026-06-01

## Session Overview

**Topic:** M2 · Attachment Auto-Router — Goals review and refinement
**Goals:** Review/enhance/adjust Goals section in vision.md. Add or delete as needed. Max 10 goals. Pareto applies.

## Technique Selection

**Approach:** AI-Recommended
**Phase 1 — Assumption Reversal:** Challenge which existing goals are actually goals vs constraints already covered in the Constraints section.
**Phase 2 — SCAMPER (Eliminate + Combine):** Trim redundant goals, merge overlapping ones, sharpen wording.
**Phase 3 — Reversal Inversion (spot-check):** "How would M2 fail?" to surface any missing goals.

## Session Log

### Decisions

- **G3, G4, G6 removed from Goals** — duplicates of CON-1, CON-5, CON-6; they belong in Constraints only.
- **M2b · Intelligent Auto-Router** identified as a follow-on module — sender→customer→folder mapping, LLM-assisted folder inference, maintained knowledge base, batch/routine operation. NOT part of M2 v1. To be added to a new `plan/01-foundation.md`.
- **M2 v1 unknown-location handling** stays as-is: unknown targets → `_review/` staging (CON-4); the user resolves manually. G2 remains scoped to *known* folder space.

### Surviving Goals (so far)

- **G1** — single approval action → correct Drive folder (P01)
- **G2** — tool decides location, user confirms/overrides (P02) *(override UX intentionally minimal in v1)*
- **G5** — provenance: every filed copy links back to source mail (F06), findable from both directions

- **G_new (approval quality):** "The user can approve or reject any proposal without opening the original mail" — zero context-switching. Add as goal.
- **CON_new:** Every proposal must display sender, document type, proposed folder path, and confidence score. Add as constraint.

### Applied Changes

**docs/vision.md — Goals section:**
- G1, G2: kept unchanged
- G3 (non-destructive), G4 (confidence gate), G6 (idempotent): removed from Goals → stay in Constraints only
- G3 (new): "The user can approve or reject any proposal without opening the original mail — all necessary context is in the proposal itself."
- G4 (reworded from G5): "Every filed document is findable from both its Drive location and the original email — nothing gets lost in the filing process."

**docs/vision.md — Constraints section:**
- CON-9 added: every proposal must display sender, document type, proposed folder path, and confidence score
- CON-10 added: F01 must err on inclusion — ambiguous attachments surfaced for review, never silently dropped

**plan/01-foundation.md — created:**
- M2b · Intelligent Auto-Router: sender→location mapping, LLM-assisted folder inference, batch/routine operation, F30/F31 new primitives

### Candidates / Open Questions

