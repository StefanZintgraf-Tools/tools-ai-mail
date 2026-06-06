# todo

Next step to continue, see unchecked "[ ]" term

- [ ] analyse, run and test the newly created skills.
      - [x] `ubiquitous-language-guard` — **lens** · enforce the glossary on `requirements.md`; write approved new/changed terms back into `CONTEXT.md` (HITL).
      - [x] `pareto-scope-cut` — **lens** · cut imagined/future scope (ai-mail: defer M2b/M3/M4); append a Postponed-decisions log.
      - [x] `domain-model` — **authoring** · produce the conceptual model (glossary-aware, VO/aggregate-aware) → `docs/entity_model.md`.
      - [x] `adr-threshold-gate docs/entity_model.md` — **lens** · catch any irreversible modelling decision → `docs/adr/####-*.md` (proposed; HITL to accept).
      - [x] `hidden-constraint-sweep docs/entity_model.md` — **lens** · the 8-class sweep (retention / concurrency / PII / …) the model implies. All 4 missing gaps now resolved into the model + requirements.
        - [x] let's work on Gap 1 out of these findings. Goal: update the related planning artifacts of ai-mail (located in plan and docs folders).
        - [x] let's work on Gap 3 out of these findings. Goal: update the related planning artifacts of ai-mail (located in plan and docs folders).
        - [x] let's work on Gap 5 out of these findings. Goal: update the related planning artifacts of ai-mail (located in plan and docs folders).
        - [x] let's work on Gap 7 out of these findings. Goal: update the related planning artifacts of ai-mail (located in plan and docs folders).
      - [x] requirements.md was modified --> run domain-model again? Update workflow.md if yes
      - [x] re-run /hidden-constraint-sweep docs/entity_model.md
      - [x] `/usecase-diag` — **authoring** + lenses · → `docs/use_cases.puml` (forward FR→UC coverage).
      - [x] `/usecase-spec` — **authoring** + lenses · → `docs/use_cases/*.md` (fail-closed reverse coverage + `Requirements covered` trace line).
      - [x] manual review of the use-cases
      - [ ] session Frage beantworten
      - [ ] `/trace-check` — **lens** · cross-artifact consistency (UC→FR, entity-in-spec, actor↔glossary, BR↔invariant). 
        Frage: muss man alles zurueckverfolgen? also nicht nur bis zu requirements.md sondern komplett? 
        - /trace-check dann /adr-threshold-gate docs/entity_model oder andersrum?
        - update workflow.md
  

- review created artifacts and how to use them
  - what are the input artifacts for the vanilla pocock skills
    - prototype
    - to-prd
    - to-issues
    - tdd
  - how to change the vanilla pocock skills to take benefit from the new artifacts
  - continue with pocock skills?

- use openspec, benefits?
  - C:\PROJ\github\OpenSpec.1.4.1


- [ ] potential next steps: see todo_ideas.md
