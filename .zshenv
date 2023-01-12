# browser
export BROWSER="firefox"

# editor for kubectl edit commands
export KUBE_EDITOR=nvim

# ssh socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# paths
export PATH=$HOME/.config/rofi/bin:${KREW_ROOT:-$HOME/.krew}/bin:$LEGO_HOME/bin:$PATH:$HOME/.local/bin

# openai
source $HOME/.openai-api

# lego
export LEGO_HOME="$HOME/work/projects/idtx/lego/"
