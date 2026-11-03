local function setup_navic()
  require("nvim-navic").setup({
    separator = " ",
    highlight = true,
    depth_limit = 5,
    lazy_update_context = true,
  })

  local navic = require("nvim-navic")

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("RiuNavic", { clear = false }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        navic.attach(client, args.buf)
      end
    end,
  })
end

return {
  "SmiteshP/nvim-navic",
  lazy = false,
  config = setup_navic,
}
