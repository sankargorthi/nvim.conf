local T = {
	{
		'folke/todo-comments.nvim',
		opts = {
			search = {
				pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
			},
			hightlight = {
				pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
			}
		}
	},
}
return T
