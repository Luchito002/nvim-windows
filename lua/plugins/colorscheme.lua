return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      on_highlights = function(hl, c)
        -- Texto de ventanas inactivas, incluida la lista del picker al escribir en el input.
        hl.NormalNC = { fg = "#B2BCDF", bg = "NONE" }
        hl.WinSeparator = { fg = c.blue0, bold = true }
        hl.VertSplit = { fg = c.blue0, bold = true }
        hl.LineNr = { fg = "#A9B1D6", bg = "NONE" }
        hl.CursorLineNr = { fg = "#C0CAF5", bg = "NONE", bold = true }
      end,
    },
    config = function(_, opts)
      local inactive_namespace = vim.api.nvim_create_namespace("TokyoNightInactive")

      local function dim_color(color, background)
        local red = math.floor(color / 0x10000) % 0x100
        local green = math.floor(color / 0x100) % 0x100
        local blue = color % 0x100
        local background_red = tonumber(background:sub(2, 3), 16)
        local background_green = tonumber(background:sub(4, 5), 16)
        local background_blue = tonumber(background:sub(6, 7), 16)
        -- El input de Snacks toma el foco y deja la lista en este namespace.
        -- 90% conserva la distinción de ventana inactiva sin apagar su texto.
        local intensity = 0.90

        return string.format(
          "#%02x%02x%02x",
          red * intensity + background_red * (1 - intensity),
          green * intensity + background_green * (1 - intensity),
          blue * intensity + background_blue * (1 - intensity)
        )
      end

      local function refresh_inactive_windows()
        local palette = require("tokyonight.colors").setup(opts)
        local highlights = vim.api.nvim_get_hl(0, {})

        for name, highlight in pairs(highlights) do
          if highlight.fg then
            highlight.fg = dim_color(highlight.fg, palette.bg)
            highlight.bg = nil
            vim.api.nvim_set_hl(inactive_namespace, name, highlight)
          end
        end

        local current_window = vim.api.nvim_get_current_win()

        for _, window in ipairs(vim.api.nvim_list_wins()) do
          vim.api.nvim_win_set_hl_ns(window, window == current_window and 0 or inactive_namespace)
        end
      end

      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")

      local group = vim.api.nvim_create_augroup("TokyoNightInactiveWindows", { clear = true })

      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "WinEnter", "WinLeave", "WinNew" }, {
        group = group,
        callback = function()
          vim.schedule(refresh_inactive_windows)
        end,
      })

      refresh_inactive_windows()
    end,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
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

        -- Un poco más de contraste para los mensajes inline del LSP, sin cambiar
        -- los colores de severidad que se usan en signos, floats y la statusline.
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#F07178", bg = "NONE" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#EBCB8B", bg = "NONE" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#5EBAE7", bg = "NONE" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#78C6A3", bg = "NONE" })

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
