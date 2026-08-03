#!/usr/bin/env bash
# Ghostty config validation. macOS only.
#
# Worth its own check: `theme = catppuccin-mocha` sat in this repo for over a
# year silently doing nothing, because the bundled theme is named
# "Catppuccin Mocha". Ghostty warns rather than failing, so nothing noticed.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

note() { printf '  %-8s %s\n' "$1" "$2"; }

GHOSTTY=""
for cand in /Applications/Ghostty.app/Contents/MacOS/ghostty "$(command -v ghostty 2>/dev/null)"; do
  [ -n "$cand" ] && [ -x "$cand" ] && GHOSTTY="$cand" && break
done

if [ -z "$GHOSTTY" ]; then
  note SKIP "ghostty not installed"
  exit 0
fi

echo "== config validates, and no warnings =="
out=$("$GHOSTTY" +validate-config --config-file=ghostty/.config/ghostty/config 2>&1)
code=$?

if [ -n "$out" ]; then
  # A named theme that cannot be resolved only produces a warning, so treat any
  # output at all as a failure.
  note FAIL "validate-config was not silent:"
  printf '%s\n' "$out" | sed 's/^/           /'
  exit 1
fi

if [ "$code" -ne 0 ]; then
  note FAIL "validate-config exited $code"
  exit 1
fi

note OK "silent and exit 0"

echo
echo "== the theme name resolves to a real theme =="
theme=$(grep -E '^theme *=' ghostty/.config/ghostty/config | head -1 | sed 's/^theme *= *//')
if [ -z "$theme" ]; then
  note SKIP "no theme configured"
else
  themedir="/Applications/Ghostty.app/Contents/Resources/ghostty/themes"
  if [ -e "$themedir/$theme" ]; then
    note OK "theme '$theme' exists"
  else
    note FAIL "theme '$theme' not in $themedir"
    exit 1
  fi
fi
