-- LSP and server installation
return {
	-- defer neodev to when a Lua file is opened
	{
		'folke/neodev.nvim',
		ft = 'lua',
		config = true,
	},
	{
		'mason-org/mason.nvim',
		dependencies = {
			'williamboman/mason-lspconfig.nvim',
			'neovim/nvim-lspconfig',
		},
		build = ':MasonUpdate',
		config = function()
			local mason = require('mason')
			local mason_lspconfig = require('mason-lspconfig')
			local lspconfig = require('lspconfig')

			-- Keymaps restored from previous config
			local on_attach = function(_, bufnr)
				local bufmap = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				bufmap('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
				bufmap('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
				bufmap('n', 'gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
				bufmap('n', 'go', vim.lsp.buf.type_definition, '[G]oto Type [D]ef')
				bufmap('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
				bufmap('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
				bufmap('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
				bufmap('n', 'K', vim.lsp.buf.hover, 'Hover Docs')
				bufmap('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

				-- Restore your :Format command
				vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
					vim.lsp.buf.format({ bufnr = bufnr })
				end, { desc = 'Format current buffer with LSP' })
			end

			-- capabilities for nvim-cmp completion
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			-- init Mason
			mason.setup()

			mason_lspconfig.setup({
				ensure_installed = {
					-- JS/TS
					'ts_ls',

					-- TailwindCSS (v4 support)
					'tailwindcss',

					-- HTML, CSS, JSON, YAML
					'html',
					'cssls',
					'jsonls',
					'yamlls',

					-- Lua
					'lua_ls',

					-- Python
					'pyright',
				},
			})

			-- Setup servers (generic + overrides)
			local servers = {
				ts_ls = {},
				tailwindcss = {},
				pyright = {},
				lua_ls = {},
				-- add your servers here
			}

			for server_name, config in pairs(servers) do
				config.capabilities = capabilities
				config.on_attach = on_attach

				if server_name == 'lua_ls' then
					require('lazy').load({ plugins = { 'neodev.nvim' } })
					require('neodev').setup({})
				end

				lspconfig[server_name].setup(config)
			end
		end,
	}
}

