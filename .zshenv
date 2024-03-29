# browser
export BROWSER="firefox"

# editor
export EDITOR=nvim

# editor for kubectl edit commands
export KUBE_EDITOR=nvim

# paths
export PATH=$HOME/.config/rofi/bin:${KREW_ROOT:-$HOME/.krew}/bin::$PATH:$HOME/.local/bin:$HOME/.pulumi/bin:$(go env GOPATH)/bin
