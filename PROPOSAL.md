# Proposal: multi-track, interactive, adaptive learning puzzles

*Drafted 2026-07-02. Status: decisions resolved; **Phases 1 and 2 implemented 2026-07-02**
(Phase 1: de-Bend reframe, `numeric` + `estimate` answer types, "Go deeper" resources, one-tap
difficulty rating, outcome logging. Phase 2: multi-track architecture — per-track curricula,
URLs, progress (v3 record), resume cards, per-track runbook with buffer 8 — and the Bayes track
launched with lessons 1–8). 2026-07-03: `ml` activated early (drafted spine in Part 3) and a
`cog` track (cognitive science & AI architectures — Hearsay-II blackboards, ACT-R/SOAR, through
modern agent harnesses) added beyond the original proposal; both seeded and live. Phase 3
(widgets/Pyodide/labs) and Phase 4's adaptivity work not started.*

This proposes the next evolution of the daily-learning-puzzles system, addressing four things:

1. **De-anchor from Bend.** Bend was an example of the *kind* of thinking to practice, not the
   destination. The system should read as "training grounds for ways of thinking," with functional/
   parallel thinking as one track among several.
2. **More interactive puzzles.** Today there are two answer types (`reveal`, `mcq`). Add runnable
   code, numeric answers, embedded visual widgets, and "lab" lessons built around the excellent free
   interactive resources already on the web.
3. **New tracks:** Bayesian statistics and machine learning, with room for more.
4. **Real feedback.** Today feedback is a freeform file you write and a single "high-water mark"
   integer. Add outcome logging, a weakness map per concept, spaced review, and periodic
   boundary-probing so the system discovers what you need practice on — not just what's next.

---

## Part 1 — De-anchor from Bend

The FP curriculum is genuinely good; the problem is framing, not content. Changes:

- **Rename the through-line.** "The ideas behind Bend" → "functional & parallel thinking."
  Purity, immutability, associativity, folds, work/span — these stand on their own (they're the
  intellectual core of Haskell, Spark, MapReduce, and GPU programming alike). Scrub Bend from
  `README.md`, `curriculum/curriculum.md` rule 7, and `generation/generation-prompt.md` rule 7;
  Bend may still appear as *one* example alongside Spark and GPU kernels where it illuminates.
- **Stage 7 stays** (parallel combinators, work vs span) — that's general and valuable.
- **Stage 8 (affine types / interaction nets) becomes an optional branch**, not the spine's
  terminus. It's the most Bend-specific material; keep it available for anyone who opts in, but the
  FP track's capstone becomes "re-derive a sequential algorithm as map/reduce/scan" (end of
  Stage 7).
- **Track slug:** the existing lessons become the `fp` track (see Part 3).

## Part 2 — Interactivity

### 2a. New answer types

Extend the existing `answer_type` mechanism (all client-side, no build-system change):

| Type | What it is | Best for | Cost |
|---|---|---|---|
| `numeric` | Type a number; checked with tolerance (`answer: 0.087, tolerance: 0.005`). | Bayes problems, work/span counts, expected values. | Small — a form + JS check, same pattern as `mcq`. |
| `code` | In-browser runnable Python via **Pyodide** (WASM, loaded on demand, runs in a Web Worker). Front matter carries hidden test cases; pass = solution unlocks. | "Write this function" puzzles across all tracks — currently `reveal`-only with no verification. | Medium. One runtime (Python) keeps it simple; numpy is available for ML/Bayes lessons. |
| `estimate` | Give a point estimate **and** a 90% interval before revealing the true value. Both are logged. | Calibration training — the most Bayesian exercise there is, and it produces the richest feedback signal (see Part 4). | Small. |
| `interact` | The puzzle embeds a widget (see 2b); the question is answered by exploring it, then confirmed via an `mcq`/`numeric` check. | "Move the prior and watch the posterior", "find the learning rate that diverges." | Depends on 2b. |

### 2b. Widget library, not freeform JS

The failure mode to avoid: the generator authoring bespoke JavaScript per lesson (inconsistent,
buggy, unreviewable). Instead, build a **small vetted widget library** in `web/js/widgets/`, and
lessons invoke widgets declaratively via a Hugo shortcode with JSON parameters:

