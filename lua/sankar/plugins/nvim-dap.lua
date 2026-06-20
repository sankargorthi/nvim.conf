local D = {
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			'rcarriga/nvim-dap-ui',
			'nvim-neotest/nvim-nio',
			'theHamsta/nvim-dap-virtual-text',
			{
				'jay-babu/mason-nvim-dap.nvim',
				dependencies = { 'williamboman/mason.nvim' },
			},
		},
		config = function()
			require 'sankar.configs.nvim-dap'
		end,
	},
	{
		'jbyuki/one-small-step-for-vimkind',
		dependencies = { 'mfussenegger/nvim-dap' },
	},
}
return D
