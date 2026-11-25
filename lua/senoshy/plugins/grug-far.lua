return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  opts = {},
  keys = {
    {
      '<leader>sR',
      function()
        require('grug-far').open({ transient = true })
      end,
      mode = 'n',
      desc = '[S]earch and [R]eplace',
    },
    {
      '<leader>sR',
      function()
        require('grug-far').with_visual_selection({ transient = true })
      end,
      mode = 'v',
      desc = '[S]earch and [R]eplace selection',
    },
  },
}
