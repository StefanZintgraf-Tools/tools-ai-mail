# Mail-Access Credentials Out of Greppable Artifacts

**Status:** accepted

## Context

M2 cannot read the Mailbox without a secret — an IMAP password, an OAuth refresh token, or a
Graph client secret, depending on the access method that C-007 still leaves TBD. That secret is an
unmodeled part of M2 today: the entity model and requirements describe everything the pipeline
*writes* (the Provenance Ledger, the Action Plan, the per-copy back-link) but nothing about the
credential it must *hold* to run at all. M2 is headless and re-runnable, so the secret has to be
available without an interactive prompt every run.

The hidden-constraint sweep (Gap 1, Security/PII) flagged the real hazard: M2's own durable
artifacts are exactly the wrong place to keep a secret. The **Provenance Ledger** is append-only,
greppable, and deliberately external; the **Action Plan** is a hand-edited plaintext plan file; the
**back-link** travels *with* every filed copy into Target Locations the User may later sync to the
cloud. Writing a credential into any of them — which is tempting precisely because those artifacts
already exist, persist, and are easy to read — would leak it into long-lived, possibly-synced,
plaintext storage.

The *mechanism* (which secret store, on which OS, for which access method) depends on the access
method (C-007) and the stack (C-006), both still deferred to the use-case spec. The *principle* —
where a secret may and may not live — does not depend on either and is decidable now.

## Decision

**Mail-access credentials live only in an OS-level secret store** (e.g. Windows Credential Manager /
DPAPI, macOS Keychain, or an equivalent secrets manager), read at run time. A credential is **never**
written into the Provenance Ledger, the Action Plan or any plan/apply file, the per-copy
provenance back-link, application logs, or any artifact that is committed, synced, or carried with a
filed copy.

This is the principle only. The concrete store and the credential-acquisition flow (interactive
first-run setup, token refresh, etc.) are settled in the **use-case spec alongside the C-007
access-method decision** — they are *not* deferred past M2: M2 cannot read the Mailbox without
resolving them. NFR-006 makes the principle testable.

## Considered Options

- **Credential in the Provenance Ledger / Action Plan / plan file** (rejected) — tempting because
  those artifacts already exist, persist across runs, and are trivially greppable, but that is exactly
  why it fails: a secret would land in long-lived, hand-edited, possibly cloud-synced plaintext.
- **Credential in an environment variable / config file checked into the repo** (rejected) — better
  than the ledger but still plaintext-at-rest and easy to commit or sync by accident; gives no
  per-OS protection.
- **OS-level secret store, read at run time** (chosen) — keeps the secret out of every M2 artifact,
  uses platform-provided at-rest protection, and supports headless re-runs without re-prompting.

## Consequences

- A mail-access adapter (per C-007) must fetch its credential from the secret store, not receive it
  through a plan file or ledger entry — a constraint on every future adapter, alongside the
  Message-ID surfacing requirement (ADR-0004).
- First-run credential setup becomes an explicit use-case-spec concern (how the secret first gets
  into the store), rather than something that falls out of editing a config file.
- NFR-006 gives a pass/fail check: no M2-produced artifact may contain a credential. The Action Plan
  is hand-edited, so this is also a User-facing guarantee, not only an implementation rule.
- This ADR records the principle; it does **not** pick the secret store or the access method. Those
  ride with C-006/C-007 in the use-case spec, and a follow-up ADR may capture the mechanism if that
  choice itself crosses the ADR threshold.
