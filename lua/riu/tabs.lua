-- Per-tab buffer workspaces (NvChad tabufline style).
--
-- Split out from the bufferline plugin config so tracking starts at startup,
-- independent of when bufferline itself is lazy-loaded. Bufferline consumes
-- this via `require("riu.tabs").is_member`.
--
-- Keys are tabpage HANDLES (the tabpage object), not numbers: handles are
-- stable for the lifetime of a tab and can be validity-checked, which makes
-- pruning closed tabs trivial.

local api = vim.api

local M = {}

-- tabpage handle -> { [bufnr] = true }
local tab_buffers = {}

local function current_tab()
  return api.nvim_get_current_tabpage()
end

function M.get_tab_set(tab)
  tab = tab or current_tab()
  if not tab_buffers[tab] then tab_buffers[tab] = {} end
  return tab_buffers[tab]
end

--- Whether a buffer belongs to the given (default: current) tab's workspace.
function M.is_member(bufnr)
  return M.get_tab_set()[bufnr] == true
end

--- Register the current buffer as part of the current tab's workspace.
function M.add_current()
  local buf = api.nvim_get_current_buf()
  if buf and buf > 0 and api.nvim_buf_is_valid(buf) then
    M.get_tab_set()[buf] = true
  end
end

local augroup = api.nvim_create_augroup("RiuPerTabBuffers", { clear = true })

api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TabEnter" }, {
  group = augroup,
  callback = M.add_current,
})

-- A freshly created tab inherits the active buffer as its first member.
api.nvim_create_autocmd("TabNew", {
  group = augroup,
  callback = function()
    M.get_tab_set()
    M.add_current()
  end,
})

-- Drop bookkeeping for tabs that no longer exist after one is closed.
api.nvim_create_autocmd("TabClosed", {
  group = augroup,
  callback = function()
    for tab in pairs(tab_buffers) do
      if not api.nvim_tabpage_is_valid(tab) then
        tab_buffers[tab] = nil
      end
    end
  end,
})

-- Remove closed buffers from every tab's workspace set.
api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = augroup,
  callback = function(args)
    for _, set in pairs(tab_buffers) do
      set[args.buf] = nil
    end
  end,
})

return M
