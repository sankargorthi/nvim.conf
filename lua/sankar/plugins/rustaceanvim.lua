return {
	{
		'mrcjkb/rustaceanvim',
		version = '^5',
		ft = { 'rust' },
		init = function()
			local lsp = require 'sankar.lsp'
			vim.g.rustaceanvim = {
				server = {
					on_attach = lsp.on_attach,
					capabilities = lsp.capabilities(),
				},
			}
		end,
	},
}
