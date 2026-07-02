local R = {
	{
		'MeanderingProgrammer/render-markdown.nvim',
		lazy = 'VeryLazy',
		ft = { 'markdown', 'rust', 'lua', 'python', 'typescript', 'typescriptreact', 'javascript' },
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		---@module 'render-markdown',
		opts = {
			file_types = { 'markdown', 'rust', 'lua', 'python', 'typescript', 'typescriptreact', 'javascript' },
			-- image.nvim already renders the actual image for ![](...) nodes.
			-- Suppress render-markdown's icon glyph so we don't stack them.
			link = {
				image = '',
				image_custom = false,
			},
		},
	},
	{
		'iamcco/markdown-preview.nvim',
		lazy = 'VeryLazy',
		cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
		build = 'cd app && yarn install',
		init = function()
			vim.g.mkdp_filetypes = { 'markdown' }
		end,
		ft = { 'markdown' },
	},
}
return R
