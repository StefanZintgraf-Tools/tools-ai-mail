# ai-mail

The ubiquitous language for **ai-mail** — a suite of mailbox-assistance modules (M1–M6) that
share a kernel of primitives. This glossary is system-wide: kernel terms are true across every
module; module-scoped terms are added lazily as each module is built. M2 (Attachment Auto-Router)
is the first module.

## Language

### Shared kernel — true across all modules

**Proposal**:
A system-suggested action object that the headless pipeline produces, carrying its content and a
**Confidence** score. It exists independently of any human and is the artifact the golden corpus
grades. Each module specializes the action: in M2 it is filing one **Attachment** into a
**Target Location**.
_Avoid_: suggestion, recommendation, routing decision (for the object).

**Approval Request**:
The runtime event of presenting a **Proposal** to the **User** for an approve / edit / reject
decision — the human-in-the-loop gate (HumanLayer `require_approval` pattern, F16). A Proposal
becomes an Approval Request only on the human-in-the-loop path; corpus grading never raises one.
_Avoid_: confirmation, prompt, approval (for the gate as a whole).

**Mail**:
One email message; carries zero or more **Attachments**; the input the pipeline scans. Not the
unit of routing.
_Avoid_: email, message, item.

**Attachment**:
One file carried by one **Mail** — **the atomic unit of routing**, and the subject of exactly one
**Proposal**. "Every file the Mail carries" — the judgment of whether an Attachment is worth filing
belongs to F01 (detect-attachment), which may detect-but-filter inline images, footer logos, and
signatures; such filtering does not make them "not Attachments". Distinct from the filed copy that
lands in the Target Location.
_Avoid_: file, document, enclosure.

**Target Location**:
The place a **Proposal** routes its subject to. In M2, specialized to *an existing folder on
the local/network filesystem*, drawn from a closed set (CON-4) — never fabricated. Across ai-mail
the destination may instead be a mail action, ERP record, or Pipedrive entity (M3/M4).
_Avoid_: target folder, destination, store, target.

**Staging Area** (`_review/`):
The holding place for **Attachments** the pipeline could not confidently route — an explicit
"no Target Location yet" outcome (the fallback for unknown mappings and below-threshold
**Confidence**, CON-4/CON-5). It is also the **no-silent-drop** landing for an **errored**
Attachment — one that cannot be hashed, parsed, or copied — which lands here as an explicit *errored*
outcome rather than vanishing (C-014). It is **not** a Target Location: corpus grading scores
landing here as "no decision / deferred", never as a correct folder.
_Avoid_: review folder (as if it were just another Target Location), quarantine.

**Sender**:
The originating identity of a **Mail**, used as a routing key. In M2 v1 this is the **From email
address**, verbatim. Organization-level grouping (many addresses → one org) is deferred to M2b
(F30 sender→location map); an unrecognized address simply misses the map and routes to the
**Staging Area**.
_Avoid_: from, author, contact, customer (for the v1 key).

**Routing Key**:
What F04 maps to a **Target Location**. In M2 v1 it is the **Sender** alone (one-dimensional).
Document Type as a second dimension is deferred to M2b; later modules add further dimensions
(e.g. project number, recipient address for shared mailboxes). M2 deliberately keeps it minimal.
A one-dimensional key is **single-valued only when each sender files into one folder**; a sender
that historically spans multiple folders is below-confidence by construction and routes to the
**Staging Area** — the document-type dimension that disambiguates such senders is a must-have in M2b.

**Document Type** *(M2b)*:
The label F03 assigns to an **Attachment** (invoice, contract, bank-statement, delivery-note,
license-agreement, …). **Deferred to M2b** — v1 routes by **Sender only**, so M2 produces no Document
Type and the Routing Key is one-dimensional. When F03 returns in M2b it is a **closed but editable
enum** held in a **single source** both F03 and the golden corpus read (adding a label = one-line
edit + re-grade, not code surgery); `other` means "type unrecognized" and routes to the **Staging
Area**, never to a Target Location.
_Avoid_: category, kind, class.

**Confidence**:
A per-decision score in [0,1]. M2 v1 produces **one**: **location-confidence** (F04) — how sure the
router is of the folder. The **Confidence gate** compares it to the configured threshold; below it,
the **Proposal** routes to the **Staging Area** (CON-5). The Proposal displays the score so the User
sees the weak ones. (M2b reintroduces **type-confidence** from F03, and the gate becomes
**min(type, location)**.)
_Avoid_: a single blended score, certainty, probability.

**Provenance**:
The link between a filed copy and its source **Mail**, in two parts. The **Provenance back-link**
is the origin stamp carried with the filed copy (Message-ID, date, **Sender**); it answers Copy→Mail.
The **Provenance Ledger** is an external append record mapping `source Mail ↔ filed copy`; it
answers Mail→Copy *without annotating the mail* (required because CON-1 forbids write-back to the
mailbox), and it is the **same store F22 reads for dedup** (CON-6). Two keys, deliberately separate:
the **dedup decision** (write the file at all?) keys on **content-hash only** — so a missing or
reused Message-ID can never cause a duplicate file; the **provenance link** keys on
`(Message-ID, content-hash)`, where Message-ID is the portable, access-method-independent mail
identity (synthetic `hash(from+date+subject)` fallback when absent). One store, two jobs:
findability and dedup. The User routinely archives or moves the source **Mail** within the mailbox
after filing; this is *why* both keys are location-independent — `Message-ID` (not folder path or
IMAP UID) — and why CON-1's no-write-back rule leaves the User free to reorganize without breaking
either lookup direction. In v1, resolving either direction is **manual ledger inspection** — the
ledger is a greppable artifact; no dedicated lookup tool is built.
_Avoid_: audit log, history, metadata (for the ledger specifically); IMAP UID / Graph item-ID (for
the mail identity — not portable).

