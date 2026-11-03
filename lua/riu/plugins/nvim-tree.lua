local function setup_nvim_tree()
  require("nvim-tree").setup({
    disable_netrw = true,
    hijack_netrw = true,
    open_on_tab = false,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    diagnostics = {
      enable = true,
      show_on_dirs = false,
      icons = { hint = " ", info = " ", warning = " ", error = " " },
    },
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    view = {
      width = 32,
      side = "left",
      preserve_window_proportions = true,
    },
    renderer = {
      root_folder_label = false,
      indent_width = 2,
      highlight_git = true,
      group_empty = true,
      icons = {
        show = { file = true, folder = true, folder_arrow = true, git = true },
        glyphs = {
          default = "󰈙",
          symlink = "󰁕",
          folder = {
            arrow_closed = "󰍂",
            arrow_open = "󰍃",
            default = "󰉋",
            open = "󰝰",
            empty = "󰉋",
            empty_open = "󰝰",
            symlink = "󰉋",
            symlink_open = "󰝰",
          },
          git = { unmerged = "󰘓", unstaged = "󰄱", untracked = "? ", renamed = "󰁕", staged = "󰁆" },
        },
      },
    },
    filters = {
      dotfiles = true,
    },
    actions = {
      open_file = {
        quit_on_open = false,
      },
    },
  })
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeCollapse" },
  keys = {
    { "<leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    { "<leader>ef", "<Cmd>NvimTreeFindFile<CR>", desc = "Reveal file in explorer" },
    { "<leader>ec", "<Cmd>NvimTreeCollapse<CR>", desc = "Collapse file explorer" },
  },
  config = setup_nvim_tree,
}
