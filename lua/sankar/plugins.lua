return {
	{
		"oxfist/night-owl.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd.colorscheme("night-owl")
		end,
	},
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.4',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{ 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

	-- Git plugins
	{ 'tpope/vim-fugitive' },
	{ 'mbbill/undotree' },

	-- blamer
	{ 'APZelos/blamer.nvim' },

	-- UI Language plugins
	{ 'norcalli/nvim-colorizer.lua' }

}

