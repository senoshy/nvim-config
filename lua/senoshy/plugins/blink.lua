return {
  'saghen/blink.cmp',
  version = '1.*',
  lazy = false,
  dependencies = { 'rafamadriz/friendly-snippets' },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      accept = {
        auto_brackets = { enabled = true },
      },
    },
    signature = { enabled = true },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  config = function(_, opts)
    local blink = require('blink.cmp')
    blink.setup(opts)
    vim.lsp.config('*', {
      capabilities = blink.get_lsp_capabilities(),
    })
  end,
}
