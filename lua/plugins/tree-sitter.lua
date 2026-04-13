return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "master",
  build = ":TSUpdate",
  config = function()
    vim.env.CC = "gcc"

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "c_sharp",
        "java",
        "html",
        "cpp",
        "prisma",
        "http",
        "json",
      },

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },
    })

    -- folds
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldlevel = 99
      end,
    })
  end,
}
