---
name: pareto-scope-cut
description: >
  Applies a Pareto build-only-what-is-needed-now lens to a planning artifact:
  flags entities, functional requirements, and flows that exist for imagined or
  future needs rather than the project's current scope marker, splits them into
  in-scope vs deferred, and appends a "Postponed decisions" log. Use when the
  user asks to "cut scope", "trim scope", "apply Pareto", "defer future work",
  "what can we postpone", "build only what we need now", "remove gold-plating",
  "flag premature abstraction", "scope this down to the milestone", or wants to
  separate in-scope from deferred work and record postponed decisions. Step-agnostic:
  works on requirements, entity/domain models, use-case diagrams, and use-case specs.
---

# Pareto Scope Cut

A cross-cutting lens that enforces "build only what the next concrete requirement needs."
It takes a planning artifact plus the project's scope marker, flags everything built for
imagined or future needs, splits the artifact into **in-scope** vs **deferred**, and records
each deferral as a one-line postponed-decision so it is never silently re-decided.

## Instructions

1. Identify two inputs:
   - **The artifact** to scope-cut: any planning doc (requirements catalog, entity/domain model, use-case diagram, use-case spec).
   - **The scope marker**: the boundary that defines "now" — typically a milestone or phase marker named in a planning doc (e.g. the current milestone/phase the team committed to build). Take it as an argument if given; otherwise ask the user which marker defines current scope. NEVER guess the boundary silently.
2. Read the artifact and enumerate every scopeable item: entities, functional requirements (FRs), actors, use cases, flows, attributes, and any introduced abstraction/structure.
3. Classify each item against the scope marker using the rules below. Each item is either **in-scope** (needed by the current marker) or **deferred** (built for an imagined/future need).
4. For every deferred item, draft a one-line **postponed-decision record** (G9 format below).
5. Present the proposed split + the postponed-decisions log to the user. Get explicit approval BEFORE writing anything back (HITL gate).
6. On approval, append the deferred list and the "Postponed decisions" log to the artifact. Do not delete in-scope content; do not rewrite unrelated sections.

## Classification rules

Flag an item as **deferred** when any of these hold:

| Rule | Flag when… | Source |
|------|-----------|--------|
| G1 | The item is a clever, generalized, or "future-proof" design where a simpler explicit one meets the current need. | Boring, explicit, replaceable first |
| G3 | The item is an expensive-later-cheap decision dressed up early: plugin systems, multi-tenancy, i18n, advanced patterns — with no concrete requirement at the current marker. | Defer expensive decisions |
| G5 | The item is an abstraction (shared base, generic type, interface) extracted with fewer than two concrete cases demanding it. Extract shared structure ONLY when reused twice. | No premature abstraction |
| G10 | The item is sized for a multi-release roadmap rather than the next concrete requirement at the scope marker. | Smallest architecture for the next known requirement |

An item is **in-scope** only if it is directly required by a concrete requirement at or before the current scope marker. When unsure, ask the user — do not assume in-scope.

## Postponed-decision record (G9)

Every deferred item gets exactly one line, so the decision is written down and never silently re-decided:

```
- [<item id/name>] Deferred: <what was cut>. Reason: <imagined/future need, not at <marker>>. Revisit when: <concrete trigger>.
```

Example:

```
- [FR-12 Multi-tenant workspaces] Deferred: per-tenant isolation layer. Reason: no second tenant exists at current marker (G3/G10). Revisit when: a second paying tenant is signed.
```

## Output format

Append to the END of the artifact (behind the HITL approval gate):

```markdown
## Scope split (against <scope marker>)

### In scope
- <item> — <one-line why it is needed now>
- ...

### Deferred
- <item> — <one-line why it is future/imagined>
- ...

## Postponed decisions
- [<item>] Deferred: <what>. Reason: <why, cites G1/G3/G5/G10>. Revisit when: <trigger>.
- ...
```

## DO NOT

- Do NOT write to the artifact before showing the proposed split + log and getting explicit human approval.
- Do NOT delete or rewrite in-scope content — this skill only splits and appends.
- Do NOT model entities, maintain a glossary, gate ADRs, or sweep constraints — that is other skills' job. This skill ONLY does the scope cut and the postponed-decision log.
- Do NOT hard-code any specific project's milestone names or plan file paths. Read the scope marker generically from the argument or by asking.
- Do NOT defer an item without a one-line G9 postponed-decision record.
- Do NOT silently re-decide a previously postponed decision; reference the existing log line instead.

## Workflow

1. Resolve inputs: the artifact and the scope marker (arg, or ask the user).
2. Read the artifact; enumerate every scopeable item (entities, FRs, actors, use cases, flows, attributes, abstractions).
3. Classify each item in-scope vs deferred using the G1/G3/G5/G10 rules.
4. For each deferred item, draft a one-line G9 postponed-decision record.
5. Assemble the proposed "Scope split" + "Postponed decisions" sections.
6. Present to the user; STOP and request explicit approval (HITL gate).
7. On approval, append the two sections to the end of the artifact. Confirm what was written.
8. Validate:
   - Every enumerated item is classified exactly once (in-scope or deferred).
   - Every deferred item has a matching one-line postponed-decision record citing G1/G3/G5/G10.
   - No in-scope content was deleted or rewritten.
   - The scope marker is named in the "Scope split" heading.
