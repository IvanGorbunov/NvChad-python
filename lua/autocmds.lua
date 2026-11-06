require "nvchad.autocmds"

local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "python", "lua", "bash", "json", "toml" },
  callback = function(args)
    -- Do not try to start a parser that is not yet installed.
    pcall(vim.treesitter.start, args.buf)
  end,
})
