-- Bufferline wired for NvChad-style per-tab buffer workspaces.
-- Buffer membership per tab is tracked in riu.tabs (loaded at startup);
-- here we filter what bufferline displays to the current tab's set.

local tabs = require("riu.tabs")
local api = vim.api

local function setup_bufferline()
  require("bufferline").setup({
    options = {
      mode = "buffers",
      themable = true,
      numbers = "none",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      left_mouse_command = "buffer %d",
      indicator = {
        icon = "▎",
        style = "icon",
      },
      buffer_close_icon = "󰅖",
      modified_icon = "● ",
      left_trunc_marker = " ",
      right_trunc_marker = " ",
      max_name_length = 18,
      max_prefix_length = 15,
      tab_size = 20,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "center",
          separator = false,
        },
      },
      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      persist_buffer_sort = true,
      separator_style = "thin",
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      },
      -- Show only the buffers that belong to the current workspace (tab).
      custom_filter = function(bufnr)
        return tabs.is_member(bufnr)
      end,
    },
  })
end

-- Re-render the bufferline after switching tabs so the new workspace's
-- buffers show immediately.
api.nvim_create_autocmd("TabEnter", {
  group = api.nvim_create_augroup("RiuBufferline", { clear = false }),
  callback = function()
    vim.schedule(function()
      pcall(function() require("bufferline.ui").refresh() end)
    end)
  end,
})

return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  keys = {
    { "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Buffer anterior" },
    { "<S-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "Buffer próximo" },
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Fixar buffer" },
    { "<leader>br", "<Cmd>BufferLineCloseOthers<CR>", desc = "Fechar outros buffers" },
  },
  config = setup_bufferline,
}
