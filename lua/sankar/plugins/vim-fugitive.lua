local F = {
	{
		'tpope/vim-fugitive',
		config = function()
			vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = ' Fugitive git commit view' })
		end
	},
}

return F
