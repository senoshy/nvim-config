return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {},
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<CR>', desc = 'Symbols (Trouble)' },
    { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', desc = 'LSP Definitions / References (Trouble)' },
    { '<leader>xL', '<cmd>Trouble loclist toggle<CR>', desc = 'Location List (Trouble)' },
    { '<leader>xq', '<cmd>Trouble qflist toggle<CR>', desc = 'Quickfix List (Trouble)' },
  },
}
