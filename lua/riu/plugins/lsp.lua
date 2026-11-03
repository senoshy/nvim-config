return {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_lsp.default_capabilities()

    local standard_servers = {
      "lua_ls",
      "pyright",
      "texlab",
      "ts_ls",
      "html",
      "cssls",
      "qmlls",
    }
    for _, server in ipairs(standard_servers) do
      vim.lsp.config(server, { capabilities = capabilities })
      vim.lsp.enable(server)
    end

    vim.lsp.config("clangd", {
      capabilities = capabilities,
    })
    vim.lsp.enable("clangd")

    vim.lsp.config("nil_ls", {
      capabilities = capabilities,
      settings = {
        ["nil"] = {
          formatting = {
            command = { "alejandra" },
          },
          nix = {
            flake = {
              autoArchive = true,
            },
          },
        },
      },
    })
    vim.lsp.enable("nil_ls")

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code Action" }))

        if vim.b[ev.buf].riu_lsp_format_hooked then
          return
        end
        vim.b[ev.buf].riu_lsp_format_hooked = true

        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = ev.buf,
          callback = function()
            local bo = vim.bo[ev.buf]
            if bo.readonly or bo.buftype ~= "" then
              return
            end
            if vim.b[ev.buf].disable_formatting then
              return
            end
            if #vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/formatting" }) == 0 then
              return
            end
            vim.lsp.buf.format({ async = false })
          end,
        })
      end,
    })
  end,
}
