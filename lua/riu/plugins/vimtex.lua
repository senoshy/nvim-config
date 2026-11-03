local function setup_vimtex()
  vim.g.vimtex_view_method = "zathura"
  vim.g.vimtex_compiler_method = "latexrun"
  vim.g.vimtex_complete_enabled = 0
end

return {
  "lervag/vimtex",
  ft = "tex",
  config = setup_vimtex,
}
