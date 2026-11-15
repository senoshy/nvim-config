return {
    'stevearc/oil.nvim',
    ---@module oil
    ---@type oil.SetupOpts
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },

    opts = {
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    },
    lazy = false,
}
