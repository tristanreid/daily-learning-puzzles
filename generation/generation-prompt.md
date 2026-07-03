# Lesson-authoring spec

How to author a good lesson. This is the *content* spec — the operational run procedure (sync,
buffer math, publish) lives in [`../routine/RUNBOOK.md`](../routine/RUNBOOK.md), and the ordered
concepts live in [`../curriculum/curriculum.md`](../curriculum/curriculum.md).

A **lesson** = one puzzle page **and** its solution page. When generating, write both files into
`build/lessons/` (gitignored scratch); the routine copies them to the site.

## Hard rules for a good lesson

1. **Standalone.** Re-define every term used ("a *pure function* is one whose output depends only on
   its inputs, with no side effects"). Never assume the reader remembers a previous lesson.
2. **Build, but link.** When a lesson leans on an earlier concept, list it in `builds_on` so the
   backlink renders. Going deeper is opt-in, not required.
3. **5–10 minutes.** One idea, sharply. If it needs more, split across lessons.
4. **Concept over jargon.** Use a real language only when it illuminates the concept, and then give
   enough that a dev who's never seen it can follow. Default to Python/TS/Scala-flavored pseudocode.
5. **Classical before clever.** Establish the classic version of an algorithm/structure before any
   optimized or alternative variant.
6. **Solution teaches.** The solution page fully explains the answer, the *why*, common pitfalls, and
   a forward hook ("this is the seed of folds, coming up").
7. **Through-line.** When natural, connect back to why this matters for parallelism: purity +
   immutability + associativity are what let work run in any order / in parallel — no threads,
   locks, mutexes, or atomics. Spark, MapReduce, GPU kernels, and languages like Bend all express
   this idea; cite whichever example illuminates, and never treat any single one as the destination.
8. **Difficulty ramps.** Honor `generation/feedback.md` — after the early warm-up, puzzles should be
   genuinely challenging; bias toward slightly-too-hard over too-easy.

## Answer types (pick the best fit)

- `reveal` — think/sketch, then reveal the solution. Best for "write this function" puzzles.
- `mcq` — multiple choice, client-checked. Best for "which of these is X / predict the result".
- `numeric` — the reader types a number, checked against `answer` ± `tolerance`. Best when the
  puzzle has one numeric result: counts, complexities, work/span figures, probabilities. Prefer it
  over `mcq` when plausible distractors are hard to write — it can't be brute-forced. After three
  misses the solution unlocks anyway.
- `estimate` — the reader gives a best guess plus a 90% interval before seeing the true value;
  hit/miss is logged for calibration. Use for genuine quantity questions where being calibrated
  matters more than being exact. There is no "wrong" interval, so the puzzle body should still
  pose reasoning worth doing.
- `code` — in-browser runnable check (Pyodide). **Not built yet.** Don't use until the tooling exists.

Every solution page may also carry a `resources` list — 1–3 high-quality free links (interactive
explainers, free textbook chapters, videos) rendered as a "Go deeper" box. Only include links you
are confident exist and are stable; prefer the classics (Seeing Theory, MLU-Explain, R2D3,
Distill.pub, free textbook sites) over blog posts.

## File + front-matter schema

Two files per lesson, zero-padded to 4 digits, written to `build/lessons/`:

`build/lessons/NNNN-puzzle.md`
```yaml
---
title: "Short puzzle title"
description: "One-sentence summary for SEO/cards."
lesson_number: N                # integer, matches the filename
concept: "Pure functions"       # short concept label (shown in eyebrow/archive)
stage: 0                        # curriculum stage number
layout: puzzle                  # selects layouts/learn/puzzle.html
role: puzzle                    # used by templates to find puzzle/solution pairs
answer_type: mcq                # "reveal", "mcq", "numeric", or "estimate" (no "code" yet)
builds_on: [1, 3]               # lesson numbers; [] if none. Renders backlinks.
skin: chalkboard
mcq:                            # ONLY when answer_type: mcq
  question: "Which function is pure?"
  options:
    - "First option"
    - "Second option"
  correct: 1                    # 0-based index of the correct option
numeric:                        # ONLY when answer_type: numeric
  question: "How many comparisons in the worst case?"   # optional; body may pose it instead
  answer: 42                    # the number to check against
  tolerance: 0                  # optional absolute tolerance; default 0 (exact)
  unit: "comparisons"           # optional label shown next to the input
estimate:                       # ONLY when answer_type: estimate
  prompt: "What fraction of positives are true positives?"  # optional; body may pose it
  answer: 0.087                 # the true value, revealed at lock-in
  unit: ""                      # optional
---

Puzzle body in Markdown. Define every term. Pose one clear challenge.
```

`build/lessons/NNNN-solution.md`
```yaml
---
title: "Solution: same/related title"
description: "One-sentence summary."
lesson_number: N                # MUST equal the puzzle's number (pairs them)
concept: "Pure functions"
stage: 0
layout: solution                # selects layouts/learn/solution.html
role: solution
builds_on: [1, 3]
skin: chalkboard
resources:                      # optional "Go deeper" links (0–3); solution pages only
  - title: "Seeing Theory — Conditional probability"
    url: https://seeingtheory.brown.edu/compound-probability/index.html
    note: "interactive visualization"   # optional
---

Full explanation: the answer, why it's right, the underlying concept, common pitfalls, and a
forward hook to what it sets up.
```

Notes:
- Templates pair a puzzle with its solution by matching `lesson_number` — keep them equal, and keep
  the filename's number in sync.
- Ordering, the resume button, and the buffer math all key off `lesson_number`.
- Include ONLY the block matching `answer_type` (`mcq:`, `numeric:`, or `estimate:`); for `reveal`
  omit all three (the solution link shows immediately). For `mcq`/`numeric`, the solution link
  unlocks on a correct answer (numeric also unlocks after three misses); for `estimate`, on lock-in.
- Cross-links between lessons use root-relative paths like `../0003-puzzle/` (they resolve on the site).

## Re-runs (when feedback says "re-run this week")

Regenerate only lessons **above** `L` (the learner's last completed) — never rewrite a lesson already
finished. Overwrite the relevant `NNNN-puzzle.md` / `NNNN-solution.md` in place, keeping the numbers.
