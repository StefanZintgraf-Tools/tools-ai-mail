# Requirements Reference

## ID Prefixes

| Prefix | Type                       | Example |
|--------|----------------------------|---------|
| FR     | Functional Requirement     | FR-001  |
| NFR    | Non-Functional Requirement | NFR-001 |
| C      | Constraint                 | C-001   |
| OOS    | Out-of-Scope / Non-Goal    | OOS-001 |

## Priority

| Priority | Description                                         |
|----------|-----------------------------------------------------|
| High     | Must have. Core functionality or critical quality.  |
| Medium   | Should have. Important but system works without it. |
| Low      | Nice to have. Can be deferred to future releases.   |

## Status

| Status      | Description                                    |
|-------------|------------------------------------------------|
| Open        | Requirement defined but not yet implemented.   |
| In Progress | Currently being implemented.                   |
| Implemented | Implementation complete, pending verification. |
| Verified    | Tested and confirmed working.                  |
| Deferred    | Postponed to a future release.                 |
| Rejected    | Removed from scope.                            |

## NFR Categories

| Category        | Description                                   |
|-----------------|-----------------------------------------------|
| Performance     | Speed, throughput, response time              |
| Scalability     | Ability to handle growth                      |
| Availability    | Uptime, fault tolerance                       |
| Security        | Authentication, authorization, encryption     |
| Usability       | User experience, accessibility                |
| Maintainability | Code quality, documentation, modularity       |
| Portability     | Platform independence, deployment flexibility |

## Constraint Categories

| Category    | Description                                   |
|-------------|-----------------------------------------------|
| Technical   | Technology stack, platforms, integrations     |
| Business    | Budget, resources, organizational policies    |
| Schedule    | Deadlines, milestones, time constraints       |
| Regulatory  | Legal, compliance, industry standards         |
| Operational | Deployment, maintenance, support requirements |

## Out-of-Scope Sources

Where a recorded non-goal came from (gr_algn Aln15, gr_idea Idea3). An
Out-of-Scope item carries forward a *decision not to do something*; it is not a
Constraint (a limit on how you build) or a Deferred FR status (in scope, not yet
built).

| Source           | Description                                                            |
|------------------|-----------------------------------------------------------------------|
| vision non-goal  | An explicit non-goal / out-of-scope item in the vision document.      |
| alignment reject | An option ruled out during grilling (alignment transcript).           |
| idea non-goal    | A negative goal distilled in the idea phase.                          |
| user             | A scope exclusion the user stated directly while writing requirements. |
