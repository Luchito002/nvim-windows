return {
  "rebelot/heirline.nvim",
  event = "UiEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local conditions = require("heirline.conditions")
    local devicons = require("nvim-web-devicons")

    local colors = {
      fg = "#839496",
      black = "#00141a",

      red = "#ab031f",
      green = "#859900",
      blue = "#268bd2",
      yellow = "#b58900",
      orange = "#cb4b16",
      purple = "#6c71c4",
      cyan = "#2aa198",

      gray = "#073642",
      diag = "#002b36",

      mode_text = "#00141a",

      file_icon = "#2aa198",
      file_text = "#93a1a1",

      gitred = "#3b0d14",
      git_icon = "#1f7a1f",
      git_text = "#93a1a1",

      diag_err = "#ab031f",
      diag_warn = "#b58900",

      lsp_icon = "#00141a",
      lsp_text = "#00141a",

      ruler_icon = "#00141a",
      ruler_text = "#00141a",
      scroll_icon = "#00141a",
      scroll_text = "#00141a",

      add = "#859900",
      change = "#b58900",
      remove = "#ab031f",
    }

    local Align = { provider = "%=" }
    local Space = { provider = " " }

    local is_narrow = function()
      return vim.o.columns < 100
    end

    local is_tiny = function()
      return vim.o.columns < 80
    end

    local show_branch = function()
      return vim.o.columns >= 90
    end

    local show_lsp = function()
      return vim.o.columns >= 110
    end

    local Bubble = function(bg, fg, content)
      local body = {
        hl = { bg = bg, fg = fg, bold = true },
      }

      vim.list_extend(body, content)

      return {
        { provider = "", hl = { fg = bg } },
        body,
        { provider = "", hl = { fg = bg } },
      }
    end

    local mode_color = function()
      local m = vim.fn.mode(1)
      local map = {
        n = colors.blue,
        no = colors.blue,
        i = colors.green,
        ic = colors.green,
        v = colors.purple,
        V = colors.purple,
        ["\22"] = colors.purple,
        c = colors.orange,
        R = colors.red,
        r = colors.red,
        t = colors.red,
      }

      return map[m] or map[m:sub(1, 1)] or colors.blue
    end

    local ViMode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        names = {
          n = "通常",
          i = "挿入",
          v = "選択",
          V = "行選択",
          ["\22"] = "矩形選択",
          c = "命令",
          R = "置換",
          t = "端末",
        },
      },
      {
        provider = "  ",
        hl = { fg = colors.mode_text, bold = true },
      },
      {
        provider = function(self)
          return (self.names[self.mode] or self.mode) .. " "
        end,
        hl = { fg = colors.mode_text, bold = true },
      },
      hl = function()
        return {
          fg = colors.mode_text,
          bg = mode_color(),
          bold = true,
        }
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local FileName = {
      {
        provider = function()
          return is_narrow() and " " or "  "
        end,
        hl = { fg = colors.yellow, bold = true, force = true },
      },
      {
        condition = function()
          return not is_narrow()
        end,
        provider = function()
          local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          return cwd ~= "" and (cwd .. "/") or ""
        end,
        hl = { fg = colors.file_text, bold = true },
      },
      {
        provider = function()
          local filename = vim.fn.expand("%:t")

          if filename == "" then
            return "  "
          end

          local ext = vim.fn.expand("%:e")
          local icon, _ = devicons.get_icon(filename, ext, { default = true })

          return " " .. icon .. " "
        end,
        hl = { fg = colors.red, bold = true, force = true },
      },
      {
        provider = function()
          local name = vim.fn.expand("%:t")

          if name == "" then
            return "[No Name] "
          end

          if is_tiny() and #name > 24 then
            return name:sub(1, 21) .. "... "
          end

          return name .. " "
        end,
        hl = { fg = colors.file_text, bold = true },
      },
    }

    local FileBlock = Bubble(colors.gray, colors.fg, FileName)

    local GitBranch = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status = vim.b.gitsigns_status_dict
      end,
      {
        provider = "  ",
        hl = { fg = colors.git_icon, bold = true },
      },
      {
        provider = function(self)
          local branch = self.status and self.status.head or ""
          return branch .. " "
        end,
        hl = { fg = colors.git_text, bold = true },
      },
      hl = { fg = colors.git_text, bg = colors.gitred, bold = true },
    }

    local GitBranchBlock = {
      condition = function()
        return show_branch() and conditions.is_git_repo()
      end,
      { provider = "", hl = { fg = colors.gitred } },
      GitBranch,
      { provider = "", hl = { fg = colors.gitred } },
    }

    local Diagnostics = {
      condition = conditions.has_diagnostics,
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warns = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      end,
      {
        provider = function(self)
          if self.errors > 0 then
            return "  " .. self.errors .. " "
          end
          return ""
        end,
        hl = { fg = colors.diag_err, bold = true },
      },
      {
        provider = function(self)
          if self.warns > 0 then
            return "  " .. self.warns .. " "
          end
          return ""
        end,
        hl = { fg = colors.diag_warn, bold = true },
      },
      hl = { fg = colors.black, bg = colors.diag, bold = true },
    }

    local DiagnosticsBlock = {
      condition = function()
        local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        local warns = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        return errors > 0 or warns > 0
      end,
      { provider = "", hl = { fg = colors.diag } },
      Diagnostics,
      { provider = "", hl = { fg = colors.diag } },
    }

    local LSP = {
      condition = function()
        return #vim.lsp.get_clients({ bufnr = 0 }) > 0
      end,
      {
        provider = "  ",
        hl = { fg = colors.lsp_icon, bold = true },
      },
      {
        provider = function()
          local names = {}

          for _, lsp in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            table.insert(names, lsp.name)
          end

          return table.concat(names, ", ") .. " "
        end,
        hl = { fg = colors.lsp_text, bold = true },
      },
      hl = { fg = colors.black, bg = colors.cyan, bold = true },
    }

    local LSPBlock = {
      condition = function()
        return show_lsp() and #vim.lsp.get_clients({ bufnr = 0 }) > 0
      end,
      { provider = "", hl = { fg = colors.cyan } },
      LSP,
      { provider = "", hl = { fg = colors.cyan } },
    }

    local GitChanges = {
      condition = function()
        if not conditions.is_git_repo() then
          return false
        end

        local g = vim.b.gitsigns_status_dict

        if not g then
          return false
        end

        return (g.added or 0) > 0
          or (g.changed or 0) > 0
          or (g.removed or 0) > 0
      end,
      init = function(self)
        self.g = vim.b.gitsigns_status_dict or {}
      end,
      {
        provider = function(self)
          if (self.g.added or 0) > 0 then
            return " +" .. self.g.added .. " "
          end
          return ""
        end,
        hl = { fg = colors.add, bold = true },
      },
      {
        provider = function(self)
          if (self.g.changed or 0) > 0 then
            return " ~" .. self.g.changed .. " "
          end
          return ""
        end,
        hl = { fg = colors.change, bold = true },
      },
      {
        provider = function(self)
          if (self.g.removed or 0) > 0 then
            return " -" .. self.g.removed .. " "
          end
          return ""
        end,
        hl = { fg = colors.remove, bold = true },
      },
      hl = { fg = colors.black, bg = colors.gitred, bold = true },
      update = {
        "BufEnter",
        "BufWritePost",
        "TextChanged",
        "TextChangedI",
        "User",
        pattern = "GitSignsUpdate",
      },
    }

    local GitChangesBlock = {
      condition = function()
        if not conditions.is_git_repo() then
          return false
        end

        local g = vim.b.gitsigns_status_dict

        if not g then
          return false
        end

        return (g.added or 0) > 0
          or (g.changed or 0) > 0
          or (g.removed or 0) > 0
      end,
      { provider = "", hl = { fg = colors.gitred } },
      GitChanges,
      { provider = "", hl = { fg = colors.gitred } },
    }

    local Ruler = Bubble(colors.blue, colors.black, {
      {
        provider = "",
        hl = { fg = colors.ruler_icon, bold = true },
      },
      {
        provider = " %l:%c ",
        hl = { fg = colors.ruler_text, bold = true },
      },
    })

    local Scroll = Bubble(colors.green, colors.black, {
      {
        provider = "",
        hl = { fg = colors.scroll_icon, bold = true },
      },
      {
        provider = " %p%% ",
        hl = { fg = colors.scroll_text, bold = true },
      },
    })

    local ModeBlock = {
      {
        provider = "",
        hl = function()
          return { fg = mode_color() }
        end,
      },
      ViMode,
      {
        provider = "",
        hl = function()
          return { fg = mode_color() }
        end,
      },
    }

    local StatusLine = {
      hl = { bg = "NONE", fg = colors.fg },

      Space,
      ModeBlock,
      Space,
      FileBlock,
      Space,
      GitBranchBlock,
      Space,
      DiagnosticsBlock,

      Align,

      GitChangesBlock,
      Space,
      LSPBlock,
      Space,
      Ruler,
      Space,
      -- Scroll,
      -- Space,
    }

    require("heirline").setup({
      statusline = StatusLine,
    })

    vim.o.laststatus = 3
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
  end,
}
