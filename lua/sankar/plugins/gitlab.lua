local G = {
	{
		'harrisoncramer/gitlab.nvim',
		dependencies = {
			'MunifTanjim/nui.nvim',
			{ 'nvim-lua/plenary.nvim', commit = '2d9b06177a975543726ce5c73fca176cedbffe9d' },
			'sindrets/diffview.nvim',
			'stevearc/dressing.nvim',                                -- Recommended but not required. Better UI for pickers.
			'nvim-tree/nvim-web-devicons',                           -- Recommended but not required. Icons in discussion tree.
		},
		build = function() require('gitlab.server').build(true) end, -- Builds the Go binary
		config = function()
			local Gitlab = require 'gitlab'

			-- Initialize Gitlab
			Gitlab.setup()

			-- Let's remap some bindings
			vim.keymap.set('n', 'glc', function()
					Gitlab.choose_merge_request({ reviewer_username = 'sankar.gorthi', open_reviewer = true })
				end,
				{ desc = "Show all of sankar's review requests" });

			vim.keymap.set('n', 'glM', function()
					vim.print("Don't merge from here. Use a better way")
				end,
				{ desc = 'Stop me from accidentally merging from here' });
		end,
	}
}
return G
