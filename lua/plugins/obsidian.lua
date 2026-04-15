return {
  "epwalsh/obsidian.nvim",
  version = "*",

  cmd = {
    "ObsidianNew",
    "ObsidianOpen",
    "ObsidianQuickSwitch",
    "ObsidianSearch",
    "ObsidianToday",
    "ObsidianYesterday",
    "ObsidianTomorrow",
    "ObsidianBacklinks",
    "ObsidianTags",
    "ObsidianLink",
    "ObsidianLinkNew",
    "ObsidianTemplate",
    "ObsidianWorkspace",
    "ObsidianPasteImg",
    "ObsidianRename",
    "ObsidianTOC",
  },

  ft = "markdown",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },

  keys = {
    -- Notas
    { "<leader>zn", "<cmd>ObsidianNew<CR>", desc = "New note" },
    { "<leader>zo", "<cmd>ObsidianOpen<CR>", desc = "Open in Obsidian app" },

    -- Búsqueda
    { "<leader>zs", "<cmd>ObsidianSearch<CR>", desc = "Search notes" },
    { "<leader>zf", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find note" },

    -- Links (visual)
    { "<leader>zl", "<cmd>ObsidianLink<CR>", mode = "v", desc = "Link selection" },
    { "<leader>zL", "<cmd>ObsidianLinkNew<CR>", mode = "v", desc = "Create + link note" },

    -- Navegación
    { "<leader>zb", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
    { "<leader>zt", "<cmd>ObsidianTags<CR>", desc = "Tags" },

    -- Diario
    { "<leader>zd", "<cmd>ObsidianToday<CR>", desc = "Today note" },
    { "<leader>zy", "<cmd>ObsidianYesterday<CR>", desc = "Yesterday note" },
    { "<leader>zm", "<cmd>ObsidianTomorrow<CR>", desc = "Tomorrow note" },

    -- Extras
    { "<leader>zr", "<cmd>ObsidianRename<CR>", desc = "Rename note" },
    { "<leader>zT", "<cmd>ObsidianTemplate<CR>", desc = "Template" },
    { "<leader>zc", "<cmd>ObsidianTOC<CR>", desc = "TOC" },
    { "<leader>zp", "<cmd>ObsidianPasteImg<CR>", desc = "Paste image" },
  },

  opts = {
    workspaces = {
      {
        name = "vault",
        path = "D:/Obsidian",
      },
    },

    notes_subdir = "notes",
    new_notes_location = "notes_subdir",

    completion = {
      nvim_cmp = false,
      min_chars = 2,
    },
  },
}
