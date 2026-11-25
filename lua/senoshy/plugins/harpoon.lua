return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>ma', function() require('harpoon'):list():add() end, desc = '[M]ark [A]dd file (Harpoon)' },
    {
      '<leader>mm',
      function()
        local harpoon = require('harpoon')
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = '[M]ark [M]enu (Harpoon)',
    },
    { '<leader>mp', function() require('harpoon'):list():prev() end, desc = '[M]ark [P]revious (Harpoon)' },
    { '<leader>mn', function() require('harpoon'):list():next() end, desc = '[M]ark [N]ext (Harpoon)' },
    { '<leader>1', function() require('harpoon'):list():select(1) end, desc = 'Harpoon file 1' },
    { '<leader>2', function() require('harpoon'):list():select(2) end, desc = 'Harpoon file 2' },
    { '<leader>3', function() require('harpoon'):list():select(3) end, desc = 'Harpoon file 3' },
    { '<leader>4', function() require('harpoon'):list():select(4) end, desc = 'Harpoon file 4' },
    { '<leader>5', function() require('harpoon'):list():select(5) end, desc = 'Harpoon file 5' },
  },
  config = function()
    require('harpoon'):setup()
  end,
}
