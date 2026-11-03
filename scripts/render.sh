#!/bin/sh
# Render the demo deck to PNG (and PDF) with the SDSC Marp theme.
#
#   ./scripts/render.sh                 # demo deck -> out/
#   ./scripts/render.sh slides/my.md    # any deck, same theme
#
# The browser is launched through scripts/chrome-wrapper.sh, which adds the
# "--no-sandbox" flag needed on hosts where AppArmor blocks unprivileged user
# namespaces (Ubuntu 23.10+).

set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

export CHROME_PATH="$ROOT/scripts/chrome-wrapper.sh"

DECK=${1:-demo/demo.md}
NAME=$(basename "$DECK" .md)

npx --yes @marp-team/marp-cli@"${MARP_CLI_VERSION:-4.5.1}" "$DECK" \
  --theme themes/sdsc.css \
  --allow-local-files \
  --images png --image-scale 1 \
  -o "out/$NAME.png"

npx --yes @marp-team/marp-cli@"${MARP_CLI_VERSION:-4.5.1}" "$DECK" \
  --theme themes/sdsc.css \
  --allow-local-files \
  --pdf \
  -o "out/$NAME.pdf"

echo
echo "Rendered $DECK -> out/$NAME.00N.png, out/$NAME.pdf"
