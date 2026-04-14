return {
  "NvChad/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      names = false,
      RRGGBBAA = true,
      AARRGGBB = true,
      mode = "background",
    },
  },
}
