# Requirements — M2 · Attachment Auto-Router

Source: [vision.md](vision.md). Stable function/capability/pain IDs (`F##`, `M#`, `P##`, `A##`,
`CON-#`) are defined in the [vision](vision.md) and [`../plan/01-foundation.md`](../plan/01-foundation.md).
Each requirement below traces back to a vision element in its title or row.

## Functional Requirements

Define what the system does. All in user-story form.

| ID     | Title                       | User Story                                                                                                                                                               | Priority | Status |
| ------ | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ------ |
| FR-001 | Detect Attachment (F01)     | As a mailbox owner, I want the system to detect mails carrying at least one attachment worth filing so that I do not have to scan my inbox manually.                     | High     | Open   |
| FR-002 | Extract Attachment (F02)    | As a mailbox owner, I want the system to extract the file object from each detected mail so that it can be processed without a manual download.                          | High     | Open   |
| FR-003 | Classify Attachment (F03)   | As a mailbox owner, I want each attachment labelled from a closed-but-editable enum (invoice, contract, bank-statement, delivery-note, license-agreement, …, `other`) so that filing can be automated; `other` routes to staging. | High     | Open   |
| FR-004 | Derive Target Folder (F04)  | As a mailbox owner, I want the system to map each attachment via its Routing Key (Sender = From email address × document type) to an existing folder beneath the declared Routing Roots so that I do not decide where each file goes. | High     | Open   |
| FR-005 | Route Uncertain to Staging  | As a mailbox owner, I want attachments with unknown mappings or low confidence routed to a `_review` staging area so that nothing is filed into the wrong place.         | High     | Open   |
| FR-006 | Present Proposal for Review | As a mailbox owner, I want all proposed filing actions presented together as an editable Action Plan with full context so that I can decide without opening the original mail.    | High     | Open   |
| FR-007 | Approve, Edit, or Reject    | As a mailbox owner, I want to approve, edit, or reject each proposal so that I stay in control of what gets filed.                                                       | High     | Open   |
| FR-008 | Commit Approved File (F22)  | As a mailbox owner, I want each approved attachment copied into its target folder under its Target Filename when I run `apply` so that only approved rows are committed.            | High     | Open   |
| FR-009 | Record Provenance (F06)     | As a mailbox owner, I want every filed copy linked to its source mail (Message-ID, date, sender) via the external Provenance Ledger so that I can trace any document to its origin. | High     | Open   |
| FR-010 | Bidirectional Findability   | As a mailbox owner, I want to locate a filed document from both its target folder location and the original email so that nothing is lost in the filing process.                 | Medium   | Open   |
| FR-011 | Manual Rename               | As a mailbox owner, I want to edit the Target Filename of any proposal in the Action Plan before `apply` so that files land under a name I choose. (AI-suggested naming is M2b/F32.) | Medium   | Open   |
| FR-012 | Deduplicate Identical Content | As a mailbox owner, I want identical bytes (same content-hash) never filed twice — only a new provenance link recorded — so that re-sent or re-scanned attachments do not create duplicates. | High     | Open   |
| FR-013 | Flag Conflict               | As a mailbox owner, I want a same-path/different-content collision flagged in the Action Plan for me to resolve (rename / overwrite / skip) so that nothing is silently overwritten. | High     | Open   |
| FR-014 | Select Run Scope            | As a mailbox owner, I want to choose which mails a run processes (a folder + optional date range) so that I control the batch; re-scanning overlapping mail is safe (dedup).        | Medium   | Open   |

## Non-Functional Requirements

Measurable quality attributes. Each is testable with a pass/fail threshold.

