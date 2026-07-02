local M = {
	{
		'folke/neodev.nvim',
		opts = {}
	},
	{
		'williamboman/mason.nvim',
		version = '^1.0.0',
		config = function()
			require('mason').setup()
		end,
	},
	{
		'williamboman/mason-lspconfig.nvim',
		version = '^1.0.0',
		dependencies = {
			'williamboman/mason.nvim',
			'neovim/nvim-lspconfig',
		},
	},
	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
			'folke/neodev.nvim',
		},
		config = function()
			local lsp = require 'sankar.lsp'

			-- Per-server overrides. Empty table = accept lspconfig defaults.
			local servers = {
				bashls = {},
				-- clangd = {},
				-- gopls = {},
				pyright = {
					settings = {
						python = {
							pythonPath = '/Users/SankarGorthi/.pyenv/versions/3.13.5/envs/contact_manager/bin/python',
						},
					},
				},
				biome = {},
				jsonls = {},
				marksman = {},
				tailwindcss = {},
				ts_ls = {
					root_markers = { '.git' },
					init_options = {
						preferences = { disableSuggestions = true },
					},
				},
				html = { filetypes = { 'html', 'twig', 'hbs' } },
				cssls = {},
				dockerls = {},
				-- eslint = {},

				-- xml
				lemminx = {
					settings = {
						xml = {
							validation = { noGrammar = 'ignore' },
						},
					},
				},

				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
							diagnostics = { globals = { 'vim', 'fname' } },
							-- LuaJIT is Neovim's Lua runtime
							runtime = { version = 'LuaJIT' },
						},
					},
				},
				mdx_analyzer = {},
				vimls = {},
			}

			-- Global defaults merged into every server config
			vim.lsp.config('*', {
				capabilities = lsp.capabilities(),
			})

			for server, opts in pairs(servers) do
				vim.lsp.config(server, opts)
			end

			-- mason-lspconfig v1 only handles install/registry; we drive enable ourselves.
			require('mason-lspconfig').setup {
				automatic_installation = true,
				ensure_installed = vim.tbl_keys(servers),
			}

			vim.lsp.enable(vim.tbl_keys(servers))

			-- on_attach: LspAttach fires once per (client, buffer) pair
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client then
						lsp.on_attach(client, args.buf)
					end
				end,
			})

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

			cmp.setup.filetype({ 'sql' }, {
				sources = {
					{ name = 'vim-dadbod-completion' },
					{ name = 'buffer' },
				}
			})
		end
	},
}
return M
