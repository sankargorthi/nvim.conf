local dap = require 'dap'

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

vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = ' Toggle breakpoint', noremap = true })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = ' Continue',  noremap = true })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = ' Step Over', noremap = true })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = ' Step Into', noremap = true })
vim.keymap.set('n', '<leader>du', dap.step_out, { desc = ' Step Out', noremap = true })

vim.keymap.set('n', '<leader>dl', function()
	require 'osv'.launch({ port = 8086 })
end, { noremap = true, desc = ' Launch debugger' })
vim.keymap.set('n', '<leader>dw', function()
	local widgets = require 'dap.ui.widgets'
	widgets.hover()
end, { desc = ' Evaluate expression and show result' })
vim.keymap.set('n', '<leader>df', function()
	local widgets = require 'dap.ui.widgets'
	widgets.centered_float(widgets.frames)
end, { desc = ' Show debugger frames' })
