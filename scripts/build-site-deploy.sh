#!/usr/bin/env bash
# Build the Zola site for publication under the /site web context on barrel-organ-discovery.org.
# Produces HTML/assets with absolute URLs rooted at:
#   https://www.barrel-organ-discovery.org/site/
#
# Usage (from repo root):
#   ./scripts/build-site-deploy.sh
#
# Override base URL (must end with /):
#   BOD_SITE_BASE_URL="https://www.barrel-organ-discovery.org/site/" ./scripts/build-site-deploy.sh
#
# Local preview of the same paths (optional):
#   zola serve -u "http://127.0.0.1:1111/site/"
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SITE_BASE_URL="${BOD_SITE_BASE_URL:-https://www.barrel-organ-discovery.org/site/}"
case "$SITE_BASE_URL" in
  */) ;;
  *) SITE_BASE_URL="${SITE_BASE_URL}/" ;;
esac

if [[ -x "$ROOT/scripts/sync-wiki-static-assets.sh" ]]; then
  "$ROOT/scripts/sync-wiki-static-assets.sh"
fi

echo "Building with base_url=$SITE_BASE_URL"
zola build --base-url "$SITE_BASE_URL"
echo "Output: $ROOT/public/"
