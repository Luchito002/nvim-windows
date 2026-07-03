return {
  "nvim-tree/nvim-web-devicons",
  config = function()
    local devicons = require("nvim-web-devicons")

    devicons.setup({
      default = true,

      override_by_extension = {
        ["cshtml"] = {
          icon = "󰪮",
          color = "#512BD4",
          name = "Cshtml",
        },
      },
    })
  end,
}
