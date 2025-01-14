local M = {
	options = {
		icons_enabled = true,
		component_separators = '|',
		-- theme = 'gruvbox-material',
		theme = 'dracula',
		section_separators = '',
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diagnostics' },
		lualine_c = {
			{
				'filename',
				path = 1,
				shorting_target = 40,
			}
		},
		lualine_x = { 'diff', 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = { 'mode' },
		lualine_b = {},
		lualine_c = {
			{
				'filename',
				path = 1,
				shorting_target = 60
			}
		},
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
}

return M
