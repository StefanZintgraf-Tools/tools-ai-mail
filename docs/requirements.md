# Requirements — M2 · Attachment Auto-Router

Source: [vision.md](vision.md). Stable function/capability/pain IDs (`F##`, `M#`, `P##`, `A##`,
`CON-#`) are defined in the [vision](vision.md) and [`../plan/00-foundation.md`](../plan/00-foundation.md).
Each requirement below traces back to a vision element in its title or row.

## Functional Requirements

Define what the system does. All in user-story form.

| ID     | Title                       | User Story                                                                                                                                                               | Priority | Status |
| ------ | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ------ |
| FR-001 | Detect Attachment (F01)     | As a mailbox owner, I want the system to detect mails carrying at least one attachment worth filing so that I do not have to scan my inbox manually.                     | High     | Open   |
| FR-002 | Extract Attachment (F02)    | As a mailbox owner, I want the system to extract the file object from each detected mail so that it can be processed without a manual download.                          | High     | Open   |
| FR-003 | Classify Attachment (F03)   | As a mailbox owner, I want each attachment labelled as invoice, contract, bank-statement, ticket, photo, log, or other so that filing can be automated.                  | High     | Open   |
| FR-004 | Derive Target Folder (F04)  | As a mailbox owner, I want the system to map each attachment to an existing target folder from its sender and document type so that I do not decide where each file goes. | High     | Open   |
| FR-005 | Route Uncertain to Staging  | As a mailbox owner, I want attachments with unknown mappings or low confidence routed to a `_review` staging area so that nothing is filed into the wrong place.         | High     | Open   |
| FR-006 | Present Proposal for Review | As a mailbox owner, I want each proposed filing action presented with full context so that I can decide without opening the original mail.                               | High     | Open   |
| FR-007 | Approve, Edit, or Reject    | As a mailbox owner, I want to approve, edit, or reject each proposal so that I stay in control of what gets filed.                                                       | High     | Open   |
| FR-008 | Commit Approved File (F22)  | As a mailbox owner, I want an approved attachment copied into its target folder so that the file reaches its destination with a single approval action.            | High     | Open   |
| FR-009 | Record Provenance (F06)     | As a mailbox owner, I want every filed copy to carry a back-link to its source mail (mail ID, date, sender) so that I can trace any document to its origin.              | High     | Open   |
| FR-010 | Bidirectional Findability   | As a mailbox owner, I want to locate a filed document from both its target folder location and the original email so that nothing is lost in the filing process.                 | Medium   | Open   |

## Non-Functional Requirements

Measurable quality attributes. Each is testable with a pass/fail threshold.

| ID      | Title                 | Requirement                                                                                                                                                         | Category        | Priority | Status |
| ------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- | -------- | ------ |
| NFR-001 | Confidence Gate       | F03 and F04 must emit a confidence score in [0,1]; any item scoring below the configured threshold must route to `_review/`, with 0 auto-approvals below threshold. | Usability       | High     | Open   |
| NFR-002 | Idempotency           | Re-running the pipeline against already-processed mail must produce 0 duplicate writes, enforced by content-hash or provenance key.                                 | Maintainability | High     | Open   |
| NFR-003 | Proposal Completeness | 100% of proposals must display all four fields — sender, document type, proposed folder path, and confidence score — before the approval step.                      | Usability       | High     | Open   |
| NFR-004 | Inclusion Bias        | F01 must surface 100% of ambiguous attachments (e.g. generic names like `scan.jpg`) for review; 0 ambiguous attachments may be silently dropped.                    | Usability       | High     | Open   |
| NFR-005 | Provenance Coverage   | 100% of filed copies must be resolvable from both their target folder location and their source mail via the recorded back-link.                                            | Usability       | Medium   | Open   |

## Constraints

Boundaries imposed on the solution.

| ID    | Title                           | Constraint                                                                                                                                                                          | Category    | Priority | Status   |
| ----- | ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | -------- | -------- |
| C-001 | Non-Destructive (CON-1)         | The system must file a copy only; it must never move, delete, or modify the source mail or attachment.                                                                              | Technical   | High     | Open     |
| C-002 | Human-in-the-Loop (CON-2)       | No attachment may be written to the target folder without an explicit approval step, following the HumanLayer `require_approval` light-approval pattern (pattern only, not the deprecated SDK). | Operational | High     | Open     |
| C-003 | Existing Folders Only (CON-4)   | F04 must select from an existing closed set of target folders and must never fabricate a folder path; folder creation is out of scope for v1.                                        | Technical   | High     | Open     |
| C-004 | Private Mailbox Only (v1)       | v1 must target the private mailbox only; acontis, shared, and PST mailboxes are excluded from scope.                                                                                | Business    | High     | Open     |
| C-005 | Pareto / Spare-Time (CON-3)     | Scope must stay limited to relief of pains P01 and P02; every design decision must prefer the simplest surface that works over added capability.                                    | Business    | High     | Open     |
| C-006 | Stack TBD (CON-7)               | Programming language and runtime are not fixed here; the choice is deferred to the build-spine plan step.                                                                           | Technical   | Medium   | Deferred |
| C-007 | Interaction Surface TBD (CON-8) | The mail-selection method and the shape of the approval surface (CLI prompt, editable file, other) are deferred to the use-case specification.                                      | Technical   | Medium   | Deferred |

## Open Questions

- **NFR-001 threshold value** — the confidence threshold that routes items to `_review/` is not fixed
  in the vision. Confirm the numeric cutoff (e.g. 0.7) during use-case specification.
- **C-007 / mail access** — IMAP vs Gmail API vs local PST vs Outlook vs Kerio Connect is deferred (vision "Out of scope"); resolve
  before NFR-002's dedup key can be finalised.
