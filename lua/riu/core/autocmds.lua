-- General editor autocmds, grouped in a single exposed augroup so plugins
-- can add to it. Keep the ones that are genuinely useful and generalized;
-- language/service-specific triggers live in their plugin configs.

local api = vim.api
local M = {}

M.augroup = api.nvim_create_augroup("RiuCore", { clear = false })

-- Reload a file's edits when it changes on disk and the buffer is unmodified.
api.nvim_create_autocmd("FileChangedShellPost", {
  group = M.augroup,
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk, buffer reloaded", vim.log.levels.INFO)
  end,
})

-- Keep the quickfix window auto-closed when not needed.
api.nvim_create_autocmd("FileType", {
  group = M.augroup,
  pattern = { "qf" },
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.buflisted = false
  end,
})

-- Trim trailing whitespace on save for safe filetypes only.
local function trim_trailing_whitespace()
  local save = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(save)
end

local skip_trim_filetypes = {
  "markdown",
  "md",
  "tex",
  "latex",
  "gitcommit",
  "gitrebase",
  "diff",
  "mail",
}

api.nvim_create_autocmd("BufWritePre", {
  group = M.augroup,
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local bo = vim.bo[bufnr]

    -- Skip special buffers (terminals, help, quickfix, etc.)
    if bo.buftype ~= "" then
      return
    end

    -- Skip readonly buffers
    if bo.readonly then
      return
    end

    local ft = bo.filetype
    if ft and vim.tbl_contains(skip_trim_filetypes, ft) then
      return
    end

    trim_trailing_whitespace()
  end,
})

return M