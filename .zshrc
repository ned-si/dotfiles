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
alias ghd="gh dash"
alias restish="noglob restish"
alias findhost='ssh exoadmin@infra-dns003 findhost \$1\'
#alias findhost='ssh exoadmin@infra-dns003.gv2.p.exoscale.net findhost'
alias exo-irc="ssh irc -t 'tmux attach; bash -l'"
alias exo-api-pp="export EXOSCALE_API_KEY=$EXOSCALE_API_KEY_PP; export EXOSCALE_API_SECRET=$EXOSCALE_API_SECRET_PP; export EXOSCALE_API_ENDPOINT=$EXOSCALE_API_ENDPOINT_PP; export EXOSCALE_API_ENVIRONMENT=$EXOSCALE_API_ENVIRONMENT_PP"
alias exo-api-prod="export EXOSCALE_API_KEY=$EXOSCALE_API_KEY_PROD; export EXOSCALE_API_SECRET=$EXOSCALE_API_SECRET_PROD; unset EXOSCALE_API_ENDPOINT; unset EXOSCALE_API_ENVIRONMENT"
alias exo-api-test="export EXOSCALE_API_KEY=$EXOSCALE_API_KEY_TEST; export EXOSCALE_API_SECRET=$EXOSCALE_API_SECRET_TEST; unset EXOSCALE_API_ENDPOINT; unset EXOSCALE_API_ENVIRONMENT"
alias exo-api-pp-julien="export EXOSCALE_API_KEY=$EXOSCALE_API_KEY_PP_PERSONAL; export EXOSCALE_API_SECRET=$EXOSCALE_API_SECRET_PP_PERSONAL; export EXOSCALE_API_ENDPOINT=$EXOSCALE_API_ENDPOINT_PP; export EXOSCALE_API_ENVIRONMENT=$EXOSCALE_API_ENVIRONMENT_PP"
alias exo-api-prod-julien="export EXOSCALE_API_KEY=$EXOSCALE_API_KEY_PROD_PERSONAL; export EXOSCALE_API_SECRET=$EXOSCALE_API_SECRET_PROD_PERSONAL; unset EXOSCALE_API_ENDPOINT; unset EXOSCALE_API_ENVIRONMENT"
alias exo-ts="tailscale status -json | jq '.BackendState, .TailscaleIPs, .CurrentTailnet'"
alias exo-tu="sudo tailscale logout && sudo tailscale up --accept-routes --hostname=laptop-julien-sudan --shields-up --stateful-filtering"
alias exo-tlo="sudo tailscale logout"
alias exo-cl='ssh exoadmin@infra-cfg001.gv2.p.exoscale.net sudo puppet cert list'

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

## talhelper
source <(talhelper completion zsh)


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
function gcexo() {
    git config user.name "Julien Sudan"
    git config user.email "julien.sudan@exoscale.ch"
    git config user.signingkey 9BEDF41A8472C335
}

function gcmain() {
    git config user.name "Julien Sudan"
    git config user.email "nedsi@pm.me"
    git config user.signingkey 0B69285D11496F81
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

# yazi gooodness
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

complete -o nospace -C /usr/bin/tofu tofu

## zoxide
eval "$(zoxide init zsh)"
