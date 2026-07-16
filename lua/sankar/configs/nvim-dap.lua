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

-- mason-nvim-dap registers js-debug-adapter as `js`, but vscode-js-debug
-- (and neotest-vitest) call it via `pwa-node`. Bridge the name here.
dap.adapters['pwa-node'] = {
	type = 'server',
	host = 'localhost',
	port = '${port}',
	executable = {
		command = 'node',
		args = {
			vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
			'${port}',
		},
	},
}

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

-- Rust: attach codelldb to a running aspen `xroot`. The pgrep filter matches the
-- dev-profile binary path so we don't pick up unrelated `root` processes.
local function pick_xroot_pid()
	local pgrep = vim.fn.systemlist({ 'pgrep', '-f', 'target/debug/root' })
	if vim.v.shell_error ~= 0 or #pgrep == 0 then
		vim.notify('nvim-dap: no target/debug/root process found. Is xroot running?', vim.log.levels.WARN)
		return nil
	end
	if #pgrep == 1 then
		return tonumber(pgrep[1])
	end
	local prompt = { 'Select xroot pid:' }
	for i, pid in ipairs(pgrep) do
		table.insert(prompt, string.format('%d. %s', i, pid))
	end
	local choice = vim.fn.inputlist(prompt)
	if choice < 1 or choice > #pgrep then
		return nil
	end
	return tonumber(pgrep[choice])
end

dap.configurations.rust = {
	{
		name = 'Attach to running xroot',
		type = 'codelldb',
		request = 'attach',
		pid = pick_xroot_pid,
		args = {},
		-- Force codelldb to load the Rust language plugin. Auto-detect from
		-- DWARF sometimes misses (esp. on attach to an already-running
		-- process), which prints "no plugin for language 'rust'. Inspection
		-- of frame variables will be limited" on every frame change.
		sourceLanguages = { 'rust' },
	},
}

-- Session-scoped Ctrl-chord cluster: single-key stepping bound while a DAP
-- session is live, torn down on end so <C-j>/<C-k>/<C-l>/<C-h>/<C-g>/<C-n>/
-- <C-p> retain their normal-mode meanings (line-up/down, backspace, redraw,
-- file-info, prev/next line) outside of a debug session.
local session_maps = {
	{ 'n', '<C-j>', dap.step_over,     'DAP: step over' },
	{ 'n', '<C-k>', dap.step_out,      'DAP: step out (return to caller)' },
	{ 'n', '<C-l>', dap.step_into,     'DAP: step into (descend into call)' },
	{ 'n', '<C-h>', dap.restart_frame, 'DAP: restart current frame' },
	{ 'n', '<C-g>', dap.run_to_cursor, 'DAP: run to cursor (temp bp + continue)' },
	{ 'n', '<C-p>', dap.up,            'DAP: previous frame (caller)' },
	{ 'n', '<C-n>', dap.down,          'DAP: next frame (callee)' },
}

dap.listeners.after.event_initialized.session_maps = function()
	for _, m in ipairs(session_maps) do
		vim.keymap.set(m[1], m[2], m[3], { desc = m[4] })
	end
end

local function remove_session_maps()
	for _, m in ipairs(session_maps) do
		pcall(vim.keymap.del, m[1], m[2])
	end
end
dap.listeners.before.event_terminated.session_maps = remove_session_maps
dap.listeners.before.event_exited.session_maps = remove_session_maps

vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = ' Toggle [b]reakpoint', noremap = true })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = ' [C]ontinue', noremap = true })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = ' Step [O]ver', noremap = true })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = ' Step [I]nto', noremap = true })
-- Attach-only workflow: disconnect detaches codelldb without killing the
-- debuggee (xroot). `dap.terminate` would SIGKILL xroot instead — reach for
-- it manually via `:lua require'dap'.terminate()` if that's ever wanted.
vim.keymap.set('n', '<leader>dt', dap.disconnect, { desc = 'Detach debugger (leave xroot running)', noremap = true })
vim.keymap.set('n', '<leader>dB', function()
	vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(cond)
		if cond and cond ~= '' then dap.set_breakpoint(cond) end
	end)
end, { desc = 'Set conditional [B]reakpoint', noremap = true })
vim.keymap.set('n', '<leader>dL', function()
	vim.ui.input({ prompt = 'Log message: ' }, function(msg)
		if msg and msg ~= '' then dap.set_breakpoint(nil, nil, msg) end
	end)
end, { desc = 'Set [L]ogpoint (print, no stop)', noremap = true })
vim.keymap.set('n', '<leader>dW', function()
	require('dapui').elements.watches.add(vim.fn.expand('<cword>'))
end, { desc = 'Add [W]ord under cursor to watches', noremap = true })
vim.keymap.set('v', '<leader>dW', function()
	vim.cmd('normal! "zy')
	require('dapui').elements.watches.add(vim.fn.getreg('z'))
end, { desc = 'Add selection to [W]atches', noremap = true })
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
