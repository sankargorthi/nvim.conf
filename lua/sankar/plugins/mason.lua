local M = {
	{
		'folke/neodev.nvim',
		opts = {}
	},
	{
		'williamboman/mason.nvim',
		opts = {
			ensure_installed = {
				'prettierd',
				'eslint_d',
				'elsint-lsp',
				'lua-language-server',
				'typescript-language-server',
			}
		},
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
		config = function()
			-- mason-lspconfig requires that these setup functions are called in this order
			-- before setting up the servers.
			require('mason-lspconfig').setup()

			local util = require 'lspconfig.util'
			local servers = {
				bashls = {},
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				jsonls = {},
				marksman = {},
				ts_ls = {
					root_dir = util.root_pattern('.git')(fname),
					init_options = {
						preferences = {
							disableSuggestions = true
						}
					},
				},
				html = { filetypes = { 'html', 'twig', 'hbs' } },
				cssls = {},
				eslint = {},

				-- xml
				lemminx = {},

				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						diagnostics = {
							globals = { 'vim', 'fname' }
						},
						runtime = {
							-- Specify Lua version used by Neovim (5.1)
							version = 'LuaJIT',
						},
					},
				},
				vimls = {},
			}

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

			local on_attach = function(client, bufnr)
				local builtins = require 'telescope.builtin'
				local nmap = function(keys, func, desc)
					if desc then
						desc = 'LSP: ' .. desc
					end

					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
				end

				local function getProductionReferences(...)
					builtins.lsp_references({
						...,
						cwd = vim.fn.expand('%:p:h'),
						file_ignore_patterns = { '__tests__', '__test__', '*.test.js', '*.stories.jsx', '__stories__' }
					})
				end

				nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
				nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
				nmap('gd', builtins.lsp_definitions, '[G]oto [D]efinition')
				nmap('gr', getProductionReferences, '[G]oto [R]eferences in production code')
				nmap('gra', builtins.lsp_references, '[G]oto [R]eferences [A]ll scopes')
				nmap('gI', builtins.lsp_implementations, '[G]oto [I]mplementation')
				nmap('<leader>D', builtins.lsp_type_definitions, 'Type [D]efinition')
				nmap('<leader>ds', builtins.lsp_document_symbols, '[D]ocument [S]ymbols')
				nmap('<leader>ws', builtins.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

				-- See `:help K` for why this keymap
				nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
				nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

				-- Lesser used LSP functionality
				nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
					vim.lsp.buf.format()
				end, { desc = 'Format current buffer with LSP' })
				-- Create a command `:OrganizeImports` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, 'OrganizeImports', function(_)
					local params = {
						command = '_typescript.organizeImports',
						arguments = { vim.api.nvim_buf_get_name(0) },
					}
					vim.lsp.buf.execute_command(params)
				end, { desc = 'Organize Imports' })

				if client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
					vim.api.nvim_clear_autocmds { buffer = bufnr, group = 'lsp_document_highlight' }
					vim.api.nvim_create_autocmd('CursorHold', {
						callback = vim.lsp.buf.document_highlight,
						buffer = bufnr,
						group = 'lsp_document_highlight',
						desc = 'Document Highlight',
					})
					vim.api.nvim_create_autocmd('CursorMoved', {
						callback = vim.lsp.buf.clear_references,
						buffer = bufnr,
						group = 'lsp_document_highlight',
						desc = 'Clear All the References',
					})
				end
			end


			-- Ensure the servers above are installed
			local mason_lspconfig = require 'mason-lspconfig'

			mason_lspconfig.setup {
				automatic_installation = true,
				ensure_installed = vim.tbl_keys(servers),
			}

			mason_lspconfig.setup_handlers {
				function(server_name)
					require('lspconfig')[server_name].setup {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						init_options = (servers[server_name] or {}).init_options,
						filetypes = (servers[server_name] or {}).filetypes,
					}
				end,
			}

			-- [[ Configure nvim-cmp ]]
			-- See `:help cmp`
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			require('luasnip.loaders.from_vscode').lazy_load()
			luasnip.config.setup {}

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete {},
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				},
			}
		end
	},
}
return M
