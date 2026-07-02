#!/usr/bin/env bash
# Shared config for the daily-learning-puzzles scripts. NO secrets in here.
#
# The learner-progress token is deliberately NOT stored in this (public) repo.
# It lives only in the local scheduled-task config. For manual runs that need it,
# export it yourself:  export LEARN_TOKEN=...
set -euo pipefail

# Path to the tristancode.com Hugo site — the deploy target Netlify builds.
# Override by exporting WORKSPACE before running any script.
WORKSPACE="${WORKSPACE:-$HOME/projects/github.com/tristanreid/tristancode-workspace}"

# Absolute path to this repo (daily-learning-puzzles).
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
