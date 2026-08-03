#!/usr/bin/env bash
# tmux config: does it load, and are the bindings the ones intended?
#
# Loading is not enough on its own. Two bugs got through review by being valid
# tmux config that could never fire: M-S-<lower> spellings, which no terminal
# produces, and a key bound twice so the later silently won.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

SOCK="ci-tmux-$$"
fail=0
note() { printf '  %-8s %s\n' "$1" "$2"; }
cleanup() { tmux -L "$SOCK" kill-server 2>/dev/null || true; }
trap cleanup EXIT

echo "== config loads without error =="
if tmux -f tmux/.tmux.conf -L "$SOCK" new-session -d 2>/tmp/ci-tmux-err; then
  note OK "tmux.conf"
else
  note FAIL "tmux.conf"; sed 's/^/           /' /tmp/ci-tmux-err; exit 1
fi
if [ -s /tmp/ci-tmux-err ]; then
  note WARN "stderr while loading:"; sed 's/^/           /' /tmp/ci-tmux-err
fi
rm -f /tmp/ci-tmux-err

echo
echo "== no M-S-<lower> spellings =="
# tmux accepts M-S-j but treats it as a different key from M-J, and a terminal
# sends Alt+Shift+j as ESC followed by J. Such a binding can never match.
if grep -nE 'bind[^#]*M-S-[a-z]' tmux/.tmux.conf; then
  note FAIL "use M-<uppercase> instead"
  fail=1
else
  note OK "none found"
fi

echo
echo "== expected root-table bindings, each exactly once =="
for k in M-h M-j M-k M-l M-H M-J M-K M-L M-b M-v M-c M-n M-p M-s; do
  n=$(tmux -L "$SOCK" list-keys -T root 2>/dev/null \
      | grep -cE "^bind-key +-T root +${k} ")
  case "$n" in
    1) note OK "$k" ;;
    0) note FAIL "$k missing"; fail=1 ;;
    *) note FAIL "$k bound $n times"; fail=1 ;;
  esac
done

echo
echo "== all four pane directions are navigable =="
# M-h was once bound to both split-window and select-pane, so the later won and
# one direction was unreachable.
for pair in "M-h:-L" "M-j:-D" "M-k:-U" "M-l:-R"; do
  key="${pair%%:*}"; dir="${pair##*:}"
  if tmux -L "$SOCK" list-keys -T root | grep -qE "^bind-key +-T root +${key} +select-pane ${dir}\$"; then
    note OK "$key selects $dir"
  else
    note FAIL "$key does not select $dir"; fail=1
  fi
done

echo
echo "== options that other things depend on =="
# yazi's image previews need passthrough; nvim's autoread needs focus-events.
for opt in allow-passthrough:on focus-events:on; do
  name="${opt%%:*}"; want="${opt##*:}"
  got=$(tmux -L "$SOCK" show -gv "$name" 2>/dev/null)
  if [ "$got" = "$want" ]; then note OK "$name=$got"; else note FAIL "$name=$got want $want"; fail=1; fi
done

exit "$fail"
