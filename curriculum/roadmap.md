# Roadmap — the cross-track plan

The roadmap sets direction; each track's `curriculum/<track>.md` enumerates the next concrete
lessons. The weekly routine reads **Active tracks** below to know what to generate.

## Active tracks

| id | name | spine | status |
|---|---|---|---|
| `fp` | Functional & parallel thinking | [`fp.md`](fp.md) | active — Stages 0–5 mostly generated; spine ends at the Stage 7 capstone |
| `bayes` | Bayesian statistics | [`bayes.md`](bayes.md) | active — launched 2026-07 |

Planned, not yet active:

| id | name | notes |
|---|---|---|
| `ml` | Machine learning | launches in Phase 4 (see `../PROPOSAL.md` Part 3 for the drafted spine) |

## Buffer policy

Keep **≥ 8 unsolved lessons ahead of the learner per active track**, never more (feedback must land
before lessons are written). One weekly run covers all active tracks.

## Capstones (the milestones each track aims at)

- **fp** — re-derive a sequential algorithm as map/reduce/scan with a work/span analysis
  (end of Stage 7). The affine/interaction-nets material is an opt-in branch after that.
- **bayes** — build and defend a grid-approximation analysis of real data end-to-end (`code`,
  once the Pyodide runner exists); plus a personal calibration report from the `estimate` log.
- **ml** — diagnose a deliberately broken pipeline (leakage, imbalance, bad baseline) from evidence.

## Pacing intent

- Difficulty ramps per track: warm-up early, genuinely hard later — bias toward "slightly too hard"
  once past the basics (standing feedback in `../generation/feedback.md`).
- Cross-link tracks via `builds_on` only within a track; use prose mentions across tracks
  (e.g. ML's "attention parallelizes" pointing at fp's work/span material).
- Interleaving (a "today's set" mixing tracks) is planned once per-track progress has data —
  see `../PROPOSAL.md` Part 5.

## Branch points (opt-in deep dives, offered when the learner asks)

- fp: affine/once-use thinking, interaction nets; possibly Futhark/GPU or Lean/proof flavors.
- bayes: PyMC-style probabilistic programming once Stage 5 lands.
- ml: Karpathy Zero-to-Hero shadow track alongside Stage 4.
