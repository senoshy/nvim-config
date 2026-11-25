return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  main = 'treesitter-context',
  opts = {
    max_lines = 3,
    trim_scope = 'outer',
  },
}
