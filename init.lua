vim.opt.termguicolors = true

require("sankar")

-- customizations

-- lualine controls the tabline for me. Hide it in vim for now
vim.go.showtabline = 0

-- show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- file history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.local/share/nvim_undodir'
vim.opt.undofile = true

-- make editor prettier
vim.opt.scrolloff = 20
vim.opt.colorcolumn = "100"
vim.opt.signcolumn = "yes"

-- nice tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.smartindent = true

-- share clipboard with OS
vim.opt.clipboard = 'unnamedplus'

-- disable providers to make checkhealth happy 🙂
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.spelllang = 'en_us'
vim.opt.spell = true
