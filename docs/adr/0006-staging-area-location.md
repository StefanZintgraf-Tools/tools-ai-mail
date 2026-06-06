# Staging Area Location & Naming (`_review/`)

**Status:** accepted

## Context

Every artifact in M2 names the Staging Area as `_review/` — a relative, trailing-slash path
(vision, CONTEXT, entity_model, UC-001..005). What none of them pinned down is **where `_review/`
actually lives on disk** and **whether the name is fixed**. The STAGING_AREA value-object modelled
`Location` only as free-text `Not Null`, so the path was undefined at the model level.

This is not a cosmetic gap. The staging path is load-bearing for three already-decided mechanisms:

- **Re-stage idempotency (C-015 / NFR-002):** a staged Attachment is written at a
  *content-hash-addressed* path inside `_review/`, so a re-run targets the same path and overwrites
  identical bytes harmlessly. Content-hash addressing assumes **one** staging namespace.
- **Single-writer run (C-015):** exactly one run may write the Staging Area at a time. "The" Staging
  Area presumes a single, well-known location.
- **Drain workflow (UC-005):** the User empties `_review/` by hand and needs one predictable place to
  look; the Provenance Ledger does not track staged items, so the location cannot be recovered from
  the ledger.

A drive-absolute path (`C:\_review`) was floated. It would sit **outside** the declared Routing Root,
which contradicts CON-4's principle that the system operates only beneath the root it was given, and
it is non-portable across machines and OSes.

The one open question was *which root* `_review/` attaches to when several are declared — an unrouted
Attachment has, by definition, no Target Location and therefore no root to attribute it to. **That
question is removed at the source: M2 v1 declares exactly one Routing Root** (multiple roots are
deferred to M2b, alongside organization-grouping and the document-type dimension). With a single root,
"the Staging Area" and "the root" are both unambiguous.

## Decision

**The Staging Area is a single, relative, fixed-named `_review/` directory beneath the (single, v1)
Routing Root.**

- **Relative, never absolute.** It is resolved at run time from the User's Routing Root declaration;
  no drive-rooted or hard-coded path (no `C:\_review`).
- **Single.** There is exactly one `_review/` for the run — trivially so in v1, since there is exactly
  one Routing Root. This gives content-hash addressing one global namespace and honours the
  single-writer assumption.
- **Beneath the Routing Root.** It lives directly beneath the declared root, keeping the Staging Area
  inside the managed world (CON-4) and off the routable Target-Location set (it is *not* a Target
  Location).
- **Fixed name in v1.** The literal `_review` is a convention, **not user-configurable** in M2.

## Considered Options

- **Absolute path (`C:\_review`) (rejected)** — sits outside the Routing Root (against CON-4),
  non-portable across machines/OSes, and hard-codes a drive that may not exist.
- **Multiple Routing Roots with a per-root or primary-root staging rule (deferred, not v1)** — forces
  a choice of which root an unrouted Attachment lands under, splits the content-hash namespace
  (per-root) or relies on a positional "first/primary root" rule that silently moves `_review/` when
  roots are re-ordered. M2 v1 sidesteps this entirely by allowing **exactly one Routing Root**;
  multi-root and its staging-selection rule are an **M2b** concern.
- **A sibling directory alongside the root / a configurable path (rejected for v1)** — more flexible
  but adds configuration surface with no payoff for the single-mailbox, single-root, spare-time M2
  scope (CON-3). Deferred, not foreclosed.
- **Single `_review/` beneath the single Routing Root, fixed name (chosen)** — one global staging
  namespace, inside the managed world, portable, zero configuration. Smallest decision that satisfies
  idempotency, single-writer, and drain.

## Consequences

- STAGING_AREA `Location` is specified as a **relative `_review/` beneath the Routing Root**, not
  free-text — implementers read this from the entity model, not this ADR.
- The ACTOR declares **exactly one Routing Root in v1**; "one or more roots" is an M2b extension. This
  is the assumption that makes the staging location unambiguous, so the single-root constraint and this
  ADR stand or fall together.
- Content-hash addressing and the single-writer assumption keep their global, one-namespace guarantee
  with no further qualification.
- UC-005 drains exactly one directory; there is no "which `_review/`?" question to answer.
- The deferred mechanisms that re-open this decision are **multiple Routing Roots** (M2b) and, with
  them, a **per-root or configurable staging location/name**. Until then, both are out of scope.
