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

			-- Kind icons + formatter for the completion menu.
			-- Consumed by the cmp.setup{} in plugins/mason.lua.
			'onsails/lspkind.nvim',
		},
	},
}
return N
