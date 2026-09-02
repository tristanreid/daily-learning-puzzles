# Exam report schema

One report per track per exam session, at `assessment/reports/<track>/<YYYY-MM-DD>.md`. The file
is Markdown with a YAML front-matter block. **The front matter is the machine-readable part**: the
weekly generator reads it. The body is a short narrative for the learner.

Reports are append-only history. Never edit an old report; write a new one.

## Concept tags

A tag is `<track>/<slug>`, where the slug is a short kebab-case name for the concept as it appears
in `curriculum/<track>.md` — e.g. `fp/fold-as-elimination`, `bayes/base-rates`,
`cog/blackboard-control`, `ml/leakage`. Always include the `lessons` list so the tag can be matched
back to the spine even if a slug drifts between sessions. Reuse the slug from the previous report
when probing the same concept.

## Front matter

```yaml
---
track: bayes                     # fp | bayes | cog | ml
date: 2026-09-02
mode: full                       # full | diagnostic   ("all" runs write one diagnostic report per track)
examiner: claude-fable-5-1       # model that ran the session
learner_position: 15             # lastCompleted for this track at exam time
duration_minutes: 40
questions_asked: 11

# One-paragraph verdict, written last. Where does correct reasoning stop in this track?
overall_edge: >
  Fluent through beta-binomial updating; reasoning thins at the posterior predictive and
  breaks when asked to justify a prior choice for a non-conjugate case.

# The brief's central question, answered for this track from what the exam showed.
difficulty_verdict: content-too-easy   # content-too-easy | format-masking | well-pitched | mixed
# -1 easier, 0 hold, +1 harder, +2 much harder — relative to the most recent lessons in this track
recommended_difficulty_shift: +1

concepts:
  - tag: bayes/base-rates
    lessons: [7]
    stage: 1
    status: mastered             # mastered | solid | shaky | missing | not-probed
    highest_rung_passed: 3       # 0-3; 0 = nothing passed
    first_rung_failed: null      # 1-3 or null if nothing failed
    scores: [3, 3]               # per response, in order asked (0-3)
    evidence: >
      Rung 2: derived the 4.7% by population count in a new scenario and, unprompted, gave the
      odds-form shortcut. Rung 3: correctly argued why two tests are only multiplicative under
      conditional independence, with a concrete counterexample.
    misconception: null          # the specific wrong belief, in the learner's words, or null
    confident_error: false       # true if a wrong answer was delivered with confidence
    recommendation: skip         # skip | extend | reinforce | remediate
    learner_amended: false       # true if the status was changed at the learner's request in debrief
  - tag: bayes/posterior-predictive
    lessons: [17]
    stage: 2
    status: shaky
    highest_rung_passed: 1
    first_rung_failed: 2
    scores: [1, 2, 0]
    evidence: >
      Rung 2: used the posterior mean as the predictive probability ("about 0.71") and did not
      integrate over the posterior; on follow-up, could not say why that differs. Rung 1: stated
      the definition correctly.
    misconception: "The prediction for the next flip is just the posterior mean of theta."
    confident_error: true
    recommendation: remediate
    learner_amended: false

# Concepts from stages the learner has not reached. A miss here is expected, not a weakness.
pretest:
  - tag: bayes/grid-approximation
    lessons: []                  # empty when the lesson does not exist yet
    stage: 5
    status: partial              # already-known | partial | missing
    note: "Could describe the grid but not why it fails past ~3 parameters."
    recommendation: compress     # skip | compress | teach-as-planned

transfer:
  - prompt: "Given a Spark job with 1-in-10k fraud labels and a 99%-precision alert, estimate PPV and say what data you would need to improve it."
    concepts: [bayes/base-rates, bayes/sequential-evidence]
    score: 3
    note: "Clean. Connected it to alert fatigue from his own monitoring without prompting."

# Verbatim, from the framing questions and the debrief.
work_context: "Building a planner/critic loop for the agent harness; a lot of Spark this week."
learner_requests:
  - "Bring the MCMC material forward; I want something to run."
  - "The estimate lessons feel like guessing — make the reasoning part harder."
lessons_flagged:                 # from "any recent lessons that felt off"
  - lesson: 14
    note: "Too easy; choosing the prior was obvious from the framing."

# What the generator should do in the next batch for this track. Short, imperative, specific.
# Appended to generation/feedback.md when the learner agrees. Order by importance.
directives:
  - "Next batch: +1 difficulty; start each puzzle one step past where the lesson would have stopped."
  - "Remediate bayes/posterior-predictive: one numeric lesson that makes the posterior-mean shortcut give a visibly wrong answer, then the integral."
  - "Skip bayes/base-rates and bayes/odds-form as standalone lessons; use them only as steps inside harder problems."
  - "Compress Stage 5 grid approximation to one lesson; the learner already has the intuition."
  - "Use a Spark fraud-scoring pipeline as the running example in Stage 4."
---
```

## Body

Keep it short. One section per concept probed, in the order asked:

```
## bayes/posterior-predictive — shaky (edge: rung 2)

**Rung 2.** Q: <paraphrased question>. A: "<quoted or closely paraphrased answer>". Score 1.
**Follow-up.** Q: … A: … Score 2.
**Rung 1.** Q: … A: … Score 0.
```

Then `## Transfer`, `## Pre-test`, and `## Debrief notes` (anything said in debrief that is not
already captured in the front matter).

## Status definitions

| status | meaning | typical rung outcome |
|---|---|---|
| `mastered` | reasons correctly beyond what was taught | rung 2 pass and rung 3 pass or partial |
| `solid` | correct at the level taught, thin beyond it | rung 2 pass, rung 3 fail; or rung 2 partial that closed |
| `shaky` | present but breaks under transfer | rung 1 pass, rung 2 fail |
| `missing` | not usable | rung 1 fail |
| `not-probed` | chosen but not reached in the time budget | — |

## Recommendation → generator action

The generator reads the latest report per track before writing a batch. Mapping:

| recommendation | what the generator does |
|---|---|
| `skip` | no further standalone lesson on this concept; it may appear as a step inside a harder puzzle |
| `extend` | the concept is ahead of the curriculum; write the rung-3 material next, not the planned rung-2 material |
| `reinforce` | one more puzzle, at rung-2 difficulty, in a new domain, before moving on |
| `remediate` | a lesson built around the recorded `misconception`: walk into the error, then out. Use a checked format (`numeric` preferred) |
| pretest `skip` / `compress` / `teach-as-planned` | drop, merge to one lesson, or leave the spine alone |

`recommended_difficulty_shift` applies to the whole next batch for the track. `directives` are read
verbatim and take precedence over the mapping when they conflict.

## Minimal validity

A report is valid if the front matter parses as YAML and has `track`, `date`, `mode`,
`learner_position`, `overall_edge`, `difficulty_verdict`, `recommended_difficulty_shift`,
`concepts` (at least one entry with `tag`, `lessons`, `status`, `recommendation`), and `directives`
(at least one). Everything else is optional.
