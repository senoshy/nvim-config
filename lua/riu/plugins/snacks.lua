local M = {}

local function get_git_root()
  local buf_path = vim.api.nvim_buf_get_name(0)
  if buf_path:match("^oil://") then
    buf_path = buf_path:gsub("^oil://", "")
  end
  if buf_path == "" then
    buf_path = vim.fn.getcwd()
  else
    buf_path = vim.fn.fnamemodify(buf_path, ":h")
  end
  local cmd = string.format("git -C %s rev-parse --show-toplevel 2>/dev/null", vim.fn.shellescape(buf_path))
  local git_root = vim.fn.system(cmd)
  if vim.v.shell_error == 0 then
    return vim.trim(git_root)
  end
  return nil
end

-- 1. Consolidated Initialization Block
local function setup_snacks()
  local dashboard_sections = {
    { section = "header", padding = 1 },
    { section = "keys",   gap = 1, padding = 1 },
  }

  -- Initialize Snacks with your custom options
  require("snacks").setup({
    styles = {
      input = {
        keys = {
          n_esc = { "<C-c>", { "cmp_close", "cancel" }, mode = "n", expr = true },
          i_esc = { "<C-c>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
        },
      },
    },
    input = { enabled = true },
    quickfile = { enabled = true, exclude = { "latex" } },
    picker = {
      enabled = true,
      matcher = { frecency = true, cwd_bonus = false },
      sources = { files = { exclude = { ".git", "node_modules", "dist", "build" } } },
      formatters = {
        file = { filename_first = true, filename_only = false, icon_width = 2 },
      },
      layout = { preset = "telescope", cycle = false },
      layouts = {
        select = {
          preview = false,
          layout = {
            backdrop = false,
            width = 0.6,
            min_width = 80,
            height = 0.4,
            min_height = 10,
            box = "vertical",
            border = "rounded",
            title = "{title}",
            title_pos = "center",
            { win = "input",   height = 1,          border = "bottom" },
            { win = "list",    border = "none" },
            { win = "preview", title = "{preview}", width = 0.6,      height = 0.4, border = "top" },
          },
        },
        telescope = {
          reverse = true,
          layout = {
            box = "horizontal",
            backdrop = false,
            width = 0.8,
            height = 0.9,
            border = "none",
            {
              box = "vertical",
              { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
              {
                win = "input",
                height = 1,
                border = "rounded",
                title = "{title} {live} {flags}",
                title_pos = "center",
              },
            },
            {
              win = "preview",
              title = "{preview:Preview}",
              width = 0.50,
              border = "rounded",
              title_pos = "center",
            },
          },
        },
        ivy = {
          layout = {
            box = "vertical",
            backdrop = false,
            width = 0,
            height = 0.4,
            position = "bottom",
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "left",
            { win = "input", height = 1, border = "bottom" },
            {
              box = "horizontal",
              { win = "list",    border = "none" },
              { win = "preview", title = "{preview}", width = 0.5, border = "left" },
            },
          },
        },
      },
    },
    image = {
      enabled = function()
        return vim.bo.filetype == "markdown"
      end,
      doc = { float = false, inline = false, max_width = 50, max_height = 30, wo = { wrap = false } },
      convert = { notify = true, command = "magick" },
      img_dirs = {
        "img", "images", "assets", "static", "public", "media", "attachments",
        "Archives/All-Vault-Images/", "~/Library", "~/Downloads",
      },
    },
    dashboard = {
      enabled = true,
      sections = dashboard_sections,
    },
  })

  -- 2. Directly Apply Keymaps
  local keymap = vim.keymap.set
  local snacks = require("snacks")

  keymap("n", "<Leader>lg", function()
    local git_root = get_git_root()
    if git_root then snacks.lazygit({ cwd = git_root }) end
  end, { desc = "Lazygit" })

  keymap("n", "<leader>gl", function()
    local git_root = get_git_root()
    if git_root then snacks.lazygit.log({ cwd = git_root }) end
  end, { desc = "Lazygit Logs" })

  keymap("n", "<Leader>es", function() snacks.explorer() end, { desc = "Open Snacks Explorer" })
  keymap("n", "<Leader>rN", function() snacks.rename.rename_file() end, { desc = "Fast Rename Current File" })
  keymap("n", "<Leader>dB", function() snacks.bufdelete() end, { desc = "Delete Buffer" })
  keymap("n", "<Leader>pf", function() snacks.picker.files() end, { desc = "Find files" })
  keymap("n", "<leader>pc", function() snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
    { desc = "Find config file" })
  keymap("n", "<leader>ps", function() snacks.picker.grep() end, { desc = "Grep word" })
  keymap("n", "<leader>pws", function() snacks.picker.grep_word() end, { desc = "Search word" })
  keymap("n", "<leader>pk", function() snacks.picker.keymaps({ layout = "ivy" }) end, { desc = "Search keymaps" })
  keymap("n", "<Leader>gbr", function() snacks.picker.git_branches({ layout = "select" }) end, { desc = "Git branches" })
  keymap("n", "<leader>th", function() snacks.picker.colorschemes({ layout = "ivy" }) end, { desc = "Colorschemes" })
  keymap("n", "<leader>vh", function() snacks.picker.help() end, { desc = "Help page" })
  keymap("n", "<leader>t", function() snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, { desc = "Toggle Terminal" })
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = setup_snacks, -- 👈 Your nix.lua loader will now perfectly run this!
}
