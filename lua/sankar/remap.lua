vim.g.mapleader = " "

-- Block move selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- window management
vim.keymap.set("n", "<leader>wd", "<C-w>t<C-w>K", { desc = 'Rotate windows down' })
vim.keymap.set("n", "<leader>wr", "<C-w>t<C-w>H", { desc = 'Rotate windows right' })

-- Try to reload the config. Although I haven't had a lot of success
vim.keymap.set('n', '<leader>rc', function()
	dofile(vim.env.MYVIMRC)
	print("Config reloaded!")
end, { desc = "Refresh Neovim configuration" })

vim.keymap.set("n", "<leader>so", function()
	vim.cmd("source %")
	print("Sourced!")
end, { desc = "Source current file" })

local function toggle_whitespace()
	if vim.wo.list then
		print("Hide whitespace")
		vim.wo.list = false
		vim.opt.listchars = {}
	else
		print("Showing whitespace")
		vim.wo.list = true
		vim.opt.listchars:append({
			tab = ">-",
			trail = "·",
		})
	end
	vim.cmd("edit") -- Reloads the buffer without losing changes
end

vim.api.nvim_create_autocmd("User", {
	pattern = "ToggleWhitespace",
	callback = toggle_whitespace,
})

vim.keymap.set("n", "<leader>ss", function()
	vim.api.nvim_exec_autocmds("User", { pattern = "ToggleWhitespace" })
end, { desc = "Toggle whitespace display" })
