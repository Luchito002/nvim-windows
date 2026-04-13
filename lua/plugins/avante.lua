-- return {
--   "yetone/avante.nvim",
--   event = "VeryLazy",
--   version = false,
--   build = vim.fn.has("win32") ~= 0
--       and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
--       or "make",
--
--   opts = {
--     provider = "openai",
--     instructions_file = "avante.md",
--     providers = {
--       openai = {
--         endpoint = "https://api.openai.com/v1",
--         model = "gpt-5-mini",
--         timeout = 30000,
--         extra_request_body = {
--           temperature = 0.2,
--           max_completion_tokens = 4096,
--         },
--       },
--     },
--     behaviour = {
--       enable_fastapply = false,
--     },
--     mode = "agentic",
--   },
--
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "MunifTanjim/nui.nvim",
--     "nvim-tree/nvim-web-devicons",
--     "nvim-telescope/telescope.nvim",
--     "hrsh7th/nvim-cmp",
--     "stevearc/dressing.nvim",
--   },
--
--   keys = {
--     { "<leader>aa", "<cmd>AvanteAsk<cr>",              desc = "Avante Ask" },
--     { "<leader>at", "<cmd>AvanteToggle<cr>",           desc = "Avante Toggle" },
--     { "<leader>an", "<cmd>AvanteChatNew<cr>",          desc = "Avante New Chat" },
--     { "<leader>ac", "<cmd>AvanteAddCurrentBuffer<cr>", desc = "Add buffer" },
--     { "<leader>aB", "<cmd>AvanteAddAllBuffers<cr>",    desc = "Add all buffers" },
--     { "<leader>ae", "<cmd>AvanteEdit<cr>",             desc = "Edit selection" },
--     { "<leader>aR", "<cmd>AvanteShowRepoMap<cr>",      desc = "Repo Map" },
--     { "<leader>as", "<cmd>AvanteToggle<cr>",           desc = "Toggle Sidebar" },
--   },
-- }


return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  enabled = false,
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",

  opts = {
    provider = "ollama",
    instructions_file = "avante.md",

    providers = {
      ollama = {
        endpoint = "http://127.0.0.1:11434",
        model = "gemma3:4b",
        timeout = 30000,
        disable_tools = true,
        extra_request_body = {
          options = {
            temperature = 0.2,
            num_ctx = 8192,
            keep_alive = "5m",
          },
        },
      },
    },

    behaviour = {
      enable_fastapply = false,
    },

    mode = "agentic",
  },

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "stevearc/dressing.nvim",
  },

  keys = {
    { "<leader>aa", "<cmd>AvanteAsk<cr>",              desc = "Avante Ask" },
    { "<leader>at", "<cmd>AvanteToggle<cr>",           desc = "Avante Toggle" },
    { "<leader>an", "<cmd>AvanteChatNew<cr>",          desc = "Avante New Chat" },
    { "<leader>ac", "<cmd>AvanteAddCurrentBuffer<cr>", desc = "Add buffer" },
    { "<leader>aB", "<cmd>AvanteAddAllBuffers<cr>",    desc = "Add all buffers" },
    { "<leader>ae", "<cmd>AvanteEdit<cr>",             desc = "Edit selection" },
    { "<leader>aR", "<cmd>AvanteShowRepoMap<cr>",      desc = "Repo Map" },
    { "<leader>as", "<cmd>AvanteToggle<cr>",           desc = "Toggle Sidebar" },
  },
}
