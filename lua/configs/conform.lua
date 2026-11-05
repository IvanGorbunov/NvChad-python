local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    python = {
      "ruff_organize_imports",
      "ruff_format",
    },
  },

  format_on_save = function(bufnr)
    if vim.bo[bufnr].filetype == "python" then
      return {
        timeout_ms = 1500,
        lsp_format = "never",
      }
    end
  end,
}

return options
