# Sourced by every zsh, interactive or not. Environment only: anything that
# prints, expects a TTY, or defines a widget belongs in .zshrc.

# Make path/fpath unique arrays so repeated sourcing cannot bloat them. Several
# things prepend to PATH unconditionally (generated rc files, nested tmux
# shells), and this makes all of that idempotent.
typeset -U path fpath

# --- editor ---------------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim
export KUBE_EDITOR=nvim
export PAGER=less
export LANG=en_US.UTF-8

# --- java -----------------------------------------------------------------
# Homebrew's openjdk is keg-only. Setting JAVA_HOME is enough for jdtls and
# maven, and avoids the sudo symlink into /Library/Java/JavaVirtualMachines
# that `brew info openjdk` suggests.
if [[ -d /opt/homebrew/opt/openjdk ]]; then
  export JAVA_HOME=/opt/homebrew/opt/openjdk
  path=("$JAVA_HOME/bin" $path)
fi

# --- path -----------------------------------------------------------------
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  $path
  "${KREW_ROOT:-$HOME/.krew}/bin"
)
[[ -d "$HOME/.cargo/bin" ]] && path+=("$HOME/.cargo/bin")

# BasicTeX/MacTeX. Not added by the installer, and vimtex needs latexmk here.
[[ -d /Library/TeX/texbin ]] && path+=(/Library/TeX/texbin)

# --- ssh agent ------------------------------------------------------------
# Bitwarden desktop serves every key from this socket, so there are no private
# keys on disk.
if [[ -S "$HOME/.bitwarden-ssh-agent.sock" ]]; then
  export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
fi

# --- machine-local overrides ---------------------------------------------
# Untracked, and the right home for anything work-specific: generated rc files
# from internal tooling, private paths, secrets, per-host environment. This repo
# is published, so none of that belongs in a tracked file.
#
# Sourced early so its exports are visible to everything that follows, including
# .zshrc.
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"
