# Track spine: `cog` — Cognitive science & AI architectures

Lessons in this track live at `/learn/cog/` (front matter `track: cog`). Numbering starts at 1 and
is independent of other tracks.

This track braids two strands that were born together and keep re-converging: **how human
cognition works** (memory, attention, expertise, judgment) and **how AI systems have modeled it**
(production systems, blackboard architectures like Hearsay-II, ACT-R, SOAR, subsumption, BDI —
through to modern agent harnesses). Herbert Simon and Allen Newell thread through both strands,
and the track leans into that. The learner has built an experimental agent harness inspired by
Hearsay-II's blackboard model — treat blackboard systems as a first-class destination, not a
historical footnote, and regularly connect classic architectures to modern agent design.

## Audience

Tristan: experienced software developer (Python, SQL, TypeScript, Spark), building agent systems.
Knows the blackboard idea from practice; wants the deeper theory, the neighboring architectures,
and the psychology underneath them. Prefers puzzles that exercise architectural judgment ("what
would this system do / why did they design it this way") over terminology recall.

## Hard rules for every lesson

Same as the shared rules in `../generation/generation-prompt.md`, plus track-specific ones:

1. **Architecture puzzles, not vocabulary quizzes.** Ask what a system does on a concrete input,
   why a design choice was made, or which architecture fits a problem — never "which term means X".
2. **Psychology and machinery illuminate each other.** When teaching a mechanism (production
   firing, spreading activation), show the human phenomenon it models; when teaching a phenomenon
   (chunking, satisficing), show the machinery it inspired.
3. **Connect to modern agents.** Where natural, end with "and in a modern LLM agent harness, this
   corresponds to…". The learner should keep recognizing their own systems in 1970s papers.
4. **Answer types:** mostly `mcq` (trace-the-system, choose-the-architecture) and `reveal`
   (design sketches); `numeric` where a mechanism computes something (activation, agenda scores).
5. **Resources.** The classics are free: Erman et al.'s Hearsay-II survey, Nii's blackboard
   papers, Corkill's "Blackboard Systems", Brooks' subsumption papers, Newell & Simon's Turing
   Award lecture, ACT-R and SOAR sites, MIT OCW's Society of Mind lectures (Minsky himself).

## The stages (ordered)

### Stage 0 — Minds as information processors
- [x] C1 Marr's three levels (computational / algorithmic / implementational): one analysis, three
      questions — `mcq`
- [x] C2 Working memory and chunking: Miller's 7±2, what a "chunk" buys, chess masters — `mcq`
- [x] C3 Production systems: condition→action rules over a working memory; recognize-act cycle,
      conflict resolution — `mcq`

### Stage 1 — Blackboard architectures  ← the Hearsay-II payoff
- [x] C4 The blackboard idea: shared hypothesis space, independent knowledge sources,
      opportunistic control — why Hearsay-II needed it for speech — `mcq`
- [x] C5 Hearsay-II anatomy: hypothesis levels (segment→syllable→word→phrase), bidirectional
      inference, islands of certainty — `mcq`
- [x] C6 Control: the agenda, scheduling knowledge sources, focus of attention; BB1's control
      blackboard — `numeric` (score an agenda) or `mcq`
- [x] C7 When blackboards beat pipelines (and when they don't); blackboard vs message-passing —
      `reveal` (design exercise)
- [x] C8 Blackboards now: multi-agent LLM harnesses, shared scratchpads, tool results as
      hypotheses; what carries over and what changed — `reveal`

### Stage 2 — Integrated cognitive architectures
- [x] ACT-R I: declarative vs procedural memory; chunks with activation
- [x] ACT-R II: spreading activation, base-level decay; why forgetting is rational
- [x] C11 SOAR I: problem spaces, universal subgoaling, impasses
- [x] C12 SOAR II: chunking as learning; comparing ACT-R and SOAR design bets
- [x] C13 What these architectures predict about humans (timing, errors) — and how well they do

### Stage 3 — Human memory & attention
- [ ] Encoding vs retrieval; recognition vs recall; retrieval practice (why these puzzles quiz you)
- [ ] Spreading activation & priming (the psychology ACT-R formalized)
- [ ] Attention as selection: dichotic listening, inattentional blindness, the binding problem
- [ ] Long-term memory systems: episodic vs semantic vs procedural

### Stage 4 — Learning & expertise
- [ ] The power law of practice; what gets faster and what doesn't
- [ ] Expertise as chunking + retrieval (de Groot's chess studies, Chase & Simon)
- [ ] Deliberate practice and its limits; transfer (and its scarcity)
- [ ] Spacing & interleaving (the science this whole puzzle system is built on)

### Stage 5 — Judgment & bounded rationality
- [ ] Satisficing (Simon): why real agents don't optimize
- [ ] Heuristics & biases: availability, anchoring, representativeness (bridge to the bayes track)
- [ ] Dual-process accounts: what System 1/2 explains and what it hand-waves
- [ ] Ecological rationality: when heuristics are smart

### Stage 6 — Alternative architectures
- [ ] Subsumption (Brooks): intelligence without representation; layered competencies
- [ ] Society of Mind (Minsky): agencies, K-lines; the mind as a messy committee
- [ ] BDI agents: beliefs, desires, intentions; commitment strategies
- [ ] Distributed cognition (Hutchins): the cockpit remembers its speed

### Stage 7 — Modern synthesis (capstone territory)
- [ ] Cognitive architectures vs deep learning: symbols, gradients, and the bitter lesson —
      argued both ways
- [ ] Anatomy of a modern agent harness: planner/executor/critic, memory stores, tool use —
      mapped onto the classic architectures
- [ ] Capstone: design a blackboard-style agent harness for a concrete task; defend the
      knowledge-source decomposition and control policy

## Generation marker

`last_generated_lesson: 13`
(The generator updates this after each run. New lessons continue the next unchecked item, in order.)
