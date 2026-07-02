return {
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		opts = {
			preset = 'modern',
			-- Group labels for each leader prefix. which-key reads the
			-- per-keymap `desc` fields on its own; these just name the
			-- category header shown when the popup opens.
			spec = {
				{ '<leader>c', group = 'code / crates' },
				{ '<leader>d', group = 'debug' },
				{ '<leader>f', group = 'find' },
				{ '<leader>g', group = 'git' },
				{ '<leader>h', group = 'help' },
				{ '<leader>i', group = 'inlay hints' },
				{ '<leader>m', group = 'man pages' },
				{ '<leader>p', group = 'pickers' },
				{ '<leader>r', group = 'refactor / run' },
				{ '<leader>w', group = 'workspace' },
			},
		},
		keys = {
			{
				'<leader>?',
				function() require('which-key').show({ global = true }) end,
				desc = 'Show all keymaps',
			},
			{
				'<leader>K',
				function() require('which-key').show({ global = false }) end,
				desc = 'Show buffer-local keymaps',
			},
		},
	},
}
