local augrp = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require 'null-ls'

local opts = {
	sources = {
		null_ls.builtins.formatting.prettierd,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = augrp,
				buffer = bufnr,
			})

			-- Define a list of filetypes to check
			local supported_filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			}

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augrp,
				buffer = bufnr, -- Scoped to this specific buffer
				callback = function()
					local filetype = vim.bo[bufnr].filetype
					if vim.tbl_contains(supported_filetypes, filetype) then
						-- Format the buffer
						vim.lsp.buf.format({ bufnr = bufnr })

						-- Organize imports
						local params = {
							command = '_typescript.organizeImports',
							arguments = { vim.api.nvim_buf_get_name(bufnr) },
						}
						vim.lsp.buf.execute_command(params)
					end
				end,
			})
		end
	end
}

return opts
