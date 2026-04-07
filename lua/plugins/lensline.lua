return {
  "oribarilan/lensline.nvim",
  enabled = false,
  tag = "2.0.0",
  event = "LspAttach",
  config = function()
    require("lensline").setup({
      profiles = {
        {
          name = "vs_like",
          providers = {
            {
              name = "usages",
              enabled = true,
              include = { "refs", "defs", "impls" },
              breakdown = true,
            },
            { name = "last_author", enabled = true },
            { name = "diagnostics", enabled = true },
          },
          style = {
            render = "all",
            placement = "above",
          },
        },
      },
    })
  end,
}
