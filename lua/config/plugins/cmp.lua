---@diagnostic disable: missing-fields
local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_autopairs = require "nvim-autopairs.completion.cmp"

local M = {}

function M.setup()
  cmp.setup({

    window = {
      completion = {
        border = "rounded",
        scrollbar = false,
      },

      documentation = {
        border = "rounded",
      },
    },

    formatting = {
      format = function(entry, vim_item)
        local KIND_ICONS = {
          Tailwind = '󰝤󰝤󰝤󰝤󰝤󰝤',
          Color = '色',
          Class = 'クラス',
          Constant = '定数',
          Constructor = 'コンストラクタ',
          Enum = '列挙型',
          EnumMember = '列挙メンバ',
          Event = 'イベント',
          Field = 'フィールド',
          File = 'ファイル',
          Folder = 'フォルダ',
          Function = '関数',
          Interface = 'インタフェース',
          Keyword = 'キーワード',
          Method = 'メソッド',
          Module = 'モジュール',
          Operator = '演算子',
          Property = 'プロパティ',
          Reference = '参照',
          Snippet = "スニペット",
          Struct = '構造体',
          Text = 'テキスト',
          TypeParameter = '型 パラメータ',
          Unit = 'ユニット',
          Value = '値',
          Variable = '変数'
        }
        if vim_item.kind == 'Color' and entry.completion_item.documentation then
          local _, _, r, g, b =
          ---@diagnostic disable-next-line: param-type-mismatch
              string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')

          if r and g and b then
            local color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
            local group = 'Tw_' .. color

            if vim.api.nvim_call_function('hlID', { group }) < 1 then
              vim.api.nvim_command('highlight' .. ' ' .. group .. ' ' .. 'guifg=#' .. color)
            end

            vim_item.kind = KIND_ICONS.Tailwind
            vim_item.kind_hl_group = group

            return vim_item
          end
        end

        vim_item.kind = KIND_ICONS[vim_item.kind] or vim_item.kind

        return vim_item
      end,
    },

    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-n>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.choice_active() then
          luasnip.change_choice(1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-p>"] = cmp.mapping.select_prev_item(),


      ["<CR>"] = cmp.mapping.confirm {

        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },


      ["<c-space>"] = cmp.mapping.complete(),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "luasnip" },
      { name = "buffer" },
    },
  })

  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

  -- Auto import para c#
--   local cmp = require("cmp")
--
--   cmp.event:on("confirm_done", function(evt)
--     local entry = evt.entry
--     if not entry or not entry.source or entry.source.name ~= "nvim_lsp" then
--       return
--     end
--
--     vim.schedule(function()
--       local bufnr = 0
--
--       -- Obtener diagnósticos en la línea actual
--       local line = vim.api.nvim_win_get_cursor(0)[1] - 1
--       local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
--
--       if not diagnostics or vim.tbl_isempty(diagnostics) then
--         return
--       end
--
--       -- Detectar errores típicos de "falta using"
--       local needs_import = false
--
--       for _, d in ipairs(diagnostics) do
--         if d.severity == vim.diagnostic.severity.ERROR then
--           local msg = d.message:lower()
--
--           if msg:match("type or namespace")
--             or msg:match("could not be found")
--             or msg:match("are you missing") then
--             needs_import = true
--             break
--           end
--         end
--       end
--
--       if not needs_import then
--         return
--       end
--
--       -- Ejecutar auto-import
--       vim.lsp.buf.code_action({
--         apply = true,
--         context = {
--           only = {
--             "source.addImports",
--             "quickfix",
--           },
--           diagnostics = diagnostics,
--         },
--       })
--     end)
--   end)


  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

return M
