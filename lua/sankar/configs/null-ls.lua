local augrp = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require 'null-ls'

local opts = {
  sources = {
		null_ls.builtins.formatting.prettierd,
	},
	on_attach = function (client, buffnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = augrp,
				buffer = buffnr,
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augrp,
				buffer = buffnr,
				callback = function ()
					vim.lsp.buf.format({ bufnr = buffnr })
					local params = {
						command = '_typescript.organizeImports',
						arguments = {vim.api.nvim_buf_get_name(0)},
					}
					vim.lsp.buf.execute_command(params)
				end
			})
		end
	end
}

return opts
