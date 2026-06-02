# External Provenance Ledger

**Status:** accepted

## Context

M2 must deliver **bidirectional findability** (G4 / NFR-005): from a filed copy you can reach the
source Mail, *and* from a source Mail you can reach what it produced. At the same time M2 is
**non-destructive with zero write-back to the mailbox** (CON-1) — the source Mail must never be
modified. The Copy→Mail direction is trivial (stamp the copy), but the Mail→Copy direction's obvious
implementation — tagging the mail "filed ✓" — is exactly the write-back CON-1 forbids.

## Decision

Keep an **external Provenance Ledger**: an append record, outside both the mailbox and the target
folders, mapping `source Mail ↔ filed copy (+ content hash)`. It answers the Mail→Copy direction
without ever touching the mail, and it is **the same store F22 reads for idempotency** (CON-6) —
"have I already filed this Attachment?" is a ledger lookup. One store, two jobs: findability and
dedup. The Copy→Mail back-link (mail ID, date, Sender) is additionally carried with the filed copy;
its physical form (embedded metadata vs sidecar) is deferred to the use-case spec.

## Considered Options

- **Tag/annotate the source mail** (Outlook category, IMAP flag) — rejected: violates CON-1
  zero-write-back.
- **Filesystem only** (rely on the back-link stamped on the copy) — rejected: answers Copy→Mail but
  not Mail→Copy, and gives F22 no place to check "already filed?".
- **External ledger** (chosen) — satisfies both directions and idempotency without mutating the mail.

## Consequences

- A new store must exist and stay consistent with the filesystem; an orphaned ledger entry (copy
  deleted by hand) or orphaned copy (ledger lost) becomes a recoverable inconsistency to design for.
- Idempotency and findability are now coupled to one store — a benefit (single source of truth) and
  a risk (single point of failure) to weigh in the use-case spec.
