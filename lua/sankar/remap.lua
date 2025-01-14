vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>wd", "<C-w>t<C-w>K", { desc = 'Rotate windows down' })
vim.keymap.set("n", "<leader>wr", "<C-w>t<C-w>H", { desc = 'Rotate windows right' })
vim.keymap.set('n', '<leader>rc', function()
	dofile(vim.env.MYVIMRC)
	print("Config reloaded!")
end, { desc = "Refresh Neovim configuration" })

