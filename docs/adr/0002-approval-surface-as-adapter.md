# Approval Surface as a Swappable Adapter (plan/apply file first)

**Status:** accepted

## Context

CON-8 left M2's approval surface open. A future version will likely want a GUI (e.g. an Outlook
plugin with an "file these attachments" button on the open mail). The risk: picking a surface for M2
that paints us into a corner the GUI can't reuse. M2 is also built in spare time (CON-3 Pareto) and
needs a golden-corpus artifact to grade the pipeline against.

## Decision

Treat the **Proposal** as a UI-agnostic data contract emitted by the headless propose-pipeline
(F01→F04). Every **Approval Surface** is a thin, swappable adapter over that contract: it renders
Proposals, collects approve / edit / reject decisions, and triggers F22 — **no routing or approval
logic lives in the surface**. M2 ships the cheapest surface that exercises the full contract: a
**plan/apply editable file** (YAML **Action Plan** → hand-edit → `apply` commits approved rows). A
later Outlook-plugin GUI is an *additional* adapter over the same contract, not a rewrite.

## Considered Options

- **Synchronous per-file CLI prompt** — simple but blocks the User per attachment; poor for batch
  backfill.
- **`_review/` queue of files** — no central view; the rename/select/conflict decisions get clumsy.
- **Channel approval (Slack/HumanLayer)** — heavyweight external dependency, anti-Pareto for v1.
- **Build the GUI now** — expensive (CON-3), and gives nothing to grade.
- **plan/apply YAML file (chosen)** — async batch, no GUI, honors the human-decision points
  (rename / re-target / skip), and *doubles as the corpus artifact*.

## Consequences

- The Proposal contract must stay clean and surface-agnostic; leaking plan-file specifics into the
  pipeline would forfeit the GUI-reuse this decision buys.
- The plan-file format is semi-disposable; the durable asset is the Proposal/Action Plan contract.
- Single-mail interactive use (the future GUI's mode) and batch use are the same pipeline with N=1
  vs N>1 — both must be supported by the core, not just the batch surface.
