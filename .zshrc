# k8s
autoload -Uz compinit
compinit
source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k

# aliases
alias vi="nvim"
alias vim="nvim"
alias pip="pip3"

# tmux --> testing without as iterm has it incorporated
# case $- in *i*)
#   if [ -z "$TMUX" ]; then exec tmux; fi;;
# esac

# Path to your oh-my-zsh installation.
export ZSH="/Users/jsu/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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
  debian 
  docker 
  docker-compose 
  docker-machine 
  helm 
  kubectl 
  python 
  rsync 
  safe-paste 
  sudo 
  systemadmin 
  systemd 
  tmux 
  vi-mode 
  vundle
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
   export EDITOR='nvim'
 fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
