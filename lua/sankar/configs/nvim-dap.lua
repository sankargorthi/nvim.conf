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

vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = ' Toggle [b]reakpoint', noremap = true })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = ' [C]ontinue', noremap = true })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = ' Step [O]ver', noremap = true })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = ' Step [I]nto', noremap = true })
vim.keymap.set('n', '<leader>du', dap.step_out, { desc = ' Step O[u]t', noremap = true })

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
