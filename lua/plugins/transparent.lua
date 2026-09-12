return {
  "tribela/transparent.nvim",
  event = "VimEnter",
  enable = true,
  config = function()
    require("transparent").setup({
      auto = true,
      extra_groups = {
        "EndOfBuffer",
        "StatusLine",
        "StatusLineNC",
        "WinBar",
        "WinBarNC",
        "Pmenu",
        "PmenuSbar",
        "PmenuThumb",
        "NormalFloat",
        "FloatBorder",
        "FloatTitle",
        "MsgArea",
        "MsgSeparator",
        "TelescopeNormal",
        "TelescopeBorder",
        "SnacksPicker",
        "SnacksPickerInput",
        "SnacksPickerList",
        "SnacksPickerPreview",
        "LazyNormal",
        "LazyBorder",
        "MasonNormal",
        "MasonBorder",
      },
      excludes = {},
    })
    vim.cmd("TransparentEnable")
  end,
}
