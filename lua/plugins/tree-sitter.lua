return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "master",
  build = ":TSUpdate",
  config = function()
    vim.env.CC = "gcc"

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    parser_config.razor = {
      install_info = {
        url = "https://github.com/tris203/tree-sitter-razor",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
      },
      filetype = "razor",
    }

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
        "razor",
      },

      highlight = {
        enable = true,
        disable = { "razor" },
      },

      indent = {
        enable = true,
        disable = { "razor" },
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldlevel = 99
      end,
    })
  end,
}
