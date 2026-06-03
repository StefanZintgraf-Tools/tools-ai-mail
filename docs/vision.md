# Vision: M2 · Attachment Auto-Router

## References

This vision uses stable IDs defined elsewhere in the planning docs. To resolve any `F##`, `M#`, `P##`,
or `A##` reference, see:

- **F-primitives (`F01`–`F29`), M-capabilities (`M1`–`M6`), the function/capability catalog, and the
  M2 selection decision** — [`../plan/01-foundation.md`](../plan/01-foundation.md) (e.g. `F01`
  detect-attachment, `F22` write-to-external-system, and the "start with M2" decision at its end).
- **Private-mailbox pains (`P01`–`P16`)** — [`../plan/painlist_private.md`](../plan/painlist_private.md)
  (e.g. `P01`/`P02`, the 🔥 attachment-filing pains).
- **acontis pains (`A01`–`A36`)** — [`../plan/painlist_acontis.md`](../plan/painlist_acontis.md).
- **Ubiquitous language (canonical term definitions)** — [`CONTEXT.md`](CONTEXT.md).
- **Architecture decisions** — [`adr/`](adr/): ADR-0001 (external provenance ledger), ADR-0002
  (approval surface as a swappable adapter; plan/apply file first).

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
  nothing gets lost in the filing process, and findability survives the user later archiving or moving
  the source mail within the mailbox (lookups key on the portable `Message-ID`, not on mail location);
  in v1 this is served by inspecting the ledger directly, not by a built lookup tool.

## Scope

### In scope (v1)

- **F01** detect-attachment — identify mails that carry at least one attachment worth filing; the
  "worth filing" judgment (filter inline images / footer logos / signatures) lives here, not in the
  definition of an attachment
- **F02** extract-attachment — get the file object from the mail (one **Proposal** per attachment)
- **F04** derive-target-location — map the **Routing Key (Sender)** to an **existing**
  folder discovered beneath the declared **Routing Roots**; *Sender = the From email address* in v1;
  unknown mappings or below-threshold confidence → `_review/` Staging Area, never auto-created folders
- **F22** write-to-external-system — copy the file into the target folder under the **Target Filename**
  (defaults to the original name, User-editable); **dedup keys on content-hash** (identical bytes are
  not re-filed — only a new provenance link is recorded); a same-path/different-content **Conflict**
  routes to `_review/` staging, never auto-overwritten
- **F06** record-provenance — via an **external Provenance Ledger** (ADR-0001) that maps
  `source Mail ↔ filed copy` for bidirectional findability *without writing back to the mailbox*;
  mail identity = the `Message-ID` header (content-hash fallback)
- **Approval surface** — the tool emits an **Action Plan** (the batch of Proposals); the User edits it
  (approve / re-target / rename / skip) and `apply` commits only the approved rows.
  The Proposal is a **UI-agnostic contract** and the surface is a swappable adapter (ADR-0002); M2's
  first adapter is a plan/apply **YAML** file; a later GUI (e.g. Outlook plugin) is just another adapter.

### Out of scope (v1)

- Mail access method (IMAP / Gmail API / local PST / Outlook / Kerio Connect) — deferred to use-case
  spec; **now unblocked** — idempotency no longer depends on it (mail identity is the portable
  `Message-ID`, not a transport-specific id)
- AI-suggested renaming — inferring a folder's **Naming Scheme** to propose a Target Filename
  (new primitive **F32 · infer-filename**) is **M2b**, not M2; M2 supports only *manual* rename via
  the editable Action Plan
- Document-type classification (**F03**) — v1 routes by **Sender only**; the closed-but-editable type
  enum (invoice / contract / …) and its type-confidence move to **M2b**
- Sender organization-grouping (many addresses → one org) — **M2b** (F30 sender→location map)
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
  pattern; do not depend on the deprecated SDK). The surface is a plan/apply **Action Plan** the User
  edits before `apply` commits (ADR-0002).
- **CON-3 Pareto / spare-time** — built in evenings for fun. Every design decision must ask: "is this
  necessary for P01/P02 relief, or is it scope creep?" Prefer the simplest surface that works.
- **CON-4 Existing folders only (v1)** — F04 is a gradeable closed-set classifier over the existing
  folders beneath the declared **Routing Roots**; it must never fabricate a folder path. Unknown
  targets → `_review/` Staging Area.
- **CON-5 Confidence gate** — F04 emits a location-confidence in [0,1]; the gate compares it to the
  threshold; below it the proposal goes to `_review/` rather than being auto-approved. (M2b adds
  F03 type-confidence, and the gate becomes **min(type, location)**.)
- **CON-6 Idempotency / dedup** — the **dedup decision keys on content-hash** (re-filing identical
  bytes is a no-op that only adds a provenance link); the Provenance Ledger is the dedup store
  (ADR-0001). A same-path/different-content **Conflict** is a separate concern — routed to `_review/`
  staging, not dedup.
- **CON-7 Stack TBD** — programming language and runtime are not constrained here; the choice is
  deferred to the build-spine's plan step.
- **CON-8 Mail-access deferred (surface & selection resolved)** — the approval surface is the
  plan/apply Action Plan adapter (ADR-0002) and **Run Scope** is a User-specified folder (a
  trigger/adapter concern; date-range narrowing deferred). Only the *mail-access method* (IMAP / Graph / PST / …)
  remains deferred to the use-case spec.
- **CON-9 Proposal completeness** — every proposal must display sender, proposed folder path, and the
  location-confidence score; the user must be able to decide without opening the original mail.
- **CON-10 Err on inclusion** — F01 must never silently drop an ambiguous attachment (e.g. generic
  names like `scan.jpg`); when uncertain, surface for review rather than suppress.
- **CON-11 External provenance ledger** — bidirectional findability (Copy↔Mail) must be achieved
  *without annotating the source mail* (CON-1); it is served by an external ledger, which is also the
  dedup store (ADR-0001).
- **CON-12 Surface/core separation** — no routing or approval logic may live in an Approval Surface;
  the Proposal is a UI-agnostic contract and every surface (plan/apply now, GUI later) is a thin
  adapter over it (ADR-0002).
