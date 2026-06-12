# Product Foundation Brainstorming — method review & feasibility map

This README reviews whether the `product-foundation-brainstorming` skill drives the
`bmad-brainstorming` engine with the **appropriate methods** for its job, and documents
which of the BMAD brainstorming methods are feasible for *this* skill and why.

It is grounded against the live BMAD-METHOD v6 source, not a secondary compilation:

- `src/core-skills/bmad-brainstorming/SKILL.md`
- `src/core-skills/bmad-brainstorming/assets/brain-methods.csv` — **108 techniques, 13 categories**
- `src/core-skills/bmad-brainstorming/references/converge.md` — the convergence moves

**The catalog's goal taxonomy** (the `good_for` column) is exactly:
`novel · unstuck · planning · feature · strategy · diagnosis · personal`.

## Verdict

**Yes — the skill uses appropriate methods, and they are grounded correctly.**

- This skill's intrinsic goal is **`novel`** (a foundation vision for a *new* product),
  framed **user-first** (with `personal`/`feature`-style empathy techniques) and held
  inside hard "no tech / no modules / no MVP-scoping" boundaries (frame §2).
- All **11 methods** named in `references/frame.md` exist in the live catalog, every
  `(category, provenance)` label matches `brain-methods.csv` exactly, and each selection
  fits the `novel` + user-first goal while respecting the no-scope boundaries.
- The single convergence move (**Affinity Clustering**) is used correctly — it is the
  recommended *first* "pile → handful" move in `converge.md`, and the frame deliberately
  forbids the ranking/MoSCoW moves that would violate §2.

