return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  ft = {
    "markdown",
    "opencode_output",
  },
  opts = {
    enabled = true,

    file_types = {
      "markdown",
      "opencode_output",
    },

    anti_conceal = {
      enabled = false,
    },
  },
}
