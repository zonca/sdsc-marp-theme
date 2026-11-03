#!/bin/sh
# Build the public preview of the demo deck:
#   preview/index.html   self-contained interactive preview (single file)
#   preview/deck.pdf     PDF version of the demo deck
#   preview/screenshot.png  contact sheet of all the slides
#
# The preview folder is what GitHub Pages publishes
# (https://zonca.github.io/sdsc-marp-theme/).

set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

export CHROME_PATH="$ROOT/scripts/chrome-wrapper.sh"
MARP="npx --yes @marp-team/marp-cli@${MARP_CLI_VERSION:-4.5.1}"

mkdir -p preview

echo "Rendering preview HTML"
$MARP demo/demo.md \
  --theme themes/sdsc.css \
  --allow-local-files \
  --html \
  -o preview/index.html

echo "Rendering preview PDF"
$MARP demo/demo.md \
  --theme themes/sdsc.css \
  --allow-local-files \
  --pdf \
  -o preview/deck.pdf

echo "Inlining assets"
python3 scripts/inline_assets.py preview/index.html

echo "Building contact sheet"
python3 scripts/contact_sheet.py out/demo.*.png preview/screenshot.png

touch preview/.nojekyll

echo
echo "Preview ready: preview/index.html, preview/deck.pdf, preview/screenshot.png"
