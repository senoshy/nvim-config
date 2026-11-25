vim.lsp.log.set_level("off")

-- Neovim opens stdpath('log')/lsp.log and warns on startup once the file passes
-- 1 GB. Truncate it well before that so the warning never fires.
local lsp_log = vim.lsp.log.get_filename()
local lsp_log_stat = vim.uv.fs_stat(lsp_log)
if lsp_log_stat and lsp_log_stat.size > 100 * 1000 * 1000 then
  vim.uv.fs_truncate(lsp_log, 0)
end

local transparent_group = vim.api.nvim_create_augroup('user-transparent-bg',
  { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = transparent_group,
  command = [[
    highlight StatusLine guifg=fg guibg=NONE
    highlight! link StatusLineNC Comment
  ]],
})
-- Reload the scheme when Neovim follows Ghostty's light/dark mode switching
vim.api.nvim_create_autocmd('OptionSet', {
  group = transparent_group,
  pattern = 'background',
  nested = true,
  command = 'colorscheme tokyonight',
})

-- Redraw statusline when starting/stopping macro recording (useful with cmdheight=0)
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  group = vim.api.nvim_create_augroup('user-recording-status', { clear = true }),
  callback = function()
    -- reg_recording() is still set during RecordingLeave, so redraw after it
    vim.schedule(function()
      vim.cmd.redrawstatus { bang = true }
    end)
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- For C files, parse gcc/clang output into the quickfix list on :make
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user-c-make', { clear = true }),
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.cmd 'compiler gcc'

    -- Use make -B so it always rebuilds. :make pipes the output through `tee`, so
    -- pipefail is needed for v:shell_error to hold make's exit code instead of tee's
    vim.opt_local.makeprg = 'set -o pipefail; make -B'

    -- Ignore non-diagnostic lines in quickfix
    vim.opt_local.errorformat:append '%-G%.%#'
  end,
})

-- Treat .h files as C instead of C++
vim.g.c_syntax_for_h = 1

-- [[ LSP ]]
-- Each server is configured in `lsp/<name>.lua` and turned on here.
-- The server binary itself must be on $PATH. See `:help lsp-quickstart`
-- and `:checkhealth vim.lsp` to see what's running.

-- The configs live in `lua/senoshy/lsp/`, which is not the `lsp/` directory
-- Neovim scans on the runtimepath, so register each one explicitly.
local lsp_servers = {
  'bashls',
  'clangd',
  'jsonls',
  'lua_ls',
  'marksman',
  'nil_ls',
  'ruff',
  'rust_analyzer',
  'texlab',
  'ty',
  'yamlls',
}
for _, name in ipairs(lsp_servers) do
  vim.lsp.config(name, require('senoshy.lsp.' .. name))
end

vim.lsp.enable(lsp_servers)

vim.diagnostic.config {
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '●',
      [vim.diagnostic.severity.WARN] = '●',
      [vim.diagnostic.severity.HINT] = '●',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
  -- Show the diagnostic message in a float after jumping with ]d / [d
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}

-- Built-in default LSP keymaps (no need to map them):
--   K hover, grn rename, gra code action, grr references, gri implementation,
--   grt type definition, gO document symbols, <C-S> (insert) signature help
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    if client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})
