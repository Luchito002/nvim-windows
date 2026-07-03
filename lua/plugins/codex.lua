return {
  "kkrampis/codex.nvim",
  lazy = true,
  cmd = { "Codex", "CodexToggle" },

  keys = {
    {
      "<leader>cc",
      function()
        require("codex").toggle()
      end,
      desc = "Toggle Codex side-panel",
      mode = { "n", "t" },
    },
  },

  opts = {
    keymaps = {
      toggle = nil,
      quit = "<C-q>",
    },

    border = "rounded",

    -- IMPORTANTE:
    -- true = panel lateral
    -- false = ventana flotante
    panel = true,

    -- Tamaño del panel lateral.
    -- Si el plugin lo respeta como proporción, 0.35 queda cómodo.
    width = 0.45,
    height = 0.8,

    model = nil,
    autoinstall = true,
    use_buffer = false,
  },
}
