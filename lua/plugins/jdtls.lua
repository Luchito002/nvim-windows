return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mason-org/mason.nvim",
    "saghen/blink.cmp",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local jdtls = require("jdtls")
    local root_markers = {
      "mvnw",
      "mvnw.cmd",
      "gradlew",
      "gradlew.bat",
      "pom.xml",
      "build.gradle",
      "build.gradle.kts",
      "settings.gradle",
      "settings.gradle.kts",
      ".git",
    }
    local root_dir = vim.fs.root(0, root_markers)

    if not root_dir then
      return
    end

    local workspace_dir = vim.fn.stdpath("data")
      .. "/jdtls-workspace/"
      .. vim.fn.sha256(root_dir):sub(1, 12)
    local java_dap = require("config.plugins.dap.java")

    local config = {
      cmd = { "jdtls" },
      root_dir = root_dir,
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      on_attach = function()
        vim.schedule(java_dap.use_internal_console)
      end,
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = "interactive",
          },
          maven = {
            downloadSources = true,
          },
          format = {
            enabled = true,
          },
        },
      },
      init_options = {
        bundles = java_dap.bundles(),
      },
    }

    config.cmd = vim.list_extend(config.cmd, { "-data", workspace_dir })
    jdtls.start_or_attach(config, {
      dap = {
        config_overrides = {
          console = "internalConsole",
        },
      },
    })
  end,
}
