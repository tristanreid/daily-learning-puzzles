---
name: learn-exam
description: Run an interactive oral exam for one tristancode.com/learn track (fp, bayes, cog, ml) or "all", find the learner's edge, and write a report the weekly generator reads.
---

Argument: `$ARGUMENTS` — a track id (`fp`, `bayes`, `cog`, `ml`) or `all`. If missing or invalid,
ask which track before doing anything else.

1. Obtain the progress token. It is **not** in this repo (the repo is public). Read
   `/Users/tristanreid/.claude/scheduled-tasks/learn-puzzle-generator/SKILL.md` and take the value
   of `LEARN_TOKEN`. Use it only in the `curl` call the examiner prompt describes. Never write it
   into any file, report, or feedback entry. If the file is missing, proceed without the token: the
   examiner prompt says how.
2. Read `assessment/examiner-prompt.md` in this repo and follow it exactly, with `<track>` set to
   the argument. The prompt covers preparation, the exam itself, the debrief, and writing the
   report to `assessment/reports/<track>/<YYYY-MM-DD>.md` per `assessment/report-schema.md`.
3. Do not commit or push. Do not edit any curriculum file. The only files you may write are new
   reports under `assessment/reports/` and, if the learner agrees in the debrief, an entry at the
   top of `generation/feedback.md`.

The learner is the person you are talking to. Keep the exam phase terse; save explanation for the
debrief.