Caveats are minor and are listed under [Risks](#risks-worth-holding-the-line-on).

---

## Table 1 — BMAD brainstorming methods (the "skills" the method offers)

*Overview of the brainstorming approaches the BMAD method supports, with the feasibility
column requested: why or why not each is feasible for this skill.*

| BMAD method / skill | What it is | Feasible for `product-foundation-brainstorming`? Why / why not |
|---|---|---|
| **`bmad-brainstorming`** (core) | Facilitated free-form session over the 108-technique catalog; targets 100+ ideas before organizing | **Yes — it is the engine.** This skill is a *launcher* that supplies stance + goal + technique order to this engine and reuses its memlog/resume machinery. Mandatory dependency. |
| **`bmad-party-mode`** | Multi-agent roundtable (PM, Architect, UX…) debating in character | **No — wrong altitude.** Pulls in PM/Architect/UX personas, i.e. design/tech voices the frame §2 explicitly bans this early. Would anchor on solutions, not the user's world. |
| **`bmad-advanced-elicitation`** | Deep-probes an existing draft/artifact | **Partial / downstream.** Nothing to elicit *against* at foundation stage. Useful *later* to stress-test the produced vision/use-case artifacts, not during this session. |
| **`bmad-cis-design-thinking`** | 7-step Empathize→Define→Ideate→Prototype→Test | **No as a whole, yes in spirit.** Its Empathize stage is exactly this skill's user-first stance, but Prototype/Test drag in solution+tech (§2 violation). The skill borrows the *empathy* idea via the Empathy Map technique instead. |
| **`bmad-cis-innovation-strategy`** | Market analysis → disruption vectors → strategic options → roadmap | **No.** Business-model/strategy/roadmap output is `strategy`-goal and scope-laden — the opposite of a plain-language user vision with no v1. |
| **`bmad-cis-problem-solving`** | Diagnosis → root cause → solution → implementation plan | **No.** `diagnosis`-goal and implementation-bound. This skill is opening up, not narrowing onto one problem to crack. |
| **`bmad-cis-storytelling`** | 10-step narrative crafting | **Partial overlap, not used.** The Session A "future press release / 5-star review" *is* a narrative artifact, but it is produced by the catalog's **Sci-Fi Artifact From the Future** technique inside one engine, not by spinning up a separate storytelling workflow. |
| **`bmad-cis-agent-*`** (Carson et al.) | Named persona wrappers around the CIS workflows | **No — redundant.** This skill already fixes a stance (Creative Partner) and a coach voice via `bmad-brainstorming`; a second persona layer adds nothing and risks re-eliciting the frame. |

> Note on the requested "additional row": feasibility is captured **per method** as the
> third column above (one explanation per row), which is the only sensible per-method
> reading — a single shared row could not say why each method does or doesn't fit.

---

## Table 2 — Catalog categories, feasibility for a vision/use-case session

*Which of the 13 catalog categories are appropriate for this skill's `novel` + user-first
goal under the no-tech/no-scope boundary.*

| Category (count) | Feasible here? | Why / why not |
|---|---|---|
| **structured** (15) | **Yes, selectively** | Source of the user-framing + shaping tools: Empathy Map, Lotus Blossom, Job to Be Done. Avoid the scope-y ones (Decision Tree, Solution Matrix, Backcasting). |
| **creative** (10) | **Yes — core diverge** | What If, Cross-Pollination, Concept Blending are top `novel` picks; pattern-stealing without committing to tech. |
| **deep** (13) | **Yes, one** | Assumption Reversal is the anti-anchoring engine for §0. Most others (Five Whys, Fishbone, Causal Loop) are `diagnosis` — out of scope. |
| **speculative_future** (8) | **Yes, one** | Sci-Fi Artifact From the Future is the canonical product-vision artifact (the future press release / fake review). Others trend toward strategy. |
| **theatrical** (7) | **Yes, one** | Persona Journey surfaces persona-specific use-cases in pure user POV. |
| **collaborative** (8) | **Yes, as fallback** | Random Stimulation breaks fixation when the pile clusters. Most others are `group`-only. |
| **introspective_delight** (8) | **No** | `personal`/life-decision oriented (solo); not product-vision work. |
| **biomimetic** (6) | **No** | `feature`/`strategy` mechanism-design — too solution-shaped for foundation stage. |
| **quantum** (6) | **No** | `strategy`/`diagnosis` framing; narrows rather than opens. |
| **cultural** (7) | **No** | Mostly `personal`/`strategy`; tangential to a plain-language user vision. |
| **wild** (7) | **No (optional spice)** | `unstuck` energy only; not needed when the diverge batch is already strong. |
| **absurdist** (6) | **No (optional spice)** | Same — fixation-breakers, not vision generators. |
| **constraint** (7) | **No — actively avoid** | Ship-in-60, One Feature Only, $0 Mandate are MVP/scoping moves — direct §2 violations. |

---

## Table 3 — The 11 selected methods, grounded vs. the live catalog

*This is the actual review: each method the frame uses, checked against `brain-methods.csv`,
with a feasibility verdict for this skill.*

| Session | Method | Catalog `category · provenance` (verified) | Catalog `good_for` | Role in frame | Feasible? Why |
|---|---|---|---|---|---|
| A (opener) | **Empathy Map** | structured · classic ✓ | feature, personal | Warm-up: user says/thinks/does/feels | **Yes** — operationalizes the §3 user-first stance; pure user POV, zero tech. |
| A (diverge) | **Assumption Reversal** | deep · classic ✓ | novel, diagnosis, strategy | Anti-anchoring engine for §0 | **Yes — keystone.** Flips "how it's done today," directly enforcing "forget the first feature." |
| A (diverge) | **What If Scenarios** | creative · signature ✓ | novel, unstuck, strategy | Detonate constraints incl. feasibility | **Yes** — top `novel` lead pick; "assume time/money/AI free" is pure vision fuel. |
| A (diverge) | **Cross-Pollination** | creative · signature ✓ | novel, feature, strategy | Steal patterns from other industries | **Yes** — strong `novel` default; steals the *pattern*, not the tech. |
| A (diverge) | **Concept Blending** | creative · signature ✓ | novel | Fuse product × other category | **Yes** — the #1 lead pick for "novel concept / new product." |
| A (fallback) | **Random Stimulation** | collaborative · classic ✓ | unstuck, novel | Break fixation if the pile clusters | **Yes** — correct as an `unstuck` contingency; `audience: either`, runs solo fine. |
| A (distill) | **Sci-Fi Artifact From the Future** | speculative_future · signature ✓ | novel, feature | Future press release / 5-star review = the vision | **Yes — perfect.** This technique's literal use case is the product-vision artifact (Working-Backwards in one move). |
| B (expand) | **Lotus Blossom** | structured · classic ✓ | feature, planning, novel | Vision → 8 high-level use-cases | **Yes, with care** — designed to expand a vision into themes; must be held at use-case altitude, not feature decomposition. |
| B (test) | **Job to Be Done** | structured · classic ✓ | feature, strategy, novel | Keep each use-case honest to a real job | **Yes, with care** — keeps use-cases user-true; watch the `feature` pull toward solutioning. |
| B (expand) | **Persona Journey** | theatrical · signature ✓ | feature, strategy | Walk §3 personas through their day | **Yes** — surfaces use-cases only one persona notices; stays in user POV. |
| B (converge) | **Affinity Clustering** | *convergence move* (`converge.md`) ✓ | n/a (not divergent) | Group use-cases into named themes | **Yes — correct & correctly fenced.** The recommended first "pile → handful" move; frame rightly forbids ranking/MoSCoW (would breach §2). |

---

## Risks — and how the skill now mitigates them

The drift risk is handled by the frame's **Altitude Guard** (§2): a line-by-line tripwire —
*"would a user who doesn't care how it's solved recognize this as their own words?"* — with a
banned-vocabulary list (*system, module, API, screen, MVP/v1, first/ship…*), a one-breath
redirect move, and a mandatory pass over each artifact before it's emitted. It is wired into
the three feature-leaning techniques at point of use and into both distill/converge steps.

1. **`feature`-tagged techniques can drift into feature-spec** *(Empathy Map, Lotus Blossom,
   Job to Be Done)* — **mitigated:** each now carries a point-of-use `↳ Altitude guard` note,
   and the guard's banned-vocabulary test catches "the system…/a dashboard…/needs a feature…".
2. **Lotus Blossom is a decomposition engine** — **mitigated:** its guard note requires every
   petal and sub-petal to read as "I can now …", not as a component or screen.
3. **No `constraint`/`planning` techniques — by design** — still true; the frame excludes One
   Feature Only / Ship-in-60 / Impact–Effort, and convergence uses Affinity Clustering *only*,
   with ranking/MoSCoW explicitly forbidden.
4. **`bmad-advanced-elicitation` is the natural *next* step**, not part of this skill — use it
   afterward to pressure-test the vision and use-case artifacts this session produces.

> Residual risk: the guard is coach-enforced, not a hard state machine (an LLM coach can't be
> one — the same constraint the SKILL.md acknowledges for sequencing). It lowers drift
> probability and catches it at the artifact gate; it can't make drift impossible.

## Bottom line

The method selection is **appropriate, complete for its goal, and accurately grounded** in the
live 108-technique catalog. The diverge → distill funnel (Assumption Reversal + 3 creative
`novel` techniques → Sci-Fi Artifact) and the expand → converge funnel (Lotus / JTBD / Persona
→ Affinity Clustering) are textbook fits for a user-first new-product vision, and the frame's
boundaries keep the inherently `feature`-leaning structured techniques from drifting into scope.
