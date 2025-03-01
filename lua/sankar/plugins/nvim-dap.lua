local D = {
	{
		'jbyuki/one-small-step-for-vimkind',
		dependencies = {
			'mfussenegger/nvim-dap'
		},
		config = function()
			require 'sankar.configs.nvim-dap'
		end
	},

	{
		'mfussenegger/nvim-dap',
	},
}
return D
