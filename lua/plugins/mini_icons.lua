return {
  "nvim-tree/nvim-web-devicons",
  config = function()
    require("nvim-web-devicons").setup({
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
