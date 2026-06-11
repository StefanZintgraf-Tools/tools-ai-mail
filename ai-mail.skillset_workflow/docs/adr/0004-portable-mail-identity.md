# Portable Mail Identity (Message-ID, never store UIDs)

**Status:** accepted

## Context

M2's findability and dedup guarantees rest on being able to name a Mail durably. NFR-005
requires that a filed copy stay resolvable to its source Mail **after the User relocates that
Mail**, and ADR-0001's Provenance Ledger keys the `source Mail ↔ filed copy` mapping on a mail
identity. M2 must also work across more than one mail-access method (IMAP today, Graph later —
C-006/C-007 leave the access stack TBD), so whatever identifies a Mail has to mean the same thing
regardless of how the mail was reached.

The obvious identifier is the one the access method hands you: an IMAP UID or a Graph item-ID. But
those are **store-local** — they change between accounts, re-syncs, and access methods, and they do
not survive the User moving the mail to another folder. Keying the ledger on one of them would break
NFR-005 the first time a mail is relocated or re-fetched through a different stack.

## Decision

**A Mail's identity is its `Message-ID`** — the RFC mail header, which is portable and stable across
access method and folder location. The Provenance Ledger, provenance back-links, and all Mail→Copy /
Copy→Mail lookups key on Message-ID, **never** on an IMAP UID or Graph item-ID.

Because RFC does not *guarantee* a Message-ID is present, when it is absent identity falls back to a
**synthetic `hash(from + date + subject)`** so the Mail stays addressable. The synthetic key is a
fallback only; a real Message-ID is always preferred.

## Considered Options

- **IMAP UID / Graph item-ID** (rejected) — always present and trivial to read, but store-local: not
  portable across access methods and broken by mail relocation, which violates NFR-005.
- **Message-ID only, fail when absent** (rejected) — portable, but a missing header would leave the
  Mail unaddressable and silently un-filed.
- **Message-ID with synthetic `hash(from+date+subject)` fallback** (chosen) — portable and
  relocation-stable, and still addressable when the header is missing.

## Consequences

- The ledger and back-links are now keyed on a portable identity that survives relocation and a later
  IMAP→Graph switch — NFR-005 holds without any write-back to the mailbox (C-001).
- The synthetic fallback is weaker than a true Message-ID: two genuinely distinct mails with the same
  from/date/subject would collide on one synthetic key. This is an accepted edge to watch; the
  dedup-on-content-hash rule (NFR-002) prevents it from ever causing a *lost or duplicated file*,
  only an ambiguous provenance link.
- Adapters for any future access method must surface the RFC Message-ID (and compute the fallback the
  same way), not their native UID — a constraint on every mail-access adapter.
