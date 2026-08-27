#!/usr/bin/env bash
# Neovim: does the config start clean, and are the mappings and options present?
#
# This is the check with the best return. Two bugs shipped as warnings on a
# startup nobody was reading: a lualine theme name that does not exist, and
# plugin renames. Both are only visible if warnings are treated as failures.
#
# CI sets CI=1, which disables mason (see lua/plugins/ci.lua) so this does not
# download several hundred megabytes of language servers on every run.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

fail=0
note() { printf '  %-8s %s\n' "$1" "$2"; }

# Run against a copy of the config. Never the working tree, and never whatever
# XDG_CONFIG_HOME happens to be set to.
#
# `Lazy! sync` below performs an update, which ignores lazy-lock.json, moves each
# plugin to the latest commit on its branch and then writes the lock back out
# to $XDG_CONFIG_HOME/nvim. Point that at the repo and simply running the check
# rewrites tracked plugin pins, so an unrelated commit can carry a plugin bump
# nobody asked for.
#
# Honouring a preset XDG_CONFIG_HOME, as this did at first, was worse than
# useless: GitHub's runners export XDG_CONFIG_HOME=/home/runner/.config, so the
# copy was never built in CI and the check read whatever happened to be in that
# directory, which only worked because the workflow linked the config into it.
# An ambient variable with nothing to do with this repo decided what got tested.
#
# So build it unconditionally. CHECK_NVIM_CONFIG is the way to aim the check at
# an already-installed config instead, e.g. the stowed one.
if [ -n "${CHECK_NVIM_CONFIG:-}" ]; then
  export XDG_CONFIG_HOME="$CHECK_NVIM_CONFIG"
else
  cfgcopy=$(mktemp -d)
  trap 'rm -rf "$cfgcopy"' EXIT
  mkdir -p "$cfgcopy/nvim"
  cp -R nvim/.config/nvim/. "$cfgcopy/nvim/"
  export XDG_CONFIG_HOME="$cfgcopy"
fi

echo "== every lua file parses =="
while IFS= read -r f; do
  if nvim --headless --clean -c "lua assert(loadfile('$f'))" -c 'qa!' 2>/tmp/ci-lua-err; then
    note OK "${f#nvim/.config/nvim/}"
  else
    note FAIL "${f#nvim/.config/nvim/}"; sed 's/^/           /' /tmp/ci-lua-err; fail=1
  fi
done < <(find nvim/.config/nvim -name '*.lua' | sort)
rm -f /tmp/ci-lua-err

