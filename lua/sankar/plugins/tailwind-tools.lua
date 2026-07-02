local M = {
	"luckasRanarison/tailwind-tools.nvim",
	name = "tailwind-tools",
	build = ":UpdateRemotePlugins",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim", -- optional
		"neovim/nvim-lspconfig", -- optional
	},
	opts = {
		conceal = {
			enabled = true
		},
		-- We register the tailwindcss LSP via vim.lsp.config in mason.lua;
		-- setting override=false stops this plugin from doing its own
		-- require('lspconfig').tailwindcss.setup(...) (the deprecation call).
		server = {
			override = false,
		},
	},
	config = function(_, opts)
		require("tailwind-tools").setup(opts)

		-- The BufEnter conceal autocmd can fire on a buffer Telescope
		-- just closed (picker teardown). classes.get_ranges then throws
		-- on vim.bo[bufnr].ft. Bail when the buffer is gone; conceal
		-- stays active on every real buffer.
		local classes = require("tailwind-tools.classes")
		local original_get_ranges = classes.get_ranges
		classes.get_ranges = function(bufnr, filters)
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return {}
			end
			return original_get_ranges(bufnr, filters)
		end
	end,
}

return M
