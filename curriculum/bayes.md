# Track spine: `bayes` — Bayesian statistics

Lessons in this track live at `/learn/bayes/` (front matter `track: bayes`). Numbering starts at 1
and is independent of other tracks.

This track teaches **probability as plausibility**: representing beliefs as distributions,
updating them with evidence via Bayes' theorem, and knowing how much to trust the result. The
destination is practical — reading a posterior, resisting base-rate neglect, reasoning about
models and forecasts — plus personal **calibration** trained throughout via `estimate` puzzles.

## Audience

Tristan: experienced software developer (Python, SQL, TypeScript, Spark). Has surely met
probability before; the point is to make Bayesian *reasoning* automatic, not to pass a stats
course. Comfortable with code and light algebra; prefers concrete puzzles over derivations.

## Hard rules for every lesson

Same as the shared rules in `../generation/generation-prompt.md`, plus track-specific ones:

1. **Numbers over symbols first.** Introduce every idea with a concrete worked scenario (counts of
   people, natural frequencies) before any formula. The formula is the *summary*, not the opener.
2. **Through-line.** When natural, connect back to the core loop: prior × likelihood → posterior;
   yesterday's posterior is today's prior. And to calibration: a belief is a bet.
3. **Real misconceptions are the curriculum.** Base-rate neglect, confusing P(A|B) with P(B|A),
   "statistically independent" vs "feels unrelated", overconfident intervals — target them head-on.
4. **Answer types:** favor `numeric` (most Bayes puzzles have one number) and `mcq` for
   predict-the-behavior questions; sprinkle `estimate` regularly (≈ every 4–5 lessons) to build the
   calibration log. `interact` widgets arrive in a later phase.
5. **Resources.** Bayes has exceptional free material — most solutions should carry 1–2 "Go deeper"
   links (Seeing Theory, Think Bayes 2, Bayes Rules!, 3Blue1Brown's Bayes videos, Setosa).

## The stages (ordered)

### Stage 0 — Probability as plausibility
- [x] B1 Probability as degree of belief; the two readings (frequency vs plausibility) and why both
      obey the same rules — `mcq`
- [x] B2 Joint, marginal, conditional: one table of counts, three questions — `numeric`
- [x] B3 The multiplication rule P(A,B) = P(A|B)·P(B); when order of conditioning helps — `numeric`
- [x] B4 Independence: what it actually claims, and how it fails (correlated evidence) — `mcq`
- [x] B5 Conditioning on *how you learned it* (two-child problem / Monty Hall flavor) — `mcq`

### Stage 1 — Bayes' theorem proper
- [x] B6 Deriving Bayes' theorem from the joint (it's just the multiplication rule twice) — `numeric`
- [x] B7 The rare-disease test via natural frequencies; base-rate neglect — `numeric`
- [x] B8 P(A|B) ≠ P(B|A): prosecutor's fallacy drills — `mcq`
- [x] B9 Odds form: posterior odds = prior odds × likelihood ratio — `numeric`
- [x] B10 Sequential evidence: two tests, compounding likelihood ratios; when compounding is
      legitimate (conditional independence) — `numeric`
- [ ] B11 Calibration seed: first estimation drills; what a 90% interval commits you to — `estimate`

### Stage 2 — Distributions as beliefs
- [ ] Distributions as answer sheets: pmf/pdf as "plausibility per value"
- [ ] The binomial likelihood: what data says about a rate
- [ ] Priors: uniform, informative, and what "letting the data speak" really means
- [ ] Beta-binomial updating: posterior = prior counts + observed counts
- [ ] Watching the posterior sharpen; how much one observation moves you
- [ ] Posterior predictive: what do you expect *next*?

### Stage 3 — Sequential updating & conjugacy
- [ ] Yesterday's posterior is today's prior (order of evidence doesn't matter — when it doesn't)
- [ ] Conjugacy as "the update has a closed form"; beta-binomial and normal-normal
- [ ] When conjugacy breaks and why that's fine (grid thinking preview)

### Stage 4 — Estimation & decisions
- [ ] Point estimates are loss-function choices (mean/median/mode ↔ quadratic/absolute/0-1 loss)
- [ ] Credible intervals vs confidence intervals (what each actually claims)
- [ ] Expected-value decisions; when the posterior says "don't decide yet"

### Stage 5 — Computation
- [ ] Grid approximation by hand (the honest workhorse) — `code` when available
- [ ] Monte Carlo: sampling replaces integration
- [ ] MCMC intuition: a random walk that spends time where plausibility is high
- [ ] Diagnostics intuition: when to distrust your samples

### Stage 6 — Models with structure
- [ ] Hierarchical intuition: shrinkage and partial pooling (eight-schools story)
- [ ] Regression with priors; regularization as prior belief
- [ ] Model comparison: why "fits better" isn't "is better"

### Stage 7 — Calibration & forecasting
- [ ] Scoring rules: Brier and log score; why calibration and sharpness both matter
- [ ] Being well-calibrated vs being right; reading your own calibration log
- [ ] Forecasting practice: base rates first, then adjust (reference-class thinking)

## Generation marker

`last_generated_lesson: 10`
(The generator updates this after each run. New lessons continue the next unchecked item, in order.)
