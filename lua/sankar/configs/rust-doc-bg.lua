-- Tint the full-line background of Rust doc comments (`///` and `//!`) with
-- the theme's "overlay" surface so they read as a callout block and the
-- surrounding code stands out. Applied via treesitter query for
-- `(doc_comment)` nodes plus per-line `line_hl_group` extmarks — a plain
-- highlight-group `bg` on `@comment.documentation.rust` would only tint the
-- character cells that hold text, leaving pure `//!` spacer lines uncolored.

local ns = vim.api.nvim_create_namespace('rust_doc_comment_bg')
local hl_group = 'RustDocCommentBg'

-- Rose-pine palette values, keyed by nvim background mode. Hardcoded rather
-- than derived from `rose-pine.palette` (which caches its variant on first
-- `require` and returns stale colors after auto-dark-mode swaps) or from
-- `ColorColumn.bg` (which doesn't consistently track the theme's overlay
-- surface). Values sourced from rose-pine.nvim's `dawn` and `moon` palette
-- files — swap if you retune.
local TINT = {
	light = '#f2e9e1', -- dawn.overlay
	dark = '#2a283e',  -- moon.highlight_low (subtler than moon.overlay #393552)
}

local function set_hl()
	local bg = TINT[vim.o.background] or TINT.light
	-- No `default = true`: we WANT to overwrite on every ColorScheme event.
	-- With `default`, the second call (fired when auto-dark-mode swaps the
	-- theme) becomes a no-op because the group is already defined, pinning
	-- the initial (often wrong) color chosen during startup before the
	-- theme was finalized.
	vim.api.nvim_set_hl(0, hl_group, { bg = bg })
end

local function highlight_buf(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then return end
	if vim.bo[bufnr].filetype ~= 'rust' then return end
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'rust')
	if not ok or not parser then return end
	local tree = parser:parse()[1]
	if not tree then return end
	local query = vim.treesitter.query.parse('rust', '(doc_comment) @doc')
	for _, node in query:iter_captures(tree:root(), bufnr) do
		local sr, _, er, ec = node:range()
		-- A node ending at column 0 of row `er` doesn't cover that row.
		local last = ec == 0 and er - 1 or er
		for row = sr, last do
			vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
				line_hl_group = hl_group,
				priority = 10,
			})
		end
	end
end

set_hl()

vim.api.nvim_create_autocmd('ColorScheme', {
	callback = set_hl,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged' }, {
	pattern = '*.rs',
	callback = function(args) highlight_buf(args.buf) end,
})
