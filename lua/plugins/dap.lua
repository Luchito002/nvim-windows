return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",

  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
  },

  config = function()
    local function patch_nvim_dap_windows_breakpoints()
      if vim.fn.has("win32") == 0 then
        return false
      end

      local session_file = vim.fn.stdpath("data") .. "/lazy/nvim-dap/lua/dap/session.lua"

      if vim.fn.filereadable(session_file) == 0 then
        vim.notify("nvim-dap session.lua no encontrado", vim.log.levels.WARN)
        return false
      end

      local ok, lines = pcall(vim.fn.readfile, session_file)
      if not ok or not lines then
        vim.notify("No se pudo leer session.lua de nvim-dap", vim.log.levels.ERROR)
        return false
      end

      local content = table.concat(lines, "\n")

      if content:find('path = path:gsub("/", "\\\\");', 1, true) then
        return false
      end

      local new_content, count = content:gsub(
        "path%s*=%s*path%s*;",
        'path = path:gsub("/", "\\\\");',
        1
      )

      if count == 0 then
        vim.notify("No se encontró el path correcto en session.lua", vim.log.levels.WARN)
        return false
      end

      local write_ok = pcall(vim.fn.writefile, vim.split(new_content, "\n", { plain = true }), session_file)
      if not write_ok then
        vim.notify("No se pudo escribir el parche en session.lua", vim.log.levels.ERROR)
        return false
      end

      vim.notify("Parche aplicado correctamente a nvim-dap", vim.log.levels.INFO)
      return true
    end

    local patched_now = patch_nvim_dap_windows_breakpoints()

    if patched_now then
      package.loaded["dap"] = nil
      package.loaded["dap.session"] = nil
    end

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

    dapui.setup({
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
      element_mappings = {},
      expand_lines = true,
      force_buffers = true,

      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.6 },
            { id = "breakpoints", size = 0.4 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 1.0 },
          },
          size = 12,
          position = "bottom",
        },
      },

      controls = {
        enabled = true,
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
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },

      render = {
        max_type_length = nil,
        max_value_lines = 100,
      },
    })

    vim.keymap.set("n", "db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "dc", dap.continue, { desc = "Continue" })
    vim.keymap.set("n", "dr", dap.repl.open, { desc = "Open REPL" })
    vim.keymap.set("n", "ds", dap.step_over, { desc = "Step over" })
    vim.keymap.set("n", "di", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "do", dap.step_out, { desc = "Step out" })
    vim.keymap.set("n", "dj", function() require("dap").run_to_cursor()end, { desc = "Run to cursor" })

    vim.keymap.set("v", "K", function()
      dapui.eval(nil, {
        enter = true,
        context = "hover",
      })
    end, { desc = "DAP eval selection" })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    require("config.plugins.dap.python")

    local csharp = require("config.plugins.dap.csharp")
    vim.keymap.set("n", "dp", function()
      csharp.pick_entry()
    end, { desc = "Pick .NET project" })
  end,
}
