-- customizations
vim.g.mapleader = ' '

-- netrw
vim.g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'

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
vim.opt.colorcolumn = '100'
vim.opt.signcolumn = 'yes'
vim.opt.winborder = 'rounded'

-- Open splits to the right/below so new scratch buffers (MIR/HIR views,
-- diagnostics, help) land on the far side of the source rather than
-- displacing it leftward/upward. Reads L->R, top->bottom like text.
vim.opt.splitright = true
vim.opt.splitbelow = true

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

-- change cursorhold updatetime
vim.opt.updatetime = 1500

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.spelllang = 'en_us'
vim.opt.spell = true

-- Perf tuning
vim.g.loaded_matchparen = 1
