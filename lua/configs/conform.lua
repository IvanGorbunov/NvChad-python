return {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_organize_imports", "ruff_format" },
  },

  -- Opt in for Python only. No unexpected rewrite of Lua or other filetypes.
  format_on_save = function(bufnr)
    if vim.bo[bufnr].filetype == "python" then
      return { timeout_ms = 1500, lsp_format = "never" }
    end
  end,
}
