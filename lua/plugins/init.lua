return {
  -- NvChad v2.5's old TSInstall/ensure_installed interface needs legacy Treesitter.
  { "nvim-treesitter/nvim-treesitter", branch = "master" },

  -- NvChad v2.5 currently uses PATH="skip"; needed for Mason-installed CLI tools.
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = function(_, opts)
      opts.PATH = "prepend"
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  { "mfussenegger/nvim-dap", lazy = true },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local debugger_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      if vim.fn.executable(debugger_python) ~= 1 then
        vim.notify("Run :MasonInstall debugpy, then restart Nvim", vim.log.levels.WARN)
        return
      end
      require("dap-python").setup(debugger_python)
      require("dap-python").test_runner = "pytest"
    end,
  },
}