echo
echo "== the config under test is the one that loads =="
# A precondition, because every section below reports OK when nvim produces no
# output at all: they test for the *absence* of complaints, and a `-c lua` that
# aborts early prints nothing to stdout. Point the check at an empty config and
# it passes almost everything, which is how a CI run with no config at all
# reported OK for options and completion while only the two sections that assert
# something is present failed. Assert the basics up front so a later OK means
# something was actually examined.
# Tagged with a sentinel and grepped back out, because this is the first nvim
# invocation of the run: on a cold cache lazy.nvim bootstraps here and prints its
# clone progress to stdout, which otherwise lands in the middle of the answer.
# That is what made this fail in CI while passing locally, where the cache is warm.
probe=$(nvim --headless -c 'lua
local lazy_ok = pcall(require, "lazy.core.config")
io.write("\nPROBE|" .. table.concat({
  vim.fn.stdpath("config"),
  tostring(lazy_ok),
  tostring(vim.g.mapleader),
  tostring(pcall(require, "config.keymaps")),
}, "|") .. "\n")' -c 'qa!' 2>/dev/null | sed -n 's/.*PROBE|//p' | tail -1)
if [ -z "$probe" ]; then
  note FAIL "nvim printed nothing at all, so nothing below would be tested"
  exit 1
fi
IFS='|' read -r p_cfg p_lazy p_leader p_keymaps <<EOF
$probe
EOF
if [ "$p_cfg" != "$XDG_CONFIG_HOME/nvim" ]; then
  note FAIL "nvim reads $p_cfg, not the copy at $XDG_CONFIG_HOME/nvim"; exit 1
fi
if [ "$p_lazy" != "true" ]; then
  note FAIL "lazy.nvim did not load, the config was not read"; exit 1
fi
if [ "$p_leader" != " " ]; then
  note FAIL "mapleader is [$p_leader], not a space, so the mapping check cannot work"; exit 1
fi
if [ "$p_keymaps" != "true" ]; then
  note FAIL "config.keymaps is not requireable from $p_cfg"; exit 1
fi
note OK "$p_cfg, lazy loaded, leader is a space"

echo
echo "== plugins install and resolve =="
sync_out=$(nvim --headless "+Lazy! sync" +qa 2>&1)
if printf '%s' "$sync_out" | grep -qiE 'was renamed|update your config'; then
  note FAIL "a plugin moved upstream:"
  printf '%s' "$sync_out" | grep -iE 'was renamed|update your config' | sort -u | sed 's/^/           /'
  fail=1
else
  note OK "no plugin renames pending"
fi
missing=$(nvim --headless -c 'lua
local out = {}
for name, p in pairs(require("lazy.core.config").plugins) do
  if not p._.installed then table.insert(out, name) end
end
io.write(table.concat(out, " "))' -c 'qa!' 2>/dev/null)
if [ -n "$missing" ]; then
  note FAIL "not installed: $missing"; fail=1
else
  note OK "all plugins installed"
fi

echo
echo "== startup produces no warnings or errors =="
# Warnings here are the point: "theme not found, falling back" is a warning.
#
# On failure the whole output is printed, not just the matching lines. nvim writes
# "Error in command line:" and puts the actual message on the following line, so
# grepping for matches alone throws away the only useful part.
start_out=$(nvim --headless -c 'doautocmd User VeryLazy' -c 'lua vim.wait(3000)' -c 'qa!' 2>&1)
if printf '%s' "$start_out" | grep -qiE '^E[0-9]+:|error|warn|not found|deprecat'; then
  note FAIL "startup was not clean, full output follows:"
  printf '%s\n' "$start_out" | sed 's/^/           | /'
  fail=1
else
  note OK "clean"
fi

echo
echo "== options that were deliberately chosen =="
opts=$(nvim --headless -c 'lua
local want = { confirm = false, autoformat = false, number = true, relativenumber = true,
               undofile = true, swapfile = false, clipboard = "", expandtab = true }
local bad = {}
for k, v in pairs(want) do
  local got = (k == "autoformat") and vim.g.autoformat or vim.o[k]
  if got ~= v then table.insert(bad, string.format("%s=%s want %s", k, tostring(got), tostring(v))) end
end
io.write(table.concat(bad, "; "))' -c 'qa!' 2>/dev/null)
if [ -n "$opts" ]; then note FAIL "$opts"; fail=1; else note OK "all as configured"; fi

echo
echo "== completion stays quiet until asked =="
# Guards the whole point of lua/plugins/completion.lua. LazyVim's own blink
# defaults are the opposite of every assertion below, so an upstream change or a
# stray opts table that stops overriding them would silently bring the popup and
# the <CR>-accepts-an-entry behaviour back.
#
# blink loads on InsertEnter, which never fires here, so ask lazy for it by name
# rather than relying on the require to trigger the load.
cmpcfg=$(nvim --headless -c 'lua
require("lazy").load({ plugins = { "blink.cmp" } })
local ok, cfg = pcall(require, "blink.cmp.config")
if not ok then io.write("blink.cmp.config did not load") return end
local bad = {}
-- These three are typed "boolean | fun(ctx): boolean" and blink does not store
-- them as given: a plain false in the spec comes back out as a function that
-- returns false. So resolve before comparing, or a correct config fails here.
local function resolve(v)
  if type(v) ~= "function" then return v end
  local called, res = pcall(v, { mode = "default", bounds = {}, get_keyword = function() return "" end })
  if not called then return "<function that errored, cannot verify>" end
  return res
end
local function want(path, got, expected)
  got = resolve(got)
  if got ~= expected then
    table.insert(bad, string.format("%s=%s want %s", path, tostring(got), tostring(expected)))
  end
end
want("completion.menu.auto_show", cfg.completion.menu.auto_show, false)
want("completion.list.selection.preselect", cfg.completion.list.selection.preselect, false)
want("completion.ghost_text.enabled", cfg.completion.ghost_text.enabled, false)
want("keymap.preset", cfg.keymap.preset, "default")
-- <CR> must reach the buffer as a newline, so blink must not claim it at all.
if cfg.keymap["<CR>"] ~= nil then
  table.insert(bad, "keymap[<CR>] is set, must stay unmapped")
end
-- and the manual trigger has to exist, or the menu becomes unreachable
if cfg.keymap["<C-l>"] == nil then
  table.insert(bad, "keymap[<C-l>] missing, no way to summon the menu")
end
io.write(table.concat(bad, "; "))' -c 'qa!' 2>/dev/null)
if [ -n "$cmpcfg" ]; then note FAIL "$cmpcfg"; fail=1; else note OK "manual only, <CR> untouched"; fi

echo
echo "== mappings that matter are present =="
maps=$(nvim --headless -c 'doautocmd User VeryLazy' -c 'lua
vim.wait(2000)
local have = {}
for _, m in ipairs(vim.api.nvim_get_keymap("n")) do have[m.lhs] = true end
-- leader is a space, so that is what appears in lhs
local want = { " j", " k", " l", " ;", " U", " -", " cw", " pv", " sk", " ts", " x", " tc", " a" }
local missing = {}
for _, k in ipairs(want) do if not have[k] then table.insert(missing, "<leader>" .. k:sub(2)) end end
-- and these must NOT exist: no sidebar file tree
local banned = { " e", " E", " fe" }
local present = {}
for _, k in ipairs(banned) do if have[k] then table.insert(present, "<leader>" .. k:sub(2)) end end
local out = {}
if #missing > 0 then table.insert(out, "missing: " .. table.concat(missing, " ")) end
if #present > 0 then table.insert(out, "should be unmapped: " .. table.concat(present, " ")) end
io.write(table.concat(out, " | "))' -c 'qa!' 2>/dev/null)
if [ -n "$maps" ]; then note FAIL "$maps"; fail=1; else note OK "all present, none banned"; fi

echo
echo "== filetype detection =="
# Asserts on the filetype a real buffer ends up with, not on
# vim.filetype.match(). The two differ: match() reports "tf" for a .tf file and
# an ftplugin then reassigns it to "terraform", which is the name terraform-ls
# actually attaches to. Opening the file is the only faithful check.
#
# Fires VeryLazy first, because config/autocmds.lua is where the Jenkinsfile and
# .ily rules are registered and LazyVim loads it on that event.
# One nvim per file, with the file as an argument, because that is how a file
# actually gets opened. `:edit` inside an already-running headless session
# resolves .tf to "tf" while opening it from argv resolves it to "terraform",
# and "terraform" is the name terraform-ls attaches to.
#
# The fixtures carry real content, not just the right names. nvim's .tf resolver
# inspects the buffer to tell Terraform HCL from other formats that use the same
# extension, so an empty main.tf legitimately resolves to "tf" rather than
# "terraform". Empty fixtures would test the wrong thing.
ftdir=$(mktemp -d)
printf 'pipeline {\n  agent any\n}\n' > "$ftdir/Jenkinsfile"
printf 'pipeline {\n  agent any\n}\n' > "$ftdir/deploy.jenkinsfile"
printf 'resource "aws_s3_bucket" "b" {\n  bucket = "x"\n}\n' > "$ftdir/main.tf"
printf '# Heading\n\nSome prose.\n' > "$ftdir/notes.md"
printf '\\version "2.24.0"\n{ c4 d e f }\n' > "$ftdir/score.ily"

check_ft() { # filename expected
  local got
  got=$(nvim --headless "$ftdir/$1" -c 'doautocmd User VeryLazy' \
        -c 'lua vim.wait(400); io.write(vim.bo.filetype)' -c 'qa!' 2>/dev/null)
  if [ "$got" = "$2" ]; then
    note OK "$1 -> $got"
  else
    note FAIL "$1 -> ${got:-nil}, want $2"; fail=1
  fi
}

check_ft Jenkinsfile groovy
check_ft deploy.jenkinsfile groovy
check_ft main.tf terraform
check_ft notes.md markdown
check_ft score.ily lilypond

rm -rf "$ftdir"

exit "$fail"
