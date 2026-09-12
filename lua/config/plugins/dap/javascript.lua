local M = {}

local function executable_path(paths)
  for _, path in ipairs(paths) do
    if vim.fn.executable(path) == 1 or vim.fn.filereadable(path) == 1 then
      return path
    end
  end
end

local function browser_url()
  return vim.fn.input("URL de debug: ", "http://localhost:5173/InstallmentCalculation.Web")
end

local function js_debug_path()
  return vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/out/src/vsDebugServer.js"
end

local function browser_runtime_args()
  return {
    "--new-window",
    "--disable-extensions",
    "--disable-default-apps",
    "--disable-background-networking",
    "--disable-component-extensions-with-background-pages",
    "--disable-renderer-backgrounding",
  }
end

local function register_js_adapters(dap)
  local adapter = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        js_debug_path(),
        "${port}",
      },
      detached = true,
    },
  }

  dap.adapters["pwa-node"] = adapter
  dap.adapters["node-terminal"] = adapter
  dap.adapters["pwa-chrome"] = adapter
  dap.adapters["pwa-msedge"] = adapter
  dap.adapters["pwa-extensionHost"] = adapter
end

function M.setup()
  local dap = require("dap")

  register_js_adapters(dap)

  local edge_path = executable_path({
    "msedge",
    "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
    "C:/Program Files/Microsoft/Edge/Application/msedge.exe",
  })

  local chrome_path = executable_path({
    "chrome",
    "C:/Program Files/Google/Chrome/Application/chrome.exe",
    "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe",
  })

  local browser_configs = {
    {
      type = "pwa-msedge",
      request = "launch",
      name = "React: lanzar en Edge",
      url = browser_url,
      webRoot = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
      trace = true,
      runtimeExecutable = edge_path,
      runtimeArgs = browser_runtime_args(),
      sourceMapPathOverrides = {
        ["vite:///*"] = "${webRoot}/*",
        ["/src/*"] = "${webRoot}/src/*",
        ["/@fs/*"] = "*",
        ["webpack:///src/*"] = "${webRoot}/src/*",
        ["webpack:///*"] = "*",
      },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
      skipFiles = {
        "<node_internals>/**",
        "**/node_modules/**",
      },
      log_file_path = vim.fn.stdpath("cache") .. "/dap_js.log",
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "React: lanzar en Chrome",
      url = browser_url,
      webRoot = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
      trace = true,
      runtimeExecutable = chrome_path,
      runtimeArgs = browser_runtime_args(),
      sourceMapPathOverrides = {
        ["vite:///*"] = "${webRoot}/*",
        ["/src/*"] = "${webRoot}/src/*",
        ["/@fs/*"] = "*",
        ["webpack:///src/*"] = "${webRoot}/src/*",
        ["webpack:///*"] = "*",
      },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
      skipFiles = {
        "<node_internals>/**",
        "**/node_modules/**",
      },
      log_file_path = vim.fn.stdpath("cache") .. "/dap_js.log",
    },
    {
      type = "pwa-chrome",
      request = "attach",
      name = "React: adjuntar a Chrome (9222)",
      port = 9222,
      webRoot = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      protocol = "inspector",
      sourceMapPathOverrides = {
        ["vite:///*"] = "${webRoot}/*",
        ["/src/*"] = "${webRoot}/src/*",
        ["/@fs/*"] = "*",
        ["webpack:///src/*"] = "${webRoot}/src/*",
        ["webpack:///*"] = "*",
      },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
    },
    {
      type = "pwa-msedge",
      request = "attach",
      name = "React: adjuntar a Edge (9222)",
      port = 9222,
      webRoot = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      protocol = "inspector",
      sourceMapPathOverrides = {
        ["vite:///*"] = "${webRoot}/*",
        ["/src/*"] = "${webRoot}/src/*",
        ["/@fs/*"] = "*",
        ["webpack:///src/*"] = "${webRoot}/src/*",
        ["webpack:///*"] = "*",
      },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
    },
  }

  local node_configs = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Node: archivo actual",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
      runtimeExecutable = "node",
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Node: adjuntar proceso",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      protocol = "inspector",
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
    },
  }

  local configurations = vim.list_extend(browser_configs, node_configs)

  for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
    dap.configurations[lang] = configurations
  end
end

return M
