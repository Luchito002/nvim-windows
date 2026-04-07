return {
  "tribela/transparent.nvim",
  event = "VimEnter",
  enable = false,
  config = function()
    require("transparent").setup({

      auto = true,
      extra_groups = {
        "StatusLine",
        "StatusLineNC",
        "Pmenu",
        "NormalFloat",
        "FloatBorder",
        "TelescopeNormal",
        "TelescopeBorder",
        "LazyNormal",
        "LazyBorder",
        "MasonNormal",
        "MasonBorder",
      },
      excludes = {},
    })
  end,
}
