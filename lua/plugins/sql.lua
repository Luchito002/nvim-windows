return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true,
      },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.g.db_ui_tmp_query_location = vim.fn.stdpath("data") .. "/db_ui/tmp"
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
    end,
    config = function()
      vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Dadbod UI" })
      vim.keymap.set("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", { desc = "Dadbod find buffer" })
      vim.keymap.set("n", "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", { desc = "Dadbod rename buffer" })
    end,
  },
}
