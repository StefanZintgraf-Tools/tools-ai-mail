---
name: pareto-scope-cut
description: >
  Applies a Pareto build-only-what-is-needed-now lens to a planning artifact:
  flags entities, functional requirements, flows, and abstractions (generic base
  types, plugin/framework hooks, premature interfaces) that exist for imagined or
  future needs rather than the project's current scope marker, splits them into
  in-scope vs deferred, and appends a "Postponed decisions" log. Use when the
  user asks to "cut scope", "trim scope", "apply Pareto", "defer future work",
  "what can we postpone", "build only what we need now", "remove gold-plating",
  "flag premature abstraction", "defer a framework/ORM/plugin system", "scope this
  down to the milestone", or wants to separate in-scope from deferred work and
  record postponed decisions. Step-agnostic: works on requirements, entity/domain
  models, use-case diagrams, and use-case specs.
---

# Pareto Scope Cut

A cross-cutting lens that enforces "build only what the next concrete requirement needs."
It takes a planning artifact plus the project's scope marker, flags everything built for
imagined or future needs, splits the artifact into **in-scope** vs **deferred**, and records
each deferral as a one-line postponed-decision so it is never silently re-decided.

## Inputs

1. **The artifact** to scope-cut — any one planning doc: a requirements catalog, entity/domain
   model, use-case diagram (`*.puml`), or a use-case spec (`use_cases/*.md`). Named by the user
   or the file in focus.
2. **The scope marker** — the boundary that defines "now," typically a milestone or phase marker
   named in a planning doc (the current milestone/phase the team committed to build). Take it as
   an argument if given; otherwise ask the user which marker defines current scope. NEVER guess
   the boundary silently, and never hard-code a project's milestone names or plan file paths.
3. **The marker's requirement set** — also read the concrete requirements the marker *commits to*,
   from the planning doc that names it. You classify against what the marker actually requires, not
   against its name alone; a bare marker name is not enough to decide in-scope vs deferred. If you
   cannot find the marker's requirements, ask the user for them rather than guessing.
   - **Ordering ("at or before"):** if markers are sequential (phases/milestones in order), an item
     is in-scope when a concrete requirement at the current marker *or any earlier one* needs it.
     Determine the order from the same planning doc that lists the markers. If the ordering cannot
     be determined, treat only the named current marker as "now" and ask the user about any item
     that looks like it belongs to an earlier marker.

## Procedure

1. **Resolve inputs** — the artifact, the scope marker, and the marker's requirement set (§Inputs).
2. **Enumerate every scopeable item** in the artifact: entities, functional requirements (FRs),
   actors, use cases, flows, attributes, and any introduced abstraction/structure. "Abstraction"
   is concrete here — e.g. a generic base entity or catch-all `Item`/`Thing` supertype, an
   abstract/interface actor standing in for several concrete ones, a configurable rule engine
   where one hard-coded rule suffices, or a plugin/extension point with no second plugin yet.
3. **Classify each item** in-scope vs deferred using the G1/G3/G5/G6/G10 rules below.
4. **Draft a one-line G9 postponed-decision record** (canonical format below) for every deferred item.
5. **Assemble** the proposed "Scope split" + "Postponed decisions" sections.
6. **HITL gate** — present the proposed split + log to the user, then STOP and request explicit
   approval. Write nothing before approval.
7. **Write back on approval** — append the two sections to the END of the artifact, then confirm
   what was written. **Idempotency:** if the artifact already contains a `## Scope split` and/or
   `## Postponed decisions` section from a previous run, REPLACE those sections in place rather than
   appending — never leave two copies. Do not delete in-scope content or rewrite unrelated sections.
8. **Validate:**
   - Every enumerated item is classified exactly once (in-scope or deferred).
   - Every deferred item has a matching one-line postponed-decision record citing G1/G3/G5/G6/G10.
   - No in-scope content was deleted or rewritten.
   - The scope marker is named in the "Scope split" heading.
   - No duplicate "Scope split" / "Postponed decisions" sections remain.

## Classification rules

Flag an item as **deferred** when any of these hold:

| Rule | Flag when… |
|------|-----------|
| G1 | The item is a clever, generalized, or "future-proof" design where a simpler explicit one meets the current need. |
| G3 | The item is an expensive-later-cheap decision dressed up early: multi-tenancy, internationalization, advanced patterns — with no concrete requirement at the current marker. |
| G5 | The item is an abstraction (shared base, generic type, interface) extracted with fewer than two concrete cases demanding it. Extract shared structure ONLY when reused twice. |
| G6 | The item introduces a framework, ORM, message bus, or plugin/extension system the current scope does not require. |
| G10 | The item is sized for a multi-release roadmap rather than the next concrete requirement at the scope marker. |

An item is **in-scope** only if it is directly required by a concrete requirement at or before the
current scope marker (see ordering in §Inputs). When unsure, ask the user — do not assume in-scope.
An item that is *neither* required now *nor* a future/imagined feature (genuinely dead or irrelevant
content) is outside this skill's job: leave it untouched and note it to the user rather than forcing
it into a bucket.

## Postponed-decision record (G9)

Every deferred item gets exactly one line, so the decision is written down and never silently
re-decided. This is the one canonical format — used in both the log and the output below:

```
- [<item id/name>] Deferred: <what was cut>. Reason: <why, cites G1/G3/G5/G6/G10>. Revisit when: <concrete trigger>.
```

Example:

```
- [FR-12 Multi-tenant workspaces] Deferred: per-tenant isolation layer. Reason: no second tenant exists at current marker (G3/G10). Revisit when: a second paying tenant is signed.
```

## Output format

Append to (or, on re-run, replace at) the END of the artifact, behind the HITL approval gate:

```markdown
## Scope split (against <scope marker>)

### In scope
- <item> — <one-line why it is needed now>
- ...

### Deferred
- <item> — <one-line why it is future/imagined>
- ...

## Postponed decisions
- [<item>] Deferred: <what>. Reason: <why, cites G1/G3/G5/G6/G10>. Revisit when: <trigger>.
- ...
```

## DO NOT

- Do NOT write to the artifact before showing the proposed split + log and getting explicit human approval.
- Do NOT append a second "Scope split" / "Postponed decisions" section on re-run — replace the existing ones in place.
- Do NOT delete or rewrite in-scope content — this skill only splits and appends/replaces.
- Do NOT classify against the marker's *name* alone — read the requirements it commits to, and ask if they are unavailable.
- Do NOT model entities, maintain a glossary, gate ADRs, or sweep constraints — that is other skills' job. This skill ONLY does the scope cut and the postponed-decision log.
- Do NOT hard-code any specific project's milestone names or plan file paths. Read the scope marker generically from the argument or by asking.
- Do NOT defer an item without a one-line G9 postponed-decision record.
- Do NOT silently re-decide a previously postponed decision; reference the existing log line instead.
