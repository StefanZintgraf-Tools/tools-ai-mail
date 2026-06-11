# Sender-only Routing for M2 (defer Document Type to M2b)

**Status:** accepted

## Context

The original Routing Key for F04 (derive-target-location) was a two-dimensional tuple
**(Sender × Document Type)** → Target Location, with F03 (classify-attachment-type) producing the
document-type half from a closed-but-editable enum (invoice / contract / bank-statement / … /
`other`). The source pains describe a folder taxonomy organized **by document type** (P01's example
target is `Finanzen/Rechnungen/2026`; P02 names both "verschiedene Absender, verschiedene
Dokumenttypen"; P15 calls out explicit type detection), so a two-dimensional key is the *eventually*
correct model.

M2 is built in spare time under the Pareto guardrail (CON-3): ship the simplest surface that relieves
P01/P02, defer everything else. F03 is an LLM-judgment classifier that needs its own enum source,
type-confidence, and golden-corpus labels — a meaningful slice of build and grading effort. The
question: does M2 need the document-type dimension on day one, or can it be deferred without
forfeiting P01/P02 relief?

## Decision

**M2 routes by Sender alone.** The Routing Key collapses to one dimension — *Sender = the From email
address* → an existing folder beneath the Routing Roots. F03/Document Type, type-confidence, and the
`min(type, location)` confidence gate are **deferred to M2b**, where the intelligent router
(F30/F31/F32) restores the second dimension. The M2 confidence gate is location-confidence only.

A one-dimensional key is **single-valued only when each sender files into one folder**. A sender that
historically spans multiple folders is, by construction, below location-confidence and routes to the
`_review/` Staging Area — the human handles it there, and resolving such senders is exactly what
M2b's document-type dimension is *for*. This is an **accepted Pareto cut for M2 only**, not a
permanent simplification: the document-type dimension is a **must-have in M2b**, not optional.

## Considered Options

- **Keep the 2-D key (Sender × Document Type) in M2 (rejected)** — eventually correct, but pulls F03
  (enum source + type-confidence + its own golden-corpus labels) into the first slice, against CON-3.
- **Route by Document Type alone (rejected)** — collapses every sender's invoices into one
  `Rechnungen` folder regardless of correspondent; loses the sender→folder signal that P14 shows is
  the strongest single predictor for a private mailbox.
- **Sender-only, defer Document Type to M2b (chosen)** — most private-mailbox senders are single-type
  (bank, insurer, utility, shop), so sender-only nails the 80%; multi-type senders fall to `_review/`
  rather than misfiling. Smallest gradeable F04 that relieves P01/P02.

## Consequences

- F04 becomes a gradeable closed-set classifier over **Sender → existing folder**; the golden corpus
  labels each attachment with its correct folder by sender, with no document-type label in M2.
- **Multi-type senders are a known, accepted miss** — they route to `_review/`, never misfile. This
  must be stated wherever F04 is described so it reads as a designed boundary, not a bug
  (vision F04, FR-004, CONTEXT Routing Key).
- Because the disambiguating dimension is gone, recurring same-named attachments from one sender all
  target one folder; the deterministic mail-date-prefix tiebreaker (FR-015) keeps the common
  recurring case out of `_review/`. That tiebreaker exists *because* of this cut.
- M2b is committed to reintroducing F03 — its return is scoped here as a must-have, so M2b is not
  free to drop it.
