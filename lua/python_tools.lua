-- Run Python and pytest in a real Neovim terminal tab.
-- In particular, a full-height terminal tab is suitable for curses apps.
local M = {}

local function project_root(path)
  return vim.fs.root(path, { "pyproject.toml", "pytest.ini", "setup.cfg", ".git" })
    or vim.fn.fnamemodify(path, ":h")
end

local function interpreter(root)
  -- Prefer this project's environment over another activated venv.
  for _, dirname in ipairs({ ".venv", "venv" }) do
    local candidate = root .. "/" .. dirname .. "/bin/python"
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  local activated = vim.env.VIRTUAL_ENV
  if activated and vim.fn.executable(activated .. "/bin/python") == 1 then
    return activated .. "/bin/python"
  end

  local executable = vim.fn.exepath("python3")
  if executable == "" then
    vim.notify("python3 is missing from PATH", vim.log.levels.ERROR)
    return nil
  end
  return executable
end

local function current_file()
  if vim.bo.filetype ~= "python" then
    vim.notify("Open a Python file first", vim.log.levels.WARN)
    return nil
  end

  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" then
    vim.notify("Save the Python file first", vim.log.levels.WARN)
    return nil
  end

  vim.cmd("update")
  return filename
end

local function terminal(argv, cwd)
  vim.cmd("tabnew")
  vim.bo.bufhidden = "wipe"
  local job = vim.fn.termopen(argv, { cwd = cwd })
  if job <= 0 then
    vim.notify("Could not start terminal command", vim.log.levels.ERROR)
    return
  end
  vim.cmd("startinsert")
end

function M.run_file()
  local filename = current_file()
  if not filename then return end
  local root = project_root(filename)
  local python = interpreter(root)
  if python then terminal({ python, filename }, root) end
end

function M.test_file()
  local filename = current_file()
  if not filename then return end
  local root = project_root(filename)
  local python = interpreter(root)
  if python then terminal({ python, "-m", "pytest", "-q", filename }, root) end
end

function M.test_project()
  local filename = vim.api.nvim_buf_get_name(0)
  local root = filename ~= "" and project_root(filename) or vim.fn.getcwd()
  local python = interpreter(root)
  if python then terminal({ python, "-m", "pytest", "-q" }, root) end
end

return M
