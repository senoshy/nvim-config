return {
  "nvim-telescope/telescope.nvim",

  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Telescope find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Telescope live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Telescope buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Telescope help tags" },
    { "<leader>pr", "<cmd>Telescope oldfiles<CR>", desc = "Fuzzy find recent files" },
    { "<leader>ths", "<cmd>Telescope themes<CR>", desc = "Theme Switcher" },
    { "<leader>pWs", function()
      local builtin = require("telescope.builtin") -- Loaded ONLY when pressed
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end, desc = "Find Connected Words under cursor" },
  },

  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "andrew-george/telescope-themes",
  },

  config = function()
    local ok, telescope = pcall(require, "telescope")
    if not ok then
      return
    end
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
          },
        },
      },
      extensions = {
        themes = {
          enable_previewer = true,
          enable_live_preview = true,
          persist = {
            enabled = true,
            path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
          },
        },
      },
    })

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "themes")
  end,
}