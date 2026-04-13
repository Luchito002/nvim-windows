return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  keys = {
    -- Diagnósticos de TODO el proyecto
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (workspace)",
    },

    -- Diagnósticos SOLO del archivo actual
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Diagnostics (buffer)",
    },

    -- Referencias / definiciones / implementaciones del proyecto
    {
      "<leader>xr",
      "<cmd>Trouble lsp_references toggle focus=true<cr>",
      desc = "LSP References",
    },
    {
      "<leader>xd",
      "<cmd>Trouble lsp_definitions toggle focus=true<cr>",
      desc = "LSP Definitions",
    },
    {
      "<leader>xi",
      "<cmd>Trouble lsp_implementations toggle focus=true<cr>",
      desc = "LSP Implementations",
    },

    -- Símbolos SOLO del archivo actual
    {
      "<leader>xs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Document Symbols",
    },

    -- Quickfix global
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List",
    },
  },
  opts = {},
}
