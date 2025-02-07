require('telescope').load_extension 'file_browser'
require('telescope').load_extension 'git_worktree'
require('telescope').load_extension 'fzf'

local fzf = require 'telescope'.extensions.fzf

require('telescope').setup({
	defaults = {
		sorting_strategy = 'ascending',
		file_sorter = fzf.native_fuzzy_sorter,
		layout_strategy = 'vertical',
		layout_config = {
			prompt_position = 'top',
			mirror = true, -- show results on top
			height = 0.6,
			width = 0.65,
		},
		path_display = {
			-- There's a known issue with truncate and git worktree. Don't use this until that is fixed
			-- truncate = DO_NOT_USE
			absolute = false,
			shorten = true,
			smart = true,
		},
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
vim.keymap.set('n', '<leader>ff', builtin.live_grep, { desc = '[?] Search across all files' })
vim.keymap.set('n', '<leader>hh', builtin.help_tags, { desc = '[?] Search across help files' })
vim.keymap.set('n', '<leader>mm', builtin.man_pages, { desc = '[?] Search across man pages' })
