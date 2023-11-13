require("sankar")

-- customizations

-- show line numbers
vim.wo.number = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

-- share clipboard with OS
vim.o.clipboard = 'unnamedplus'

-- disable providers to make checkhealth happy 🙂
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
