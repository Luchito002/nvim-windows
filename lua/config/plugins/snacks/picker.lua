local function set_picker_hl()
  local cyan = "#27a1b9"
  local purple = "#B284BE"
  local green = "#5de4c7"

  -- Título/borde general del bloque izquierdo
  vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = cyan })
  vim.api.nvim_set_hl(0, "SnacksPickerTitle", { fg = cyan, bold = true })

  -- Input
  vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg = cyan })
  vim.api.nvim_set_hl(0, "SnacksPickerInputTitle", { fg = cyan, bold = true })

  -- Results
  vim.api.nvim_set_hl(0, "SnacksPickerListBorder", { fg = purple })
  vim.api.nvim_set_hl(0, "SnacksPickerListTitle", { fg = purple, bold = true })

  -- Preview
  vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { fg = green })
  vim.api.nvim_set_hl(0, "SnacksPickerPreviewTitle", { fg = green, bold = true })

  -- Transparent backgrounds
  vim.api.nvim_set_hl(0, "SnacksPicker", { bg = "none" })
  vim.api.nvim_set_hl(0, "SnacksPickerInput", { bg = "none" })
  vim.api.nvim_set_hl(0, "SnacksPickerList", { bg = "none" })
  vim.api.nvim_set_hl(0, "SnacksPickerPreview", { bg = "none" })
end

set_picker_hl()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_picker_hl,
})

return {
  layout = {
    preset = "telescope_like",
  },

  layouts = {
    telescope_like = {
      reverse = false,
      layout = {
        box = "horizontal",
        backdrop = false,
        width = 0.90,
        height = 0.85,
        border = "none",
        {
          box = "vertical",
          width = 0.50,
          border = "rounded",
          title = "{title}",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
        },
        {
          win = "preview",
          width = 0.50,
          border = "rounded",
          title = "{preview}",
        },
      },
    },
  },

  win = {
    input = {
      border = "rounded",
      title_pos = "center",
      keys = {
        ["<C-j>"] = { "list_down", mode = { "i", "n" } },
        ["<C-k>"] = { "list_up", mode = { "i", "n" } },
      },
    },
    list = {
      border = "rounded",
      title_pos = "center",
      keys = {
        ["<C-j>"] = "list_down",
        ["<C-k>"] = "list_up",
      },
    },
    preview = {
      border = "rounded",
      title_pos = "center",
    },
  },

  sources = {
    files = {
      title = "ファイル検索",
      win = {
        preview = { title = "プレビュー" },
      },
    },

    grep = {
      title = "テキスト検索",
      win = {
        preview = { title = "コンテキスト" },
      },
    },

    buffers = {
      title = "開いているバッファ",
      win = {
        preview = { title = "内容" },
      },
    },

    recent = {
      title = "最近使ったファイル",
      win = {
        preview = { title = "プレビュー" },
      },
    },

    help = {
      title = "ヘルプ",
      win = {
        preview = {
          title = "内容",
          minimal = true,
        },
      },
    },
  },
}
