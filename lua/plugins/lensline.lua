return {
  "oribarilan/lensline.nvim",
  tag = "2.1.0",
  event = "LspAttach",
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
