return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<A-f>]], -- Alt + f
      direction = "float",
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      --  Cambiar shell a PowerShell
      shell = "pwsh.exe",

      float_opts = {
        border = "rounded"
      },
      highlights = {
        FloatBorder = {
          guifg = "#5F8FA3"
        },
      },
    })
  end,
}
