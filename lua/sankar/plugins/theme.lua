local T = {
	{
		'rose-pine/neovim',
		name = 'rose-pine',
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require('rose-pine').setup({
				disable_background = true,
				styles = {
					italic = false
				}
			})

			vim.cmd.colorscheme('rose-pine-moon')

			vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
			vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
			vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
		end
	},
	-- {
	-- 	'oxfist/night-owl.nvim',
	-- 	name = 'nightowl',
	-- 	lazy = 'VeryLazy',
	-- 	config = function()
	-- 		-- load the colorscheme here
	-- 		-- vim.cmd.colorscheme('night-owl')
	-- 	end,
	-- },
	-- {
	-- 	'catppuccin/nvim',
	-- 	name = 'catppuccin',
	-- 	lazy = 'VeryLazy', -- make sure we load this during startup if it is your main colorscheme
	-- 	-- config = function()
	-- 	-- 	vim.cmd.colorscheme 'catppuccin-latte'
	-- 	-- end
	-- },
	-- {
	-- 	'folke/tokyonight.nvim',
	-- 	name = 'tokyonight',
	-- 	lazy = 'VeryLazy',
	-- 	-- config = function()
	-- 	-- 	vim.cmd.colorscheme 'tokyonight-day'
	-- 	-- end
	-- },
}

return T
