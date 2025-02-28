local N = {
	{
		'nvimtools/none-ls.nvim',
		opts = function()
			return require 'sankar.configs.null-ls'
		end
	},
}
return N
