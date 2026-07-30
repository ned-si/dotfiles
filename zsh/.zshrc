# Interactive shells.
#
# Ordering here is load-bearing in three places:
#   - the Kiro CLI pre block can exec() into its own pty, so it goes first
#   - p10k's instant prompt must precede anything that writes to the terminal
#   - zsh-syntax-highlighting must be sourced after every other zle widget
# Everything else is grouped for readability.

# Kiro CLI manages this file itself and regenerates it on update, so source it
# rather than inlining the generated block.
[[ -f "$HOME/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] \
  && builtin source "$HOME/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Powerlevel10k instant prompt. Anything that may prompt for input must go
# above this line.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- oh-my-zsh ------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # powerlevel10k is sourced below instead

# Trimmed down from the Arch/Exoscale set: dropped systemd, systemadmin,
# vundle, autojump (zoxide replaces it), gcloud and ansible.
plugins=(
  git
  docker
  docker-compose
  kubectl
  helm
  terraform
  python
  macos
  common-aliases
  safe-paste
  sudo
  vi-mode
  colored-man-pages
)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# --- prompt ---------------------------------------------------------------
if [[ -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
fi
# Run `p10k configure` to regenerate.
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# --- aliases --------------------------------------------------------------
alias v="nvim"
alias v.="nvim ."
alias vi="nvim"
alias vim="nvim"

alias lg="lazygit"
alias ghd="gh dash"

alias k="kubectl"
alias kns="kubens"
alias kctx="kubectx"

alias tf="terraform"

alias ts="tmux-sessionizer"

# eza for listings. `cat` is deliberately left alone so scripts and pipes keep
# working; use `catp` when you want the pretty version.
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --group-directories-first"
  alias ll="eza -l --git --group-directories-first"
  alias la="eza -la --git --group-directories-first"
  alias lt="eza --tree --level=2"
fi
command -v bat >/dev/null 2>&1 && alias catp="bat -p"

# --- history --------------------------------------------------------------
export HISTFILE="$HOME/.history"
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

setopt NO_FLOW_CONTROL    # free up C-s and C-q
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE  # a leading space keeps a command out of history
setopt LIST_PACKED
setopt SHARE_HISTORY

# --- completion -----------------------------------------------------------
# Homebrew drops completions here; must be on fpath before compinit.
[[ -d /opt/homebrew/share/zsh/site-functions ]] \
  && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
[[ -d "$HOME/.zfunc" ]] && fpath=("$HOME/.zfunc" $fpath)

autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Only alphanumerics count as word characters, so C-w stops at punctuation.
# Must come before the history-search and syntax-highlighting plugins.
autoload -U select-word-style && select-word-style bash

complete -F __start_kubectl k 2>/dev/null

# These ship as bash-style completers rather than zsh functions.
[[ -x /opt/homebrew/bin/terraform ]] \
  && complete -o nospace -C /opt/homebrew/bin/terraform terraform
[[ -x /opt/homebrew/bin/tofu ]] \
  && complete -o nospace -C /opt/homebrew/bin/tofu tofu
command -v aws_completer >/dev/null 2>&1 \
  && complete -C "$(command -v aws_completer)" aws

# --- keybindings ----------------------------------------------------------
bindkey -v

# Edit the current command line in nvim.
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

# Pattern-capable variants of the default incremental search.
bindkey "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

# C-z backgrounds, and also foregrounds again when the line is empty.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg

# --- functions ------------------------------------------------------------
# yazi, but leaves the shell in whatever directory you quit from.
function y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  local cwd
  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# --- tools ----------------------------------------------------------------
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v pyenv  >/dev/null 2>&1 && eval "$(pyenv init - zsh)"
command -v fzf    >/dev/null 2>&1 && source <(fzf --zsh)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- machine-local overrides ---------------------------------------------
# Untracked. Interactive-only work config: aliases, functions, completions for
# internal tools. Environment variables belong in ~/.zshenv.local instead.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Must be sourced after every other zle widget, so keep it last apart from the
# Kiro CLI post block.
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -f "$HOME/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] \
  && builtin source "$HOME/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
