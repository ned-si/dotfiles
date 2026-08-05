-- Completion on demand, never unprompted.
--
-- LazyVim ships blink.cmp with the "enter" keymap preset, and blink preselects
-- the first item by default. Together that means the menu appears on every
-- keystroke and <CR> accepts whatever happens to be highlighted rather than
-- inserting a newline. This inverts both halves: nothing appears until it is
-- asked for, and nothing is selected until it is picked.
return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        -- The menu is summoned explicitly and never on its own. Triggers are
        -- deliberately left alone so that once it is open it keeps filtering
        -- as you type.
        menu = { auto_show = false },
        -- Opening the menu selects nothing, so <CR> stays a newline and a
        -- stray <Tab> cannot quietly commit an entry. This is the same
        -- guarantee the previous config got from "noselect" in completeopt.
        -- Accepting still takes one keypress: blink's select_and_accept falls
        -- back to the first item when the selection is empty.
        list = { selection = { preselect = false, auto_insert = false } },
        -- An inline preview of the highlighted item is the same interruption
        -- wearing a different hat.
        ghost_text = { enabled = false },
      },
      keymap = {
        -- "default" rather than LazyVim's "enter": it leaves <CR> unmapped, so
        -- blink never competes for it, and mini.pairs keeps its own <CR>
        -- handling. Accept is <C-y>, <C-n>/<C-p> move, <C-e> dismisses.
        preset = "default",
        -- The preset summons the menu with <C-Space>, which cannot work here:
        -- macOS binds ctrl+space to "select previous input source", so the key
        -- is swallowed before any terminal sees it. <C-l> is unmapped in
        -- insert mode, in tmux and in Ghostty. <C-Space> stays mapped by the
        -- preset and starts working the moment that macOS shortcut is off.
        ["<C-l>"] = { "show", "show_documentation", "hide_documentation" },
      },
    },
  },
}
