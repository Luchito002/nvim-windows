return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nsidorenco/neotest-vstest",
  },
  config = function()
    vim.g.neotest_vstest = {
      -- opcional
      timeout_ms = 30 * 5 * 1000,
      broad_recursive_discovery = false,
    }
    require("neotest").setup({
      summary = {
        open = "topleft vsplit | vertical resize 60",
      },
      adapters = {
        require("neotest-vstest"),
      },
    })

    vim.keymap.set("n", "<leader>tt", function()
      require("neotest").run.run()
    end, { desc = "Test nearest" })

    vim.keymap.set("n", "<leader>tf", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "Test file" })

    vim.keymap.set("n", "<leader>ts", function()
      require("neotest").summary.toggle()
    end, { desc = "Test summary" })

    vim.keymap.set("n", "<leader>to", function()
      require("neotest").output.open({ enter = true })
    end, { desc = "Test output" })
  end,
}
