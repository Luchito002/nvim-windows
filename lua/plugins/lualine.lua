return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    local mode_map = {
      ["n"] = "通常",
      ["no"] = "演算子保留",
      ["nov"] = "演算子保留",
      ["noV"] = "演算子保留",
      ["no\22"] = "演算子保留",
      ["niI"] = "通常-挿入",
      ["niR"] = "通常-置換",
      ["niV"] = "通常",
      ["nt"] = "通常-ターミナル",
      ["v"] = "ビジュアル",
      ["vs"] = "ビジュアル",
      ["V"] = "ビジュアルライン",
      ["Vs"] = "ビジュアルライン",
      ["\22"] = "ビジュアルブロック",
      ["\22s"] = "ビジュアルブロック",
      ["s"] = "選択",
      ["S"] = "選択ライン",
      ["\19"] = "選択ブロック",
      ["i"] = "挿入",
      ["ic"] = "挿入補完",
      ["ix"] = "挿入",
      ["R"] = "置換",
      ["Rc"] = "置換補完",
      ["Rx"] = "置換",
      ["Rv"] = "ビジュアル置換",
      ["Rvc"] = "ビジュアル置換補完",
      ["Rvx"] = "ビジュアル置換",
      ["c"] = "コマンドライン",
      ["cv"] = "EX",
      ["ce"] = "EX",
      ["r"] = "一文字置換",
      ["rm"] = "一文字置換",
      ["r?"] = "確認",
      ["!"] = "シェル",
      ["t"] = "ターミナル",
    }

    local function modes()
      return mode_map[vim.api.nvim_get_mode().mode] or "__"
    end

    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        -- lualine_a = { modes },
        lualine_a = {
          {
            function()
              local logo = ""
              return logo .. " " .. modes()
            end,
          }
        },
        lualine_b = { { "branch", icon = "" }, "db_ui#statusline" },
        lualine_c = { { "filename", file_status = true, path = 1, } },
        lualine_x = {
          "diagnostics",
          "diff",
          "filetype",
          {
            require("lazy.status").updates(),
            cond = require("lazy.status").has_updates(),
            color = { fg = "#ff9e64" }
          }
        },
      },
      inactive_winbar = {
        --lualine_c = { "filename" },
      }
    })
  end
}
