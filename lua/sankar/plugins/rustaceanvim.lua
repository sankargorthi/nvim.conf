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

			vim.g.rustaceanvim = {
				tools = {
					executor = float_executor,
					test_executor = float_executor,
				},
				server = {
					on_attach = lsp.on_attach,
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

			vim.keymap.set('n', '<leader>rr', function()
				vim.cmd.RustLsp('run')
			end, { desc = '🦀 [r]un at cursor', noremap = true })
			vim.keymap.set('n', '<leader>rR', function()
				vim.cmd.RustLsp('runnables')
			end, { desc = '🦀 [R]unnables picker', noremap = true })
		end,
	},
}
