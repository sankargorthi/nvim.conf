local function keymap()
	if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
		return '⌨ ' .. vim.b.keymap_name
	end
	return ''
end

local L = {
	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				component_separators = '|',
				-- theme = 'gruvbox-material',
				theme = 'dracula',
				section_separators = '',
				always_show_tabline = false,
			},
			tabline = {
				-- lualine_a = { 'buffers' },
				-- lualine_b = { },
				-- lualine_c = { 'filename' },
				-- lualine_z = { 'tabs' },
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'diagnostics' },
				lualine_c = {
					{
						'filename',
						path = 1,
						shorting_target = 40,
					},
				},
				lualine_x = { 'diff', 'encoding', 'fileformat', 'filetype' },
				lualine_y = { keymap, 'searchcount', 'selectioncount', 'progress' },
				lualine_z = { 'location', 'tabs' }
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						'filename',
						path = 0,
						shorting_target = 20
					}
				},
				lualine_x = { 'location' },
				lualine_y = {},
				lualine_z = { 'tabs' }
			},
			extensions = {
				'ctrlspace',
				'fugitive',
				'fzf',
				'lazy',
				'man',
				'mason',
				'quickfix',
				'symbols-outline',
			}
		}
	},
}

return L
