return {
  'nvim-mini/mini.nvim',
  lazy = false,
  config = function()
    local icons = require('mini.icons')
    icons.setup()
    icons.mock_nvim_web_devicons()

    require('mini.surround').setup()

    local statusline = require('mini.statusline')
    statusline.setup({
      use_icons = true,
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
          local git = statusline.section_git({ trunc_width = 40 })
          local diff = statusline.section_diff({ trunc_width = 75 })
          local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
          local lsp = statusline.section_lsp({ trunc_width = 75 })
          local filename = statusline.section_filename({ trunc_width = 140 })
          local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
          local location = statusline.section_location({ trunc_width = 75 })
          local search = statusline.section_searchcount({ trunc_width = 75 })
          local reg = vim.fn.reg_recording()
          local recording = reg ~= '' and ('recording @' .. reg) or ''

          return statusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
            '%<',
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=',
            { hl = 'WarningMsg', strings = { recording } },
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          })
        end,
      },
    })
  end,
}
