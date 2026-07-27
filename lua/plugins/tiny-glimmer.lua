return {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
  priority = 10,
  opts = {
    enabled = true,
    disable_warnings = true,
    refresh_interval_ms = 8,
    overwrite = {
      auto_map = true,
      yank = {
        enabled = true,
        default_animation = "fade",
      },
      paste = {
        enabled = true,
        default_animation = "reverse_fade",
      },
      search = {
        enabled = false,
      },
      undo = {
        enabled = false,
      },
      redo = {
        enabled = false,
      },
    },
    animations = {
      fade = {
        from_color = "#ab031f",
        to_color = "#5c2a2a",
        min_duration = 180,
        max_duration = 280,
      },
      reverse_fade = {
        from_color = "#5c2a2a",
        to_color = "#073642",
        min_duration = 220,
        max_duration = 320,
      },
    },
  },
  config = function(_, opts)
    require("tiny-glimmer").setup(opts)

    vim.api.nvim_set_hl(0, "TinyGlimmerPaste", { fg = "#5c2a2a", bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "TinyGlimmerYank", { fg = "#ab031f", bg = "NONE", bold = true })
  end,
}
