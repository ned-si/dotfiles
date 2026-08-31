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

# --- launch tmux ----------------------------------------------------------
# Drop straight into tmux, so a terminal window is never outside it. exec, not
# plain tmux, so there is no stray parent shell to fall back into on detach.
#
# The guards matter more than the exec does. A bare `exec tmux` here hijacks
# anything that starts an interactive shell for a single command, which is a lot:
#
#   -o interactive            skip scripts and non-interactive shells
#   ZSH_EXECUTION_STRING      set by `zsh -ic 'cmd'`, which git, nvim's :!,
#                             build tools and agents all use. Without this,
#                             every one of them ends up inside a new tmux
#                             session and hangs waiting for a terminal.
#   -t 1                      stdout must be a real tty, not a pipe
#   TMUX                      already inside tmux: nesting is not wanted
#   TERM_PROGRAM              editor-integrated terminals manage their own
#                             shell and their integration breaks if replaced
#   NVIM / VIM                :terminal inside an editor
#   command -v tmux           on a machine without tmux this must be a no-op,
#                             not a broken login
#
# Placed after the instant prompt to match the original ordering, and after the
# Kiro CLI pre block, which does its own exec into a pty.
if [[ -o interactive ]] \
  && [[ -z "$ZSH_EXECUTION_STRING" ]] \
  && [[ -t 1 ]] \
  && [[ -z "$TMUX" ]] \
  && [[ -z "$NVIM" ]] \
  && [[ -z "$VIM" ]] \
  && [[ "$TERM_PROGRAM" != "kiro" ]] \
  && [[ "$TERM_PROGRAM" != "vscode" ]] \
  && [[ -z "$INSIDE_EMACS" ]] \
  && command -v tmux >/dev/null 2>&1
then
  # A fresh session per window, deliberately. Attaching to an existing one is a
  # conscious act: `tmux a`, or <prefix>f for the sessionizer picker.
  exec tmux
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

# eza for listings.
#
# The whole ls family has to be redefined, not just `ls`. oh-my-zsh's
# common-aliases plugin defines l, lr, lt, lS, ldot, lart and lrt in terms of BSD
# ls flags, and those are not eza flags: eza's -F/--classify takes an optional
# WHEN value, so `ls -lFh` becomes `eza -lFh` and eza reads the `h` as the value
# for --classify and errors out. Overriding only `ls` leaves the rest broken.
# common-aliases makes `l` a long listing. Keeping it short instead: the long
# form is what ll and la are for, and --git is only on those, since it stats
# every entry and that is slow in $HOME where the OneDrive placeholders live.
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --group-directories-first"
  alias l="eza -a --group-directories-first"
  alias ll="eza -lh --git --group-directories-first"
  alias la="eza -lha --git --group-directories-first"
  alias lt="eza --tree --level=2"
  alias lr="eza -lh --sort=modified --recurse --level=2"
  alias lS="eza -1 --sort=size --reverse"
  alias ldot="eza -lhd .*"
  alias lart="eza -1a --sort=changed --reverse"
  alias lrt="eza -1 --sort=changed --reverse"
fi

# `cat` is deliberately left alone so scripts and pipes keep working; use `catp`
# when you want the pretty version.
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

# --- suggestions, on demand only ------------------------------------------
# Nothing is proposed while typing. C-o fetches a suggestion for what is in the
# buffer; C-e or End accepts it, and typing on past it drops it.
#
# Proposing after every keystroke means the accept widgets are always live, and
# in vi mode those are keys used for ordinary editing (vi-end-of-line and
# vi-add-eol, i.e. $ and A), so a suggestion gets taken by accident rather than
# on purpose. Same reasoning as completion in nvim: offered when asked for.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

if (( ${+functions[_zsh_autosuggest_fetch]} )); then
  # Exactly what the plugin's own disable widget sets. There is no documented
  # option for "start disabled", and its presence, not its value, is what the
  # plugin tests.
  typeset -g _ZSH_AUTOSUGGEST_DISABLED

  # autosuggest-fetch does not consult that flag, so it still works while
  # suggestions are off, and no re-enabling dance is needed. Only the automatic
  # path in _zsh_autosuggest_modify bails out early.
  bindkey -M viins '^o' autosuggest-fetch
  bindkey -M vicmd '^o' autosuggest-fetch
fi

# --- completion menu: same keys as nvim -----------------------------------
# C-n and C-p move, C-y takes the highlighted entry, C-e dismisses. Enter and
# space are deliberately not accept keys: in the default menuselect keymap both
# commit whatever happens to be highlighted, which is the shell version of the
# <CR>-accepts-a-completion problem fixed in nvim.
zstyle ':completion:*' menu select
zmodload zsh/complist 2>/dev/null
if [[ -n "${modules[zsh/complist]}" ]]; then
  bindkey -M menuselect '^n' down-line-or-history
  bindkey -M menuselect '^p' up-line-or-history
  bindkey -M menuselect '^y' accept-line
  bindkey -M menuselect '^e' send-break
  # undo leaves the menu and puts the buffer back as it was, so neither key
  # silently inserts a completion.
  bindkey -M menuselect ' ' undo
  bindkey -M menuselect '^M' undo
fi

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
