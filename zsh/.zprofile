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

[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"

[[ -f "$HOME/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] \
  && builtin source "$HOME/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"
