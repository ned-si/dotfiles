# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# tmux
case $- in *i*)
  if [ -z "$TMUX" ]; then exec tmux; fi;;
esac

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  autojump
  ansible
  colorize
  common-aliases
  docker
  docker-compose
  docker-machine
  helm
  kubectl
  kube-ps1
  python
  rsync
  safe-paste
  sudo
  systemadmin
  systemd
  terraform
  tmux
  vi-mode
  vundle
#  zsh-autosuggestions
  gcloud
)

source $ZSH/oh-my-zsh.sh

# aliases
alias v="nvim"
alias v.="nvim ."
alias vi="nvim"
alias vim="nvim"
alias pip="pip3"
alias lg="lazygit"
alias k="kubectl"
alias kubectl="kubecolor"
alias krew="kubectl krew"
alias kns="kubens"
alias kctx="kubectx"
alias kon="kubeon"
alias kof="kubeoff"
alias ts="tmux-sessionizer"

# autocompletion
## general
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit
compinit

## NOTE: must come before zsh-history-substring-search & zsh-syntax-highlighting.
autoload -U select-word-style
select-word-style bash # only alphanumeric chars are considered WORDCHARS

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

## kubectl
source <(kubectl completion zsh)
complete -F __start_kubectl k
## kubecolor
compdef kubecolor=kubectl

## aws
complete -C '/usr/bin/aws_completer' aws

## azure TODO: add it again later
# source /usr/share/bash-completion/completions/az

## terraform
complete -o nospace -C /usr/bin/terraform terraform

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## vagrant
fpath=(/opt/vagrant/embedded/gems/2.2.19/gems/vagrant-2.2.19/contrib/zsh $fpath)

## doctl
[[ $commands[doctl] ]] && source <(doctl completion zsh)
#
## openshift `oc`
if [ $commands[oc] ]; then
  source <(oc completion zsh)
  compdef _oc oc
fi


# options
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt NO_FLOW_CONTROL         # disable start (C-s) and stop (C-q) characters
setopt HIST_FIND_NO_DUPS       # don't show dupes when searching
setopt HIST_IGNORE_SPACE       # [default] don't record commands starting with a space
setopt LIST_PACKED             # make completion lists more densely packed


# Keybindings

## vi bindings
bindkey -v

## edit command with nvim

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

# Replace standard history-incremental-search-{backward,forward} bindings.
# These are the same but permit patterns (eg. a*b) to be used.
bindkey "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

# Functions

## Change local git config
function gcidtx() {
    git config user.name "Julien Sudan"
    git config user.email "juliensu@ext.inditex.com"
    git config user.signingkey C4C0EBDD98B457B6
}

function gcdtn() {
    git config user.name "Julien Sudan"
    git config user.email "julien.sudan@datenna.com"
    git config user.signingkey F2E011CB02DFC70A
}

function gcpma() {
    git config user.name "Julien Sudan"
    git config user.email "Julien.Sudan@madnesspartners.com"
    git config user.signingkey F96C11C4EADD77DC
}

## Start command
function start() {
  feh --bg-fill ~/personal/images/wallpaper-dune-2-09.jpg
  $HOME/.config/polybar/launch.sh --forest
  sudo systemctl restart logid.service
}

# Make CTRL-Z background things and unbackground them.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg


source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
