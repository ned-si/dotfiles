-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
   on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', '<leader>hn', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc = "[H]unk [N]ext" })

    map('n', '<leader>hp', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc = "[H]unk [P]revious"})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = '[H]unk - [S]tage hunk' })
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = '[H]unk - [R]eset hunk' })
    map('n', '<leader>hS', gs.stage_buffer, { desc = '[H]unk - [S]tage buffer' })
    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[H]unk - [U]ndo staged hunk' })
    map('n', '<leader>hR', gs.reset_buffer, { desc = '[H]unk - [R]eset buffer' })
    map('n', '<leader>hP', gs.preview_hunk, { desc = '[H]unk - [P]review hunk' })
    map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = '[H]unk - [B]lame line' })
    map('n', '<leader>ht', gs.toggle_current_line_blame, { desc = '[H]unk - [T]oggle blame line' })
    map('n', '<leader>hd', gs.diffthis, { desc = '[H]unk - [D]iff' })
    map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = '[H]unk - [D]iff with HEAD' })
    map('n', '<leader>htd', gs.toggle_deleted, { desc = '[H]unk - [T]oggle [D]eleted lines' })

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = '[I]n [H]unk' })
  end }
