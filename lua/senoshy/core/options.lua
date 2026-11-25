-- Options
-- see :help option-list

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.cmdheight = 0

opt.clipboard = 'unnamedplus'

opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.textwidth = 88

opt.breakindent = true
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300

opt.splitright = true
opt.splitbelow = true

opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

opt.foldlevel = 99
opt.foldlevelstart = 99
