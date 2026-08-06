#!/usr/bin/env bash
# Shell syntax and lint.
#
# Catches the class of bug that breaks a login shell outright: an unbalanced
# quote in .zshrc leaves you with no working terminal, which is a bad thing to
# discover by opening a terminal.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

fail=0
note() { printf '  %-8s %s\n' "$1" "$2"; }

echo "== zsh syntax =="
for f in zsh/.zshrc zsh/.zshenv zsh/.zprofile; do
  if zsh -n "$f" 2>/tmp/ci-zsh-err; then
    note OK "$f"
  else
    note FAIL "$f"; sed 's/^/           /' /tmp/ci-zsh-err; fail=1
  fi
done
rm -f /tmp/ci-zsh-err

echo
echo "== bash syntax =="
while IFS= read -r f; do
  if bash -n "$f" 2>/tmp/ci-bash-err; then
    note OK "$f"
  else
    note FAIL "$f"; sed 's/^/           /' /tmp/ci-bash-err; fail=1
  fi
done < <(find bin ci -type f \( -name '*.sh' -o -name 'tmux-sessionizer' \) 2>/dev/null | sort)
rm -f /tmp/ci-bash-err

echo
echo "== shellcheck =="
if command -v shellcheck >/dev/null 2>&1; then
  while IFS= read -r f; do
    if shellcheck --severity=warning "$f" >/tmp/ci-sc 2>&1; then
      note OK "$f"
    else
      note FAIL "$f"; sed 's/^/           /' /tmp/ci-sc; fail=1
    fi
  done < <(find bin ci -type f \( -name '*.sh' -o -name 'tmux-sessionizer' \) 2>/dev/null | sort)
  rm -f /tmp/ci-sc
else
  note SKIP "shellcheck not installed"
fi

echo
echo "== every listing alias actually runs =="
# The `l` alias broke because eza rejects BSD ls flags, and that is invisible to
# a syntax check: `eza -lFh` is valid shell. Running each one is the only way.
#
# In an isolated directory on purpose. Some of these recurse, and pointing them
# at a shared /tmp means tripping over other processes' unreadable directories
# and failing for reasons that have nothing to do with the aliases.
if command -v eza >/dev/null 2>&1; then
  sandbox=$(mktemp -d)
  mkdir -p "$sandbox/sub"
  : > "$sandbox/a.txt"
  : > "$sandbox/.hidden"
  for a in ls l ll la lt lr lS ldot lart lrt; do
    out=$(cd "$sandbox" && zsh -i -c "$a" 2>&1 >/dev/null)
    if [ -n "$out" ]; then
      note FAIL "$a -> $(printf '%s' "$out" | head -1)"; fail=1
    else
      note OK "$a"
    fi
  done
  rm -rf "$sandbox"
else
  note SKIP "eza not installed, cannot exercise the aliases"
fi

exit "$fail"
