return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",

  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    {
      "microsoft/vscode-js-debug",
      build = table.concat({
        "npm install --legacy-peer-deps --ignore-scripts --no-package-lock",
        "npx gulp vsDebugServerBundle",
        "if not exist out mkdir out",
        "xcopy /E /I /Y dist out",
      }, " && "),
    },
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
    local dapui_resizing = false

    local function set_dap_colors()
      local colors = {
        Red = "#ab031f", Yellow = "#b58900", Green = "#859900", Blue = "#268bd2",
        Cyan = "#2aa198", Purple = "#6c71c4", Gray = "#586e75", Orange = "#cb4b16",
      }

      for name, color in pairs(colors) do
        vim.api.nvim_set_hl(0, "Dap" .. name, { fg = color })
      end
    end

    set_dap_colors()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("DapThemeColors", { clear = true }),
      callback = set_dap_colors,
    })

    -- DAP signs
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapRed", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapYellow", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapRed", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointDisabled", { text = "", texthl = "DapGray", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointVerified", { text = "", texthl = "DapGreen", linehl = "", numhl = "" })

    vim.fn.sign_define("DapLogPoint", { text = "󰌕", texthl = "DapCyan", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "💀", texthl = "DapBlue", linehl = "Visual", numhl = "" })
    vim.fn.sign_define("DapPaused", { text = "", texthl = "DapYellow", linehl = "", numhl = "" })
    vim.fn.sign_define("DapRunning", { text = "", texthl = "DapGreen", linehl = "", numhl = "" })
    vim.fn.sign_define("DapExited", { text = "", texthl = "DapGray", linehl = "", numhl = "" })
    vim.fn.sign_define("DapTerminated", { text = "", texthl = "DapRed", linehl = "", numhl = "" })
    vim.fn.sign_define("DapRestart", { text = "", texthl = "DapPurple", linehl = "", numhl = "" })
    vim.fn.sign_define("DapException", { text = "", texthl = "DapOrange", linehl = "", numhl = "" })

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
            { id = "breakpoints", size = 0.33 },
            { id = "scopes",      size = 0.33 },
            { id = "repl",        size = 0.34 },
          },
          size = 0.3,
          position = "bottom",
        },
      },

      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "󰏤",
          play = "󰐊",
          step_into = "󰆹",
          step_over = "󰆷",
          step_out = "󰆸",
          step_back = "󰁍",
          run_last = "󰑓",
          terminate = "󰅖",
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

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
    vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
    vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step over" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })
    vim.keymap.set("n", "<leader>dj", function() require("dap").run_to_cursor() end, { desc = "Run to cursor" })

    vim.keymap.set("v", "K", function()
      dapui.eval(nil, {
        enter = true,
        context = "hover",
      })
    end, { desc = "DAP eval selection" })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({ reset = true })
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
      group = vim.api.nvim_create_augroup("DapUiResponsiveLayout", { clear = true }),
      callback = function()
        if dapui_resizing or not dap.session() then
          return
        end

        dapui_resizing = true

        vim.schedule(function()
          pcall(dapui.open, { reset = true })
          dapui_resizing = false
        end)
      end,
    })

    local csharp = require("config.plugins.dap.csharp")
    require("config.plugins.dap.javascript").setup()

    vim.keymap.set("n", "<leader>dp", function()
      csharp.pick_entry()
    end, { desc = "Pick .NET project" })
  end,
}
