# Bounded, Asymmetric Copy→Mail Reverse Resolution

**Status:** accepted

## Context

ADR-0001 promised **bidirectional findability** (G4 / NFR-005): Mail→Copy via the external
Provenance Ledger, Copy→Mail via a back-link stamped on the filed copy. It framed the Copy→Mail
direction as "trivial — stamp the copy." The entity model exposes that this is only half the story.

Reaching the **live source Mail** from a filed copy needs more than the stamp. The back-link carries
the Message-ID, date, and Sender, but to actually open or show the originating mail the system must
*locate it in the mailbox*. NFR-005 requires that link to survive the User relocating the mail, and
C-007 leaves the mail-access stack (IMAP / Graph) TBD — so no maintained index can be assumed.

The two directions are therefore **not symmetric**:

- **Mail→Copy** greps a compact, external ledger — cheap, complete, and unaffected by wherever the
  User later moves the mail.
- **Copy→Mail** must search the mailbox itself for the Message-ID. On a large mailbox, scanning every
  folder on every reverse lookup is costly, and the cost grows with the mailbox.

The open question is how much of the mailbox a Copy→Mail lookup is obliged to search — and what the
guarantee is for a mail the User has moved.

## Decision

**Bound Copy→Mail reverse resolution to a configured Reverse-Search Scope** — the inbox (always
searched) plus folders the User adds (e.g. an archive). Mail→Copy stays **unconditional** (a ledger
grep). A relocated source Mail stays reverse-findable **only while it remains within this scope**.

This bounds reverse-resolution cost on a large mailbox at the explicit price of *scoping* the
Copy→Mail guarantee, while keeping the asymmetric strength of Mail→Copy (always resolvable via the
ledger, no mailbox write-back — C-001). Broader / index-backed reverse search is **deferred** (method
TBD, tied to the C-007 access-stack decision).

## Consequences

- Mail→Copy keeps a 100% guarantee regardless of mail relocation — it never depends on folder
  location (NFR-005).
- Copy→Mail becomes an explicitly **scoped** guarantee: a mail moved *outside* the scope (e.g. to an
  unconfigured archive) is reverse-unfindable until the folder is added back to the scope. This is a
  **designed boundary** (uc-004 BR-006), not a bug, and must be stated wherever reverse search is
  described so it does not read as data loss.
- The scope is a **User-tunable knob**: adding folders trades lookup cost for reverse coverage.
- Reverse resolution is manual ledger/scope inspection in v1 (a greppable artifact, no dedicated
  lookup tool); an index-backed broadening is left open for when C-007 fixes the access stack.

## Considered Options

- **Full-mailbox scan on every Copy→Mail lookup (rejected)** — complete regardless of relocation, but
  O(mailbox) per lookup; untenable on a large mailbox and degrades as it grows.
- **Record the mail's folder location in the ledger so Copy→Mail is also a grep (rejected)** — folder
  location is exactly what changes when the User relocates a mail, so the entry goes stale on the
  first move (the same store-local trap ADR-0004 rejects) and would need mailbox-tracking write-back
  against C-001.
- **Index-backed reverse search (deferred, not v1)** — a maintained Message-ID→folder index would
  make Copy→Mail both cheap and complete, but it needs the access stack (C-007) settled and an index
  to build and keep current; out of v1 Pareto scope (CON-3).
- **Bounded Reverse-Search Scope — inbox always + configured folders (chosen)** — bounds per-lookup
  cost, keeps zero mailbox write-back, and makes the coverage/cost trade-off a User-tunable knob;
  accepts that a mail moved out of scope is reverse-unfindable until re-scoped.
