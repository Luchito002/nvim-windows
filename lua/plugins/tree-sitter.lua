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

    vim.treesitter.language.register("markdown", "opencode_output")

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
      "css",
      "markdown",
      "markdown_inline",
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
        "css",
        "markdown",
        "opencode_output",
      },
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)

        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldlevel = 99
      end,
    })
  end,
}
