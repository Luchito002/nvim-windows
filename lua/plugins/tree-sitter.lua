return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    vim.env.CC = "gcc"

    local ts = require("nvim-treesitter")

    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    ts.install({
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
      "css"
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "lua",
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
        "python",
        "cs",
        "java",
        "html",
        "cpp",
        "prisma",
        "http",
        "json",
        "css"
      },
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldlevel = 99
      end,
    })
  end,
}
