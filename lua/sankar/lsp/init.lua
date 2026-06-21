local M = {}

function M.capabilities()
	local caps = vim.lsp.protocol.make_client_capabilities()
	return require('cmp_nvim_lsp').default_capabilities(caps)
end

function M.on_attach(client, bufnr)
	local builtins = require 'telescope.builtin'
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
	nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
	nmap('gr', builtins.lsp_references, '[G]oto [R]eferences [A]ll scopes')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', builtins.lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', builtins.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Do[K]umentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })

	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
		vim.api.nvim_clear_autocmds { buffer = bufnr, group = 'lsp_document_highlight' }
		vim.api.nvim_create_autocmd('CursorHold', {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = 'lsp_document_highlight',
			desc = 'Document Highlight',
		})
		vim.api.nvim_create_autocmd('CursorMoved', {
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
			group = 'lsp_document_highlight',
			desc = 'Clear All the References',
		})
	end
end

return M
