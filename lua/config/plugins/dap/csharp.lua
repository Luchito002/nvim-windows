local dap = require("dap")

dap.adapters.coreclr = {
  type = "executable",
  command = "D:/Tools/netcoredbg/netcoredbg.exe",
  args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "Launch API fixed",
    request = "launch",
    program = "D:/InstallmentCalculation/InstallmentCalculation.API/bin/Debug/net9.0/InstallmentCalculation.API.dll",
    cwd = "D:/InstallmentCalculation/InstallmentCalculation.API",
    stopAtEntry = false,
    justMyCode = false,
    console = "internalConsole",
    env = {
      ASPNETCORE_ENVIRONMENT = "Development",
    },
  },
}
