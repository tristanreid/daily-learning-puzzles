# Assessment — periodic oral exams that steer the generator

The site's own answer checks have stopped producing signal: every multiple-choice item is answered
correctly first try, no lesson has been rated "struggled", and the open-ended `reveal` lessons
check nothing. This directory adds a second feedback channel: an **interactive exam run by an LLM**
that escalates until it finds where correct reasoning stops, then writes a structured report the
weekly generator reads.

- [`examiner-prompt.md`](examiner-prompt.md) — the prompt that runs the session.
- [`report-schema.md`](report-schema.md) — what the session writes, and how the generator uses it.
- `reports/<track>/<date>.md` — the reports themselves (append-only).

## Running one

From a Claude Code session opened in this repo:

```
/learn-exam all        # first time: diagnostic sweep across all four tracks, ~45-60 min
/learn-exam bayes      # afterwards: one track in depth, ~30-45 min
```

The skill lives at `.claude/skills/learn-exam/SKILL.md`. It reads the progress token from the
local scheduled-task file (never from this repo) and hands off to the examiner prompt.

What to expect: two framing questions, then one question at a time with only *Correct / Partly /
No* in reply, then a debrief where the misses are explained and you can dispute the draft
statuses. At the end it asks whether to append its directives to `generation/feedback.md`.

Say "don't know" early and often. A fast honest miss is worth more to the report than a slow
reconstruction, and the session is budgeted on the assumption that about a third of the questions
will be missed.

## Wiring into the weekly run (not yet done — do after the first exam proves useful)

Two small edits make the generator act on reports without any new plumbing:

1. `routine/RUNBOOK.md` step 2: add "`assessment/reports/<track>/` — read the most recent report
   per track, if any, and apply its `directives`, `recommended_difficulty_shift`, and per-concept
   `recommendation` as described in `assessment/report-schema.md`."
2. `generation/generation-prompt.md` rule 8: add "When an assessment report exists for the track,
   its `recommended_difficulty_shift` overrides the default ramp, and `remediate` concepts must
   use a checked answer type."

Until then, saying yes to the append-to-feedback question at the end of the exam achieves most of
the effect, because the generator already reads `feedback.md` in full.

## Cadence

One exam per track roughly every eight completed lessons, matching the buffer depth, so results can
change direction before much has been written. The `all` sweep is for the first session and for
occasional "where am I" checks; it is too shallow to replace the per-track exam.
