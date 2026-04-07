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
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          styles = {
            comments = "NONE", -- sin italic

            keywords = "NONE", -- sin bold/italic
            types = "NONE",    -- sin bold/italic
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
        },
        palettes = {}, -- override de colores base si quieres
        groups = {},   -- grupos globales
        on_highlights = function(hl, c)
          -- Ventanas normales y no activas
          hl.Normal       = { fg = c.fg1, bg = "NONE" }
          hl.NormalNC     = { fg = c.fg1, bg = "NONE" }
          hl.SignColumn   = { bg = "NONE" }

          hl.LineNr       = { fg = c.comment, bg = "NONE" }
          hl.CursorLineNr = { fg = c.cyan, bg = "NONE", bold = true }
          hl.EndOfBuffer  = { fg = c.bg0, bg = "NONE" }
          hl.StatusLine   = { fg = c.fg1, bg = "NONE" }

          hl.StatusLineNC = { fg = c.comment, bg = "NONE" }
          hl.TabLine      = { fg = c.comment, bg = "NONE" }

          hl.TabLineFill  = { bg = "NONE" }
          hl.TabLineSel   = { fg = c.cyan, bg = "NONE", bold = true }
          hl.VertSplit    = { fg = c.comment, bg = "NONE" }
          hl.WinSeparator = { fg = c.comment, bg = "NONE" }

          hl.FloatBorder  = { fg = c.comment, bg = "NONE" }
          hl.Pmenu        = { fg = c.fg1, bg = "NONE" }
          hl.PmenuSel     = { fg = c.bg0, bg = "NONE", bold = true }


          -- Ventanas flotantes como Lazy, Mason, etc
          hl.TelescopeNormal = { fg = c.fg1, bg = "NONE" }
          hl.TelescopeBorder = { fg = c.comment, bg = "NONE" }
          hl.MasonNormal     = { fg = c.fg1, bg = "NONE" }
          hl.MasonBorder     = { fg = c.comment, bg = "NONE" }
          hl.LazyNormal      = { fg = c.fg1, bg = "NONE" }
          hl.LazyBorder      = { fg = c.comment, bg = "NONE" }
        end,

      })

      -- activar esquema Carbonfox
      vim.cmd([[colorscheme carbonfox]])

      vim.api.nvim_set_hl(0, "@decorator", { fg = "#9d00ff", italic = true })
      vim.api.nvim_set_hl(0, "@attribute", { fg = "#9d00ff", bold = true })
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#00ab64", bold = true })


      -- integración con lualine
      require("lualine").setup({
        options = {
          theme = "carbonfox",
        },
      })
    end,
  },
}
