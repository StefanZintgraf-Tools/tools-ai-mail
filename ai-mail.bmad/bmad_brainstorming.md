# BMAD Brainstorming — Complete Guide & Method Chooser

> Compiled from the BMAD-METHOD v6 sources (`bmad-brainstorming` skill, technique catalog
> `brain-methods.csv` with 108 techniques, the catalog deep-analysis, `llms-full.txt`,
> and the CIS — Creative Intelligence Suite). Last updated: 2026-06-11.

---

## 1. The Brainstorming Options at a Glance

| Option | Skill | What it is | Reach for it when |
|---|---|---|---|
| **Core brainstorming** | `bmad-brainstorming` | Facilitated free-form session over a library of 108 techniques; targets **100+ ideas** before organizing | You have a topic and want maximum ideas — the default choice |
| **Party mode** | `bmad-party-mode` | Multi-agent roundtable (PM, Architect, UX, …) debating in character | You want diverse *expert perspectives*, disagreement, and cross-talk |
| **Advanced elicitation** | `bmad-advanced-elicitation` | Deep-probing of an existing draft/artifact | You already have content and want it stress-tested or enriched |
| **CIS: Design Thinking** | `bmad-cis-design-thinking` | 7-step Empathize → Define → Ideate → Prototype → Test workflow | Human-centered product/service design with real users |
| **CIS: Innovation Strategy** | `bmad-cis-innovation-strategy` | 9-step market analysis → disruption vectors → 3 strategic options → roadmap | Business-model innovation, disruption hunting |
| **CIS: Problem Solving** | `bmad-cis-problem-solving` | 9-step diagnosis → root cause → solutions → implementation plan | A concrete *problem* to crack, not open ideation |
| **CIS: Storytelling** | `bmad-cis-storytelling` | 10-step narrative crafting (framework, arc, hook, variations) | Pitch, brand story, case study |
| **CIS agents** | `bmad-cis-agent-*` | Named personas (e.g. **Carson**, Brainstorming Coach) wrapping the workflows | You like a persistent coach personality across the session |

**Rule of thumb:** open-ended ideation → `bmad-brainstorming`. A defined problem →
`bmad-cis-problem-solving`. A business/strategy question → `bmad-cis-innovation-strategy`.
Users at the center → `bmad-cis-design-thinking`. Need a narrative → `bmad-cis-storytelling`.

---

## 2. How a Core Session Works

1. **Setup** — topic + goal ("the why") + constraints. The *why* steers technique choice.
2. **Stance** — pick one, holds for the whole run:
   - **Facilitator** — the AI never supplies ideas; pure forcing-function for *yours*.
   - **Creative Partner** — you trade ideas back and forth (authorship is tracked).
   - **Ideate for me** — the AI runs the whole session solo and shows the result.
3. **Technique batch** — via the browser **composer page** (visual catalog, copy-paste prompt)
   or in chat. **3–4 techniques is the sweet spot.** You can also say `you choose N`
   (AI picks for your goal) or `invent N` (brand-new techniques on the fly).
4. **Diverge** — run each technique until it stops producing. Anti-bias protocol: the
   creative domain shifts every 5–10 turns / ~10 ideas to prevent clustering.
   **The magic happens in ideas 50–100** — resist concluding early.
5. **Converge** (explicit, separate phase — never mixed into generation): cluster,
   prioritize, decide. Moves: Affinity Clustering, Dot Voting, Impact–Effort Matrix,
   NUF Test, PMI, MoSCoW.
6. **Wrap-up** — synthesis, themes, action items; everything saved to a session document
   (a `.memlog.md` keeps state on disk, so sessions survive interruption and can be resumed).

---

## 3. Choosing the Right Techniques — Goal Router

This is the official goal → technique affinity from the catalog analysis. Lead picks **bold**.

