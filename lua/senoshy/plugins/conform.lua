return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      nix = { 'alejandra' },
      python = { 'ruff_organize_imports', 'ruff_format' },
      rust = { 'rustfmt' },
    },
  },
}
