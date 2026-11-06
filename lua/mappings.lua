require "nvchad.mappings"

local map = vim.keymap.set
local python = require "python_tools"

-- Keep NvChad's existing mappings; add separate Python key prefixes.
map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Run files and tests (terminal tab keeps curses at full height).
map("n", "<F5>", python.run_file, { desc = "Python: run file in terminal tab" })
map("n", "<leader>pr", python.run_file, { desc = "Python: run current file" })
map("n", "<leader>pt", python.test_file, { desc = "Python: pytest current file" })
map("n", "<leader>pa", python.test_project, { desc = "Python: pytest project" })

-- Debugpy + nvim-dap. F5 remains reserved for running curses programs.
map("n", "<F6>", function() require("dap").continue() end, { desc = "Debug: start/continue" })
map("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Debug: toggle breakpoint" })
map("n", "<F10>", function() require("dap").step_over() end, { desc = "Debug: step over" })
map("n", "<F11>", function() require("dap").step_into() end, { desc = "Debug: step into" })
map("n", "<F12>", function() require("dap").step_out() end, { desc = "Debug: step out" })
map("n", "<leader>dq", function() require("dap").terminate() end, { desc = "Debug: terminate" })
map("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Debug: toggle REPL" })

-- LSP and diagnostics (avoid overriding NvChad gd / <leader>ra).
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: code action" })
map("n", "<leader>lr", vim.lsp.buf.references, { desc = "LSP: references" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Diagnostics: show current" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Diagnostics: next" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Diagnostics: previous" })