| Your goal | Strong default techniques |
|---|---|
| **Build a feature** (green/brownfield) | **First Principles**, **SCAMPER**, **Morphological Analysis**, Crazy 8s, Solution Matrix, Reverse Brainstorming, One Feature Only, Ship in 60 Minutes, Job to Be Done, Cursed Genie (edge cases) |
| **Novel concept / new product** | **Concept Blending**, **Cross-Pollination**, **Forced Relationships**, What If Scenarios, Trait Transfer, Nature's Solutions, Emerging Tech Collision, Quantum Tunneling |
| **Personal / life decision** | **Future Self Interview**, **Values Archaeology**, **Laddering**, Six Thinking Hats, Ancestor Council, the whole *Introspective* category |
| **Strategy / positioning** | **Six Thinking Hats**, **Failure Analysis** (pre-mortem), Ecosystem Thinking, Utopia vs Dystopia, 1000x Budget, Disney Method, Scenario Cross |
| **Concrete planning** (event/project) | **Mind Mapping**, **Lotus Blossom**, Morphological Analysis, Decision Tree Mapping, Backcasting, $0 Mandate, Time Horizon Ladder |
| **Root-cause / diagnosis** | **Five Whys**, **Causal Loop Mapping**, Fishbone Diagram, Failure Analysis, Question Storming, Starbursting, Alien Anthropologist |
| **Get unstuck / break fixation** | **Random Stimulation**, **Provocation Technique**, **Worst Possible Idea**, Crank the Dial to 11, Constraint Roulette, Three Rounds of Stupid, most of *Wild*/*Absurdist* |

**Provenance tiers** (tagged per technique below):
- `classic` — recognized professional methods (SCAMPER, Six Hats, Five Whys…). Safe for enterprise settings.
- `signature` — BMAD-original, serious.
- `playful` — the delight layer; great for energy and breaking fixation.

**Audience:** most techniques work `solo` (you + AI); a few collaborative ones shine with
a real `group` — noted where relevant.

---

## 4. The Full Catalog — 108 Techniques with Typical Use Cases

### 4.1 Structured & Analytical

#### Structured (15)

- **SCAMPER Method** `classic` — Run the idea through seven lenses: Substitute, Combine, Adapt, Modify, Put-to-other-use, Eliminate, Reverse.
  1. Evolving an existing product that feels stale
  2. Generating feature variations for a roadmap
  3. Repurposing an internal tool for customers
- **Six Thinking Hats** `classic` — Examine the problem six ways, one at a time: facts, feelings, benefits, risks, new ideas, process.
  1. Evaluating a major architecture or vendor decision
  2. Defusing an emotionally loaded team debate
  3. Doing a balanced solo review of your own plan
- **Decision Tree Mapping** `signature` — Chart every choice point and the paths it forks into, with outcome and risk per branch.
  1. Planning a migration with multiple fallback paths
  2. Mapping a pricing/packaging decision
  3. Choosing between career options with cascading consequences
- **Solution Matrix** `signature` — Grid problem variables against solution approaches, score every cell, hunt best pairings and gaps.
  1. Comparing implementation approaches across requirements
  2. Matching marketing channels to customer segments
  3. Spotting unserved combinations in a feature space
- **Trait Transfer** `signature` — Name what makes an unrelated success work, then graft those traits onto your problem.
  1. Borrowing what makes a beloved app addictive for your onboarding
  2. Applying a great restaurant's service model to support
  3. Stealing open-source community dynamics for internal docs
- **Lotus Blossom** `classic` — Theme at the center of a 3×3 grid; fill the 8 cells, then each cell becomes a new center.
  1. Systematically expanding a product vision into themes and sub-features
  2. Building a content/topic plan from one core message
  3. Decomposing a vague goal ("improve quality") into 64 concrete angles
- **Worst Possible Idea** `classic` — Deliberately generate terrible solutions, then flip each into what it teaches.
  1. Warming up a group that's afraid to speak
  2. Surfacing hidden assumptions about what "good" means
  3. Escaping fixation when every "sensible" idea looks the same
- **Disney Method** `classic` — Cycle through three rooms: Dreamer (anything goes), Realist (how we'd build), Critic (what breaks).
  1. Taking a moonshot feature from fantasy to a buildable spec
  2. Pitch preparation — pre-empting the critics
  3. Balancing visionaries and skeptics on one team
- **Starbursting** `classic` — Interrogate the idea with only questions — who, what, where, when, why, how — before answering any.
  1. Kicking off discovery on a new epic or initiative
  2. Stress-testing a feature brief before writing the PRD
  3. Preparing stakeholder interview questions
- **Mind Mapping** `classic` — Branch the central topic outward; follow tangents and let the web sprawl.
  1. First exploration of a brand-new domain
  2. Organizing a conference talk or article
  3. Untangling everything connected to a messy legacy system
- **Crazy 8s** `classic` — Eight ideas in eight minutes, one per box, no editing.
  1. Rapid UI/UX sketch variations for one screen
  2. Generating headline/naming options fast
  3. Breaking analysis paralysis at sprint start
- **How Might We** `classic` — Reframe the problem as "How might we…" opportunity questions, then ideate against the sharpest one.
  1. Turning user-research pain points into design prompts
  2. Reframing a complaint ("checkout is slow") into solution space
  3. Aligning a workshop group on which problem to attack
- **Job to Be Done** `classic` — Ask what the user is really *hiring* this to do; ideate around that job, not the assumed feature.
  1. Deciding whether a requested feature solves the real need
  2. Finding the underserved job behind churn
  3. Positioning a product against non-obvious competitors
- **Empathy Map** `classic` — Map what the user says, thinks, does, and feels; mine each quadrant for the unmet need.
  1. Synthesizing user interviews before ideating
  2. Aligning a team on who the user actually is
  3. Finding the emotional gap a feature should close
- **Backcasting** `classic` — Fix the finished future in vivid detail, then work backward to the first move.
  1. Planning a 12-month product transformation
  2. Defining the path to a launch date that cannot slip
  3. Personal goal planning (where do I want to be in 5 years?)

#### Deep (13)

- **Five Whys** `classic` — Ask "why?" five times in a chain until you hit the root cause beneath the symptom.
  1. Post-incident analysis of an outage or bug
  2. Understanding why a process keeps failing
  3. Getting to the real reason behind a vague customer complaint
- **Provocation Technique** `classic` — State something deliberately absurd, then mine it: "how could this be useful?"
  1. Breaking a team out of incremental-only thinking
  2. Challenging an industry's sacred operating assumption
  3. Reviving a stalled session with a jolt
- **Assumption Reversal** `classic` — List every baked-in assumption, flip each, rebuild on the inverted foundation.
  1. Re-examining "users will never…" beliefs before a redesign
  2. Disrupting your own business model before a competitor does
  3. Questioning inherited technical constraints in legacy code
- **Question Storming** `classic` — Generate only questions, zero answers, until the real problem comes into focus.
  1. Scoping a fuzzy stakeholder request
  2. Research planning — what don't we know?
  3. Diagnosing why a project feels stuck despite activity
- **Constraint Mapping** `signature` — Map every constraint, sort real from imagined, then attack each: dissolve, route around, or exploit.
  1. Auditing why a feature is "impossible" to build
  2. Budget planning when everything feels fixed
  3. Finding which compliance limits are actually negotiable
- **Failure Analysis** `signature` — Dissect a relevant failure: what broke, why, the lesson, and how to apply it here.
  1. Pre-mortem before a risky launch
  2. Learning from a competitor's flopped product
  3. Reviewing your own abandoned side projects before the next one
- **Emergent Thinking** `signature` — Stop forcing a solution; name what patterns the system keeps producing on its own.
  1. Spotting what users already do with your product unprompted
  2. Reading organic team behaviors before imposing process
  3. Identifying the strategy your org is *actually* following
- **Causal Loop Mapping** `classic` — Diagram feedback loops, find reinforcing and balancing cycles, target the leverage point.
  1. Understanding why tech debt keeps growing despite efforts
  2. Modeling growth dynamics (virality vs. churn)
  3. Untangling team-morale → quality → pressure spirals
- **Morphological Analysis** `classic` — List the problem's independent parameters, generate options per parameter, combine across.
  1. Exhaustively exploring a product configuration space
  2. Designing pricing (axes: metric × tier × billing model)
  3. Inventing new content formats by recombining attributes
- **Laddering** `classic` — Ask "and what would that give you?" up the chain to the real underlying need.
  1. Getting from feature requests to actual user needs
  2. Personal decisions — what is the job change really about?
  3. Sharpening marketing messaging to the deepest motivator
- **TRIZ Contradiction** `classic` — Name the core contradiction (improving X worsens Y), then find ways to win both.
  1. Performance vs. readability trade-offs in engineering
  2. Security vs. convenience in UX design
  3. Quality vs. shipping-speed conflicts in process design
- **Fishbone Diagram** `classic` — Branch the problem's spine into cause categories (people, process, tools, environment); mine each bone.
  1. Diagnosing a multi-factor quality problem
  2. Analyzing why releases keep slipping
  3. Structuring a retro around recurring incidents
- **Build on What Works** `classic` — Name what's already succeeding and why; amplify and extend it instead of fixing what's broken.
  1. Doubling down on your highest-retention feature
  2. Scaling one team's working ritual to the whole org
  3. Career planning from strengths rather than gaps

### 4.2 Creative & Generative

#### Creative (10)

- **What If Scenarios** `signature` — Detonate one constraint at a time — unlimited budget, opposite is true, problem vanished.
  1. Opening a strategy offsite with maximum ambition
  2. Testing how dependent your plan is on one assumption
  3. Escaping "we've always done it this way"
- **Analogical Thinking** `signature` — Ask "this is like what?" and steal the solution pattern from the answering domain.
  1. Solving an onboarding problem like a theme park manages queues
  2. Borrowing logistics patterns for data pipelines
  3. Explaining and rethinking a product via a familiar analogy
- **First Principles Thinking** `classic` — Strip every assumption to bedrock facts; rebuild the solution from truth alone.
  1. Re-architecting a system everyone says "must" work a certain way
  2. Cost analysis — what does this *actually* have to cost?
  3. Designing a process from scratch instead of patching the old one
- **Forced Relationships** `signature` — Grab two unrelated things at random and force a bridge until an idea falls out.
  1. Naming and branding sessions gone stale
  2. Inventing novel feature combinations
  3. Jolting a session where every idea sounds the same
- **Time Shifting** `signature` — Solve it as a 1900s artisan, then a 2150 colonist; harvest era-bound constraints and tricks.
  1. Simplifying an over-engineered product (what's the 1900 version?)
  2. Future-proofing a roadmap (what's the 2150 version?)
  3. Finding low-tech fallbacks for offline/degraded modes
- **Metaphor Mapping** `signature` — Declare the problem IS a metaphor, extend it fully, map parts back for insight.
  1. Reframing a team's relationship to tech debt ("it's a garden")
  2. Designing information architecture ("the app is a city")
  3. Communicating a complex system to stakeholders
- **Cross-Pollination** `signature` — Ask how a wildly different industry — casinos, ERs, beekeeping — would crack this.
  1. Importing hospitality patterns into SaaS support
  2. Applying aviation checklists to deployment safety
  3. Bringing game mechanics into an enterprise tool
- **Concept Blending** `signature` — Fuse two concepts into one new hybrid category; name what the merger *becomes*.
  1. Inventing new product categories ("Strava × journaling")
  2. Differentiating in a crowded market
  3. Creating workshop formats or content series
- **Reverse Brainstorming** `classic` — Generate problems instead of solutions — "how could we make this fail?" — then invert.
  1. Hardening a launch plan against self-sabotage
  2. Finding churn drivers by designing for maximum churn
  3. Security thinking — how would we break this?
- **Sensory Exploration** `signature` — Interrogate the idea through each sense — taste, smell, sound, texture.
  1. Brand identity work beyond visuals
  2. Making an abstract product feel tangible in marketing
  3. Accessibility ideation (what is the audio-first experience?)

#### Biomimetic (6)

- **Nature's Solutions** `signature` — Name an organism that already solved your problem; copy its mechanism.
  1. Designing resilient distributed systems (ant colonies, fungi networks)
  2. Efficient resource sharing (how forests share nutrients)
  3. Self-healing processes (immune-system patterns for error recovery)
- **Ecosystem Thinking** `signature` — Map your problem as an ecosystem: who eats whom, who partners, what decays.
  1. Platform strategy — mapping the partner/competitor web
  2. Understanding your product's place in a tool chain
  3. Analyzing internal team dependencies as habitats and niches
- **Evolutionary Pressure** `signature` — Spawn many ugly variants, apply a brutal selection rule, breed survivors, repeat.
  1. A/B-test-driven feature refinement strategy
  2. Iterating naming/messaging through rounds of selection
  3. Evolving a process by keeping only what survives real sprints
- **Predator & Prey** `signature` — Pick a threat, then design the defense, camouflage, or escape an animal would evolve.
  1. Competitive moats — defending against a big-tech clone
  2. Anti-abuse design against bad actors
  3. Pre-empting platform-dependency risk
- **Metamorphosis Stages** `signature` — Force the idea through egg, larva, pupa, adult: radically different forms per stage.
  1. Staging an MVP → growth → maturity product evolution
  2. Planning a company pivot in deliberate phases
  3. Designing a user journey from novice to power user
- **Swarm Logic** `signature` — Forbid the master plan: solve it with dumb local rules so order emerges bottom-up.
  1. Designing community moderation that scales without admins
  2. Decentralized team coordination rules instead of top-down process
  3. Microservices choreography over central orchestration

#### Cultural (7)

- **Indigenous Wisdom** `signature` — Ask how a traditional knowledge system would approach this; channel its problem-solving.
  1. Sustainability and long-horizon stewardship of a codebase
  2. Community-governance models for open source
  3. Decision-making that weighs seven generations (long-term consequences)
- **Fusion Cuisine** `signature` — Force-blend two unrelated cultures' approaches; harvest the hybrid.
  1. Combining Japanese kaizen with Silicon Valley move-fast culture
  2. Blending enterprise rigor with startup rituals in one org
  3. Cross-market product design (what does the Brazil × Korea version look like?)
- **Ritual Innovation** `signature` — Redesign the idea as a ceremony — threshold, gestures, transformation.
  1. Designing memorable onboarding as a rite of passage
  2. Inventing meaningful team rituals (release ceremonies, retro rites)
  3. Making a habit-forming product loop feel sacred, not mechanical
- **Mythic Frameworks** `signature` — Map the problem onto a myth; let the archetypes and structure dictate resolution.
  1. Crafting a founding story for a brand
  2. Understanding team dynamics through archetypes
  3. Structuring a product launch as a hero narrative
- **Proverb Mining** `signature` — Collect proverbs from many cultures; build from the one that clashes hardest with your assumptions.
  1. Challenging a strategy with compressed ancestral wisdom
  2. Finding messaging hooks with cross-cultural resonance
  3. Personal dilemmas — borrowed clarity from old sayings
- **Ancestor Council** `signature` — Convene three elders from different traditions; voice each verdict, reconcile disagreement.
  1. Weighing a major life/career decision from plural value systems
  2. Ethics review of a product decision
  3. Breaking a tie between competing strategic visions
- **Trickster's Gambit** `playful` — Channel the trickster — coyote, Anansi, Loki — and solve by breaking the sacred rule.
  1. Guerrilla marketing ideas that bend category norms
  2. Finding the loophole move competitors won't expect
  3. Unblocking a negotiation by reframing its rules

#### Speculative Future (8)

- **Time Horizon Ladder** `signature` — Solve for 1 year out, then 10, then 100; note what survives or breaks at each rung.
  1. Separating durable architecture choices from fashion
  2. Long-term brand vs. short-term campaign decisions
  3. Personal investments in skills — what compounds?
- **Post-Scarcity Test** `signature` — Assume the core constraint (money, energy, attention) is infinite — what does the idea become?
  1. Finding which product limits are economic vs. essential
  2. Imagining the product when AI/compute costs hit zero
  3. Re-scoping ambition before pragmatics kick in
- **Utopia vs Dystopia Split-Screen** `signature` — Write the same future twice: the brochure version and the disaster headline.
  1. Responsible-tech review of a new AI feature
  2. Stress-testing a strategy's second-order effects
  3. Balancing a pitch with honest risk narrative
- **Sci-Fi Artifact From the Future** `signature` — Describe one object, ad, or news clip from the world where this already won; reverse-engineer it.
  1. Product-vision artifacts (the future press release / fake review)
  2. Aligning a team on what success concretely looks like
  3. Marketing concept work for a launch
- **Emerging Tech Collision** `signature` — Force-marry your idea to a frontier tech (AGI, fusion, implants) — what new thing is born?
  1. Roadmapping where AI agents take your product category
  2. Hackathon framing for innovation sprints
  3. Threat analysis — which collision makes you obsolete?
- **What-If-The-World-Changed Card Flip** `signature` — Draw a wild world-shift (no privacy, 200-yr lifespans) and redesign to fit.
  1. Scenario-proofing a 5-year strategy
  2. Generating fresh constraints when ideas stagnate
  3. Designing for emerging-market or regulatory shifts
- **Future Anthropologist Dig** `signature` — A scholar in 2200 unearths your idea as a relic — what do they conclude, and what replaced it?
  1. Identifying your product's hidden cultural assumptions
  2. Asking what eventually makes this category extinct
  3. Legacy thinking — what do we want to be remembered for?
- **Scenario Cross** `classic` — Pick two high-impact uncertainties, cross into four futures, find the move that wins in all.
  1. Strategic planning under regulatory + market uncertainty
  2. Technology bets robust across AI-progress scenarios
  3. Portfolio decisions that hedge across futures

#### Quantum (6)

- **Observer Effect** `signature` — Ask how watching, measuring, or shipping the idea changes the thing itself.
  1. Metrics design — what does this KPI distort once tracked?
  2. Anticipating how a beta label changes user behavior
  3. Org design — how do dashboards change what teams do?
- **Entanglement Thinking** `signature` — Pair two distant parts of the problem; insist a change in one flips the other.
  1. Finding hidden coupling between product areas
  2. Pricing ↔ support-load interdependencies
  3. Tracing how a hiring decision ripples into product quality
- **Superposition Collapse** `signature` — Hold all rival solutions alive at once; name the one constraint that collapses them to a winner.
  1. Ending a long-running architecture debate
  2. Choosing between roadmap directions with one decisive criterion
  3. Cutting a shortlist of names/designs to one
- **Relativity Frame Shift** `signature` — Re-run the idea from a wildly different observer's frame — slow user, rival, future-you.
  1. Accessibility and low-bandwidth perspective passes
  2. Competitive war-gaming a launch
  3. Reviewing today's decision as future-you in 5 years
- **Field Lines** `signature` — Treat the goal as a charge; map the invisible forces pulling stakeholders toward or away.
  1. Stakeholder alignment before a big proposal
  2. Understanding why adoption stalls despite a good product
  3. Mapping political forces around a re-org or process change
- **Quantum Tunneling** `signature` — Assume the idea can pass straight *through* the impossible barrier — what's on the other side?
  1. Skipping the "necessary" intermediate product phase
  2. Imagining the post-approval world to find a cheaper path to it
  3. Breaking through a "we need X first" dependency mindset

### 4.3 Wild & Playful

#### Wild (7)

- **Chaos Engineering** `signature` — Deliberately break the idea every way it could fail; rebuild only what survives.
  1. Hardening a feature spec before development
  2. Robustness pass on a business plan
  3. Pre-launch resilience review
- **Guerrilla Gardening Ideas** `playful` — Plant the solution in the least expected place; let it grow underground until it surprises.
  1. Piloting an unsanctioned internal tool before asking permission
  2. Seeding a feature with a tiny user group quietly
  3. Grassroots culture change without a mandate
- **Pirate Code Brainstorm** `playful` — Steal the best bits from anywhere, remix without permission, run.
  1. Competitive teardown → recombination session
  2. Assembling a best-of process from other teams' playbooks
  3. Fast inspiration sweep across adjacent products
- **Zombie Apocalypse Planning** `playful` — Society collapsed — strip the idea to what survives with no power, rules, or backup.
  1. Finding a product's irreducible core value
  2. Disaster-recovery and offline-first thinking
  3. Ruthless MVP scoping
- **Drunk History Retelling** `playful` — Explain it three drinks in: no filter, no jargon, raw stupid-simple truth.
  1. Simplifying messaging that's drowning in jargon
  2. Testing if anyone actually understands the strategy
  3. Finding the honest pitch hiding under the deck
- **Anti-Solution** `signature` — Brainstorm how to make the problem spectacularly *worse*, then invert every sabotage.
  1. Diagnosing a retention problem via "how to maximize churn"
  2. Process improvement via "how to make meetings worse"
  3. Onboarding redesign via "how to lose users in 5 minutes"
- **Elemental Forces** `playful` — Let fire, water, earth, and air each sculpt the idea their own brutal way.
  1. Exploring radically different design temperaments for one product
  2. Re-energizing a flat ideation session
  3. Generating brand mood directions

#### Absurdist (6)

- **Villain's Monologue** `playful` — Pitch the problem as an evil mastermind gloating; the diabolical plan reveals the real solution.
  1. Finding the growth hack inside the "evil" version
  2. Threat modeling with energy and honesty
  3. Spotting where your business model quietly exploits users
- **Explain It to a Golden Retriever** `playful` — Re-pitch to an excitable dog who cares only about treats, balls, naps.
  1. Radical simplification of a feature pitch
  2. Cutting a spec down to what anyone can grasp
  3. Testing whether complexity is essential or self-inflicted
- **Infomercial at 3AM** `playful` — Sell the half-baked idea as a desperate late-night infomercial — "But wait, there's more!"
  1. Forcing out every conceivable benefit of an idea
  2. Generating feature upsells and bundle ideas
  3. Loosening up a stiff group before serious work
- **Drunk Uncle at Thanksgiving** `playful` — Let your least-filtered relative rant about the problem; mine the hot takes.
  1. Surfacing the criticism everyone thinks but won't say
  2. Anticipating hostile press or community reactions
  3. Stress-testing a strategy against blunt common sense
- **Cursed Genie** `playful` — Make a wish; a malicious genie grants it in the most technically-correct disastrous way; patch each loophole.
  1. Edge-case discovery for requirements and APIs
  2. Anticipating metric gaming and perverse incentives
  3. Contract/policy loophole hunting
- **Three Rounds of Stupid** `playful` — Round 1 absurd, Round 2 MORE absurd, Round 3 find the serious kernel in the silliest.
  1. Unsticking a team that's run dry on sensible ideas
  2. Innovation warm-up exercise
  3. Finding genuinely novel angles via escalating absurdity

#### Theatrical (7)

- **Time Travel Talk Show** `playful` — Host a talk show interviewing your past, present, and future selves.
  1. Career retrospective and planning session
  2. Product direction — what would v1-you and v10-you say?
  3. Extracting lessons from a long-running project
- **Alien Anthropologist** `playful` — A baffled alien studies the problem and narrates what seems strange, arbitrary, insane.
  1. Questioning "normal" industry practices nobody examines
  2. Fresh-eyes audit of your own UX
  3. Onboarding friction discovery — what would confuse an outsider?
- **Dream Fusion Laboratory** `signature` — Voice the impossible fantasy solution first, then reverse-engineer bridging steps back to reality.
  1. Turning a moonshot vision into a stepwise roadmap
  2. Recovering ambition in a team stuck on incremental fixes
  3. Personal goals — bridging from dream to Monday morning
- **Emotion Orchestra** `playful` — Run a separate ideation round led by each emotion (rage, joy, fear, hope), then harmonize.
  1. Designing for emotional range in a user journey
  2. Processing a controversial org change into constructive ideas
  3. Marketing campaigns with deliberate emotional arcs
- **Parallel Universe Cafe** `playful` — Rewrite one rule of reality (physics, economics, norms) and solve under those laws.
  1. What if storage/bandwidth were free — product implications
  2. What if attention were paid for — rethinking engagement
  3. Loosening fixed assumptions in a stuck strategy
- **Persona Journey** `signature` — Embody an archetype and solve in-character; name what that persona sees that you miss.
  1. Feature review as "the impatient power user"
  2. Sales-pitch crafting as "the skeptical CFO"
  3. Risk review as "the burned-out ops engineer"
- **Devil's Advocate Courtroom** `signature` `group` — Stage a trial: prosecute the idea, defend it, deliver the jury verdict.
  1. Final go/no-go review of a major investment
  2. De-risking a strategy before board presentation
  3. Resolving a deadlocked team disagreement with structure

#### Constraint (7)

- **Kill the Crown Jewel** `signature` — Delete the single most beloved feature — now redesign to win without it.
  1. Reducing dependency on one hero feature
  2. Preparing for a platform/API you rely on disappearing
  3. Forcing genuine differentiation beyond the obvious strength
- **1000x Budget** `signature` — Money, time, people infinite — design the absurd version, then steal what's stealable.
  1. Finding the ambition ceiling of a roadmap
  2. Discovering which "expensive" ideas are secretly cheap
  3. Vision-setting before pragmatic planning
- **Ship in 60 Minutes** `signature` — You launch in one hour with what's on hand — what do you cut, fake, or borrow?
  1. Ruthless MVP scoping
  2. Hackathon and prototype planning
  3. Unblocking perfectionism on a long-delayed release
- **The $0 Mandate** `signature` — Achieve the goal spending nothing — only people, favors, and what you own.
  1. Bootstrap marketing for a side project
  2. Process improvements with zero tooling budget
  3. Community-building without ad spend
- **One Feature Only** `signature` — Keep exactly ONE capability — pick it, make it unbelievably good.
  1. Finding a product's true core for repositioning
  2. Focusing a scattered roadmap
  3. App-store differentiation strategy
- **Crank the Dial to 11** `signature` — Exaggerate one dimension to a ludicrous extreme — fastest, biggest, cheapest, weirdest.
  1. Differentiation hunting (what if onboarding took 5 seconds?)
  2. Stress-testing scalability assumptions
  3. Finding the marketing superlative worth owning
- **Constraint Roulette** `signature` — Each round draw a brutal random limit (no screens, half the team, one day) and re-solve.
  1. Innovation workout for a comfortable team
  2. Contingency planning disguised as a game
  3. Generating diverse solution families fast

### 4.4 Collaborative *(best with a real group; the coach adapts them solo)*

- **Yes And Building** `classic` — Never negate; every contribution opens "Yes, and…" and stacks on the last.
  1. Early-stage concepting where criticism kills momentum
  2. Improving team ideation culture
  3. Building out one promising idea fast in a pair
- **Brain Writing Round Robin** `classic` `group` — Write silently, pass the sheet, build on what lands in front of you.
  1. Workshops where loud voices dominate spoken rounds
  2. Getting introverts' ideas onto the table
  3. Generating volume before group discussion biases it
- **Random Stimulation** `classic` — Pull a random word/image and force a link to the problem.
  1. Breaking fixation when all ideas converge
  2. Naming and creative copy sessions
  3. Injecting novelty into a routine planning meeting
- **Role Playing** `classic` — Each person speaks as a stakeholder, voicing what that role wants, fears, demands.
  1. Requirements discovery across user types
  2. Pre-negotiation preparation
  3. Building shared empathy before a contentious decision
- **Ideation Relay Race** `playful` `group` — 30-second turns, no pausing; keep the baton moving before anyone overthinks.
  1. High-energy workshop opener
  2. Beating perfectionism in a senior group
  3. Generating raw volume in minutes
- **Idea Hot Potato** `playful` `group` — Each catcher must mutate the idea in 10 seconds; no repeats.
  1. Evolving one seed idea through many hands
  2. Energizing a post-lunch session
  3. Teaching teams that ideas are communal, not owned
- **Steal And Upgrade** `signature` `group` — Claim a neighbor's idea you envy, then visibly improve it before returning.
  1. Cross-team pollination of roadmap ideas
  2. Normalizing building on others' work
  3. Upgrading a shortlist before final selection
- **Fold The Paper** `playful` `group` — Each adds one line to a hidden drawing/sentence, seeing only the previous fragment.
  1. Surfacing surreal combinations no one would plan
  2. Icebreaker that doubles as idea generator
  3. Loosening a formal group before real ideation

### 4.5 Introspective & Personal *(solo; best for life/career/values topics)*

- **Inner Child Conference** `signature` — Answer as your 7-year-old self: naive "why why why," chase wonder, ban boring adult thoughts.
  1. Reconnecting with why you started a project/career
  2. Cutting through over-intellectualized decisions
  3. Finding playfulness for a product aimed at delight
- **Shadow Work Mining** `signature` — Name what you're avoiding, resisting, or scared of — then dig *there*.
  1. Understanding why you keep procrastinating one task
  2. Facing the risk a plan is quietly designed to avoid
  3. Career moves blocked by unexamined fear
- **Values Archaeology** `signature` — Keep asking "why do I care?" until you hit the non-negotiable value steering the choice.
  1. Choosing between job offers
  2. Resolving founder disagreements about direction
  3. Defining personal criteria before a big purchase/move
- **Future Self Interview** `signature` — Interview your wise 80-year-old self about this problem; write down the advice.
  1. Major life decisions (relocation, career pivot)
  2. Prioritizing when everything feels urgent
  3. Sanity-checking a sacrifice-heavy plan
- **Body Wisdom Dialogue** `signature` — Scan for the tension or gut pull each option triggers; let the body's yes/no drive ideas.
  1. Tie-breaking when analysis is exhausted
  2. Detecting which commitment you actually dread
  3. Choosing among equally "rational" options
- **Permission Giving** `signature` — Write yourself an explicit permission slip to think the forbidden thought — then think it.
  1. Considering quitting/sunsetting something "unquittable"
  2. Voicing the strategy nobody is allowed to propose
  3. Unlocking ideas blocked by loyalty or guilt
- **Secret Wish Confession** `signature` — Whisper the embarrassing thing you secretly want, then build the idea honoring it.
  1. Realigning a career with what you actually want
  2. Discovering the product you wish you were building
  3. Unblocking a decision distorted by image management
- **Mood Weather Report** `signature` — Name the inner weather (fog, storm, sun) and let that exact climate generate the ideas.
  1. Starting a session when you're not "in the mood"
  2. Journaling/reflection practice with creative output
  3. Turning frustration about a project into usable signal

---

## 5. Convergence Moves (after divergence — never during)

When you're ready to narrow ("help me pick / prioritize / make it real"), the skill switches
to an explicit converge phase with these established methods:

| Move | What it does | Use when |
|---|---|---|
| **Affinity Clustering (KJ)** | Group raw ideas into named themes | 50+ ideas, no structure yet |
| **Dot Voting** | Heat-map favorites | Group needs a fast democratic cut |
| **Impact–Effort Matrix** | Plot impact vs. effort; harvest high-impact/low-effort | Roadmap-style prioritization |
| **NUF Test** | Score New / Useful / Feasible 1–10 | Exposing quiet winners vs. dazzling dead-ends |
| **PMI (Plus/Minus/Interesting)** | Fast pressure-test of one candidate | One strong idea needs a sanity check |
| **MoSCoW** | Must / Should / Could / Won't | Product scoping decisions |

---

## 6. Quick-Start Recipes

| Situation | Suggested session |
|---|---|
| "I have a vague product idea" | `bmad-brainstorming`, Facilitator stance, batch: Mind Mapping → How Might We → Concept Blending → What If Scenarios |
| "Feature ideas for the next quarter" | Creative Partner, batch: SCAMPER → Job to Be Done → Crazy 8s → Reverse Brainstorming; converge with Impact–Effort |
| "Why does X keep failing?" | Batch: Five Whys → Fishbone → Question Storming; or go straight to `bmad-cis-problem-solving` |
| "Big strategic decision" | Batch: Six Thinking Hats → Failure Analysis → Scenario Cross → Superposition Collapse; or `bmad-cis-innovation-strategy` |
| "I'm completely stuck" | Batch: Random Stimulation → Worst Possible Idea → Three Rounds of Stupid → Constraint Roulette |
| "Personal/career crossroads" | Facilitator, batch: Values Archaeology → Laddering → Future Self Interview → Six Thinking Hats |
| "I want expert debate, not techniques" | `bmad-party-mode` with relevant agents |
| "Surprise me" | `invent 4` — the coach invents brand-new techniques on the fly |

**To start:** invoke `bmad-brainstorming` (or just say *"help me brainstorm <topic>"*),
state the topic **and the why**, pick a stance, and compose a batch of 3–4 techniques —
or let the coach choose for your goal.
