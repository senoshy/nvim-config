return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
    'rouge8/neotest-rust',
  },
  keys = {
    { '<leader>nn', function() require('neotest').run.run() end, desc = '[N]eotest: Run [N]earest' },
    { '<leader>nf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = '[N]eotest: Run [F]ile' },
    { '<leader>nd', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = '[N]eotest: [D]ebug nearest' },
    { '<leader>ns', function() require('neotest').summary.toggle() end, desc = '[N]eotest: Toggle [S]ummary' },
    { '<leader>no', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = '[N]eotest: Show [O]utput' },
    { '<leader>nO', function() require('neotest').output_panel.toggle() end, desc = '[N]eotest: Toggle [O]utput panel' },
    { '<leader>nS', function() require('neotest').run.stop() end, desc = '[N]eotest: [S]top' },
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-python')({
          dap = { justMyCode = false },
        }),
        require('neotest-rust'),
      },
    })
  end,
}
