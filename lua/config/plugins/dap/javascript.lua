local dap = require("dap")

-- LIMPIAR CONFIGS
for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
  dap.configurations[lang] = {}
end

dap.configurations.typescriptreact = {
  {
    type = "pwa-msedge",
    request = "launch",
    name = "Debug React (Edge)",

    url = "http://localhost:5173",
    cwd = "${workspaceFolder}",
    webRoot = "${workspaceFolder}",

    runtimeExecutable = "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",

    sourceMaps = true,
    trace = true,

    log_file_path = vim.fn.stdpath("cache") .. "/dap_js.log",
  },
}

dap.configurations.javascript = dap.configurations.typescriptreact
dap.configurations.typescript = dap.configurations.typescriptreact
dap.configurations.javascriptreact = dap.configurations.typescriptreact
