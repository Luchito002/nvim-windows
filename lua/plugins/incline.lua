return {
  "b0o/incline.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  config = function()
    local devicons = require("nvim-web-devicons")
    local helpers = require("incline.helpers")

    require("incline").setup({
      hide = {
        cursorline = false,
        focused_win = false,
        only_win = false,
      },
      window = {
        margin = {
          horizontal = 1,
          vertical = 1,
        },
        padding = 0,
        padding_char = " ",
        placement = {
          horizontal = "right",
          vertical = "top",
        },
        winhighlight = {
          active = {
            EndOfBuffer = "None",
            Normal = "NormalFloat",
            Search = "None",
          },
          inactive = {
            EndOfBuffer = "None",
            Normal = "NormalFloat",
            Search = "None",
          },
        },
        zindex = 40,
      },
      render = function(props)
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = vim.fn.fnamemodify(bufname, ":t")

        if filename == "" then
          filename = "[No Name]"
        end

        local ft_icon, ft_color = devicons.get_icon_color(filename)
        local modified = vim.bo[props.buf].modified
        local focused = props.focused
        local bg = focused and "#073642" or "#002b36"
        local fg = focused and "#93a1a1" or "#657b83"
        local accent = focused and "#2aa198" or "#5F8FA3"
        local git_bg = focused and "#3b0d14" or "#2a1518"
        local git_fg = focused and "#93a1a1" or "#839496"

        local result = {
          { "", guifg = bg },
          {
            ft_icon and { " ", ft_icon, " ", guifg = helpers.contrast_color(ft_color), guibg = ft_color } or "",
            {
              " " .. filename .. " ",
              gui = modified and "bold,italic" or "bold",
              guifg = fg,
            },
            modified and { "● ", guifg = accent, gui = "bold" } or "",
            guibg = bg,
          },
        }

        local git = vim.b[props.buf].gitsigns_status_dict
        if git and git.head and git.head ~= "" then
          result[#result + 1] = {
            "",
            guifg = git_bg,
            guibg = bg,
          }
          result[#result + 1] = {
            "  " .. git.head .. " ",
            guifg = git_fg,
            guibg = git_bg,
            gui = focused and "bold" or "none",
          }
        end

        result[#result + 1] = { "", guifg = git and git.head and git.head ~= "" and git_bg or bg }

        return result
      end,
    })

    vim.api.nvim_set_hl(0, "InclineNormal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "InclineNormalNC", { bg = "NONE" })
  end,
}
