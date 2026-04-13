return {
  "sudo-tee/opencode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { "markdown", "opencode_output" },
      },
      ft = { "markdown", "opencode_output" },
    },
    "folke/snacks.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    require("opencode").setup({
      opencode_executable = [[C:\ProgramData\chocolatey\bin\opencode.exe]],
      keymap_prefix = "<leader>o",
      default_global_keymaps = false, -- desactiva los defaults para controlar todo
      default_system_prompt = [[
        Responde en español.
        Utiliza jergas bolivianas como: "Quiere que haga esto, nove?", "Y asi quedaria de puta madre", "Asi nomas ps oe", "Deja de preguntar eso gran puta"
        No seas serio a la hora de responder.
      ]],

      keymap = {
        editor = {
          ["<leader>ot"] = { "toggle" },         -- abrir/cerrar opencode
          ["<leader>oi"] = { "open_input" },     -- abrir input sesión actual
          ["<leader>oI"] = { "open_input_new_session" },
          ["<leader>oo"] = { "open_output" },    -- abrir output
          ["<leader>of"] = { "toggle_focus" },   -- alternar foco
          ["<leader>os"] = { "select_session" }, -- seleccionar sesión
          ["<leader>oR"] = { "rename_session" },
          ["<leader>op"] = { "configure_provider" },
          ["<leader>oV"] = { "configure_variant" },

          ["<leader>oy"] = { "add_visual_selection", mode = { "v" } },
          ["<leader>oY"] = { "add_visual_selection_inline", mode = { "v" } },

          ["<leader>o/"] = { "quick_chat", mode = { "n", "x" } },

          ["<leader>od"] = { "diff_open" },
          ["<leader>o]"] = { "diff_next" },
          ["<leader>o["] = { "diff_prev" },
          ["<leader>oc"] = { "diff_close" },

          ["<leader>ora"] = { "diff_revert_all_last_prompt" },
          ["<leader>ort"] = { "diff_revert_this_last_prompt" },
          ["<leader>orA"] = { "diff_revert_all" },
          ["<leader>orT"] = { "diff_revert_this" },

          ["<leader>oz"] = { "toggle_zoom" },
          ["<leader>ox"] = { "swap_position" },
          ["<leader>ott"] = { "toggle_tool_output" },
          ["<leader>otr"] = { "toggle_reasoning_output" },
        },

        input_window = {
          ["<S-cr>"] = { "submit_input_prompt", mode = { "n", "i" } },
          ["<esc>"] = false,
          ["<C-c>"] = { "cancel", defer_to_completion = true },
          ["~"] = { "mention_file", mode = "i" },
          ["@"] = { "mention", mode = "i" },
          ["/"] = { "slash_commands", mode = "i" },
          ["#"] = { "context_items", mode = "i" },
          ["<tab>"] = { "toggle_pane", mode = { "n", "i" }, defer_to_completion = true },
          ["<up>"] = { "prev_prompt_history", mode = { "n", "i" }, defer_to_completion = true },
          ["<down>"] = { "next_prompt_history", mode = { "n", "i" }, defer_to_completion = true },
          ["<M-m>"] = { "switch_mode" },
          ["<M-r>"] = { "cycle_variant", mode = { "n", "i" } },
        },

        output_window = {
          ["<esc>"] = { "close" },
          ["<C-c>"] = { "cancel" },
          ["]]"] = { "next_message" },
          ["[["] = { "prev_message" },
          ["<tab>"] = { "toggle_pane", mode = { "n", "i" } },
          ["i"] = { "focus_input", mode = { "n" } },
          ["<M-r>"] = { "cycle_variant", mode = { "n" } },
          ["<leader>oS"] = { "select_child_session" },
          ["<leader>oD"] = { "debug_message" },
          ["<leader>oO"] = { "debug_output" },
        },
      },

      ui = {
        position = "right",
      },

      context = {
        enabled = true,
        current_file = { enabled = true, show_full_path = true },
        selection = { enabled = true },
        diagnostics = {
          warning = true,
          error = true,
        },
      },
    })
  end,
}
