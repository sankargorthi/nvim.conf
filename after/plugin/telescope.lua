require('telescope').load_extension 'file_browser'

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>po', builtin.find_files, {})
vim.keymap.set('n', '<leader>pf', ':Telescope file_browser<CR>', {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>e', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
