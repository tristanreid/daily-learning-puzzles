# Weekly generation runbook

The versioned procedure the scheduled routine follows. The local scheduled-task
config (`~/.claude/scheduled-tasks/learn-puzzle-generator/SKILL.md`) is a thin
wrapper that points here and supplies the secret `LEARN_TOKEN`; that token is
**never** committed to this public repo.

## Paths
- **REPO** (this repo): `/Users/tristanreid/projects/github.com/tristanreid/daily-learning-puzzles`
- **SITE** (deploy target Hugo repo): `/Users/tristanreid/projects/github.com/tristanreid/tristancode-workspace`

## Command rules (keep the run hands-off)
One simple command per Bash call — no `cd`, no `&&` chains, no wrapper scripts
(those defeat the permission allow-list). Use `git -C <path> <subcmd>`, absolute
paths, `cp`, `curl`, `mise exec`, and the Read/Write/Edit file tools.

## Steps
1. **Sync both repos:**
   - `git -C REPO pull --ff-only`
   - `git -C SITE checkout main` then (separate call) `git -C SITE pull --ff-only`
2. **Read the source of truth** (file tools, in REPO):
   - `curriculum/roadmap.md` — the **Active tracks** table; every step below runs per active track.
   - `curriculum/<track>.md` — each track's ordered spine; continue from its `last_generated_lesson`.
   - `generation/generation-prompt.md` — the lesson-authoring spec (front-matter schema + rules).
   - `generation/feedback.md` — apply ALL feedback; "re-run this week" → regenerate the most
     recent UNSOLVED lessons of the named track in place instead of appending.
3. **Learner progress per track** `L(track)`:
   `curl -s "https://tristancode.com/api/progress?token=$LEARN_TOKEN&track=<track>"`
   → `{"lastCompleted": N}` (use 0 if it fails).
4. **Highest published lesson per track** `P(track)` = max `lesson_number` across
   `SITE/content/learn/<track>/*-puzzle.md` (Grep/Read; 0 if the dir is empty).
   Compute `buffer(track) = P - L`.
5. For each active track with `buffer >= 8`: nothing to generate for that track.
   If ALL tracks are covered: report "all buffers >= 8" and stop. No changes.
6. Otherwise, per under-buffered track, author exactly `8 - buffer` new lessons, numbered `P+1…`,
   each a puzzle+solution markdown PAIR written with the Write tool into
   `REPO/build/lessons/<track>/` (gitignored scratch). Follow `generation/generation-prompt.md`
   exactly (including `track:` front matter); take concepts in order from `curriculum/<track>.md`;
   honor the difficulty ramp in `generation/feedback.md`.
7. **Update the markers:** in each generated track's `REPO/curriculum/<track>.md`, mark the new
   items `[x]` and set `last_generated_lesson` to the new highest number (Edit tool).
8. **Copy into the site:** for each new file,
   `cp REPO/build/lessons/<track>/<name>.md SITE/content/learn/<track>/`
   (copy exactly the files you created this run).
9. **Verify the site build:**
   - `mise exec hugo@0.155.2 -- hugo --minify --source SITE` (must succeed)
   - `python3 SITE/scripts/check-internal-links.py` (must pass)
   Fix anything broken and re-verify.
10. **Publish lessons** (Netlify auto-deploys):
    - `git -C SITE add -A`
    - `git -C SITE commit -m "Add learn lessons (<track>: NNNN–MMMM, …)"` (no spoilers in the message)
    - `git -C SITE push origin main`
11. **Persist the markers** so the next run continues correctly:
    - `git -C REPO add -A`
    - `git -C REPO commit -m "Advance curricula (<track>: NNNN, …)"`
    - `git -C REPO push origin main`

## Constraints
- Never modify or regenerate a lesson at or below `L(track)` unless feedback says to re-run the week.
- Never generate more than needed to reach a buffer of 8 in a track.
- Lesson numbers are per track; never renumber across tracks.
- The token is private; never write it into any file under this repo.

## Done when
Every active track has `buffer >= 8` (or already had); the Hugo build + link check pass; new
lessons pushed to SITE; the curriculum markers pushed to REPO. Report per track the lesson
numbers + concepts, or that nothing was needed.
