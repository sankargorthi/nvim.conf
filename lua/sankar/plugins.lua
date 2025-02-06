return {
	{
		'rose-pine/neovim',
		name = 'rose-pine',
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require('rose-pine').setup({
				disable_background = true,
				styles = {
					italic = false
				}
			})

			vim.cmd.colorscheme('rose-pine-moon')

			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
		end
	},
	{
		'oxfist/night-owl.nvim',
		name = 'nightowl',
		lazy = 'VeryLazy',
		config = function()
			-- load the colorscheme here
			-- vim.cmd.colorscheme('night-owl')
		end,
	},
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		lazy = 'VeryLazy', -- make sure we load this during startup if it is your main colorscheme
		-- config = function()
		-- 	vim.cmd.colorscheme 'catppuccin-latte'
		-- end
	},
	{
		'folke/tokyonight.nvim',
		name = 'tokyonight',
		lazy = 'VeryLazy',
		-- config = function()
		-- 	vim.cmd.colorscheme 'tokyonight-day'
		-- end
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require 'sankar.telescope'
		end
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},

	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		config = function()
			require 'sankar.treesitter'
		end
	},

	-- Git plugins
	{
		'tpope/vim-fugitive',
		config = function()
			require 'sankar.fugitive'
		end
	},

	{
		'ThePrimeagen/git-worktree.nvim',
		config = function()
			require 'sankar.configs.worktree'
		end
	},

	-- Undo
	{
		'mbbill/undotree',
		config = function()
			require 'sankar.undotree'
		end
	},

	-- blamer
	-- {
	-- 	'APZelos/blamer.nvim',
	-- 	config = function()
	-- 		require 'sankar.blamer'
	-- 	end
	-- },

	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = require 'sankar.lualine'
	},

	-- Detect tabstop and shiftwidth automatically
	{
		'tpope/vim-sleuth',
	},

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {},
	},

	-- 'gc' to comment visual regions/lines
	{
		'numToStr/Comment.nvim',
		opts = {}
	},

	-- UI Language plugins
	{
		'catgoose/nvim-colorizer.lua',
		config = function()
			require 'sankar.colorizer'
		end
	},
	{
		'nvimtools/none-ls.nvim',
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
			{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
	},

	-- zenish mode
	{
		'folke/twilight.nvim',
		opts = {
			dimming = {
				alpha = 0.30, -- amount of dimming
				-- we try to get the foreground from the highlight groups or fallback color
				color = { "Normal", "#ffffff" },
				term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
				inactive = true, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
			},
			context = 10,      -- amount of lines we will try to show around the current line
			treesitter = true, -- use treesitter when available for the filetype
			-- treesitter is used to automatically expand the visible text,
			-- but you can further control the types of nodes that should always be fully expanded
			expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
				"function",
				"method",
				"table",
				"if_statement",
			},
			exclude = {}, -- exclude these filetypes
		}

	},

	{ 'folke/todo-comments.nvim', opts = {} },

	{ 'mfussenegger/nvim-jdtls' },

	{ 'mfussenegger/nvim-dap' },

	-- {
	-- 	'christoomey/vim-tmux-navigator',
	-- 	cmd = {
	-- 		'TmuxNavigateLeft',
	-- 		'TmuxNavigateDown',
	-- 		'TmuxNavigateUp',
	-- 		'TmuxNavigateRight',
	-- 		'TmuxNavigatePrevious',
	-- 	},
	-- 	keys = {
	-- 		{ '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
	-- 		{ '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
	-- 		{ '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
	-- 		{ '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
	-- 		{ '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
	-- 	},
	-- },

	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = require 'sankar.gitsigns'
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
	{
		'nvim-telescope/telescope-file-browser.nvim',
		lazy = 'VeryLazy',
		dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }
	},
	{
		'harrisoncramer/gitlab.nvim',
		dependencies = {
			'MunifTanjim/nui.nvim',
			{ 'nvim-lua/plenary.nvim', commit = '2d9b06177a975543726ce5c73fca176cedbffe9d' },
			'sindrets/diffview.nvim',
			'stevearc/dressing.nvim',                                -- Recommended but not required. Better UI for pickers.
			'nvim-tree/nvim-web-devicons',                           -- Recommended but not required. Icons in discussion tree.
		},
		build = function() require('gitlab.server').build(true) end, -- Builds the Go binary
		config = function()
			require 'sankar.gitlab'
		end,
	}
}
