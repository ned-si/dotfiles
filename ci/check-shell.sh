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
echo "== the user bin dirs survive macOS path_helper =="
# Another silent one. /etc/zprofile runs path_helper just before ~/.zprofile,
# and it appends the existing PATH after the system directories. Anything
# .zshenv prepended is demoted, so a tool in ~/.local/bin quietly loses to a
# system binary of the same name: `dc` resolved to /usr/bin/dc, the desk
# calculator, which just sits there reading stdin and looks like a hang.
#
# Replays that exact sequence in a throwaway HOME rather than trusting the real
# one, so it asserts what the tracked files do and nothing else. .zshenv sources
# ~/.zshenv.local, which does not exist in the fake HOME and is skipped, so no
# machine-local config can mask a regression here.
if [ "$(uname)" = "Darwin" ] && [ -x /usr/libexec/path_helper ]; then
  fake=$(mktemp -d)
  cp zsh/.zshenv zsh/.zprofile "$fake/"
  mkdir -p "$fake/.local/bin"
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
    note FAIL "user .local/bin at $loc is behind /usr/bin at $usr, system tools shadow user ones"
    fail=1
  fi
  rm -rf "$fake"
else
  note SKIP "not macOS, path_helper does not apply"
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
