return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    if not vim.g.nix_managed then
      require('nvim-treesitter').install({
        'bash',
        'c',
        'cmake',
        'cpp',
        'diff',
        'gitcommit',
        'json',
        'latex',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'nix',
        'python',
        'query',
        'rust',
        'toml',
        'vim',
        'vimdoc',
        'yaml',
      })
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
      callback = function(event)
        if pcall(vim.treesitter.start, event.buf) then
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldmethod = 'expr'
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
