local M = {
	{
		'folke/neodev.nvim',
		opts = {}
	},
	{
		'williamboman/mason.nvim',
		version = '^1.0.0',
		config = function()
			require 'mason'.setup({
				ensure_installed = {
					'biome',
					-- 'prettierd',
					-- 'eslint_d',
					-- 'elsint-lsp',
					'lua-language-server',
					'tailwindcss',
					'tsserver',
					-- 'typescript-language-server',
					'lua_ls'
				}
			})
		end
	},
	{
		'williamboman/mason-lspconfig.nvim',
		version = '^1.0.0',
		dependencies = {
			'williamboman/mason.nvim',
			'neovim/nvim-lspconfig'
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
		config = function()
			-- mason-lspconfig requires that these setup functions are called in this order
			-- before setting up the servers.
			require('mason-lspconfig').setup()

			local util = require 'lspconfig.util'
			local servers = {
				bashls = {},
				-- clangd = {},
				-- gopls = {},
				pyright = {
					python = {
						pythonPath = "/Users/SankarGorthi/.pyenv/versions/3.13.5/envs/contact_manager/bin/python",
					}
				},
				["biome@2.0.6"] = {},
				jsonls = {},
				marksman = {},
				tailwindcss = {},
				ts_ls = {},
				html = { filetypes = { 'html', 'twig', 'hbs' } },
				cssls = {},
				dockerls = {},
				-- eslint = {},

				-- gopls = {},

				-- xml
				lemminx = {
					xml = {
						validation = {
							noGrammar = 'ignore',
						}
					}
				},

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
				mdx_analyzer = {},
				vimls = {},
			}

			local lsp = require 'sankar.lsp'

			-- Ensure the servers above are installed
			local mason_lspconfig = require 'mason-lspconfig'

			mason_lspconfig.setup {
				automatic_installation = true,
				ensure_installed = vim.tbl_keys(servers),
			}

			mason_lspconfig.setup_handlers {
				function(server_name)
					require('lspconfig')[server_name].setup {
						capabilities = lsp.capabilities(),
						on_attach = lsp.on_attach,
						settings = servers[server_name],
						init_options = (servers[server_name] or {}).init_options,
						filetypes = (servers[server_name] or {}).filetypes,
					}
				end,
				['ts_ls'] = function()
					require('lspconfig').ts_ls.setup {
						capabilities = lsp.capabilities(),
						on_attach = lsp.on_attach,
						root_dir = util.root_pattern('.git'),
						init_options = {
							preferences = { disableSuggestions = true },
						},
					}
				end,
			}

			-- [[ Configure nvim-cmp ]]
			-- See `:help cmp`
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			local types = require 'luasnip.util.types'
			require('luasnip.loaders.from_vscode').lazy_load()
			luasnip.config.setup {
				history = true,

				updateevents = 'TextChanged,TextChangedI',

				enable_autosnippets = true,

				ext_opts = {
					[types.choiceNode] = {
						active = {
							virt_text = { { '<-', 'Error' } },
						}
					}
				}
			}

			cmp.setup {
				performance = {
					debounce = 150,
					throttle = 60,
					fetching_timeout = 200,
				},
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

			cmp.setup.filetype({ "sql" }, {
				sources = {
					{ name = "vim-dadbod-completion" },
					{ name = "buffer" },
				}
			})
		end
	},
}
return M
