return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,

        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
      },
    })

    vim.keymap.set("n", "<leader>-", ":Neotree toggle<CR>", { silent = true })
  end,
}
