#!/usr/bin/env bash
# Copy the website-facing source (Hugo templates/partials, learn.css, learn.js,
# and the Netlify progress function) from web/ into the tristancode.com site.
# Run this after changing anything under web/. It does NOT commit — review the
# diff in the site repo, then commit/push there (or use `just publish-web`).
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$here/config.sh"

theme="$WORKSPACE/themes/tristancode-theme"

cp "$REPO"/web/layouts/learn/list.html      "$theme/layouts/learn/list.html"
cp "$REPO"/web/layouts/learn/puzzle.html    "$theme/layouts/learn/puzzle.html"
cp "$REPO"/web/layouts/learn/solution.html  "$theme/layouts/learn/solution.html"
cp "$REPO"/web/layouts/partials/builds-on.html   "$theme/layouts/partials/builds-on.html"
cp "$REPO"/web/layouts/partials/learn-data.html  "$theme/layouts/partials/learn-data.html"
cp "$REPO"/web/css/learn.css                "$theme/static/css/learn.css"
cp "$REPO"/web/js/learn.js                  "$WORKSPACE/static/js/learn/learn.js"
cp "$REPO"/web/netlify/functions/progress.mjs "$WORKSPACE/netlify/functions/progress.mjs"

echo "synced web/ → $WORKSPACE"
