return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  opts = {
    animate = { enabled = false, duration = 50, easing = "outQuad" },
    bigfile = { enabled = false },
    dashboard = require("config.plugins.snacks.dashboard"),
    explorer = { enabled = true },
    indent = require("config.plugins.snacks.indent"),
    input = { enabled = true },
    picker = require("config.plugins.snacks.picker"),
    notifier = { enabled = true },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    rename = { enabled = true },
    words = { enabled = false },
    zen = { enabled = true },
  },

  keys = {
    { "<leader><leader>", function() Snacks.picker.files() end,        desc = "Find Files" },
    { "<leader>w",        function() Snacks.picker.grep() end,         desc = "Find Word" },
    { "<leader>r",        function() Snacks.picker.recent() end,       desc = "Recent files" },
    { "<leader>b",        function() Snacks.picker.buffers() end,      desc = "Open Buffers" },
    { "<leader>th",       function() Snacks.picker.help() end,         desc = "Open Help tags" },
    { "<leader>c",        function() Snacks.picker.colorschemes() end, desc = "Select colorscheme" },

    { "<leader>-",        function() Snacks.explorer() end,            desc = "Explorer" },
  },
}
