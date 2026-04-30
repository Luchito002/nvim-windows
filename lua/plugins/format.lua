return {
  "stevearc/conform.nvim",
  enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },

        python = { "ruff_format", "black" },

        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },

        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },

        cs = { "csharpier" },
        razor = { "csharpier" },

        java = { "google-java-format" },
      },

      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
      },
    })

    -- keymap opcional (mejor que usar el del LSP)
    vim.keymap.set("n", "<leader>f", function()
      require("conform").format({ async = true })
    end, { desc = "Format file" })
  end,
}
