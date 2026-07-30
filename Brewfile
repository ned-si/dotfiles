# Homebrew toolchain for these dotfiles.
#
#   task brew      install everything listed here
#   task brew:tex  install the TeX/PDF casks (needs sudo, run it yourself)
#
# Deliberately absent: yabai / skhd / spacebar. Their configs live in the
# macos-wm stow package but they need SIP changes that are not an option on a
# managed work machine.

# --- shell and terminal ---------------------------------------------------
brew "powerlevel10k"
brew "tmux"
brew "zoxide"
brew "fzf"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# --- core cli -------------------------------------------------------------
brew "stow"
brew "ripgrep"
brew "fd"
brew "bat"
brew "eza"
brew "git-delta"
brew "jq"
brew "tree"

# --- git, forges, issue trackers -----------------------------------------
brew "git"
brew "gh"
brew "lazygit"
brew "jira-cli"
brew "go-task"

# --- editor ---------------------------------------------------------------
brew "neovim"
brew "lua-language-server"
brew "stylua"
brew "tree-sitter-cli"

# --- file manager ---------------------------------------------------------
# yazi previews need these: video thumbnails, PDFs, archives, images.
brew "yazi"
brew "ffmpeg"
brew "poppler"
brew "sevenzip"
brew "imagemagick"

# --- python ---------------------------------------------------------------
# uv is what devops-cli uses; pyenv is here for pinning interpreter versions.
brew "uv"
brew "pyenv"
brew "ruff"

# --- infrastructure -------------------------------------------------------
brew "terraform"
brew "opentofu"
brew "kubectl"
brew "kubectx"
brew "kubeconform"
brew "helm"
brew "k9s"

# --- java -----------------------------------------------------------------
# Keg-only. zsh sets JAVA_HOME rather than symlinking into
# /Library/Java/JavaVirtualMachines, which would need sudo.
brew "openjdk"
brew "maven"

# --- node -----------------------------------------------------------------
# Needed by npm-groovy-lint for Jenkinsfile linting.
brew "node"

# --- music engraving ------------------------------------------------------
# LilyPond for drum sheets. nvim-lilypond-suite's player renders the emitted
# MIDI with timidity, converts with ffmpeg, then plays it through mpv, so all
# three are required for playback to work.
brew "lilypond"
brew "timidity"
brew "mpv"
# Alternative synth to timidity. Needs a SoundFont supplied separately, which is
# why timidity is the configured default.
brew "fluid-synth"

# --- casks ----------------------------------------------------------------
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"
cask "font-victor-mono-nerd-font"
cask "font-meslo-for-powerlevel10k"
cask "obsidian"
