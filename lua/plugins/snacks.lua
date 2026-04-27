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
    terminal = require("config.plugins.snacks.terminal"),
    lazygit = require("config.plugins.snacks.lazygit")
  },

  keys = {
    { "<leader><leader>", function() Snacks.picker.files() end,        desc = "Find Files" },
    { "<leader>w",        function() Snacks.picker.grep() end,         desc = "Find Word" },
    { "<leader>r",        function() Snacks.picker.recent() end,       desc = "Recent files" },
    { "<leader>b",        function() Snacks.picker.buffers() end,      desc = "Open Buffers" },
    { "<leader>th",       function() Snacks.picker.help() end,         desc = "Open Help tags" },
    { "<leader>c",        function() Snacks.picker.colorschemes() end, desc = "Select colorscheme" },

    { "<leader>-",        function() Snacks.explorer() end,            desc = "Explorer" },

    { "<A-f>",            function() Snacks.terminal.toggle() end,     mode = { "n", "t" },              desc = "Terminal flotante" },

    { "<leader>gg",       function() Snacks.lazygit.open() end,        desc = "Lazygit" },
    { "<leader>gl",       function() Snacks.lazygit.log() end,         desc = "Lazygit Log" },
    { "<leader>gf",       function() Snacks.lazygit.log_file() end,    desc = "Lazygit Current File Log" },
  },
}
