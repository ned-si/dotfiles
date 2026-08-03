#!/usr/bin/env bash
# Stow layout: would every package link cleanly into an empty $HOME?
#
# Uses a throwaway target directory rather than the real $HOME, so this is safe
# to run locally on a machine that is already linked.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

fail=0
note() { printf '  %-8s %s\n' "$1" "$2"; }

TARGET=$(mktemp -d)
cleanup() { rm -rf "$TARGET"; }
trap cleanup EXIT

# Read the package lists straight out of the Taskfile so the two cannot drift.
common=$(grep -E '^  COMMON:' Taskfile.yml | sed 's/^  COMMON: *//')
linux=$(grep -E '^  LINUX:' Taskfile.yml | sed 's/^  LINUX: *//')
macoswm=$(grep -E '^  MACOS_WM:' Taskfile.yml | sed 's/^  MACOS_WM: *//')

echo "== packages named in the Taskfile exist as directories =="
for pkg in $common $linux $macoswm; do
  if [ -d "$pkg" ]; then note OK "$pkg"; else note FAIL "$pkg not a directory"; fail=1; fi
done

echo
echo "== each package simulates cleanly into an empty target =="
for pkg in $common $linux $macoswm; do
  [ -d "$pkg" ] || continue
  if stow --dir="$PWD" --target="$TARGET" --simulate "$pkg" >/tmp/ci-stow 2>&1; then
    note OK "$pkg"
  else
    note FAIL "$pkg"; sed 's/^/           /' /tmp/ci-stow; fail=1
  fi
done
rm -f /tmp/ci-stow

echo
echo "== all packages together, no collisions between them =="
if stow --dir="$PWD" --target="$TARGET" --simulate $common $linux >/tmp/ci-stow-all 2>&1; then
  note OK "common + linux"
else
  note FAIL "packages collide"; sed 's/^/           /' /tmp/ci-stow-all; fail=1
fi
rm -f /tmp/ci-stow-all

echo
echo "== nothing tracked outside a package or a known root file =="
# A config file that is not inside a stow package will never be linked, which is
# a silent way to lose a change.
known_root='^(Brewfile|Taskfile\.yml|README\.md|\.gitignore|docs/|ci/|\.github/)'
while IFS= read -r f; do
  top="${f%%/*}"
  if printf '%s' "$f" | grep -qE "$known_root"; then continue; fi
  # Inside a package, the second path element must be a dotfile or .config
  rest="${f#*/}"
  case "$rest" in
    .*) ;;
    *) note WARN "$f is in package '$top' but not under a dotfile path"; ;;
  esac
done < <(git ls-files | sort)
note OK "layout scan done"

exit "$fail"
