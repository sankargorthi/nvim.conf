vim.g.mapleader = " "

-- file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- window management
vim.keymap.set("n", "<leader>wd", "<C-w>t<C-w>K", { desc = 'Rotate windows down' })
vim.keymap.set("n", "<leader>wr", "<C-w>t<C-w>H", { desc = 'Rotate windows right' })

-- Try to reload the config. Although I haven't had a lot of success
vim.keymap.set('n', '<leader>rc', function()
	dofile(vim.env.MYVIMRC)
	print("Config reloaded!")
end, { desc = "Refresh Neovim configuration" })

