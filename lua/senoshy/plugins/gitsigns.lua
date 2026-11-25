return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, 'Next git [H]unk')

      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, 'Previous git [H]unk')

      -- Actions
      map('n', '<leader>hs', gs.stage_hunk, 'Git [H]unk [S]tage')
      map('n', '<leader>hr', gs.reset_hunk, 'Git [H]unk [R]eset')
      map('v', '<leader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, 'Git [H]unk [S]tage')
      map('v', '<leader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, 'Git [H]unk [R]eset')
      map('n', '<leader>hS', gs.stage_buffer, 'Git [S]tage buffer')
      map('n', '<leader>hR', gs.reset_buffer, 'Git [R]eset buffer')
      map('n', '<leader>hp', gs.preview_hunk, 'Git [H]unk [P]review')
      map('n', '<leader>hb', function()
        gs.blame_line({ full = true })
      end, 'Git [B]lame line')
      map('n', '<leader>hd', gs.diffthis, 'Git [D]iff this')
      map('n', '<leader>tb', gs.toggle_current_line_blame, '[T]oggle git [B]lame line')
    end,
  },
}
