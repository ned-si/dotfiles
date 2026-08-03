# dotfiles

macOS (work) and Arch/i3 (personal desktop), managed with GNU stow and
driven by [Taskfile](https://taskfile.dev).

Python, Terraform, YAML/Kubernetes and Jenkins are the day job, so that is what
the editor is set up for. Neovim is a thin layer over
[LazyVim](https://lazyvim.github.io); the goal is to lean on upstream rather than
hand-roll, so this repo stays small enough to still work after being ignored for
a year.

## Install

```sh
git clone git@github.com:ned-si/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles

task brew          # Homebrew toolchain (macOS)
task link          # symlink config into $HOME for this platform
task tmux:plugins  # tpm + tmux plugins
```

`task link` picks the package set from `uname`, so the same command is correct on
both machines. `task link:check` dry-runs it and shows what would change; `task
unlink` reverses it.

Stow refuses to overwrite a real file, so if `task link` reports conflicts, move
the existing file aside first. `task adopt` does the opposite of what you
probably want: it pulls `$HOME`'s version *into* the repo.

### Steps that need you

Two things cannot be automated:

```sh
gh auth login      # required by octo.nvim and gh-dash
task brew:tex      # Skim + BasicTeX, needs your sudo password
```

On first `nvim` launch, mason downloads `ltex-ls-plus`, which is a ~300MB
LanguageTool bundle. Let it finish before expecting grammar checking to work.

## Layout

Every top-level directory is a stow package whose interior mirrors `$HOME`:

| package | lands at | notes |
|---|---|---|
| `zsh` | `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.p10k.zsh` | |
| `tmux` | `~/.tmux.conf` | |
| `nvim` | `~/.config/nvim` | LazyVim |
| `git` | `~/.gitconfig`, `~/.config/git/` | identity split by remote |
| `ssh` | `~/.ssh/config` | no internal hosts, see below |
| `lazygit`, `gh-dash`, `ghostty` | `~/.config/<name>` | |
| `bin` | `~/.local/bin` | `tmux-sessionizer` |
| `linux-x11`, `i3`, `polybar`, `picom`, `rofi`, `autorandr`, `i3-layout-manager` | | Arch only |
| `macos-wm` | | yabai/skhd/spacebar, **never stowed automatically** |

`macos-wm` is kept because the config is worth not losing, but it needs SIP
changes that a managed work machine will not allow. `task link:macos-wm` if that
ever changes.

Platform differences used to live on git branches. That meant every shared change
landed twice and the platform branches needed perpetual rebasing, so it is now a
package-selection problem solved in `Taskfile.yml`.

## Checks

`task check:all` runs everything CI runs. Individually:

| task | checks |
|---|---|
| `check:shell` | zsh/bash syntax, shellcheck, and runs every listing alias |
| `check:lua` | stylua formatting |
| `check:tmux` | config loads, bindings are unique and reachable |
| `check:nvim` | starts clean, options/mappings/filetypes as configured |
| `check:stow` | every package links cleanly into an empty target |
| `check:ghostty` | config validates and the theme name resolves (macOS) |

CI runs the same tasks, so there is no separate CI logic to drift. Three jobs:
Linux for shell/tmux/stow, a cached Linux job for nvim, and macOS for ghostty.

These are not hypothetical. Every check here exists because something silently
broke: a Ghostty theme name that never resolved for over a year, tmux bindings
spelled in a way no terminal can produce, a lualine theme that fell back without
anyone noticing, plugins renamed upstream, and `l` breaking because eza rejects
BSD `ls` flags. All of them were invisible until something was actually run.

They deliberately stop short of anything needing a language server or a real
terminal. `<leader>ca` on a grammar warning, Option-as-Alt reaching tmux, and
YAML schema resolution all need a live environment, and testing them in CI buys
flakiness rather than confidence.

## Machine-local overrides

Anything secret, generated, or specific to one host goes in an untracked file.
All of these are optional and sourced only if they exist:

| file | for |
|---|---|
| `~/.zshenv.local` | environment and secrets, loaded early |
| `~/.zshrc.local` | interactive-only: aliases, functions |
| `~/.zprofile.local` | login-shell only |
| `~/.ssh/config.local` | work hosts and jump boxes |
| `~/.config/git/config.local` | anything not for publishing |

The split exists because ordering matters: `.zshenv.local` is read before the
powerlevel10k instant prompt, `.zshrc.local` after every widget is defined.

Generated rc files from other tooling are sourced from `~/.zshenv.local` rather
than inlined here, so their updates do not churn this repo and nothing
work-specific ends up in a published file.

## Git identity

The default identity lives in the untracked `~/.config/git/config.local`, since
this repo is published. Personal repos are matched on their **remote URL** rather
than their path, because they sit in `~/repos` alongside work checkouts:

```
~/repos/dotfiles     -> nedsi <nedsi@pm.me>          (personal remote)
~/repos/<work repo>  -> whatever config.local sets   (default)
```

Both SSH keys live in the Bitwarden agent, so there is no key material on disk
and nothing to configure per host.

## Neovim

Bindings that differ from LazyVim or from the old config:

| key | does | why |
|---|---|---|
| `<leader>j/k/l/;` | harpoon slots 1-4 | |
| `<leader>U` | undo tree | `<leader>u` is LazyVim's toggles group |
| `<leader>y` | yank to system clipboard | `clipboard=""`, so this is always explicit |
| `<leader>cy*` | YAML key-path tools | `<leader>y` is an operator, `<leader>yy` is taken |
| `<leader>cyK` | pin the buffer to the Kubernetes schema | when path matching guesses wrong |
| `<leader>pd` / `<leader>pt` / `gh` | peek definition / type / references | replaces lspsaga |
| `<leader>P*` | pull requests and issues | `Po` GitHub, `Pb` Bitbucket, `Pj` Jira |
| `<C-\>` | Kiro chat | |
| `<leader>-` | yazi | replaces ranger |

### Kiro in the editor

`kiro-cli acp` runs Kiro as an [Agent Client
Protocol](https://agentclientprotocol.com) agent, and
[agentic.nvim](https://github.com/carlos-algms/agentic.nvim) is an ACP client that
speaks to it. It reuses the CLI's existing auth, MCP servers, skills and
sub-agents, and sessions are shared: start a conversation in nvim and resume it
with `kiro-cli --resume`, or the reverse.

### YAML and Kubernetes

The previous config crashed on YAML because three plugins configured `yamlls` at
once and one of them applied the Kubernetes schema to every `.yaml` file. Now one
place configures it, Kubernetes is matched on paths that plausibly hold
manifests, and `kubeconform` does the actual validation including CRDs. Helm
templates go to `helm-ls`, because Go templates are not valid YAML and `yamlls`
flags every `{{ }}` as a syntax error.

### Forge integration

`octo.nvim` handles personal GitHub. Bitbucket and Jira come from `atlas.nvim`,
which upstream describes as early and prone to breaking changes; it is isolated in
`lua/plugins/forge.lua` so it can be deleted without touching anything else.
Credentials come from `~/.zshenv.local`:

```sh
export ATLAS_BITBUCKET_USER=...   # Atlassian account email
export ATLAS_BITBUCKET_TOKEN=...  # Atlassian API token
export ATLAS_JIRA_URL=https://<site>.atlassian.net
export ATLAS_JIRA_USER=...
export ATLAS_JIRA_TOKEN=...
```

### Java

Imported but inert: `jdtls` attaches only to `java` and `gradle` buffers.
Homebrew's `openjdk` is keg-only, so `.zshenv` sets `JAVA_HOME` rather than asking
for the `sudo` symlink into `/Library/Java/JavaVirtualMachines`.

### LilyPond

Compile and preview with `<localleader>c` / `<localleader>v`, play the MIDI with
`<localleader>p`. Playback renders through `timidity` rather than `fluidsynth`,
because `fluidsynth` needs a SoundFont that Homebrew does not ship.
