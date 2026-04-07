-- lua/config/plugins/dap/python.lua
local dap = require("dap")

-- Intérprete del proyecto (runtime de su app)
local function python_path_from_cwd()
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  elseif os.getenv("VIRTUAL_ENV") then
    return os.getenv("VIRTUAL_ENV") .. "/bin/python"
  else
    return "/usr/bin/python"
  end
end

-- Adapter: siempre con su venv dedicado a debugpy
dap.adapters.python = function(cb, config)
  if config.request == "attach" then
    local host = (config.connect or config).host or "127.0.0.1"
    local port = (config.connect or config).port
    cb({
      type = "server",
      host = host,
      port = assert(port, "`connect.port` is required for attach"),
      options = { source_filetype = "python" },
    })
  else
    local python_adapter = "/home/luchito/.virtualenvs/debugpy/bin/python"
    cb({
      type = "executable",
      command = python_adapter,
      args = { "-m", "debugpy.adapter" },
      options = { source_filetype = "python" },
    })
  end
end

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file (Alacritty)",
    program = "${file}",
    pythonPath = python_path_from_cwd,   -- intérprete del proyecto
    redirectOutput = true,               -- duplica stdout/err al panel de DAP UI (opcional)
  },
}
