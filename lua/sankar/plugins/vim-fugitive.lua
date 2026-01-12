local F = {
	{
		'tpope/vim-fugitive',
		config = function()
			vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = ' Fugitive git commit view' })
			vim.g.fugitive_auto_read = 0
		end
	},
}

return F
