local function setup_treesitter()
  vim.treesitter.language.register("latex", "tex")

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("RiuTreesitter", { clear = true }),
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
      if pcall(vim.treesitter.get_parser, args.buf) then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("RiuTexConceal", { clear = true }),
    pattern = { "tex", "bib" },
    callback = function()
      vim.opt_local.conceallevel = 1
      vim.opt_local.concealcursor = "nc"
    end,
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = setup_treesitter,
}
