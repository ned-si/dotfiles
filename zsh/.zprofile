# Login shells only.

# Kiro CLI manages this file itself; it is regenerated on update, which is why
# it is sourced rather than inlined here.
[[ -f "$HOME/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh" ]] \
  && builtin source "$HOME/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh"

# Homebrew. Must run before anything that resolves a brew-installed binary.
# Lives here rather than in .zshenv to keep the subprocess out of every
# non-interactive script; Ghostty and tmux both start login shells.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

# --- undo what path_helper did to the order --------------------------------
# /etc/zprofile runs macOS path_helper immediately before this file. It rebuilds
# PATH from /etc/paths and /etc/paths.d and *appends* whatever was already
# there, which silently demotes everything .zshenv prepended: ~/.local/bin ends
# up behind /usr/bin, so a tool installed there loses to a system one with the
# same name and you get the wrong binary with no indication why.
#
# So put the user directories back in front, after path_helper rather than
# before it. `typeset -U path` in .zshenv makes this a move, not a duplicate.
#
# Safe against the system tools because nothing in ~/.local/bin shares a name
# with one; the shell wrappers there are named "zsh (kiro-cli-term)" and cannot
# be reached as `zsh`. Before .zprofile.local, so machine-local paths still win.
path=("$HOME/.local/bin" "$HOME/bin" $path)

[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"

[[ -f "$HOME/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] \
  && builtin source "$HOME/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"
