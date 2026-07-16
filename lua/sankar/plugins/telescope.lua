local T = {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-dap.nvim',
		},
		config = function()
			local telescope = require 'telescope'
			local builtin = require 'telescope.builtin'
			local actions = require 'telescope.actions'
			local action_state = require 'telescope.actions.state'
			local extensions = telescope.extensions

			-- Shell the highlighted entry to macOS `open`: images go to
			-- Preview.app, PDFs to a PDF viewer, etc. Reliable for large
			-- assets that Kitty graphics + tmux would fragment.
			local function open_external(prompt_bufnr)
				local entry = action_state.get_selected_entry()
				if not entry then return end
				local path = entry.path or entry.filename or entry.value
				if path then
					vim.fn.system({ 'open', path })
				end
			end

			telescope.setup({
				defaults = {
					sorting_strategy = 'ascending',
					file_sorter = extensions.fzf.native_fuzzy_sorter,
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
						-- shorten = true,
						smart = true,
					},
					mappings = {
						i = { ['<C-o>'] = open_external },
						n = { ['<C-o>'] = open_external },
					},
				},
			})

			-- Extensions
			telescope.load_extension 'file_browser'
			telescope.load_extension 'git_worktree'
			telescope.load_extension 'fzf'
			telescope.load_extension 'dap'

			-- Keymaps
			vim.keymap.set('n', '<leader>fg', builtin.git_files,
				{ noremap = true, silent = true, desc = '[?] Search in git files' })
			vim.keymap.set('n', '<leader>po', builtin.find_files, { desc = '[?] Search workspace files' })
			vim.keymap.set('n', '<leader>pf', ':Telescope file_browser<CR>', { desc = '[?] Search workspace tree' })
			vim.keymap.set('n', '<leader>gb', ':Telescope git_branches<CR>', { desc = '[] Browse [G]it [B]ranches' })
			vim.keymap.set('n', '<leader>e', function()
				builtin.oldfiles({ only_cwd = true })
			end, { desc = '[?] Find recently opened files' })
			vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
			vim.keymap.set('n', '<leader>gw', function()
				extensions.git_worktree.git_worktrees({
					previewer = false,
					layout_config = { width = 0.5, height = 0.3 },
				})
			end, { desc = 'Browse [g]it [w]orktrees' })
			vim.keymap.set('n', '<leader>cw', extensions.git_worktree.create_git_worktree,
				{ desc = 'Prompt to [c]reate git [w]orktree' })
			vim.keymap.set('n', '<leader>ff', builtin.live_grep, { desc = '[?] Search across all files' })
			vim.keymap.set('n', '<leader>hh', builtin.help_tags, { desc = '[?] Search across help files' })
			vim.keymap.set('n', '<leader>mm', builtin.man_pages, { desc = '[?] Search across man pages' })

			-- Open current buffer's file in the default macOS app.
			vim.keymap.set('n', '<leader>o', function()
				local path = vim.fn.expand('%:p')
				if path == '' then return end
				vim.fn.system({ 'open', path })
			end, { desc = 'Open current file in default app' })
		end
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		dependencies = { 'nvim-telescope/telescope.nvim' },
	},
	{
		'nvim-telescope/telescope-file-browser.nvim',
		lazy = 'VeryLazy',
		dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }
	},
}
return T
