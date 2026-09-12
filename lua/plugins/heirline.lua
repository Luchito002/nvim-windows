return {
  "rebelot/heirline.nvim",
  event = "UiEnter",
  enabled = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local conditions = require("heirline.conditions")
    local devicons = require("nvim-web-devicons")

    local colors = {}

    local function set_colors()
      local fallback = {
        fg = "#93a1a1",
        muted = "#657b83",
        panel = "#11242b",
        line = "#1f3942",
        ink = "#00141a",
        blue = "#268bd2",
        green = "#859900",
        cyan = "#2aa198",
        yellow = "#b58900",
        orange = "#cb4b16",
        purple = "#6c71c4",
        red = "#dc322f",
      }

      local function highlight_color(group, attribute, default)
        local highlight = vim.api.nvim_get_hl(0, { name = group, link = false })
        local color = highlight[attribute]

        if color then
          return string.format("#%06x", color)
        end

        return default
      end

      local palette = {
        fg = highlight_color("Normal", "fg", fallback.fg),
        muted = highlight_color("Comment", "fg", fallback.muted),
        panel = highlight_color("StatusLine", "bg", fallback.panel),
        line = highlight_color("WinSeparator", "fg", fallback.line),
        ink = highlight_color("Normal", "bg", fallback.ink),
        blue = highlight_color("Directory", "fg", fallback.blue),
        green = highlight_color("String", "fg", fallback.green),
        cyan = highlight_color("Type", "fg", fallback.cyan),
        yellow = highlight_color("Special", "fg", fallback.yellow),
        orange = highlight_color("DiagnosticWarn", "fg", fallback.orange),
        purple = highlight_color("Statement", "fg", fallback.purple),
        red = highlight_color("DiagnosticError", "fg", fallback.red),
      }

      for key, value in pairs(fallback) do
        colors[key] = palette[key] or value
      end
    end

    set_colors()

    local function build_statusline()
      local Align = { provider = "%=" }

      local function win_width()
        return vim.api.nvim_win_get_width(0)
      end

      local function enough(width)
        return win_width() >= width
      end

      local function mode_color()
        local mode = vim.fn.mode(1)
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
          t = colors.cyan,
        }

        return map[mode] or map[mode:sub(1, 1)] or colors.blue
      end

      local function truncate(text, max)
        if #text <= max then
          return text
        end

        if max <= 3 then
          return text:sub(1, max)
        end

        return text:sub(1, max - 3) .. "..."
      end

      local function section(label, value, opts)
        opts = opts or {}

        return {
          {
            provider = opts.left_pad or " ",
          },
          {
            provider = opts.prefix or "▌",
            hl = function()
              return {
                fg = opts.accent or colors.line,
                bold = true,
              }
            end,
          },
          {
            provider = label,
            hl = {
              fg = opts.label_fg or colors.muted,
              bg = opts.bg or "NONE",
              bold = opts.label_bold == true,
            },
          },
          {
            provider = value,
            hl = function()
              local value_fg = opts.value_fg

              if type(value_fg) == "function" then
                value_fg = value_fg()
              end

              return {
                fg = value_fg or colors.fg,
                bg = opts.bg or "NONE",
                bold = opts.bold ~= false,
              }
            end,
          },
        }
      end

      local ViMode = {
        init = function(self)
          self.mode = vim.fn.mode(1)
        end,

        static = {
          names = {
            n = "NORMAL",
            i = "INSERT",
            v = "VISUAL",
            V = "V-LINE",
            ["\22"] = "V-BLOCK",
            c = "COMMAND",
            R = "REPLACE",
            t = "TERMINAL",
          },
        },

        {
          provider = "█",
          hl = function()
            return { fg = mode_color(), bold = true }
          end,
        },
        {
          provider = function(self)
            return " " .. (self.names[self.mode] or self.mode) .. " "
          end,
          hl = function()
            return { fg = colors.ink, bg = mode_color(), bold = true }
          end,
        },
        {
          provider = "",
          hl = function()
            return { fg = mode_color(), bold = true }
          end,
        },

        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
          end),
        },
      }

      local FileBlock = {
        init = function(self)
          self.filename = vim.fn.expand("%:t")
          self.cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          self.modified = vim.bo.modified
          self.readonly = vim.bo.readonly
        end,

        section(" path ", function(self)
          local name = self.filename ~= "" and self.filename or "[No Name]"
          local folder = self.cwd ~= "" and (self.cwd .. "/") or ""

          if enough(140) then
            return folder .. name .. " "
          end

          if enough(95) then
            return truncate(name, 28) .. " "
          end

          return truncate(name, 18) .. " "
        end, {
          accent = colors.yellow,
          value_fg = colors.fg,
          label_fg = colors.yellow,
          bold = true,
        }),

        {
          condition = function(self)
            return self.modified or self.readonly
          end,
          provider = function(self)
            local marks = {}

            if self.modified then
              marks[#marks + 1] = "[+]"
            end

            if self.readonly then
              marks[#marks + 1] = "[RO]"
            end

            return " " .. table.concat(marks, " ")
          end,
          hl = function(self)
            return {
              fg = self.modified and colors.orange or colors.red,
              bold = true,
            }
          end,
        },
      }

      local GitBranch = {
        condition = function()
          return enough(88) and conditions.is_git_repo()
        end,

        init = function(self)
          self.status = vim.b.gitsigns_status_dict or {}
        end,

        section(" git ", function(self)
          local branch = self.status.head or "detached"
          local limit = enough(125) and 24 or 16
          return truncate(branch, limit) .. " "
        end, {
          accent = colors.cyan,
          label_fg = colors.cyan,
          value_fg = colors.fg,
        }),
      }

      local Diagnostics = {
        condition = conditions.has_diagnostics,

        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warns = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        end,

        section(" diag ", function(self)
          local items = {}

          if self.errors > 0 then
            items[#items + 1] = " " .. self.errors
          end

          if self.warns > 0 then
            items[#items + 1] = " " .. self.warns
          end

          if enough(130) and self.hints > 0 then
            items[#items + 1] = "󰌵 " .. self.hints
          end

          return table.concat(items, " ") .. " "
        end, {
          accent = colors.red,
          label_fg = colors.red,
          value_fg = function()
            local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })

            if errors > 0 then
              return colors.red
            end
            return colors.yellow
          end,
        }),
      }

      local GitChanges = {
        condition = function()
          local g = vim.b.gitsigns_status_dict

          if not enough(92) or not conditions.is_git_repo() or not g then
            return false
          end

          return (g.added or 0) > 0 or (g.changed or 0) > 0 or (g.removed or 0) > 0
        end,

        init = function(self)
          self.g = vim.b.gitsigns_status_dict or {}
        end,

        section(" diff ", function(self)
          local items = {}

          if (self.g.added or 0) > 0 then
            items[#items + 1] = " " .. self.g.added
          end

          if (self.g.changed or 0) > 0 then
            items[#items + 1] = " " .. self.g.changed
          end

          if (self.g.removed or 0) > 0 then
            items[#items + 1] = " " .. self.g.removed
          end

          return table.concat(items, " ") .. " "
        end, {
          accent = colors.green,
          label_fg = colors.green,
          value_fg = colors.fg,
        }),
      }

      local LSP = {
        condition = function()
          return enough(118) and #vim.lsp.get_clients({ bufnr = 0 }) > 0
        end,

        section(" lsp ", function()
          local names = {}

          for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            names[#names + 1] = client.name
          end

          local text = table.concat(names, " + ")
          return truncate(text, enough(150) and 34 or 20) .. " "
        end, {
          accent = colors.purple,
          label_fg = colors.purple,
          value_fg = colors.fg,
        }),
      }

      local Cursor = section(" pos ", function()
        return string.format("%3d:%-2d ", vim.fn.line("."), vim.fn.col("."))
      end, {
        accent = colors.blue,
        label_fg = colors.blue,
        value_fg = colors.fg,
      })

      local StatusLine = {
        hl = { bg = "NONE", fg = colors.fg },

        { provider = " " },
        ViMode,
        FileBlock,
        GitBranch,
        Diagnostics,

        Align,

        GitChanges,
        LSP,
        Cursor,
        { provider = " " },
      }

      return StatusLine
    end

    local function setup_statusline()
      set_colors()

      require("heirline").setup({
        statusline = build_statusline(),
      })

      vim.o.laststatus = 3
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
    end

    setup_statusline()

    vim.api.nvim_create_autocmd({ "ColorScheme", "OptionSet" }, {
      pattern = { "*", "background" },
      callback = function(args)
        if args.event == "OptionSet" and args.match ~= "background" then
          return
        end

        setup_statusline()
        vim.cmd("redrawstatus")
      end,
    })
  end,
}