**User**:
The single actor — the **Mail**box owner, who is also the approver of every **Approval Request**.
ai-mail has one actor role throughout (no separate "owner vs approver"); many humans may each
operate their own instance, but the role is one.
_Avoid_: operator, reviewer, approver, admin (as if distinct roles).

**Approval Surface**:
A thin, **swappable adapter** that renders **Proposals** to the **User** and returns approve / edit
/ reject decisions, then triggers the commit. The pipeline emits Proposals as a UI-agnostic
contract; surfaces are adapters over it — **no routing or approval logic lives in the surface**.
M2's first surface is the plan/apply file; a later Outlook-plugin GUI is just another adapter over
the same contract (see ADR-0002).
_Avoid_: UI, frontend, GUI (as if the surface were the architecture).

**Action Plan**:
The batch serialization of all **Proposals** for one pipeline run — M2's plan/apply file (YAML),
which the **User** hand-edits (rename / re-target / skip) and then `apply`
executes for approved rows only. The same structure the golden corpus grades.
_Avoid_: report, output, manifest, queue.

**Golden Corpus**:
The labelled reference set the headless pipeline is graded against — each entry pairs an input
**Mail**/**Attachment** with its correct outcome (in M2: the correct **Target Location** by **Sender**,
or "**Staging Area** / no decision" for below-**Confidence** or multi-folder senders). It grades
**Proposals** directly and never raises an **Approval Request**. The **Action Plan** shares its structure.
_Avoid_: test set, dataset, fixtures (for the graded reference set).

**Target Filename**:
The name the filed copy is stored under in its **Target Location** — a slot on every **Proposal**
from v1. In M2 it defaults to the original **Attachment** name and is editable by the **User** in
the **Action Plan** (free manual rename). In M2b it is *suggested* by inferring the Target
Location's **Naming Scheme** (new primitive F32 · infer-filename, sibling of F31); the User still
approves or edits. Renaming itself is not a primitive — F22 writes under whatever name the Proposal
carries. On a same-path/different-content collision, F22 applies a deterministic **mail-date prefix**
(`YYYY-MM-DD-<original>`) as a one-shot tiebreaker before declaring a **Conflict** — a fixed rule, *not*
the M2b **Naming Scheme** inference (F32).
_Avoid_: filename, title (without the "target/filed" qualifier).

**Naming Scheme** *(M2b)*:
The filename convention a **Target Location** follows (e.g. `YYYY-MM-DD_invoice_<vendor>.pdf`),
inferred from the files already in the folder. Drives the suggested **Target Filename**. M2b
concept; M2 is only "aware" of it insofar as the Target Filename slot already exists.
_Avoid_: naming convention, pattern, format (use Naming Scheme).

**Conflict**:
The **terminal** state where a **Proposal** would write **different** content (same path, different
bytes) to a path that is *still* occupied **after** the deterministic tiebreaker. F22's pre-write
check first retries once under a **mail-date prefix** (`YYYY-MM-DD-<original>`); a same-path/different
-content collision is therefore **auto-resolved** in the common recurring case (e.g. a monthly
`rechnung.pdf`). Only when the date-prefixed path *also* holds different bytes (e.g. two distinct
same-named attachments in one mail, sharing a Date) is it a true Conflict → **routes to `_review/`
staging**, never committed or auto-overwritten; the dedicated in-plan rename / overwrite / skip
resolution workflow is deferred (FR-013). Never a primitive. Distinct from dedup: identical content
is silently de-duplicated (see **Provenance**), only differing content at the same path conflicts.
_Avoid_: duplicate (a duplicate is dedup, not a Conflict).

### M2 · Attachment Auto-Router

**Routing Root**:
A folder the **User** declares as a scanning root (e.g. `D:\Documents\Filing`). The closed set of
valid **Target Locations** is *every existing folder discovered beneath the Routing Roots* — leaf
and intermediate, at any depth (CON-4: existing only, never fabricated). New subfolders join the set
automatically on the next run; the golden corpus grades F04 against a **snapshot** of the discovered
set.
_Avoid_: base folder, scan path, root (unqualified).

**Run Scope**:
The set of **Mails** one pipeline run processes — a *trigger/adapter* concern, not the core (the
core just consumes a set of Mails). M2's batch adapter defines it as a User-specified folder
(date-range narrowing deferred); the future Outlook-plugin adapter defines it as "this one open Mail". Because
dedup is content-hash based and re-runs are silent no-ops, Run Scope is an **efficiency** choice,
never a correctness one — re-scanning is always safe; "since last run" incrementality is a deferred
optimization.
_Avoid_: filter, query, batch (for the selected set).
