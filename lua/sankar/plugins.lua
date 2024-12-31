return {
	-- {
	-- 	"oxfist/night-owl.nvim",
	-- 	name = 'nightowl',
	-- 	lazy = false,   -- make sure we load this during startup if it is your main colorscheme
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	config = function()
	-- 		-- load the colorscheme here
	-- 		vim.cmd.colorscheme("night-owl")
	-- 	end,
	-- },
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = 'catppuccin',
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function ()
	-- 		vim.cmd.colorscheme 'catppuccin-latte'
	-- 	end
	-- },
	{
		"folke/tokyonight.nvim",
		name = 'tokyonight',
		lazy = false,
		priority = 1000,
		config = function ()
			vim.cmd.colorscheme 'tokyonight-day'
		end
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.4',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate'
	},

	-- Git plugins
	{ 'tpope/vim-fugitive' },

	-- Undo
	{ 'mbbill/undotree' },

	-- blamer
	{ 'APZelos/blamer.nvim' },

	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = 'tokyonight',
				component_separators = '|',
				section_separators = '',
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'diff', 'diagnostics' },
				lualine_c = {
					{
						'filename',
						path = 1,
						shorting_target = 40,
					}
				},
				lualine_x = { 'encoding', 'fileformat', 'filetype' },
				lualine_y = { 'progress' },
				lualine_z = { 'location' }
			},
			inactive_sections = {
				lualine_a = { 'mode' },
				lualine_b = {},
				lualine_c = {
					{
						'filename',
						path = 1,
						shorting_target = 60
					}
				},
				lualine_x = { 'location' },
				lualine_y = {},
				lualine_z = {}
			},
		},
	},

	-- Detect tabstop and shiftwidth automatically
	-- 'tpope/vim-sleuth',

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {},
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim',      opts = {} },

	-- UI Language plugins
	{ 'norcalli/nvim-colorizer.lua' },
	{
		'nvimtools/none-ls.nvim',
		event = 'VeryLazy',
		opts = function()
			return require 'sankar.configs.null-ls'
		end
	},
	{
		'williamboman/mason.nvim',
		opts = {
			ensure_installed = {
				'prettierd',
				'elsint-lsp',
				'lua-language-server',
				'typescript-language-server',
			}
		}
	},

	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
	},

	-- {
	-- 	"christoomey/vim-tmux-navigator",
	-- 	cmd = {
	-- 		"TmuxNavigateLeft",
	-- 		"TmuxNavigateDown",
	-- 		"TmuxNavigateUp",
	-- 		"TmuxNavigateRight",
	-- 		"TmuxNavigatePrevious",
	-- 	},
	-- 	keys = {
	-- 		{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
	-- 		{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
	-- 		{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
	-- 		{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
	-- 		{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
	-- 	},
	-- },

	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

				-- don't override the built-in and fugitive keymaps
				local gs = package.loaded.gitsigns
				vim.keymap.set({ 'n', 'v' }, ']c', function()
					if vim.wo.diff then
						return ']c'
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return '<Ignore>'
				end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
				vim.keymap.set({ 'n', 'v' }, '[c', function()
					if vim.wo.diff then
						return '[c'
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return '<Ignore>'
				end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
			end,
		},
	},

	{
		-- Autocompletion
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
	},

}
