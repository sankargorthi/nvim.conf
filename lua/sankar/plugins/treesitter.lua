---@diagnostic disable: missing-fields
local T = {
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		config = function()
			require 'nvim-treesitter.configs'.setup {
				-- A list of parser names, or 'all' (the five listed parsers should always be installed)
				-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				diagnostics = { disable = { 'missing-fields' } },
				ensure_installed = {
					'bash',
					'c',
					'css',
					'go',
					'graphql',
					'html',
					-- 'java',
					'javascript',
					'lua',
					'markdown',
					'markdown_inline',
					'python',
					'query',
					'rust',
					'scss',
					'tmux',
					'typescript',
					'vim',
					'vimdoc',
					'xml',
					'yaml',
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = '/some/path/to/store/parsers', -- Remember to run vim.opt.runtimepath:append('/some/path/to/store/parsers')!

				highlight = {
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},

				indent = { enable = false },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = '<c-space>',
						node_incremental = '<c-space>',
						scope_incremental = '<c-s>',
						node_decremental = '<M-space>',
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							['aa'] = '@parameter.outer',
							['ia'] = '@parameter.inner',
							['af'] = '@function.outer',
							['if'] = '@function.inner',
							['ac'] = '@class.outer',
							['ic'] = '@class.inner',
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							[']m'] = '@function.outer',
							[']]'] = '@class.outer',
						},
						goto_next_end = {
							[']M'] = '@function.outer',
							[']['] = '@class.outer',
						},
						goto_previous_start = {
							['[m'] = '@function.outer',
							['[['] = '@class.outer',
						},
						goto_previous_end = {
							['[M'] = '@function.outer',
							['[]'] = '@class.outer',
						},
					},
					-- swap = {
					-- 	enable = true,
					-- 	swap_next = {
					-- 		['<leader>a'] = '@parameter.inner',
					-- 	},
					-- 	swap_previous = {
					-- 		['<leader>A'] = '@parameter.inner',
					-- 	},
					-- },
				},
			}

			-- Merge user-authored after/queries/<lang>/injections.scm into the
			-- compiled treesitter query. nvim-treesitter pins each language's
			-- query via `vim.treesitter.query.set` during startup, which
			-- shadows nvim's runtime-merge of `after/queries/`. We re-read
			-- every discovered file for the languages we care about and set
			-- the merged text ourselves so custom injections actually take
			-- effect. Add languages here as needed.
			local function merge_injections(lang)
				local paths = vim.api.nvim_get_runtime_file(
					'queries/' .. lang .. '/injections.scm', true)
				if #paths < 2 then return end
				local parts = {}
				for _, path in ipairs(paths) do
					local f = io.open(path, 'r')
					if f then
						table.insert(parts, f:read('*a'))
						f:close()
					end
				end
				vim.treesitter.query.set(lang, 'injections',
					table.concat(parts, '\n'))
			end

			merge_injections('rust')
		end
	},
}
return T