| ID      | Title                 | Requirement                                                                                                                                                         | Category        | Priority | Status |
| ------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- | -------- | ------ |
| NFR-001 | Confidence Gate       | F03 emits a type-confidence and F04 a location-confidence (both in [0,1]); the gate compares **min(type, location)** to the configured threshold; below it the item routes to `_review/`, with 0 auto-approvals below threshold. | Usability       | High     | Open   |
| NFR-002 | Idempotency           | Re-running the pipeline against already-processed mail must produce 0 duplicate writes; the **dedup decision keys on content-hash** (provenance links keyed on `(Message-ID, content-hash)`), stored in the external Provenance Ledger. | Maintainability | High     | Open   |
| NFR-003 | Proposal Completeness | 100% of proposals must display all five fields — sender, document type, proposed folder path, and the two confidence scores (type and location) — before the approval step.                      | Usability       | High     | Open   |
| NFR-004 | Inclusion Bias        | F01 must surface 100% of ambiguous attachments (e.g. generic names like `scan.jpg`) for review; 0 ambiguous attachments may be silently dropped.                    | Usability       | High     | Open   |
| NFR-005 | Provenance Coverage   | 100% of filed copies must be resolvable from both their target folder location and their source mail via the external Provenance Ledger, without any write-back to the mailbox. | Usability       | Medium   | Open   |

## Constraints

Boundaries imposed on the solution.

| ID    | Title                           | Constraint                                                                                                                                                                          | Category    | Priority | Status   |
| ----- | ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | -------- | -------- |
| C-001 | Non-Destructive (CON-1)         | The system must file a copy only; it must never move, delete, or modify the source mail or attachment.                                                                              | Technical   | High     | Open     |
| C-002 | Human-in-the-Loop (CON-2)       | No attachment may be written to the target folder without an explicit approval step, following the HumanLayer `require_approval` light-approval pattern (pattern only, not the deprecated SDK); realised as the plan/apply Action Plan (ADR-0002). | Operational | High     | Open     |
| C-003 | Existing Folders Only (CON-4)   | F04 must select from the existing folders beneath the declared Routing Roots and must never fabricate a folder path; folder creation is out of scope for v1.                          | Technical   | High     | Open     |
| C-004 | Private Mailbox Only (v1)       | v1 must target the private mailbox only; acontis, shared, and PST mailboxes are excluded from scope.                                                                                | Business    | High     | Open     |
| C-005 | Pareto / Spare-Time (CON-3)     | Scope must stay limited to relief of pains P01 and P02; every design decision must prefer the simplest surface that works over added capability.                                    | Business    | High     | Open     |
| C-006 | Stack TBD (CON-7)               | Programming language and runtime are not fixed here; the choice is deferred to the build-spine plan step.                                                                           | Technical   | Medium   | Deferred |
| C-007 | Mail-Access Method TBD (CON-8)  | The mail-access method (IMAP / Graph / PST / Outlook / Kerio) is deferred to the use-case spec — now unblocked, as idempotency keys on content-hash + portable `Message-ID`, not a transport id. (Approval surface and Run Scope are resolved, below.) | Technical   | Medium   | Deferred |
| C-008 | External Provenance Ledger (CON-11) | Bidirectional findability must be served by an external ledger (also the dedup store), never by annotating the source mail (CON-1). See ADR-0001.                              | Technical   | High     | Open     |
| C-009 | Surface/Core Separation (CON-12)| No routing or approval logic may live in an Approval Surface; the Proposal is a UI-agnostic contract and every surface (plan/apply now, GUI later) is a thin adapter. See ADR-0002. | Technical   | High     | Open     |
| C-010 | Dedup vs Conflict               | Identical content (same content-hash) is silently de-duplicated; only same-path/different-content is a Conflict surfaced to the User. The two must not be conflated.                | Technical   | High     | Open     |

## Open Questions

- **NFR-001 threshold value** — the `min(type, location)` confidence cutoff that routes items to
  `_review/` is not fixed. Set it **empirically against the golden corpus** (e.g. ~0.7), not by guess.
- **C-007 / mail-access method** — IMAP vs Graph vs PST vs Outlook vs Kerio is still deferred, but
  **no longer blocks anything**: NFR-002's dedup key is content-hash and the provenance key uses the
  portable `Message-ID`. The choice can be made at the use-case spec / build step on its own merits.
