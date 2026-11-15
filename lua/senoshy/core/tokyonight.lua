local opts = {
  style = 'night',
  transparent = true,
  styles = {
    floats = 'transparent',
    sidebars = 'transparent',
  },
}

-- Plugins are already on the runtimepath in the Nix build, so apply the scheme
-- here. In lazy.nvim mode this file runs before lazy.nvim, so the pcall is a
-- no-op and the spec in lua/senoshy/plugins/tokyonight.lua applies it instead.
local ok, tokyonight = pcall(require, 'tokyonight')
if ok then
  tokyonight.setup(opts)
  vim.cmd.colorscheme 'tokyonight'
end
