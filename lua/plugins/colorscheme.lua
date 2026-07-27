return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        comments = { italic = false },
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
      local function apply_overrides()
        local is_light = vim.o.background == "light"
        local lens = is_light and "#5F8FA3" or "#5F8FA3"
        local visual_bg = is_light and "#ead7d7" or "#5c2a2a"

        vim.api.nvim_set_hl(0, "Visual", { bg = visual_bg, fg = "NONE" })
        vim.api.nvim_set_hl(0, "MatchParen", { bg = "NONE", fg = "NONE" })

        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#27a1b9", bg = "NONE" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

        vim.api.nvim_set_hl(0, "Directory", { fg = "#6C71C4" })
        vim.api.nvim_set_hl(0, "SnacksExplorerDir", { fg = "#6C71C4" })
        vim.api.nvim_set_hl(0, "SnacksExplorerIconDirectory", { fg = "#6C71C4" })

        vim.api.nvim_set_hl(0, "LensLine", { fg = lens, italic = true })
        vim.api.nvim_set_hl(0, "LensLineRefs", { link = "LensLine" })
        vim.api.nvim_set_hl(0, "LensLineAuthor", { link = "LensLine" })
        vim.api.nvim_set_hl(0, "LspCodeLens", { link = "LensLine" })
        vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { fg = lens })
      end

      require("solarized-osaka").setup(opts)
      vim.cmd("colorscheme solarized-osaka")
      apply_overrides()

      local group = vim.api.nvim_create_augroup("SolarizedOsakaBackground", { clear = true })

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        pattern = "solarized-osaka",
        callback = apply_overrides,
      })

      vim.api.nvim_create_autocmd("OptionSet", {
        group = group,
        pattern = "background",
        callback = function()
          vim.schedule(function()
            vim.cmd("colorscheme solarized-osaka")
          end)
        end,
      })
    end,
  },
}
