return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 300,
    spec = {
      { '<leader>d', group = '[D]ebug / [D]ocument', mode = { 'n', 'v' } },
      { '<leader>g', group = '[G]it' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>m', group = '[M]arks (Harpoon)' },
      { '<leader>n', group = '[N]eotest' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>x', group = 'Diagnostics / Trouble' },
    },
  },
}
