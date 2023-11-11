require("sankar")

-- customizations

-- show line numbers
vim.wo.number = true

-- share clipboard with OS
vim.o.clipboard = 'unnamedplus'

-- disable providers to make checkhealth happy 🙂
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
