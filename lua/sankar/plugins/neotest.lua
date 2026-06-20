return {
	{
		'nvim-neotest/neotest',
		dependencies = {
			'nvim-neotest/nvim-nio',
			'nvim-lua/plenary.nvim',
			'antoinemadec/FixCursorHold.nvim',
			'nvim-treesitter/nvim-treesitter',
			'nvim-neotest/neotest-python',
			'marilari88/neotest-vitest',
		},
		keys = {
			{ '<leader>tn', function() require('neotest').run.run() end, desc = ' Test [n]earest' },
			{ '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = ' Test [f]ile' },
			{ '<leader>tl', function() require('neotest').run.run_last() end, desc = ' Test [l]ast' },
			{ '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = ' [D]ebug nearest test' },
			{ '<leader>to', function() require('neotest').output.open({ enter = true }) end, desc = ' Test [o]utput' },
			{ '<leader>ts', function() require('neotest').summary.toggle() end, desc = ' Test [s]ummary panel' },
		},
		config = function()
			require('neotest').setup({
				adapters = {
					require('neotest-python')({
						python = '/Users/SankarGorthi/.pyenv/versions/contact_manager/bin/python',
						dap = { justMyCode = false },
					}),
					require('neotest-vitest'),
				},
			})
		end,
	},
}
