-- Variants shipped by shatur/neovim-ayu. "ayu" follows the 'background' option.
local themes = { "ayu-dark", "ayu", "ayu-mirage", "ayu-light" }

local function set_theme(name)
  local ok, err = pcall(vim.cmd.colorscheme, name)
  if ok then
    vim.notify("Theme: " .. name, vim.log.levels.INFO)
  else
    vim.notify("Could not load " .. name .. ": " .. tostring(err), vim.log.levels.WARN)
  end
  return ok
end

local function setup_ayu(_, opts)
  require("ayu").setup(opts)

  -- ayu always reports `colors_name` as "ayu", so keep our own variant name.
  local current = opts.theme

  vim.api.nvim_create_user_command("CycleTheme", function()
    local i = 1
    for index, name in ipairs(themes) do
      if name == current then
        i = index + 1
        break
      end
    end
    current = themes[i] or themes[1]
    set_theme(current)
  end, { desc = "Cycle between ayu-dark, ayu, ayu-mirage and ayu-light" })
end

return {
  "shatur/neovim-ayu",
  event = "VeryLazy",
  config = setup_ayu,
  opts = {
    theme = "ayu-dark",
    mirage = false,
    terminal = true,
    overrides = {},
  },
}
