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
      fg          = "#c0caf5",
      black       = "#1a1b26",

      red         = "#f7768e",
      green       = "#9ece6a",
      blue        = "#7aa2f7",
      yellow      = "#e0af68",
      orange      = "#ff9e64",
      purple      = "#7a5fd0",
      cyan        = "#7dcfff",

      gray        = "#3b4261",
      gitred      = "#292e42",
      diag        = "#292e42",

      mode_text   = "#1a1b26",

      file_icon   = "#7dcfff",
      file_text   = "#c0caf5",

      git_icon    = "#7ee787",
      git_text    = "#1a1b26",

      diag_err    = "#f7768e",
      diag_warn   = "#e0af68",

      lsp_icon    = "#1a1b26",
      lsp_text    = "#1a1b26",

      ruler_icon  = "#1a1b26",
      ruler_text  = "#1a1b26",
      scroll_icon = "#1a1b26",
      scroll_text = "#1a1b26",

      add         = "#9ece6a",
      change      = "#e0af68",
      remove      = "#f7768e",
    }

    local Align = { provider = "%=" }
    local Space = { provider = " " }

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
        provider = "  ",
        hl = { fg = "#e5c07b", bold = true, force = true },
      },
      {
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
        hl = { fg = "#e06c75", bold = true, force = true },
      },
      {
        provider = function()
          local name = vim.fn.expand("%:t")
          return name ~= "" and (name .. " ") or "[No Name] "
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
      hl = { fg = colors.git_text, bg = colors.purple, bold = true },
    }

    local GitBranchBlock = {
      condition = conditions.is_git_repo,
      { provider = "", hl = { fg = colors.purple } },
      GitBranch,
      { provider = "", hl = { fg = colors.purple } },
    }

    local Diagnostics = {
      condition = conditions.has_diagnostics,
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warns  = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
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
        local warns  = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
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
        return #vim.lsp.get_clients({ bufnr = 0 }) > 0
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
      update = { "BufEnter", "BufWritePost", "TextChanged", "TextChangedI", "User", pattern = "GitSignsUpdate" },
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
      Scroll,
      Space,
    }

    require("heirline").setup({
      statusline = StatusLine,
    })

    vim.o.laststatus = 3
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
  end,
}
