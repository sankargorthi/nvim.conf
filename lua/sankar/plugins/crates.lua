return {
	{
		'saecki/crates.nvim',
		tag = 'stable',
		event = { 'BufRead Cargo.toml' },
		config = function()
			local crates = require('crates')
			crates.setup({
				completion = {
					cmp = { enabled = true },
					crates = { enabled = true },
				},
			})

			-- Wire nvim-cmp source for Cargo.toml specifically.
			require('cmp').setup.filetype({ 'toml' }, {
				sources = {
					{ name = 'crates' },
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				},
			})

			local nmap = function(keys, func, desc)
				vim.keymap.set('n', keys, func, { desc = '🦀 crates: ' .. desc })
			end
			nmap('<leader>ct', crates.toggle, '[t]oggle annotations')
			nmap('<leader>cr', crates.reload, '[r]eload')
			nmap('<leader>cv', crates.show_versions_popup, 'show [v]ersions')
			nmap('<leader>cf', crates.show_features_popup, 'show [f]eatures')
			nmap('<leader>cd', crates.show_dependencies_popup, 'show [d]ependencies')
			nmap('<leader>cu', crates.update_crate, '[u]pdate crate')
			nmap('<leader>cU', crates.upgrade_crate, '[U]pgrade crate (breaking)')
			nmap('<leader>cA', crates.update_all_crates, 'update [A]ll')
		end,
	},
}
