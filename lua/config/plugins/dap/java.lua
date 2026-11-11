local M = {}

local java_debug_bundle =
  "D:/Tools/java-debug/extension/server/com.microsoft.java.debug.plugin-0.53.2.jar"
local jdtls_provider_wrapped = false

function M.bundles()
  if vim.fn.filereadable(java_debug_bundle) == 1 then
    return { java_debug_bundle }
  end

  vim.notify("No se encontró el bundle de Java Debug: " .. java_debug_bundle, vim.log.levels.WARN)
  return {}
end

function M.use_internal_console()
  local dap = require("dap")
  local provider = dap.providers.configs.jdtls

  if not provider or jdtls_provider_wrapped then
    return
  end

  dap.providers.configs.jdtls = function(bufnr)
    local configurations = provider(bufnr)

    for _, configuration in ipairs(configurations or {}) do
      configuration.console = "internalConsole"
    end

    return configurations
  end
  jdtls_provider_wrapped = true
end

return M
