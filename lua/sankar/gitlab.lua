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
