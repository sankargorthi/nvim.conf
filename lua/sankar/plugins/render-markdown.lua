local R = {
	{
		'MeanderingProgrammer/render-markdown.nvim',
		lazy = 'VeryLazy',
		ft = { 'markdown', 'rust' },
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		---@module 'render-markdown',
		opts = {
			-- Markdown for .md files, plus rust doc comments (///, //!).
			-- Rust gets a stripped-down override: heading backgrounds and
			-- fenced-code block backgrounds were bleeding through telescope
			-- preview popups when enabled globally. Keeping inline
			-- formatting (bold, italic, inline code, links) but disabling
			-- the full-width decorations avoids that.
			file_types = { 'markdown', 'rust' },
			-- image.nvim already renders the actual image for ![](...) nodes.
			-- Suppress render-markdown's icon glyph so we don't stack them.
			link = {
				image = '',
				image_custom = false,
			},
			overrides = {
				filetype = {
					rust = {
						heading = { enabled = false },
						code = { style = 'none' },
					},
				},
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
