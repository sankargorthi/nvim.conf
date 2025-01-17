require('telescope').load_extension 'file_browser'
require('telescope').load_extension 'git_worktree'

require('telescope').setup({
	defaults = {
		layout_strategy = 'vertical',
		-- layout_strategy = 'horizontal',
		layout_config = { height = 0.95, width = 0.99 },
		-- pickers = {
		-- 	find_files = { hidden = true },
		-- },
		path_display = {
			-- smart = true,
			-- There's a known issue with truncate and git worktree. Don't use this until that is fixed
			-- truncate = DO_NOT_USE
			absolute = false,
		}
	}
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>po', builtin.find_files, {})
vim.keymap.set('n', '<leader>pf', ':Telescope file_browser<CR>', {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>e', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>gw', require('telescope').extensions.git_worktree.git_worktrees,
	{ desc = 'Browse git worktrees' })
vim.keymap.set('n', '<leader>cw', require('telescope').extensions.git_worktree.create_git_worktree,
	{ desc = 'Prompt to create git worktree' })
