return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>ss", "<cmd>AutoSession search<CR>", desc = "Search sessions" },
    { "<leader>sw", "<cmd>AutoSession save<CR>", desc = "Save session" },
    { "<leader>st", "<cmd>AutoSession toggle<CR>", desc = "Toggle session autosave" },
  },
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = {
      "~/",
      "~/Downloads",
      "/",
    },
    bypass_save_filetypes = {
      "snacks_dashboard",
    },
    close_filetypes_on_save = {
      "checkhealth",
      "codex",
    },
    pre_save_cmds = {
      function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(bufnr)
            and vim.api.nvim_buf_get_name(bufnr):match("^jdt://")
          then
            pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
          end
        end
      end,
    },
    close_unsupported_windows = true,
    lazy_support = true,
    session_lens = {
      picker = "snacks",
      previewer = "summary",
    },
  },
}
