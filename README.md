# daily-learning-puzzles

A self-paced daily/weekly puzzle path that teaches the ideas behind the **Bend** language *in the
abstract* — pure functions, recursion, higher-order functions, closures, algebraic data types,
pattern matching, folds, continuations, and the `map`/`reduce`/`scan` thinking that makes code
parallelizable. It publishes to the **`/learn/`** section of [tristancode.com](https://tristancode.com/learn/).

This repo is the **single source of truth** for the whole system. The lessons that appear on the site
are treated as build *outputs*: a generator writes them into a gitignored `build/` dir, and a publish
step copies them into the website repo, which Netlify deploys.

## Layout

```
curriculum/
  curriculum.md          # the ordered concept "spine" + the last_generated_lesson marker
  roadmap.md             # (stub) longer-horizon plan the curriculum serves
generation/
  generation-prompt.md   # how to author a good lesson: front-matter schema + hard rules
  feedback.md            # your feedback log; the routine applies it each run
routine/
  RUNBOOK.md             # the versioned weekly-run procedure (uses $LEARN_TOKEN, no secret)
web/                     # website-facing SOURCE, synced into the Hugo site
  layouts/learn/*.html   #   section templates (list / puzzle / solution)
  layouts/partials/*.html#   builds-on backlinks, lesson-index data
  css/learn.css          #   all .learn-* styles (loaded site-wide by the theme)
  js/learn.js            #   progress sync, resume, "create bookmark", MCQ, "start from here"
  netlify/functions/progress.mjs   # progress backend (Netlify Blobs)
scripts/
  config.sh              # WORKSPACE path (the site repo); no secrets
  sync-web.sh            # copy web/* into the site repo
  publish.sh             # copy build/lessons/* → site content/learn, commit, push
build/lessons/           # generated lessons land here (gitignored, not source)
```

## How it fits together

- **The site** ([tristancode-workspace](https://github.com/tristanreid/tristancode-workspace)) is a
  Hugo site on Netlify. It holds *synced copies* of `web/*` (marked with a "synced from" header) plus
  the published `content/learn/*.md` lessons. It's the deploy target — Netlify builds it.
- **Progress** ("which lesson am I on") is stored in **Netlify Blobs**, keyed by a private token that
  lives in your bookmarkable `…/learn/?u=<token>` URL. Read/written via `/api/progress`
  (`web/netlify/functions/progress.mjs`). Cross-device, no login.
- **The weekly routine** (a scheduled Claude Code task) follows `routine/RUNBOOK.md`: it keeps at
  least **12 unsolved lessons ahead** of your current spot, generating a batch, copying it to the
  site, and pushing — never running further ahead than that, so your feedback always lands first.

## Common tasks

```sh
# after editing anything under web/ (templates, css, js, function):
scripts/sync-web.sh
#   then review + commit/push in the tristancode-workspace repo

# preview the site locally (from the tristancode-workspace repo):
mise exec hugo@0.155.2 -- hugo server

# publish generated lessons sitting in build/lessons/:
scripts/publish.sh "Add learn lessons NNNN–MMMM (concepts)"
```

## Giving feedback

Append notes to [`generation/feedback.md`](generation/feedback.md); the routine reads the whole file
each run and adjusts. To change *what/how* lessons are made, edit `curriculum/curriculum.md` and
`generation/generation-prompt.md`. To change *when/how* the routine runs, edit its local
scheduled-task config (the routine's steps are mirrored in `routine/RUNBOOK.md`).

## Secrets

This repo is public. The learner-progress **token is never committed here** — it lives only in the
local scheduled-task config. Committed docs reference `$LEARN_TOKEN`.
