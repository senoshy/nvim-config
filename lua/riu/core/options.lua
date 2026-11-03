local opt = vim.opt

opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
opt.number = true
opt.relativenumber = false

opt.mouse = "a"

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.autoindent = true
opt.smartindent = true

opt.swapfile = false
opt.backup = false
opt.undofile = true

opt.incsearch = true
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

opt.termguicolors = true
opt.background = "dark"
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.backspace = { "start", "eol", "indent" }

-- Lower leader-key timeout so prefix mappings (<space>e, <space>t) fire
-- immediately instead of waiting the default 1s.
opt.timeoutlen = 300
opt.ttimeoutlen = 50

opt.splitright = true
opt.splitbelow = true

opt.cursorline = true
opt.cursorcolumn = false
opt.list = true
opt.clipboard:append("unnamedplus")

opt.showtabline = 2

vim.g.editorconfig = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
