# Track spine: `ml` — Machine learning

Lessons in this track live at `/learn/ml/` (front matter `track: ml`). Numbering starts at 1 and
is independent of other tracks.

This track teaches ML **concepts and failure modes**, not library tutorials — framed for someone
who already ships Spark pipelines. The destination is judgment: knowing why a model generalizes or
doesn't, what an evaluation does and doesn't show, and when the fancy thing loses to a baseline.
Evaluation discipline arrives deliberately *before* neural networks.

## Audience

Tristan: experienced software developer (Python, SQL, TypeScript, heavy Spark). Has met ML in
passing professionally; wants the concepts to be load-bearing, not buzzword-shaped. Comfortable
with code and light calculus; prefers puzzles that expose failure modes over derivations.

## Hard rules for every lesson

Same as the shared rules in `../generation/generation-prompt.md`, plus track-specific ones:

1. **Failure modes are the curriculum.** Overfitting, leakage, class imbalance, distribution
   shift, Goodharting — each gets confronted as a puzzle, not a warning label.
2. **Baselines before brilliance.** Every method lesson should answer "what dumb thing must this
   beat, and by how much?"
3. **Through-lines.** To the bayes track: losses as likelihoods, regularization as priors,
   calibrated probabilities. To the fp track: why training parallelizes (map/reduce gradients,
   attention as parallel lookup). Cross-track connections in prose, never in `builds_on`.
4. **Answer types:** `mcq` for predict-what-happens, `numeric` for compute-the-metric;
   `estimate` occasionally for empirical surprises. Interactive widgets and `code` arrive in a
   later phase — write lessons that stand without them.
5. **Resources.** Use the great free explainers: MLU-Explain, R2D3, distill.pub, 3Blue1Brown's
   neural-net series, ISLR (statlearning.com), TensorFlow Playground, Karpathy's Zero to Hero.

## The stages (ordered)

### Stage 0 — Learning as function fitting
- [x] M1 What "learning" means here: choose a function family, score it with a loss, search — `mcq`
- [x] M2 Memorization masquerades as skill: train vs test error, and the split that exposes it — `numeric`
- [x] M3 Overfitting by hand: model capacity vs data, the U-shaped test curve — `mcq`
- [ ] M4 Baselines: majority class, the mean, "predict yesterday" — and how often they win — `numeric`

### Stage 1 — Linear models & gradient descent
- [ ] Linear regression as the simplest fit; what the coefficients do and don't mean
- [ ] Loss surfaces; gradient descent as rolling downhill; learning rate pathologies
- [ ] Logistic regression: a linear model that outputs calibrated probabilities
- [ ] Regularization: penalizing complexity (and its Bayesian reading as a prior)

### Stage 2 — Trees & ensembles
- [ ] Decision trees: axis-aligned cuts, greedy splitting, why single trees overfit
- [ ] Bagging & random forests: averaging kills variance
- [ ] Boosting: stacking weak learners on residuals kills bias
- [ ] Feature importance skepticism: what "important" actually measures

### Stage 3 — Evaluation as epistemics  ← deliberately before neural nets
- [ ] Cross-validation: what it estimates, and how to leak through it
- [ ] Leakage: the career-saving lesson (target leakage, temporal leakage, group leakage)
- [ ] Class imbalance: accuracy lies; precision/recall/PR curves
- [ ] Calibration: when a 0.9 should mean 90% (bridge to the bayes track)
- [ ] Distribution shift: the model meets a world that moved

### Stage 4 — Neural networks
- [ ] The perceptron → depth: composing simple functions buys expressiveness
- [ ] Backpropagation: the chain rule, organized well
- [ ] Why training works anyway: SGD, overparameterization, early stopping
- [ ] What convolutions and attention each assume about structure

### Stage 5 — Embeddings & similarity
- [ ] Things as vectors: what distance in embedding space means
- [ ] Nearest neighbors: uses and traps (hubness, scale, stale embeddings)

### Stage 6 — Attention & modern architecture intuition
- [ ] Attention as soft dictionary lookup
- [ ] Why transformers parallelize (work/span, meeting the fp track's capstone)
- [ ] Scaling intuitions: what more data/params/compute each buy

### Stage 7 — Statistical wisdom
- [ ] Bias/variance in the wild; when linear beats deep
- [ ] Goodhart's law: optimizing the metric vs the goal
- [ ] Diagnosing a broken pipeline from evidence (capstone)

## Generation marker

`last_generated_lesson: 3`
(The generator updates this after each run. New lessons continue the next unchecked item, in order.)
