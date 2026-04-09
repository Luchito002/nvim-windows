return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",

  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    {
      "mxsdev/nvim-dap-vscode-js",
      build = "npm install && npm run build",
    },
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    vim.fn.sign_define("DapBreakpoint", { text = "🐞", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointDisabled", { text = "⚫", texthl = "DiagnosticHint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointVerified", { text = "🟢", texthl = "DiagnosticOk", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "DiagnosticHint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "💀", texthl = "DiagnosticInfo", linehl = "Visual", numhl = "" })
    vim.fn.sign_define("DapPaused", { text = "⏸️", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapRunning", { text = "🏃‍♂️", texthl = "DiagnosticOk", linehl = "", numhl = "" })
    vim.fn.sign_define("DapExited", { text = "🚪", texthl = "DiagnosticHint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapTerminated", { text = "🛑", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapRestart", { text = "🔁", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapException", { text = "🔥", texthl = "DiagnosticError", linehl = "", numhl = "" })

    local dapui_config = {
      icons = {
        expanded = "▾",
        collapsed = "▸",
        current_frame = "▶",
      },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      element_mappings = {
      },
      expand_lines = true,  -- use wrap para valores largos
      force_buffers = true, -- evita cerrar buffers del UI al cerrar ventanas

      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.6 },
            { id = "breakpoints", size = 0.4 },
          },
          size = 60,
          position = "left",
        },
      },

      controls = {
        enabled = false,
        element = "repl",
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⤵",
          step_over = "⤼",
          step_out = "⤴",
          step_back = "⤺",
          run_last = "↻",
          terminate = "■",
        },
      },

      floating = {
        max_height = nil, -- auto
        max_width  = nil, -- auto
        border     = "single",
        mappings   = { close = { "q", "<Esc>" } },
      },


      render = {
        max_type_length = nil,
        max_value_lines = 100,
      },
    }

    dapui.setup(dapui_config)


    -- Keymaps
    vim.keymap.set("n", "db", dap.toggle_breakpoint)

    vim.keymap.set("n", "dc", dap.continue)
    vim.keymap.set("n", "dr", dap.repl.open)
    vim.keymap.set("n", "ds", dap.step_over)
    vim.keymap.set("n", "di", dap.step_into)
    vim.keymap.set("n", "do", dap.step_out)

    vim.keymap.set("v", "K", function()
      require("dapui").eval(nil, {
        enter = true,
        context = "hover",
      })
    end)

    -- Abrir/cerrar UI automáticamente (protegido)
    dap.listeners.after.event_initialized["dapui_config"] = function() pcall(dapui.open) end
    dap.listeners.before.event_terminated["dapui_config"] = function() pcall(dapui.close) end
    dap.listeners.before.event_exited["dapui_config"]     = function() pcall(dapui.close) end

    require("config.plugins.dap.python")
    require("config.plugins.dap.csharp")
    require("config.plugins.dap.javascript")
  end,
}
