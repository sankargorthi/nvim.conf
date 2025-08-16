return {
  "stevearc/conform.nvim",
  opts = {
    -- Configuration for formatters
    formatters_by_ft = {
      javascript = { "biome" },
      typescript = { "biome" },
      javascriptreact = { "biome" },
      typescriptreact = { "biome" },
      json = { "biome" },
      css = { "biome" },
      -- Add other filetypes as needed
    },
    -- conform.nvim's definition for the biome formatter
    formatters = {
      biome = {
        command = "biome",
        -- Pass the required arguments here
        args = { "check", "--write", "--unsafe", "--stdin-file-path", "$FILENAME" },
        stdin = true,
      },
    },
  },
  config = function (_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      group = vim.api.nvim_create_augroup("ConformFormatOnSave", { clear = true }),
      callback = function(args)
        require("conform").format({ bufnr = args.buf, async = false, lsp_fallback = true })
      end,
    })
  end
}
