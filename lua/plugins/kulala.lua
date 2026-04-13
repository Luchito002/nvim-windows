return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  keys = {
    { "<leader>rs", function() require("kulala").run() end,        desc = "Send request" },
    { "<leader>ra", function() require("kulala").run_all() end,    desc = "Send all requests" },
    { "<leader>rb", function() require("kulala").scratchpad() end, desc = "Open scratchpad" },
    {
      "<leader>rf",
      function()
        vim.cmd("%!jq")
      end,
      desc = "Format JSON with jq"
    }
  },
  opts = {
    scripts = {
      default = "lua"
    },
    formatters = {
      json = {
        enabled = true,
      }
    },
    global_keymaps = false,
  },
}
