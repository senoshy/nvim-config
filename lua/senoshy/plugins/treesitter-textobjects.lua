return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter-textobjects').setup({
      select = {
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v',
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
        },
      },
      move = {
        set_jumps = true,
      },
    })

    local select = require('nvim-treesitter-textobjects.select')
    local move = require('nvim-treesitter-textobjects.move')
    local swap = require('nvim-treesitter-textobjects.swap')

    local select_maps = {
      af = '@function.outer',
      ['if'] = '@function.inner',
      ac = '@class.outer',
      ic = '@class.inner',
      aa = '@parameter.outer',
      ia = '@parameter.inner',
    }
    for lhs, query in pairs(select_maps) do
      vim.keymap.set({ 'x', 'o' }, lhs, function()
        select.select_textobject(query, 'textobjects')
      end, { desc = 'Select ' .. query })
    end

    vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
      move.goto_next_start('@function.outer', 'textobjects')
    end, { desc = 'Next function start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
      move.goto_previous_start('@function.outer', 'textobjects')
    end, { desc = 'Previous function start' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
      move.goto_next_end('@function.outer', 'textobjects')
    end, { desc = 'Next function end' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
      move.goto_previous_end('@function.outer', 'textobjects')
    end, { desc = 'Previous function end' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
      move.goto_next_start('@class.outer', 'textobjects')
    end, { desc = 'Next class start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
      move.goto_previous_start('@class.outer', 'textobjects')
    end, { desc = 'Previous class start' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']C', function()
      move.goto_next_end('@class.outer', 'textobjects')
    end, { desc = 'Next class end' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[C', function()
      move.goto_previous_end('@class.outer', 'textobjects')
    end, { desc = 'Previous class end' })

    vim.keymap.set('n', '<leader>a', function()
      swap.swap_next('@parameter.inner')
    end, { desc = 'Swap with next argument' })
    vim.keymap.set('n', '<leader>A', function()
      swap.swap_previous('@parameter.inner')
    end, { desc = 'Swap with previous argument' })
  end,
}
