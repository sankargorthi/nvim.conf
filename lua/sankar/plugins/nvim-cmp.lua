local N = {
	{
		-- Auto Completion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				performance = {
					debounce = 150,
					throttle = 60,
					fetching_timeout = 200,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered()
				}
			})
		end
	},
}
return N
