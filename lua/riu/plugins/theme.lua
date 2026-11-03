-- Colorscheme setup.
--
-- Change the palette here, then restart Neovim (or run :colorscheme tokyodark).
-- Switch themes at runtime with:
--   :colorscheme tokyodark
--   :colorscheme material
--   :colorscheme ayu-dark
--
-- Any key from tokyodark.nvim's palette can be overridden. Full key list:
--   black, bg0, bg1, bg2, bg3, bg4, bg5, fg, red, orange, yellow, green,
--   blue, cyan, purple, grey, bg_red, bg_green, bg_blue, diff_red,
--   diff_green, diff_blue, diff_add, diff_change, diff_delete, diff_text
local tokyodark_palette = {
  -- bg0 = "#11121D",
  -- bg1 = "#1A1B2A",
  -- fg = "#A0A8CD",
  -- purple = "#A485DD",
  -- blue = "#7199EE",
}

-- tokyodark options.
local tokyodark_options = {
  transparent_background = false,
  gamma = 1.0,
  terminal_colors = true,
}

-- Material style: "darker", "lighter", "oceanic", "palenight" or "deep ocean".
local material_style = "oceanic"

local function apply_bufferline(colors)
  local set = vim.api.nvim_set_hl

  set(0, "BufferLineFill", { bg = colors.bg })
  set(0, "BufferLineBackground", { fg = colors.fg_muted, bg = colors.bg })
  set(0, "BufferLineBuffer", { fg = colors.fg_muted, bg = colors.bg })
  set(0, "BufferLineBufferSelected", { fg = colors.fg, bg = colors.highlight, bold = true })
  set(0, "BufferLineBufferVisible", { fg = colors.fg_muted, bg = colors.bg })
  set(0, "BufferLineTab", { fg = colors.fg_muted, bg = colors.bg })
  set(0, "BufferLineTabSelected", { fg = colors.fg, bg = colors.highlight })
  set(0, "BufferLineTabClose", { fg = colors.red, bg = colors.bg })
  set(0, "BufferLineIndicatorSelected", { fg = colors.accent, bg = colors.highlight })
  set(0, "BufferLineSeparator", { fg = colors.bg, bg = colors.bg })
  set(0, "BufferLineSeparatorSelected", { fg = colors.highlight, bg = colors.highlight })
  set(0, "BufferLineCloseButton", { fg = colors.fg_muted, bg = colors.bg })
  set(0, "BufferLineCloseButtonSelected", { fg = colors.red, bg = colors.highlight })
  set(0, "BufferLineModified", { fg = colors.yellow, bg = colors.bg })
  set(0, "BufferLineModifiedSelected", { fg = colors.yellow, bg = colors.highlight })
  set(0, "BufferLineModifiedVisible", { fg = colors.yellow, bg = colors.bg })
  set(0, "BufferLineDiagnostic", { fg = colors.fg_muted, bg = colors.bg })
  set(0, "BufferLineDuplicate", { fg = colors.fg_muted, bg = colors.bg })
end

local function sync_bufferline()
  local name = vim.g.colors_name
  local ok, colors

  if name == "tokyodark" then
    ok, colors = pcall(function()
      local p = require("tokyodark.palette")
      return {
        bg = p.bg0,
        highlight = p.bg2,
        fg = p.fg,
        fg_muted = p.grey,
        accent = p.blue,
        red = p.red,
        yellow = p.yellow,
      }
    end)
  elseif name == "material" then
    ok, colors = pcall(function()
      local c = require("material.colors")
      return {
        bg = c.editor.bg,
        highlight = c.editor.highlight,
        fg = c.editor.fg,
        fg_muted = c.editor.fg_dark,
        accent = c.editor.accent,
        red = c.main.red,
        yellow = c.main.yellow,
      }
    end)
  elseif name and name:match("^ayu") then
    ok, colors = pcall(function()
      local c = require("ayu.colors")
      assert(c.bg, "ayu colors not generated")
      return {
        bg = c.bg,
        highlight = c.selection_bg,
        fg = c.fg,
        fg_muted = c.ui,
        accent = c.accent,
        red = c.error,
        yellow = c.warning,
      }
    end)
  end

  if ok and colors then
    apply_bufferline(colors)
  end
end

local function setup()
  local has_tokyodark, tokyodark = pcall(require, "tokyodark")
  if has_tokyodark then
    tokyodark.setup(vim.tbl_extend("force", tokyodark_options, {
      custom_palette = tokyodark_palette,
    }))
  else
    vim.notify("tokyodark.nvim is not available: " .. tostring(tokyodark), vim.log.levels.WARN)
  end

  local has_material, material = pcall(require, "material")
  if has_material then
    vim.g.material_style = material_style
    material.setup({
      contrast = {
        terminal = true,
        sidebars = true,
        floating_windows = true,
        cursor_line = false,
        lsp_virtual_text = false,
        non_current_windows = false,
        filetypes = { "NvimTree", "snacks_dashboard" },
      },
      styles = {
        comments = { italic = true },
        strings = {},
        keywords = {},
        functions = {},
        variables = {},
        operators = {},
        types = {},
      },
      plugins = {
        "gitsigns",
        "indent-blankline",
        "nvim-cmp",
        "nvim-navic",
        "nvim-tree",
        "nvim-web-devicons",
        "telescope",
        "which-key",
      },
      lualine_style = "default",
      disable = {
        colored_cursor = false,
        borders = false,
        background = false,
        term_colors = false,
        eob_lines = false,
      },
      async_loading = true,
    })
  end

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("RiuTheme", { clear = true }),
    callback = sync_bufferline,
    desc = "Keep BufferLine colors in sync with the active theme",
  })

  vim.cmd.colorscheme("tokyodark")
  sync_bufferline()
end

return {
  "tiagovla/tokyodark.nvim",
  dependencies = { "marko-cerovac/material.nvim" },
  lazy = false,
  priority = 1000,
  config = setup,
}
