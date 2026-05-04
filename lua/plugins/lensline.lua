return {
  "oribarilan/lensline.nvim",
  branch = "release/2.x",
  event = "LspAttach",
  enabled = false,
  config = function()
    require("lensline").setup({
      profiles = {
        {
          name = "default",
          providers = {
            {
              name = "usages",
              enabled = true,
              highlight = "LensLineRefs",
            },
            {
              name = "last_author",
              enabled = true,
              highlight = "LensLineAuthor",
            },
          },
          style = {
            highlight = "LensLine",
            placement = "above",
          },
        },
      },
    })
  end,
}
