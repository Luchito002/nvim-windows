return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        comments = { italic = true },
        keywords = { bold = true },
      },

      on_highlights = function(hl, c)
        -- UI base
        hl.WinSeparator = { fg = "#5F8FA3", bold = true }
        hl.Visual = { bg = "#5c2a2a", fg = "NONE" }

        -- LENSLINE
        hl.LensLine = { fg = "#5F8FA3", italic = true }
        hl.LensLineRefs = { link = "LensLine" }
        hl.LensLineAuthor = { link = "LensLine" }

        -- fallback por si usa codelens nativo
        hl.LspCodeLens = { link = "LensLine" }
        hl.LspCodeLensSeparator = { fg = "#5F8FA3" }

        -- syntax
        hl["@keyword"] = { fg = c.cyan, bold = true }

        hl["@keyword.import"] = { fg = "#ab031f", bold = true }
        hl["@keyword.export"] = { fg = "#ab031f", bold = true }
        hl["@keyword.directive"] = { fg = "#ab031f", bold = true }
        hl["@keyword.directive.cs"] = { fg = "#ab031f", bold = true }

        hl["@type"] = { fg = c.blue, bold = true }
        hl["@type.builtin"] = { fg = c.blue, bold = true }
        hl["@namespace"] = { fg = c.blue, bold = true }
      end,
    },

    config = function(_, opts)
      require("solarized-osaka").setup(opts)
      vim.cmd("colorscheme solarized-osaka")

      -- extras UI
      vim.api.nvim_set_hl(0, "Visual", { bg = "#5c2a2a", fg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#5c2a2a" })
      vim.api.nvim_set_hl(0, "MatchParen", { bg = "NONE", fg = "NONE" })
    end,
  },
}