```
{{< widget type="dist-explorer" params=`{"family":"beta","controls":["alpha","beta"],"overlay":"posterior","data":[7,3]}` >}}
```

The generator only ever writes *configuration*; humans (or a one-off focused session) write the
widget code once. Initial set, chosen to cover both new tracks:

1. **`function-plot`** — plot f(x) with slider-bound parameters. (FP: growth of naive vs
   accumulator reverse; ML: polynomial fit degree.)
2. **`dist-explorer`** — parameterized distribution (beta, normal, binomial, Poisson) with sliders;
   optional posterior overlay given data. (The Bayes track's workhorse.)
3. **`sampler`** — animated sampling: draw dots from a distribution, watch a histogram converge;
   also does the Monty Hall / base-rate "population of 1000 people" natural-frequency grids.
4. **`scatter-boundary`** — 2D points + an adjustable decision boundary; shows
   accuracy/precision/recall live. (ML track's workhorse.)
5. **`grid-walk`** — a Markov chain / MCMC random walk on a small grid or 1-D posterior, step
   button + trace plot. (Makes Metropolis intuition visceral.)
6. **`tree-viz`** — render a binary tree / fold evaluation order / parallel reduction tree.
   (Backfills interactivity into the existing FP lessons, esp. Stage 7 work-vs-span.)

Each widget: plain JS + `<canvas>`/SVG, no framework, no build step — consistent with the current
zero-dependency `learn.js` approach.

### 2c. Lab lessons — stand on the giants' interactive shoulders

Some of the best interactive teaching material ever made is free online. Rather than rebuild it,
add a **`lab` lesson flavor**: the puzzle sends you to an external interactive with a specific
mission, then checks understanding with `mcq`/`numeric` questions you can only answer by having
actually done the exploration. Examples:

- **TensorFlow Playground** (playground.tensorflow.org) — "Find the smallest network that separates
  the spiral dataset. How many hidden units did you need, and why does one layer fail?"
- **Seeing Theory** (seeingtheory.brown.edu) — chapters on conditional probability, CLT, Bayesian
  inference, regression; beautiful and directly on-curriculum.
- **R2D3** (r2d3.us) — the visual introduction to decision trees and bias/variance; a ready-made
  lab for the trees stage.
- **MLU-Explain** (mlu-explain.github.io) — Amazon's visual essays: cross-validation, precision/
  recall, random forests, logistic regression, double descent.
- **Setosa / Explained Visually** (setosa.io/ev) — Markov chains, eigenvectors, conditional
  probability.
- **Distill.pub** — momentum, t-SNE, feature visualization, for later ML stages.

A `resources` front-matter field (list of `{title, url, note}`) also gets added to *every* lesson
type, rendered as a "Go deeper" box on the solution page. Source texts to draw problems and
ordering from (all free online): **Think Bayes 2** (Downey), **Bayes Rules!** (Johnson/Ott/
Dogucu), **An Introduction to Statistical Learning** (statlearning.com, Python edition),
Blitzstein's **Introduction to Probability** (Stat 110), and Karpathy's **Neural Networks: Zero to
Hero** for the deep-learning branch. 3Blue1Brown's Bayes and neural-net videos make good
`resources` links.

## Part 3 — Multiple tracks

### Architecture

- **URL & content:** lessons move under a track: `content/learn/fp/0031-puzzle.md`,
  `content/learn/bayes/0001-puzzle.md`. Front matter gains `track: bayes`. Existing lessons get an
  `aliases:` entry (Hugo redirects) so old URLs keep working; the `fp` track continues its
  numbering unchanged.
- **Curriculum:** one spine file per track — `curriculum/fp.md`, `curriculum/bayes.md`,
  `curriculum/ml.md` — same format as today (stages, checkboxes, `last_generated_lesson`).
  `curriculum/roadmap.md` (currently a stub) becomes the real cross-track document: which tracks
  are active, pacing intent, branch points, capstones.
- **Progress backend v2:** `progress.mjs` stores per-track state instead of one integer:
  `{"version":2, "tracks":{"fp":{"lastCompleted":30,...},"bayes":{...}}}` — reading a v1 blob
  migrates it to `tracks.fp`. Same token scheme, no login, unchanged.
- **Runbook:** the buffer rule becomes per-track (e.g. keep ≥ 8 unsolved ahead per *active* track);
  one weekly run handles all tracks.
- **Landing page:** shows a resume card per track. Optionally a "today's set" that interleaves
  (see Part 5).

### Track: Bayesian statistics (proposed spine)

Heavy on `numeric`, `estimate`, `dist-explorer`, and `sampler` — this track is where the new
interactivity pays off most.

- **Stage 0 — Probability as plausibility.** Sample spaces without the boredom; conditioning;
  joint vs marginal; the two-child problem and friends. (`mcq`, `numeric`, `sampler`)
- **Stage 1 — Bayes' theorem proper.** Base rates, medical-test puzzles via natural frequencies;
  likelihood ratios; "posterior odds = prior odds × Bayes factor". (`numeric`, `sampler` grids)
- **Stage 2 — Distributions as beliefs.** Priors; the beta-binomial coin; watching the posterior
  sharpen as data arrives. (`dist-explorer` labs)
- **Stage 3 — Sequential updating.** Conjugacy as "the update has a closed form"; posterior
  predictive; why yesterday's posterior is today's prior. (`interact`, `code`)
- **Stage 4 — Estimation & decisions.** Point estimates as loss-function choices; credible vs
  confidence intervals; expected-value decisions. (`numeric`, `estimate`)
- **Stage 5 — Computation.** Grid approximation by hand (`code` with numpy); Monte Carlo; MCMC
  intuition via `grid-walk`; why sampling beats integration.
- **Stage 6 — Models with structure.** Hierarchical intuition: shrinkage, partial pooling
  (the eight-schools story told visually); regression with priors.
- **Stage 7 — Calibration & forecasting.** Scoring rules (Brier/log); being well-calibrated vs
  being right; running personal calibration from the `estimate` answers logged since Stage 0.

### Track: machine learning (proposed spine)

Framed for someone who already ships Spark pipelines: concepts and failure modes over library
tutorials. Strong overlap with the Bayes track is intentional and cross-linked via `builds_on`.

- **Stage 0 — Learning as function fitting.** Loss, train/test, overfitting felt directly
  (`function-plot`: crank polynomial degree, watch test error turn around).
- **Stage 1 — Linear models & gradient descent.** Logistic regression as calibrated probability;
  descent on a loss surface (`interact`: pick learning rates, watch divergence).
- **Stage 2 — Trees & ensembles.** R2D3 lab; why bagging works (variance), why boosting works
  (bias); feature importance skepticism.
- **Stage 3 — Evaluation as epistemics.** Cross-validation, leakage (the great career-saver),
  baselines, class imbalance, precision/recall via `scatter-boundary`. Deliberately *before*
  neural nets — evaluation discipline matters more.
- **Stage 4 — Neural nets.** Perceptron → depth; backprop as the chain rule organized well;
  TensorFlow Playground labs; Karpathy's Zero-to-Hero as the deep-dive branch.
- **Stage 5 — Embeddings & similarity.** Words/items as vectors; cosine similarity; what nearest
  neighbors in embedding space do and don't mean.
- **Stage 6 — Attention & modern architecture intuition.** Attention as soft lookup; why
  transformers parallelize (a genuine cross-link to FP Stage 7's work/span!).
- **Stage 7 — Statistical wisdom.** Bias/variance in the wild; distribution shift; Goodhart;
  when a linear baseline beats the fancy thing.

## Part 4 — A real feedback loop

Today the system knows one number (`lastCompleted`) plus whatever you type into `feedback.md`.
That can't push your boundaries. Proposed layers, cheapest first:

1. **Outcome logging (automatic).** The client already knows: mcq first-try correct or not,
   `numeric` attempts, `code` test passes/failures, `estimate` interval hit/miss. POST these to
   `progress.mjs` alongside completion — per-lesson event records in the same blob.
2. **One-tap difficulty rating (explicit).** On "Mark complete," four buttons instead of one:
   **too easy / right / struggled / didn't get it** (Anki's again/hard/good/easy, relabeled).
   One tap, no typing — the friction of `feedback.md` is why feedback is sparse.
3. **Concept tags → weakness map.** Each lesson gets a `tags:` list (e.g. `[conditioning,
   base-rates]`). The weekly routine aggregates outcomes by tag: tags with poor outcomes are
   *weak*, tags with "too easy" streaks are *mastered*. This map lives in a committed file
   (`curriculum/learner-model.md`) so it's inspectable and editable — you can overrule it.
4. **Spaced review.** The generator's buffer quota becomes ~70% new / ~30% review: *fresh variant
   puzzles* (never reruns) targeting weak tags, scheduled at expanding intervals after the
   original lesson. Mastered tags accelerate the spine (skip or compress upcoming lessons).
5. **Boundary probes.** Every ~6 weeks per track, a short diagnostic set that deliberately
   overshoots the spine — harder material, further ahead. The point is to find the frontier: what
   it reveals feeds the weakness map and can reorder or prune the curriculum ("he already gets
   folds cold; stop scheduling review for them").
6. **Calibration report.** Once enough `estimate` answers accumulate: a small stats page —
   "your 90% intervals contain the truth 71% of the time" is itself a Bayesian lesson.

`feedback.md` stays for freeform steering; it's the override channel, no longer the only channel.

## Part 5 — Other suggestions

- **Interleave tracks.** The literature is clear that interleaving beats blocking for retention.
  "Today's set" on the landing page: one lesson from your primary track, one from a secondary,
  plus any due review. Cheap to build once progress is per-track.
- **Retrofit, don't rewrite, the FP track.** Add `numeric` (work/span counts!), `tree-viz`, and
  `code` checks to *future* FP lessons; convert a handful of past `reveal` lessons to `code` only
  if re-visiting them anyway.
- **Capstones per track** in `roadmap.md`: FP — re-derive a sequential algorithm as
  map/reduce/scan with a work/span analysis; Bayes — build and defend a grid-approximation
  analysis of real data end-to-end (`code`); ML — diagnose a deliberately broken pipeline
  (leakage, imbalance, bad baseline) from evidence.
- **Keep the zero-framework discipline.** Pyodide and the widgets should load lazily and only on
  pages that need them; everything else stays static Hugo + vanilla JS. No build step for JS.
- **Author widget lessons behind a preview gate.** Add a routine step: any lesson using a widget or
  `code` must be smoke-tested in a local `hugo server` (the runbook already builds; extend it to
  screenshot/check the widget renders and tests pass under Pyodide) before publish.

## Suggested phasing

| Phase | Contents | Effort |
|---|---|---|
| **1. Reframe + cheap wins** | De-Bend all docs; `numeric` + `estimate` answer types; `resources`/"Go deeper" box; one-tap difficulty rating; outcome logging in `progress.mjs` (v2 blob, still single-track). | Small — one session. |
| **2. Multi-track** | Track-aware URLs/front-matter/progress; `curriculum/bayes.md` written in full; Bayes Stages 0–1 generated (mostly `numeric`/`mcq`, no widgets needed yet); runbook goes per-track. | Medium. |
| **3. Interactivity** | Widget library (`dist-explorer`, `sampler`, `function-plot` first); `interact` lessons; first `lab` lessons (Seeing Theory, TF Playground); Pyodide `code` runner. | Largest chunk; widgets can land one at a time. |
| **4. Adaptivity** | Concept tags backfilled; weakness map + spaced review in the weekly routine; ML track launches; boundary probes; calibration report. | Medium, ongoing. |

Phases 2 and 3 are independent and can swap. The FP track keeps generating throughout — nothing
pauses.

## Decisions (resolved 2026-07-02)

1. **Buffer size per track:** 8 unsolved ahead per *active* track (replaces the single-track 12).
2. **`code` runner is Python-only** (Pyodide). No second runtime for FP lessons.
3. **Event blob growth:** aggregate per-lesson events into per-tag counters after ~90 days; keep
   raw events only for the calibration report.
4. **Routine vs. build sessions:** widgets and the Pyodide runner are built in interactive
   sessions; the weekly routine only ever *uses* them (writes config, never JS).
