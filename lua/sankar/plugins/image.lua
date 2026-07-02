local M = {
	{
		'3rd/image.nvim',
		event = 'VeryLazy',
		build = false,
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		opts = {
			backend = 'kitty',
			processor = 'magick_cli',
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { 'markdown', 'vimwiki' },
				},
			},
			max_width_window_percentage = nil,
			max_height_window_percentage = 50,
			window_overlap_clear_enabled = true,
			-- Clear images when nvim loses focus (e.g. switching to another
			-- tmux pane). Otherwise Kitty graphics live in Ghostty's screen
			-- buffer at absolute coordinates and leak across panes.
			editor_only_render_when_focused = true,
			tmux_show_only_in_active_window = true,
		},
	},
}
return M
