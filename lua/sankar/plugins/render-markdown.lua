local R = {
	{
		'MeanderingProgrammer/render-markdown.nvim',
		lazy = 'VeryLazy',
		ft = { 'markdown' },
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		---@module 'render-markdown',
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
