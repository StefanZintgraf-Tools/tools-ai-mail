# Vision: M2 · Attachment Auto-Router

## References

This vision uses stable IDs defined elsewhere in the planning docs. To resolve any `F##`, `M#`, `P##`,
or `A##` reference, see:

- **F-primitives (`F01`–`F29`), M-capabilities (`M1`–`M6`), the function/capability catalog, and the
  M2 selection decision** — [`../plan/00-foundation.md`](../plan/00-foundation.md) (e.g. `F01`
  detect-attachment, `F22` write-to-external-system, and the "start with M2" decision at its end).
- **Private-mailbox pains (`P01`–`P16`)** — [`../plan/painlist_private.md`](../plan/painlist_private.md)
  (e.g. `P01`/`P02`, the 🔥 attachment-filing pains).
- **acontis pains (`A01`–`A36`)** — [`../plan/painlist_acontis.md`](../plan/painlist_acontis.md).

## Mission

Filing email attachments is repetitive, mindless work that still costs attention: download the file,
decide where it belongs, upload it, repeat. The Attachment Auto-Router eliminates that loop for a
mailbox by automatically detecting attachments, classifying each one (invoice, contract,
ticket, photo, …), deriving the right target folder, and presenting the proposed actions
for human review before anything is committed. Nothing is filed silently; the human stays in the loop
as a lightweight approver, not a full-time operator.

First use-case target: **User's mailbox (outlook, IMAP, Kerio Connect)** (dogfood on real data). Addresses confirmed 🔥
pains P01 (file the attachment) and P02 (find the right folder). Built in spare time for fun; Pareto
principle applies throughout — minimum work, maximum relief on the actual pain.

## Target Users

- **User (mailbox owner)** — receives recurring attachments (invoices, insurance documents,
  bank statements, delivery notes, tickets, License Agreements etc.) that need to end up in a structured folder
  hierarchy. Wants a low-effort review step, not zero oversight.

## Goals

- **G1** — A new attachment from any mail reaches its correct target folder with a single approval
  action, not a manual download-and-upload cycle (P01).
- **G2** — The "where does this belong?" decision is made by the tool, not by the User — the User only
  confirms or overrides (P02).
- **G3** — The user can approve or reject any proposal without opening the original mail — all
  necessary context is in the proposal itself.
- **G4** — Every filed document is findable from both its target folder location and the original email —
  nothing gets lost in the filing process.

## Scope

### In scope (v1)

- **F01** detect-attachment — identify mails that carry at least one attachment worth filing
- **F02** extract-attachment — get the file object from the mail
- **F03** classify-attachment-type — label the file (invoice / contract / bank-statement / ticket /
  photo / log / other)
- **F04** derive-target-location — map (sender × document-type) to an **existing** target folder;
  unknown mappings → staging area, never auto-created folders
- **F22** write-to-external-system — copy the file into the target folder; idempotent; respects the approval
  decision
- **F06** record-provenance — attach a back-link (mail ID + date + sender) to every filed copy
- **Human review / approval surface** — the tool proposes; the human approves, edits, or rejects
  before F22 writes. Shape of the surface (CLI prompt · editable file · other) is a **deferred
  decision** to be resolved in the use-case specification.

### Out of scope (v1)

- Mail access method (IMAP / Gmail API / local PST / Outlook / Kerio Connect) — deferred to use-case spec; no hard constraint
  imposed here
- Target folder creation — v1 targets existing folders only; creation is v2
- Sender-rule learning (F15) — not in M2; belongs to M3
- Sending or replying to mail (M3/M5) — explicitly excluded; zero write-back to the mailbox
- acontis / shared / PST mailboxes — v1 is private-mailbox only
- M1 / M3 / M4 / M5 / M6 capabilities — out of scope for this product

## Constraints

- **CON-1 Non-destructive** — files a copy; never moves, deletes, or modifies the source mail or
  attachment.
- **CON-2 Human-in-the-loop before commit** — no attachment is written to the target folder without an explicit
  approval step. The pattern is the HumanLayer `require_approval` light-approval model (borrow the
  pattern; do not depend on the deprecated SDK).
- **CON-3 Pareto / spare-time** — built in evenings for fun. Every design decision must ask: "is this
  necessary for P01/P02 relief, or is it scope creep?" Prefer the simplest surface that works.
- **CON-4 Existing folders only (v1)** — F04 is a gradeable closed-set classifier; it must never
  fabricate a folder path. Unknown targets → `_review/` staging area.
- **CON-5 Confidence gate** — F03 and F04 must emit a confidence score; below threshold the proposal
  goes to `_review/` rather than being auto-approved.
- **CON-6 Idempotency** — F22 must deduplicate (content-hash or provenance key); re-running against
  already-processed mail must be a no-op.
- **CON-7 Stack TBD** — programming language and runtime are not constrained here; the choice is
  deferred to the build-spine's plan step.
- **CON-8 Interaction surface TBD** — how mail is selected for processing and how the approval step
  is presented to the user are open questions deliberately left to the use-case specification.
- **CON-9 Proposal completeness** — every proposal must display sender, document type, proposed folder
  path, and confidence score; the user must be able to decide without opening the original mail.
- **CON-10 Err on inclusion** — F01 must never silently drop an ambiguous attachment (e.g. generic
  names like `scan.jpg`); when uncertain, surface for review rather than suppress.
