# Usage

What this setup can do and the keys to do it with. `README.md` covers install and
layout; this is the day-to-day reference.

Leader is `<Space>`. Local leader is `\`. In tmux the prefix is `C-f`.

---

## Contents

- [Terminal and multiplexer](#terminal-and-multiplexer)
- [Files and navigation](#files-and-navigation)
- [Editing](#editing)
- [Clipboard](#clipboard)
- [LSP and diagnostics](#lsp-and-diagnostics)
- [Languages](#languages)
- [YAML and Kubernetes](#yaml-and-kubernetes)
- [Git](#git)
- [Pull requests and issues](#pull-requests-and-issues)
- [Writing: Markdown, LaTeX, notes](#writing-markdown-latex-notes)
- [LilyPond](#lilypond)
- [AI agent in the editor](#ai-agent-in-the-editor)
- [Things that need a token or a one-off step](#things-that-need-a-token-or-a-one-off-step)

---

## Terminal and multiplexer

Ghostty is the terminal, tmux owns sessions and windows. Shell is zsh with
powerlevel10k, autosuggestions and syntax highlighting.

Opening a terminal drops you straight into tmux, with a new session per window.
Attaching to an existing session is deliberate: `tmux a`, or `prefix` `f` for the
sessionizer picker.

This is guarded so it only applies to real terminal windows. Anything that starts
an interactive shell to run a single command — git opening an editor, nvim's `:!`,
build tools, editor-integrated terminals — is left alone. If you ever need a
shell outside tmux, `zsh -i -c` or `TMUX=1 zsh` both bypass it.

The `M-` bindings depend on `macos-option-as-alt` in the Ghostty config. Without
it macOS consumes Option before tmux sees it and none of them fire. Switch it to
`left` if you want the right Option key back for character input.

| Key | Does |
| --- | --- |
| `C-f` | tmux prefix |
| `M-h/j/k/l` | move between panes |
| `M-H/J/K/L` | resize pane by 5 |
| `M-v` / `M-b` | split vertical / horizontal, in the current pane's directory |
| `prefix` `\|` / `prefix` `-` | the same splits, easier to remember |
| `M-n` / `M-p` / `M-c` | next / previous / new window |
| `M-s` | toggle synchronised panes, types into all of them at once |
| `prefix` `r` | reload tmux.conf |
| `prefix` `Tab` | extrakto: fuzzy-grab a path, URL or word off the pane |
| `prefix` `d` | jump to a session for the dotfiles repo |
| `prefix` `n` | jump to a session for the notes vault |
| `prefix` `f` | pick any project with fzf and jump to its session |
| `prefix` `t` | open this project's TODO.md, or the vault's |
| `prefix` `[` | copy mode: `v` to select, `y` to yank to the clipboard |

Shell aliases worth knowing: `v` nvim, `lg` lazygit, `ts` tmux-sessionizer, `k`
kubectl, `kctx`/`kns` context and namespace, `tf` terraform, `ghd` gh dash,
`catp` bat.

Listings are eza: `ls` and `l` are short (`l` includes dotfiles), `ll` and `la`
are the long form with permissions and a git column, `lt` is a tree. `lr`, `lS`,
`ldot`, `lart` and `lrt` are there too. The long ones stat every entry, which is
slow in `$HOME` because of the OneDrive placeholders — use `l` there.

`y` (shell function) opens yazi and leaves the shell in whatever directory you
quit from. `C-x C-x` edits the current command line in nvim. `C-r` is a
pattern-capable history search. `C-z` backgrounds, and foregrounds again on an
empty line.

Image previews work in yazi inside tmux because tmux has `allow-passthrough on`
and Ghostty speaks the Kitty graphics protocol.

## Files and navigation

| Key | Does |
| --- | --- |
| `<leader><space>` | find files in the project |
| `<leader>/` | live grep the project |
| `<leader>,` | switch buffer |
| `<leader>-` | yazi at the current file, with image previews |
| `<leader>cw` | yazi at the working directory |
| `<leader>pv` | same, out of old habit |
| `<leader>ha` / `<leader>hA` | harpoon: add / prepend current file |
| `<leader>hg` | harpoon menu |
| `<leader>j` `<leader>k` `<leader>l` `<leader>;` | jump to harpoon slot 1-4 |
| `<leader><C-j/k/l>` | replace harpoon slot 1-3 with the current file |
| `<leader>ts` | tmux-sessionizer in a new tmux window |
| `<leader>ss` | swap the two splits |
| `<leader>np` | centre a single buffer, for the ultrawide |
| `<leader>zm` / `<leader>tt` | zen mode / twilight dimming |

Harpoon is the main tool for a task: pin the three or four files you are actually
working on and jump by position rather than by name.

There is no file tree. Nothing docks to the left, and `<leader>e` is deliberately
unmapped. yazi is the only browser, and it also takes over directory buffers, so
`:e .`, `nvim <dir>` and `:Explore` all open it.

### Finding a mapping you have forgotten

| Key | Does |
| --- | --- |
| `<leader>` then pause | which-key lists everything under that prefix |
| `<leader>sk` | fuzzy-search **every** mapping, enter to run it |
| `<leader>?` | which-key popup of this buffer's local mappings |

`<leader>sk` is the one to reach for when you know what you want to do but not
which key does it.

## Editing

| Key | Does |
| --- | --- |
| `jj` | escape from insert |
| `'` | acts like a backtick, jump to exact mark |
| `J` / `K` in visual | move the selection down / up |
| `J` in normal | join, without the cursor drifting |
| `C-d` / `C-u` / `n` / `N` | scroll and search, keeping the cursor centred |
| `ys` / `ds` / `cs` | add / delete / change surround |
| `ga` | mini.align, line up columns |
| `<leader>tw` / `<leader>tl` | trim trailing whitespace / blank lines |
| `<leader>na` | ts-node-action, e.g. collapse or expand a multiline table |
| `<leader>U` | undo tree |
| `<leader>x` | chmod +x the current file |
| `<leader>dt` / `<leader>du` | diff the open windows / turn diff off |
| `<leader>tc` | toggle conceallevel, to see raw markup |
| `<leader>a` | Lazy plugin manager |
| `gcc` / `gc` | comment line / selection |

Autoformat is **off** by default. `<leader>cf` formats deliberately. Reformatting
a file you only opened to read produces noisy diffs.

`:q` behaves the way vim always has: it refuses on a modified buffer with `E37`,
`:q!` discards, `:wq` writes. LazyVim ships `confirm = true`, which replaces that
with a "Save changes?" dialog; that is turned off here.

## Clipboard

`clipboard` is deliberately empty, so nvim's registers and the system clipboard
are separate and crossing between them is always explicit.

| Key | Does |
| --- | --- |
| `<leader>y` | yank to system clipboard (`<leader>yy` for a line) |
| `<leader>Y` | yank the whole buffer to the system clipboard |
| `<leader>p` | in visual: paste over selection, keeping the register |
| `<leader>d` | delete without clobbering the register |
| `<leader>yr` / `<leader>yp` | yank the file's relative / absolute path |
| `<leader>yf` / `<leader>yd` | yank the filename / its directory |

One quirk: because `<leader>y` is an operator and `<leader>yf`/`<leader>yd` exist,
`<leader>y` followed by an `f` or `d` motion is shadowed. Everything else works.

## LSP and diagnostics

lspsaga is gone; this is native `vim.lsp` plus glance.nvim for peeking. Hover,
signature and diagnostic floats all have rounded borders.

| Key | Does |
| --- | --- |
| `K` | hover documentation |
| `gd` / `gr` / `gI` / `gy` | definition / refs / impl / type definition |
| `gh` | peek references in a split pane |
| `<leader>pd` / `<leader>pt` | peek definition / type definition |
| `<leader>pr` / `<leader>pi` | peek references / implementations |
| `<leader>cd` | line diagnostics in a float |
| `C-n` / `C-p` | next / previous diagnostic (normal mode only) |
| `]E` / `[E` | next / previous **error**, skipping warnings |
| `<leader>ca` | code action |
| `<leader>cr` | rename symbol |
| `<leader>cs` | document symbols |
| `<leader>cf` | format |
| `C-s` in insert | signature help |

## Languages

Servers install on demand through mason. Everything language-specific is
lazy-loaded by filetype, so listing a language costs nothing until you open one.

| Language | Server | Linter / formatter |
| --- | --- | --- |
| Python | basedpyright + ruff | ruff |
| Terraform | terraform-ls | tflint |
| YAML | yaml-language-server | kubeconform for manifests |
| Helm | helm-ls | |
| JSON / TOML | json-lsp / taplo | |
| Docker | dockerfile-language-server | hadolint |
| Groovy / Jenkinsfile | none, deliberately | npm-groovy-lint |
| Java | jdtls | |
| Lua | lua-language-server | stylua |
| Markdown | | markdownlint-cli2 |
| LaTeX | texlab + ltex-ls-plus | |
| Shell | | shellcheck, shfmt |

Python is 4-space with an 88-column marker. `<leader>cv` picks the virtualenv,
which matters when other tooling pins a shared uv environment and autodetection
would otherwise choose the wrong interpreter.

Jenkinsfiles are detected as groovy by filename, including `Jenkinsfile.release`
and `deploy.jenkinsfile`. There is no language server on purpose: groovyls
needs a
classpath a Jenkinsfile does not have, and reports the whole pipeline DSL as
undefined. npm-groovy-lint knows the DSL and gives real feedback.

Java is imported but inert. `jdtls` attaches only to java and gradle buffers.

## YAML and Kubernetes

The previous config crashed here, so this is set up deliberately.

Schemas come from schemastore, matched by filename. The Kubernetes schema is
applied to paths that plausibly hold manifests, `k8s/`, `kube/`, `kubernetes/`,
`manifests/`, `overlays/`, `base/`, and `*.k8s.yaml`, rather than to every `.yaml`
file. Applying it everywhere is what produced the flood of bogus diagnostics
before.

Helm templates go to `helm-ls`, not `yamlls`. Go templates are not valid YAML and
`yamlls` flags every `{{ }}` as a syntax error.

Real validation, including CRDs from the datree catalogue, comes from
`kubeconform` on write. A JSON schema alone cannot check a custom resource.

| Key | Does |
| --- | --- |
| `<leader>cyv` | show the key path at the cursor |
| `<leader>cyy` / `<leader>cyk` | yank the value / the key path |
| `<leader>cyq` | send all keys to the quickfix list |
| `<leader>cyK` | pin this buffer to the Kubernetes schema |

`<leader>cyK` inserts a `# yaml-language-server: $schema=kubernetes` modeline,
which survives being committed alongside the manifest.

## Git

lazygit is the main interface: `lg` in the shell, or `<leader>gg` in nvim. delta
renders every diff, in git, lazygit and nvim.

| Key | Does |
| --- | --- |
| `<leader>gg` | lazygit |
| `<leader>gb` | blame the current line |
| `<leader>gf` | file history |
| `]h` / `[h` | next / previous hunk |
| `<leader>ghs` / `<leader>ghr` | stage / reset hunk |
| `<leader>ogr` / `<leader>ogf` | open repo / file in a browser |

Identity is picked automatically. The default comes from the untracked
`~/.gitconfig.local`; repos with a personal remote get `nedsi` instead,
matched on
the remote URL rather than the path. Both SSH keys are served by the Bitwarden
agent, so there is no key material on disk.

Useful defaults: `zdiff3` conflicts show the common ancestor, `rerere` replays
resolutions you have already worked out, `push.autoSetupRemote` stops the
first push of a branch failing, and `git s` / `git lg` / `git last` / `git amend`
are aliased.

## Pull requests and issues

| Key | Does |
| --- | --- |
| `<leader>Po` | Octo, GitHub |
| `<leader>Pp` / `<leader>Pi` | GitHub PRs / issues |
| `<leader>Pb` | Bitbucket PRs |
| `<leader>Pj` | Jira issues |
| `ghd` in the shell | gh-dash, a GitHub PR and issue dashboard |

Octo covers GitHub and is mature. Bitbucket and Jira come from atlas.nvim, which
upstream describes as early and prone to breaking changes, so it lives alone in
`lua/plugins/forge.lua` and can be deleted without touching anything else.

## Writing: Markdown, LaTeX, notes

Prose filetypes get spell checking, wrapping at the text width, and grammar
checking from ltex-ls-plus in English and French. Source files do not.

Grammar suggestions come with code actions on `<leader>ca`: add a word to the
dictionary, disable a rule, or hide a false positive. These are not part of
LSP —
the server offers them but the editor has to do the work — so `ltex-client.nvim`
implements them. Without it they fail with "does not support command
`_ltex.addToDictionary`".

The dictionary lives in `~/.ltex/dictionaries`, **outside this repo and not
tracked**, because it accumulates project names, people and internal terms. It is
one location shared across every project, keyed by language, so a word added once
is known everywhere. `:LTeXSetLanguage` switches the language for the current
document and `:LTeXStatus` shows what the server is doing.

**LaTeX** is vimtex driving latexmk, with Skim as the viewer for bidirectional
SyncTeX: `C-S-click` in the PDF jumps to the source line.

| Key | Does |
| --- | --- |
| `\ll` | start or stop the compile watcher |
| `\lv` | open the PDF at the cursor position |
| `\lk` | stop compilation |
| `\lc` | clear auxiliary files |
| `\le` | show the error list |
| `\lt` | table of contents |

Auxiliary files go to `build/`, so the source directory stays clean.

**Notes** live in `~/braindump` as an Obsidian vault.

| Key | Does |
| --- | --- |
| `<leader>on` / `<leader>oo` | new note / open in the Obsidian app |
| `<leader>os` / `<leader>oq` | search / quick switch |
| `<leader>ot` / `<leader>oy` | today's / yesterday's daily note |
| `<leader>ob` / `<leader>of` | backlinks / follow link |
| `<leader>ol` | in visual: turn the selection into a link |
| `<leader>oi` | paste an image from the clipboard |

`<leader>tc` toggles conceal when you need to see the raw markup.

## LilyPond

| Key | Does |
| --- | --- |
| `\c` | compile |
| `\v` | open the PDF |
| `\p` | play the MIDI in a floating player |
| `\i` | insert the version header |
| `\h` | hyphenate lyrics |

Playback renders the MIDI with timidity, converts with ffmpeg and plays through
mpv. timidity rather than fluidsynth because fluidsynth needs a SoundFont that
Homebrew does not ship, while timidity bundles its own patches.

Errors land in the quickfix list and as diagnostics.

## AI agent in the editor

agentic.nvim speaks the Agent Client Protocol to an agent CLI, so it reuses that
CLI's existing auth, tool servers, skills and sub-agents rather than configuring
anything separately.

| Key | Does |
| --- | --- |
| `C-\` | toggle the chat |
| `<leader>ka` | add the current file or selection to context |
| `<leader>kn` | new session |
| `<leader>kr` | restore a previous session |
| `<localleader>m` / `<localleader>s` | switch model / provider |
| `Shift-Tab` | switch agent mode |
| `@` / `/` in the prompt | file picker / slash commands |

Sessions are shared in both directions, so a conversation started here can be
picked up in the terminal with `--resume` and vice versa.

Tool calls go through the plugin's permission prompt; `trust_all_tools` is
deliberately not set, since the agent can read and write the working tree.
`ACP_PROVIDER` in `~/.zshenv.local` selects which agent CLI to talk to.

## Things that need a token or a one-off step

| What | Why | Where |
| --- | --- | --- |
| `gh auth login` | Octo and gh-dash | once |
| Atlassian API token | Bitbucket PRs and Jira in nvim | `~/.zshenv.local` |
| Default git identity | kept out of a public repo | `~/.gitconfig.local` |
| Work tooling env | generated rc files, private paths | `~/.zshenv.local` |
| Internal SSH hosts | kept out of a public repo | `~/.ssh/config.local` |

One Atlassian API token covers both Bitbucket and Jira. The username must be your
account **email** for both APIs, not your Bitbucket username. Generate one at
<https://id.atlassian.com/manage-profile/security/api-tokens>.

`ltex-ls-plus` is a ~300MB JVM bundle, so expect 30 to 45 seconds before grammar
checking attaches to the first prose buffer of a session. That is the price of
multilingual checking; harper-ls starts instantly but is English-only.

`latexmk` is installed from CTAN into `~/.local/bin` by `task tex:latexmk`, not
through tlmgr, because tlmgr needs root and marks latexmk as non-relocatable so
its user mode refuses it.
