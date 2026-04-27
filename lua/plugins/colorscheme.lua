-- return {
--   {
--     "EdenEast/nightfox.nvim",
--     version = false,
--     lazy = false,
--     priority = 1000,
--     config = function()
--       require("nightfox").setup({
--         options = {
--           transparent = true,
--           styles = {
--             comments = "bold",
--             keywords = "bold",
--             types = "bold",
--           },
--         },
--
--         specs = {
--           all = {
--             syntax = {
--               keyword = "#2ec7c4",
--               --type = "#c94f6d",
--               type = "#7DCFFF",
--             },
--           },
--         },
--
--         groups = {
--           all = {
--             ["@keyword"] = { fg = "syntax.keyword", style = "bold" },
--             ["@keyword.modifier"] = { fg = "syntax.keyword", style = "bold" },
--             ["@keyword.import"] = { fg = "syntax.keyword", style = "bold" },
--
--             ["@type"] = { fg = "syntax.type", style = "bold" },
--             ["@type.builtin"] = { fg = "syntax.type", style = "bold" },
--
--             ["@namespace"] = { fg = "syntax.type", style = "bold" },
--           },
--         },
--       })
--
--       -- activar esquema Carbonfox
--       vim.cmd([[colorscheme carbonfox]])
--
--       vim.api.nvim_set_hl(0, "@decorator", { fg = "#7A5FFF", italic = true })
--       vim.api.nvim_set_hl(0, "@attribute", { fg = "#7A5FFF", bold = true })
--       vim.api.nvim_set_hl(0, "@lsp.type.decorator", { fg = "#7A5FFF", italic = true })
--       vim.api.nvim_set_hl(0, "@lsp.type.attribute", { fg = "#7A5FFF", bold = true })
--
--       vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#5F8FA3", bold = true })
--       vim.api.nvim_set_hl(0, "Visual", { bg = "#5c2a2a", fg = "NONE" })
--       vim.api.nvim_set_hl(0, "TelescopeMatching", { bg = "#7f1d1d", fg = "#ffffff", bold = true })
--       vim.api.nvim_set_hl(0, "CursorLine", { bg = "#5c2a2a" })
--     end,
--   },
-- }

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
        hl.WinSeparator = { fg = "#5F8FA3", bold = true }
        hl.Visual = { bg = "#5c2a2a", fg = "NONE" }

        hl["@keyword"] = { fg = c.cyan, bold = true }

        -- imports / exports / using
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
      vim.api.nvim_set_hl(0, "Visual", { bg = "#5c2a2a", fg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#5c2a2a" })
    end,
  },
}

