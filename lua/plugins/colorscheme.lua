return {
  {
    "EdenEast/nightfox.nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "bold",
          },
        },

        specs = {
          all = {
            syntax = {
              keyword = "#2ec7c4",
              --type = "#c94f6d",
              type = "#7DCFFF",
            },
          },
        },

        groups = {
          all = {
            ["@keyword"] = { fg = "syntax.keyword", style = "bold" },
            ["@keyword.modifier"] = { fg = "syntax.keyword", style = "bold" },
            ["@keyword.import"] = { fg = "syntax.keyword", style = "bold" },

            ["@type"] = { fg = "syntax.type", style = "bold" },
            ["@type.builtin"] = { fg = "syntax.type", style = "bold" },

            ["@namespace"] = { fg = "syntax.type", style = "bold" },
          },
        },
      })

      -- activar esquema Carbonfox
      vim.cmd([[colorscheme carbonfox]])

      vim.api.nvim_set_hl(0, "@decorator", { fg = "#9d00ff", italic = true })
      vim.api.nvim_set_hl(0, "@attribute", { fg = "#9d00ff", bold = true })
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#5F8FA3", bold = true })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#5c2a2a", fg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeMatching", { bg = "#7f1d1d", fg = "#ffffff", bold = true })


      -- integración con lualine
      -- require("lualine").setup({
      --   options = {
      --     theme = "carbonfox",
      --   },
      -- })
    end,
  },
}
