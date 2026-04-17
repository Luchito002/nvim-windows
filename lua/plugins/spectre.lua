return {
  "nvim-pack/nvim-spectre",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    vim.keymap.set("n", "<leader>S", function()
      require("spectre").toggle()
    end, { desc = "Abrir Spectre" })

    vim.keymap.set("n", "<leader>Sw", function()
      require("spectre").open_visual({ select_word = true })
    end, { desc = "Buscar palabra actual" })

    vim.keymap.set("v", "<leader>Sw", function()
      require("spectre").open_visual()
    end, { desc = "Buscar selección" })

    vim.keymap.set("n", "<leader>Sf", function()
      require("spectre").open_file_search({ select_word = true })
    end, { desc = "Buscar en archivo actual" })
  end
}
