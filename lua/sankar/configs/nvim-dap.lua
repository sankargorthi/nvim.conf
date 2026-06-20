local dap = require 'dap'
local dapui = require 'dapui'

require('nvim-dap-virtual-text').setup()

require('mason-nvim-dap').setup({
	ensure_installed = { 'codelldb', 'debugpy', 'js-debug-adapter' },
	automatic_installation = true,
	handlers = {
		function(config)
			require('mason-nvim-dap').default_setup(config)
		end,
	},
})

dapui.setup()

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

dap.configurations.lua = {
	{
		type = 'nlua',
		request = 'attach',
		name = 'Attach to running Neovim instance',
	}
}

dap.adapters.nlua = function(callback, config)
	callback({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 })
end

vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = ' Toggle [b]reakpoint', noremap = true })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = ' [C]ontinue', noremap = true })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = ' Step [O]ver', noremap = true })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = ' Step [I]nto', noremap = true })
vim.keymap.set('n', '<leader>du', dap.step_out, { desc = ' Step O[u]t', noremap = true })

vim.keymap.set('n', '<leader>dU', dapui.toggle, { desc = ' Toggle dap [U]I', noremap = true })
vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = ' Toggle dap [r]epl', noremap = true })

vim.keymap.set('n', '<leader>dl', function()
	require 'osv'.launch({ port = 8086 })
end, { noremap = true, desc = ' [L]aunch [d]ebugger' })
vim.keymap.set('n', '<leader>dw', function()
	local widgets = require 'dap.ui.widgets'
	widgets.hover()
end, { desc = ' Evaluate expression in [d]ebugger and sho[w] result' })
vim.keymap.set('n', '<leader>df', function()
	local widgets = require 'dap.ui.widgets'
	widgets.centered_float(widgets.frames)
end, { desc = ' Show [d]ebugger [f]rames' })
