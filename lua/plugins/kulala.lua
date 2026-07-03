return {
  "mistweaverco/kulala.nvim",
  enabled = true,
  ft = { "http", "rest" },
  keys = {
    { "<leader>es", function() require("kulala").run() end,        desc = "Send request" },
    { "<leader>ea", function() require("kulala").run_all() end,    desc = "Send all requests" },
    { "<leader>eb", function() require("kulala").scratchpad() end, desc = "Open scratchpad" },
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
