return {
    'stevearc/oil.nvim',
    ---@module oil
    ---@type oil.SetupOpts
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },

    opts = {},
    keys = {
        { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
    },
    lazy = false,
}
