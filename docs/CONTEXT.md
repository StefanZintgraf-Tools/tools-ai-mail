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
The destination a **Proposal** routes its subject to. In M2, specialized to *an existing folder on
the local/network filesystem*, drawn from a closed set (CON-4) — never fabricated. Across ai-mail
the destination may instead be a mail action, ERP record, or Pipedrive entity (M3/M4).
_Avoid_: target folder, destination, store, target.

**Staging Area** (`_review/`):
The holding place for **Attachments** the pipeline could not confidently route — an explicit
"no Target Location yet" outcome (the fallback for unknown mappings and below-threshold
**Confidence**, CON-4/CON-5). It is **not** a Target Location: corpus grading scores landing here as
"no decision / deferred", never as a correct folder.
_Avoid_: review folder (as if it were just another Target Location), quarantine.

**Sender**:
The originating identity of a **Mail**, used as a routing key. In M2 v1 this is the **From email
address**, verbatim. Organization-level grouping (many addresses → one org) is deferred to M2b
(F30 sender→location map); an unrecognized address simply misses the map and routes to the
**Staging Area**.
_Avoid_: from, author, contact, customer (for the v1 key).

**Routing Key**:
The tuple F04 maps to a **Target Location**. In M2 it is **(Sender × Document Type)**. Later modules
add dimensions (e.g. project number, recipient address for shared mailboxes); M2 deliberately keeps
it two-dimensional.

**Document Type**:
The label F03 assigns to an **Attachment** (invoice, contract, bank-statement, delivery-note,
license-agreement, …) — one half of the **Routing Key**. A **closed enum** at any given moment (so
F03 and the golden corpus always agree on the label space), but held in a **single editable source**
both read, so adding a label is a one-line edit + re-grade, not code surgery. `other` is a real
label meaning "type unrecognized" and always routes to the **Staging Area**, never to a Target
Location. Distinct from the closed set of Target Locations — F04 is the map between the two sets.
_Avoid_: category, kind, class.

**Confidence**:
A per-decision score in [0,1]. M2 produces **two**, kept separate: **type-confidence** (F03) and
**location-confidence** (F04) — you can be sure of the type yet unsure of the folder. The
**Confidence gate** compares **min(type-confidence, location-confidence)** to the configured
threshold; below it, the **Proposal** routes to the **Staging Area** (CON-5). The Proposal displays
**both** scores so the User sees which half is weak.
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
findability and dedup.
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
which the **User** hand-edits (rename / re-target / skip / clear-conflict) and then `apply`
executes for approved rows only. The same structure the golden corpus grades.
_Avoid_: report, output, manifest, queue.

**Target Filename**:
The name the filed copy is stored under in its **Target Location** — a slot on every **Proposal**
from v1. In M2 it defaults to the original **Attachment** name and is editable by the **User** in
the **Action Plan** (free manual rename). In M2b it is *suggested* by inferring the Target
Location's **Naming Scheme** (new primitive F32 · infer-filename, sibling of F31); the User still
approves or edits. Renaming itself is not a primitive — F22 writes under whatever name the Proposal
carries.
_Avoid_: filename, title (without the "target/filed" qualifier).

**Naming Scheme** *(M2b)*:
The filename convention a **Target Location** follows (e.g. `YYYY-MM-DD_invoice_<vendor>.pdf`),
inferred from the files already in the folder. Drives the suggested **Target Filename**. M2b
concept; M2 is only "aware" of it insofar as the Target Filename slot already exists.
_Avoid_: naming convention, pattern, format (use Naming Scheme).

**Conflict**:
The state where a **Proposal** would write to a target path that already holds a file of
**different** content (same path, different bytes). Detection is F22's pre-write check; *resolution*
is a flag the **User** clears in the **Action Plan** (rename / overwrite / skip). Never
auto-resolved, never a primitive. Distinct from dedup: identical content is silently de-duplicated
(see **Provenance**), only differing content at the same path is a Conflict.
_Avoid_: collision, duplicate (a duplicate is dedup, not a Conflict).

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
core just consumes a set of Mails). M2's batch adapter defines it as a User-specified folder +
optional date range; the future Outlook-plugin adapter defines it as "this one open Mail". Because
dedup is content-hash based and re-runs are silent no-ops, Run Scope is an **efficiency** choice,
never a correctness one — re-scanning is always safe; "since last run" incrementality is a deferred
optimization.
_Avoid_: filter, query, batch (for the selected set).
