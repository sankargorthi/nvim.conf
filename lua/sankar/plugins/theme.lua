local T = {
	{
		'rose-pine/neovim',
		name = 'rose-pine',
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require('rose-pine').setup({
				disable_background = false,
				styles = {
					italic = false
				}
			})

			-- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
			-- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
			-- vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
		end
	},
	{
		'f-person/auto-dark-mode.nvim',
		lazy = false,
		priority = 999, -- after rose-pine so the colorscheme is registered
		dependencies = { 'rose-pine/neovim', 'nvim-lualine/lualine.nvim' },
		config = function()
			local function set_lualine_theme(theme)
				local ok, lualine = pcall(require, 'lualine')
				if not ok then return end
				local config = lualine.get_config()
				config.options.theme = theme
				lualine.setup(config)
			end

			require('auto-dark-mode').setup({
				update_interval = 3000,
				set_dark_mode = function()
					vim.api.nvim_set_option_value('background', 'dark', {})
					vim.cmd.colorscheme('rose-pine-moon')
					set_lualine_theme('dracula')
				end,
				set_light_mode = function()
					vim.api.nvim_set_option_value('background', 'light', {})
					vim.cmd.colorscheme('rose-pine-dawn')
					set_lualine_theme('solarized_light')
				end,
			})
		end
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		---@diagnostic disable-next-line: missing-fields
	-- 		require('catppuccin').setup({
	-- 			-- variant = 'dawn',
	-- 			flavour = 'frappe',
	-- 			disable_background = false,
	-- 			styles = {
	-- 				italic = false
	-- 			}
	-- 		})
	--
	-- 		vim.cmd.colorscheme('catppuccin')
	-- 	end
	-- },
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
	-- 	lazy = false,
	-- 	config = function()
	-- 		vim.cmd.colorscheme 'tokyonight-day'
	-- 	end
	-- },
}

return T
