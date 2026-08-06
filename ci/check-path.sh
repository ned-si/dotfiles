#!/usr/bin/env bash
# PATH ordering on macOS.
#
# macOS runs path_helper from /etc/zprofile, immediately before ~/.zprofile. It
# rebuilds PATH from /etc/paths and /etc/paths.d and appends whatever was already
# there, which demotes everything .zshenv prepended. A tool installed in
# ~/.local/bin then loses to a system binary of the same name, with nothing to
# say so: `dc` resolved to /usr/bin/dc, the desk calculator, which reads stdin
# and sits there looking like a hang.
#
# Its own check rather than part of check-shell.sh, because it is only meaningful
# on macOS and check-shell.sh runs on the Linux job. A guard that always skips is
# worse than no guard, since it reads as covered.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

fail=0
note() { printf '  %-8s %s\n' "$1" "$2"; }

echo "== the user bin dirs survive path_helper =="
if [ "$(uname)" != "Darwin" ] || [ ! -x /usr/libexec/path_helper ]; then
  note SKIP "not macOS, path_helper does not apply"
  exit 0
fi

# Replays .zshenv -> path_helper -> .zprofile in a throwaway HOME, so this
# asserts what the tracked files do. Using the real HOME would let
# ~/.zshenv.local, which is untracked and machine-specific, mask a regression.
#
# zsh -f skips the rc files, which is the point: they are sourced explicitly
# below, in the order a login shell would, with nothing else interfering.
fake=$(mktemp -d)
trap 'rm -rf "$fake"' EXIT
cp zsh/.zshenv zsh/.zprofile "$fake/"
mkdir -p "$fake/.local/bin" "$fake/bin"

order=$(HOME="$fake" zsh -f -c '
  source "$HOME/.zshenv"
  eval "$(/usr/libexec/path_helper -s)"
  source "$HOME/.zprofile"
  integer i=0
  for p in $path; do
    i=i+1
    if [[ $p == "$HOME/.local/bin" ]]; then print "local=$i"; fi
    if [[ $p == /usr/bin ]]; then print "usrbin=$i"; fi
  done' 2>/dev/null)

loc=$(printf '%s\n' "$order" | sed -n 's/^local=//p' | head -1)
usr=$(printf '%s\n' "$order" | sed -n 's/^usrbin=//p' | head -1)

if [ -z "$loc" ]; then
  note FAIL "user .local/bin is not on PATH at all after path_helper"; fail=1
elif [ -z "$usr" ]; then
  note FAIL "/usr/bin is not on PATH, something is very wrong"; fail=1
elif [ "$loc" -lt "$usr" ]; then
  note OK "user .local/bin at $loc, ahead of /usr/bin at $usr"
else
  note FAIL "user .local/bin at $loc is behind /usr/bin at $usr, system tools win"
  fail=1
fi

exit "$fail"
