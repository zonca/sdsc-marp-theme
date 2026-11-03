#!/bin/sh
# Chrome launcher for Marp CLI (and any Puppeteer based tool) on hosts where
# unprivileged user namespaces are disabled by AppArmor, which is the case on
# Ubuntu 23.10+ including this machine (nebula, Ubuntu 24.04). In that state
# Chrome aborts with:
#
#   FATAL:zygote_host_impl_linux.cc: No usable sandbox!
#
# Puppeteer cannot be told to add "--no-sandbox" through Marp CLI, so Marp is
# pointed at this wrapper instead:
#
#   CHROME_PATH="$PWD/scripts/chrome-wrapper.sh" npx @marp-team/marp-cli ... --images png
#
# The wrapper picks the browser in this order: $MARP_CHROME_BIN, the newest
# Playwright Chromium in ~/.cache/ms-playwright, a system google-chrome or
# chromium, then PATH lookups. Override with MARP_CHROME_BIN if needed.

set -eu

if [ -n "${MARP_CHROME_BIN:-}" ]; then
  CHROME="$MARP_CHROME_BIN"
else
  CHROME=""
  for candidate in \
    $(ls -d "$HOME"/.cache/ms-playwright/chromium-*/chrome-linux*/chrome 2>/dev/null | sort -V -r) \
    $(ls -d "$HOME"/.cache/ms-playwright/chromium_headless_shell-*/chrome-headless-shell-linux*/chrome-headless-shell 2>/dev/null | sort -V -r) \
    /usr/bin/google-chrome \
    /usr/bin/chromium \
    /usr/bin/chromium-browser
  do
    if [ -x "$candidate" ]; then
      CHROME="$candidate"
      break
    fi
  done
fi

if [ -z "$CHROME" ]; then
  echo "chrome-wrapper: no Chrome or Chromium binary found" >&2
  exit 1
fi

exec "$CHROME" --no-sandbox --disable-gpu --disable-dev-shm-usage "$@"
