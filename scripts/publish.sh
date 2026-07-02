#!/usr/bin/env bash
# Publish generated lessons: copy build/lessons/*.md into the site's content/learn,
# then commit and push (Netlify auto-deploys). For MANUAL runs — the scheduled
# routine performs the equivalent steps as individual commands (see routine/RUNBOOK.md).
#
# Usage:  scripts/publish.sh "Add learn lessons NNNN–MMMM (<concepts>)"
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$here/config.sh"

msg="${1:?usage: publish.sh \"commit message\"}"

shopt -s nullglob
lessons=("$REPO"/build/lessons/*.md)
if [ ${#lessons[@]} -eq 0 ]; then
  echo "no lessons in build/lessons/ — nothing to publish"
  exit 0
fi

cp "$REPO"/build/lessons/*.md "$WORKSPACE/content/learn/"
git -C "$WORKSPACE" add -A
git -C "$WORKSPACE" commit -m "$msg"
git -C "$WORKSPACE" push origin main
echo "published ${#lessons[@]} file(s) → tristancode.com/learn/"
