return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  opts = {},
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[G]it [D]iffview open' },
    { '<leader>gD', '<cmd>DiffviewClose<CR>', desc = '[G]it [D]iffview close' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = '[G]it file [H]istory' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<CR>', desc = '[G]it repo [H]istory' },
  },
}
