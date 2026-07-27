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
    close_unsupported_windows = true,
    lazy_support = true,
    session_lens = {
      picker = "snacks",
      previewer = "summary",
    },
  },
}
