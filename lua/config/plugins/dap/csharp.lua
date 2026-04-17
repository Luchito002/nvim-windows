local dap = require("dap")
local registry = require("config.plugins.dap.csharp_debug_paths")

local M = {}

dap.adapters.coreclr = {
  type = "executable",
  command = "D:/Tools/netcoredbg/netcoredbg.exe",
  args = { "--interpreter=vscode" },
  options = {
    detached = false,
  },
}

local selected = nil

function M.pick_entry()
  local entries = registry.cs or {}

  if #entries == 0 then
    vim.notify("登録されたプロジェクトがありません", vim.log.levels.ERROR)
    return
  end

  vim.ui.select(entries, {
    prompt = ".NET プロジェクトを選択:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      selected = choice
      vim.notify("選択: " .. selected.name)
    end
  end)
end

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "Launch registered .NET project",
    request = "launch",
    program = function()
      if not selected then
        vim.notify("先にプロジェクトを選択してください", vim.log.levels.WARN)
        return nil
      end
      return selected.program
    end,
    cwd = function()
      return selected and selected.cwd or vim.fn.getcwd()
    end,
    stopAtEntry = false,
    justMyCode = false,
    console = "integratedTerminal",
    env = function()
      return (selected and selected.env) or {}
    end,
  },
}

return M
