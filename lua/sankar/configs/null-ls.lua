-- local augrp = vim.api.nvim_create_augroup('LspFormatting', {})
local formatting = require 'null-ls'.builtins.formatting

local opts = {
	-- sources = {
	-- 	formatting.prettierd,
	-- 	formatting.eslint_d,
	-- },
	-- on_attach = function(client)
	-- 	if client.resolved_capabilities.document_formatting then
	-- 		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	-- 	end

		-- if client.resolved_capabilities.document_formatting then
		-- 	vim.api.nvim_create_autocmd("BufWritePre", {
		-- 		buffer = bufnr,
		-- 		command = "EslintFixAll",
		-- 	})
		-- end
		-- 	if client.supports_method('textDocument/formatting') then
		-- 		vim.api.nvim_clear_autocmds({
		-- 			group = augrp,
		-- 			buffer = bufnr,
		-- 		})
		--
		-- 		-- Define a list of filetypes to check
		-- 		local supported_filetypes = {
		-- 			'javascript',
		-- 			'javascriptreact',
		-- 			'typescript',
		-- 			'typescriptreact',
		-- 		}
		--
		-- 		vim.api.nvim_create_autocmd('BufWritePre', {
		-- 			group = augrp,
		-- 			buffer = bufnr, -- Scoped to this specific buffer
		-- 			callback = function()
		-- 				vim.schedule(function()
		-- 					local filetype = vim.bo[bufnr].filetype
		-- 					if vim.tbl_contains(supported_filetypes, filetype) then
		-- 						-- Format the buffer
		-- 						vim.lsp.buf.format({ bufnr = bufnr })
		--
		-- 						-- Organize imports
		-- 						local params = {
		-- 							command = '_typescript.organizeImports',
		-- 							arguments = { vim.api.nvim_buf_get_name(bufnr) },
		-- 						}
		-- 						vim.lsp.buf.execute_command(params)
		-- 					end
		-- 				end)
		-- 			end,
		-- 		})
		-- 	end
	-- end
}

return opts
