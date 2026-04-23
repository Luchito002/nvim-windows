return {
  "nvimtools/hydra.nvim",
  config = function()
    local Hydra = require("hydra")

    Hydra({
      name = "Resize windows",
      mode = "n",
      body = "<leader>r",
      hint = [[
 Resize
 _h_ left   _l_ right
 _j_ down   _k_ up
 _q_ quit
      ]],
      config = {
        color = "pink",
        invoke_on_body = true,
        timeout = 4000,
        hint = {
          type = "window",
          position = "bottom",
          float_opts = {
            border = "rounded",
          },
        }
      },
      heads = {
        { "h",     "<C-w><", { desc = "shrink width" } },
        { "l",     "<C-w>>", { desc = "grow width" } },
        { "j",     "<C-w>+", { desc = "grow height" } },
        { "k",     "<C-w>-", { desc = "shrink height" } },
        { "q",     nil,      { exit = true, desc = "quit" } },
        { "<Esc>", nil,      { exit = true, desc = false } },
      },
    })
  end,
}
