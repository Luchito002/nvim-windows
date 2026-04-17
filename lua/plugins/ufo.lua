return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  event = "VeryLazy",
  config = function()
    vim.o.foldcolumn = "0"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

    -- Control fino de folds (nivel y actual)
    vim.keymap.set("n", "zm", "zc", { desc = "Cerrar método" })
    vim.keymap.set("n", "zr", "zo", { desc = "Abrir método" })
    vim.keymap.set("n", "za", "za", { desc = "Toggle fold" })

    -- Control por niveles
    vim.keymap.set("n", "z1", function() vim.cmd("set foldlevel=1") end)
    vim.keymap.set("n", "z2", function() vim.cmd("set foldlevel=2") end)
    vim.keymap.set("n", "z3", function() vim.cmd("set foldlevel=3") end)

    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        if filetype == "cs" then
          return { "lsp", "indent" }
        end
        return { "treesitter", "indent" }
      end,
      -- Mejora visual del texto plegado
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth

        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            break
          end
          curWidth = curWidth + chunkWidth
        end

        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    })
  end,
}
