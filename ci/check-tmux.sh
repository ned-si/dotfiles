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
echo "== every window shows its own name, and no filled blocks =="
# Asserts on the rendered status line, not on the config text, because the bug
# this catches was valid config: catppuccin renamed the option for unfocused
# windows between v1 and v2, the old name was accepted and ignored, and every
# window except the focused one displayed the pane title instead of its name.
# Nothing errored, so only looking at the output catches it.
#
# Three named windows, focus on the middle one, so a format that only works for
# the current window cannot pass.
tmux -L "$SOCK" rename-window one 2>/dev/null
tmux -L "$SOCK" new-window -n two 2>/dev/null
tmux -L "$SOCK" new-window -n three 2>/dev/null
tmux -L "$SOCK" select-window -t two 2>/dev/null
line=$(tmux -L "$SOCK" display-message -p "#{E:status-format[0]}" 2>/dev/null)
# Drop the #[...] style directives, leaving what a person would read.
visible=$(printf '%s' "$line" | sed 's/#\[[^]]*\]//g')

missing=""
for w in one two three; do
  case "$visible" in
    *"$w"*) ;;
    *) missing="$missing $w" ;;
  esac
done
if [ -n "$missing" ]; then
  note FAIL "window names absent from the status line:$missing"
  fail=1
else
  note OK "one, two and three all named"
fi

# Then both formats on their own, expanded in each window's context. Scoped to
# the formats rather than the whole line because status-right carries the
# hostname by default, and the symptom of the rename is the pane title appearing
# in the window list, which is also the hostname. Searching the whole line for
# it can never distinguish the two.
#
# Both formats are checked for every window, which is the actual requirement: a
# window is named the same whether or not it holds focus.
host=$(tmux -L "$SOCK" display-message -p "#T" 2>/dev/null)
formats_ok=1
for w in one two three; do
  for f in window-status-format window-status-current-format; do
    got=$(tmux -L "$SOCK" display-message -p -t "$w" "#{E:$f}" 2>/dev/null \
          | sed 's/#\[[^]]*\]//g')
    case "$got" in
      *"$w"*) ;;
      *) note FAIL "$f for '$w' renders '$got', without the name"; fail=1; formats_ok=0; continue ;;
    esac
    # Only meaningful when the host is not also the window name.
    if [ -n "$host" ] && [ "$host" != "$w" ]; then
      case "$got" in
        *"$host"*)
          note FAIL "$f for '$w' renders the pane title, the name option is ignored"
          fail=1; formats_ok=0 ;;
      esac
    fi
  done
done
[ "$formats_ok" = 1 ] && note OK "both formats render #W for every window"

# A background on either format is the pill look coming back.
for opt in window-status-style window-status-current-style; do
  got=$(tmux -L "$SOCK" show -gv "$opt" 2>/dev/null)
  case "$got" in
    *bg=*) note FAIL "$opt sets a background: $got"; fail=1 ;;
    *) note OK "$opt has no background" ;;
  esac
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
