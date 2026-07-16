return {
	{
		'mrcjkb/rustaceanvim',
		version = '^5',
		ft = { 'rust' },
		init = function()
			local lsp = require 'sankar.lsp'

			local float_executor = {
				execute_command = function(command, args, cwd, _)
					local shell = require('rustaceanvim.shell')
					local commands = {}
					if cwd then
						table.insert(commands, shell.make_cd_command(cwd))
					end
					table.insert(commands, shell.make_command_from_args(command, args))
					local full_command = shell.chain_commands(commands)

					local width = math.floor(vim.o.columns * 0.8)
					local height = math.floor(vim.o.lines * 0.8)
					local buf = vim.api.nvim_create_buf(false, true)
					local win = vim.api.nvim_open_win(buf, true, {
						relative = 'editor',
						width = width,
						height = height,
						row = math.floor((vim.o.lines - height) / 2),
						col = math.floor((vim.o.columns - width) / 2),
						style = 'minimal',
						border = 'rounded',
						title = ' 🦀 ' .. command .. ' ',
						title_pos = 'center',
					})

					local close = function()
						if vim.api.nvim_win_is_valid(win) then
							vim.api.nvim_win_close(win, true)
						end
					end
					vim.keymap.set({ 'n', 't' }, '<Esc>', close, { buffer = buf, nowait = true })
					vim.keymap.set('n', 'q', close, { buffer = buf, nowait = true })

					if type(vim.fn.termopen) == 'function' then
						---@diagnostic disable-next-line: deprecated
						vim.fn.termopen(full_command)
					else
						vim.fn.jobstart(full_command, { term = true })
					end
				end,
			}

			-- Rust-only buffer-local keymap overrides. Layered here (not in a
			-- FileType autocmd) so they run AFTER the shared `lsp.on_attach`
			-- has set its own generic mappings (K → vim.lsp.buf.hover, etc.)
			-- and can't be clobbered.
			local rust_on_attach = function(client, bufnr)
				lsp.on_attach(client, bufnr)
				local map = function(lhs, subcmd, desc)
					vim.keymap.set('n', lhs, function() vim.cmd.RustLsp(subcmd) end,
						{ buffer = bufnr, desc = '🦀 ' .. desc })
				end
				-- Hover actions: adds go-to-impl / view docs to the plain hover.
				map('K', { 'hover', 'actions' }, 'hover actions')
				-- <C-w>d default is `vim.diagnostic.open_float` (one-line message);
				-- swap in the full cargo-formatted block with source + `help:` hint.
				map('<C-w>d', 'renderDiagnostic', 'render diagnostic')
			end

			vim.g.rustaceanvim = {
				tools = {
					executor = float_executor,
					test_executor = float_executor,
				},
				server = {
					on_attach = rust_on_attach,
					capabilities = lsp.capabilities(),
					default_settings = {
						['rust-analyzer'] = {
							-- Run clippy on save instead of `cargo check`.
							-- More lints, roughly the same latency.
							check = { command = 'clippy' },
							-- Group auto-imports by module rather than each
							-- symbol on its own `use` line.
							imports = { granularity = { group = 'module' } },
							procMacro = { enable = true },
							-- Show elided lifetimes and parameter names as
							-- inlay hints; on_attach also enables them.
							inlayHints = {
								bindingModeHints = { enable = true },
								closureReturnTypeHints = { enable = 'always' },
								lifetimeElisionHints = { enable = 'skip_trivial' },
							},
						},
					},
				},
			}

			-- Global <leader>r… bindings. RustLsp is only meaningful when
			-- rust-analyzer is attached; invoking from a non-Rust buffer errors.
			local gmap = function(lhs, subcmd, desc)
				vim.keymap.set('n', lhs, function() vim.cmd.RustLsp(subcmd) end,
					{ desc = '🦀 ' .. desc, noremap = true })
			end
			gmap('<leader>rr', 'run',            '[r]un at cursor')
			gmap('<leader>rR', 'runnables',      '[R]unnables picker')
			-- rustc --explain E0308: conceptual walkthrough of the error code.
			gmap('<leader>re', 'explainError',   '[e]xplain error code')
			-- What the code lowers to. Occasional, but memorable.
			gmap('<leader>rm', { 'view', 'mir' }, 'view [m]ir')
			gmap('<leader>rH', { 'view', 'hir' }, 'view [H]ir')
		end,
	},
}
