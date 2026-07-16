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
		config = function(_, opts)
			-- image.nvim (upstream tip 88351f1f) derefs vim.bo[buf].filetype
			-- inside BufEnter/BufWinEnter/WinScrolled callbacks without a
			-- nvim_buf_is_valid guard. Telescope previewers, fugitive's
			-- BlurStatus, and git-worktree pane teardown all fire those
			-- events with an already-wiped scratch buf id, so the plugin
			-- throws mid-callback.
			-- Pcall-wrap every autocmd it registers so invalid-buffer/window
			-- errors silently no-op. The wrap must stay in effect across
			-- vim.schedule ticks because document.lua defers its own
			-- setup_autocommands via vim.schedule (line 422) — restoring
			-- synchronously would leave those callbacks unwrapped.
			local orig = vim.api.nvim_create_autocmd
			vim.api.nvim_create_autocmd = function(event, o)
				if type(o) == 'table' and type(o.callback) == 'function' then
					local user_cb = o.callback
					o.callback = function(args)
						local ok, err = pcall(user_cb, args)
						if not ok and not tostring(err):match('Invalid buffer id') and not tostring(err):match('Invalid window id') then
							error(err)
						end
					end
				end
				return orig(event, o)
			end
			local ok, err = pcall(require('image').setup, opts)
			-- Defer restore so it runs AFTER image.nvim's own vim.schedule'd
			-- setup_autocommands has registered (FIFO ordering).
			vim.schedule(function()
				vim.api.nvim_create_autocmd = orig
			end)
			if not ok then error(err) end
		end,
	},
}
return M
