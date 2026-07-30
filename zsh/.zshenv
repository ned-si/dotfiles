# browser
export BROWSER="firefox"

# editor
export EDITOR=nvim

# editor for kubectl edit commands
export KUBE_EDITOR=nvim

# paths
export PATH=$HOME/.config/rofi/bin:${KREW_ROOT:-$HOME/.krew}/bin:$HOME/bin:$PATH:$HOME/.local/bin:$HOME/.pulumi/bin:$(go env GOPATH)/bin:$HOME/.cargo/bin

# unicode
export LANG="en_US.UTF-8"

# exo stuff
source $HOME/.exo-api-secrets
