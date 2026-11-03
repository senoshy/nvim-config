local M = {}

local loaded = {}

local function safe_require(module_name)
  local ok, result = pcall(require, module_name)
  if not ok then
    vim.notify("Failed to load module: " .. module_name .. " - " .. result, vim.log.levels.ERROR)
    return nil
  end
  return result
end

local function get_plugin_name(spec)
  local repo = spec[1] or ""
  local name = repo:match("/([%w-_.]+)$") or repo
  return name:gsub("%.nvim$", ""):gsub("^nvim-", "")
end

local function list(v)
  if v == nil then return {} end
  if type(v) == "table" then return v end
  return { v }
end

local function dispatch(rhs)
  if type(rhs) == "string" then
    local cmd = rhs:match("^<[Cc]md>(.*)<CR>$")
    if cmd then
      vim.cmd(cmd)
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(rhs, true, false, true), "n", false)
    end
  else
    rhs()
  end
end

local function load_plugin_config(spec)
  if loaded[spec] then return true end
  loaded[spec] = true

  if type(spec.config) == "function" then
    local ok, err = pcall(spec.config, spec, spec.opts or {})
    if not ok then
      vim.notify("Error in plugin config (" .. get_plugin_name(spec) .. "): " .. err, vim.log.levels.ERROR)
      return true
    end
  end

  return true
end

local function register_keys(spec)
  for _, key in ipairs(spec.keys or {}) do
    local mode = key.mode or "n"
    local lhs = key[1]
    local rhs = key[2]
    if lhs and rhs then
      vim.keymap.set(mode, lhs, function()
        load_plugin_config(spec)
        dispatch(rhs)
      end, {
        desc = key.desc,
        noremap = key.noremap ~= false,
        silent = key.silent ~= false,
        expr = key.expr or false,
      })
    end
  end
end

local augroup = vim.api.nvim_create_augroup("RiuLazy", { clear = false })

local function on_trigger(spec, events, pattern)
  vim.api.nvim_create_autocmd(events, {
    group = augroup,
    pattern = pattern,
    once = true,
    callback = function()
      load_plugin_config(spec)
    end,
  })
end

local function on_very_lazy(spec)
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    once = true,
    callback = function()
      vim.schedule(function()
        load_plugin_config(spec)
      end)
    end,
  })
end

local function register_triggers(spec)
  for _, ev in ipairs(list(spec.event)) do
    if type(ev) == "string" then
      if ev == "VeryLazy" then
        on_very_lazy(spec)
      else
        on_trigger(spec, ev)
      end
    elseif type(ev) == "table" and ev.ft then
      on_trigger(spec, "FileType", list(ev.ft))
    end
  end

  for _, ft in ipairs(list(spec.ft)) do
    on_trigger(spec, "FileType", ft)
  end

  for _, cmd in ipairs(list(spec.cmd)) do
    on_trigger(spec, "CmdUndefined", cmd)
  end
end

-- Loaded eagerly at startup: either required for core editing or cheap to set up.
local FORCED_EAGER = {
  ["riu.plugins.lsp"] = true,
  ["riu.plugins.cmp"] = true,
  ["riu.plugins.luasnip"] = true,
  ["riu.plugins.autopairs"] = true,
  ["riu.plugins.which-key"] = true,
  ["riu.plugins.direnv"] = true,
  ["riu.plugins.snacks"] = true,
  ["riu.plugins.ayu"] = true,
  ["riu.plugins.theme"] = true,
}

local plugins_modules = {
  "riu.plugins.theme",
  "riu.plugins.ayu",
  "riu.plugins.auto-session",
  "riu.plugins.autopairs",
  "riu.plugins.oil",
  "riu.plugins.todo-comments",
  "riu.plugins.cord-nvim",
  "riu.plugins.snacks",
  "riu.plugins.lsp",
  "riu.plugins.cmp",
  "riu.plugins.navic",
  "riu.plugins.nvim-tree",
  "riu.plugins.diffview",
  "riu.plugins.gitsigns",
  "riu.plugins.luasnip",
  "riu.plugins.treesitter",
  "riu.plugins.table-mode",
  "riu.plugins.vimtex",
  "riu.plugins.indent-blankline",
  "riu.plugins.which-key",
  "riu.plugins.lualine-nvim",
  "riu.plugins.bufferline",
  "riu.plugins.direnv",
  "riu.plugins.undotree",
}

M.load_config = function()
  for _, module_name in ipairs(plugins_modules) do
    local spec = safe_require(module_name)
    if spec then
      register_keys(spec)

      if FORCED_EAGER[module_name] or not (spec.event or spec.ft or spec.cmd or spec.keys) then
        load_plugin_config(spec)
      else
        register_triggers(spec)
      end
    end
  end
end

M.load_config()

return M

