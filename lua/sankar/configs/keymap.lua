-- Block move selection
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- file explorer
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = '󰙅 Show [p]roject [v]iew' })

-- window management
vim.keymap.set('n', '<leader>wd', '<C-w>t<C-w>K', { desc = 'Rotate [W]indows [D]own' })
vim.keymap.set('n', '<leader>wr', '<C-w>t<C-w>H', { desc = 'Rotate [W]indows [R]ight' })

-- Try to reload the config. Although I haven't had a lot of success
vim.keymap.set('n', '<leader>rc', function()
	dofile(vim.env.MYVIMRC)
	print('Config reloaded!')
end, { desc = '[R]efresh Neovim [C]onfiguration' })

vim.keymap.set('n', '<leader>so', function()
	vim.cmd('source %')
	print('Sourced!')
end, { desc = '[So]urce current file' })

local function toggle_whitespace()
	if vim.wo.list then
		print('Hide whitespace')
		vim.wo.list = false
		vim.opt.listchars:remove('tab')
		vim.opt.listchars:remove('trail')
	else
		print('Showing whitespace')
		vim.wo.list = true
		vim.opt.listchars:append({
			tab = '>-',
			trail = '·',
		})
	end
	vim.cmd('edit') -- Reloads the buffer without losing changes
end

vim.api.nvim_create_autocmd('User', {
	pattern = 'ToggleWhitespace',
	callback = toggle_whitespace,
})

vim.keymap.set('n', '<leader>ss', function()
	vim.api.nvim_exec_autocmds('User', { pattern = 'ToggleWhitespace' })
end, { desc = '[S]how/Hide white[S]pace' })

-- TODO: Comments
vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next [T]odo comment' })
vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Previous [T]odo comment' })
vim.keymap.set('n', '<leader>td', ':TodoTelescope<CR>', { desc = 'Show List of all [T]O[D]Os' })
