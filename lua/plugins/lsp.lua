return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "folke/neodev.nvim",
  },
  config = function()
    vim.diagnostic.config({
      virtual_text = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN]  = "",
          [vim.diagnostic.severity.HINT]  = "󰌵",
          [vim.diagnostic.severity.INFO]  = "",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { desc = "Next diagnostic" })

    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, { desc = "Previous diagnostic" })
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP keymaps",
      callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr }

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", function()
          Snacks.picker.lsp_references()
        end, { buffer = bufnr, desc = "LSP References" })
        vim.keymap.set("n", "gd", function()
          Snacks.picker.lsp_definitions()
        end, { buffer = bufnr, desc = "Definitions" })
        vim.keymap.set("n", "gi", function()
          Snacks.picker.lsp_implementations()
        end, { buffer = bufnr, desc = "Implementations" })
        vim.keymap.set("n", "<space>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end,
    })

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    capabilities.textDocument = capabilities.textDocument or {}
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    require("neodev").setup()

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })

    vim.lsp.config("clangd", { capabilities = capabilities })
    vim.lsp.config("pyright", { capabilities = capabilities })
    vim.lsp.config("ts_ls", {
      capabilities = capabilities,
      flags = { debounce_text_changes = 300 },
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
      },
    })
    vim.lsp.config("cssls", { capabilities = capabilities })
    vim.lsp.config("jsonls", { capabilities = capabilities })
    vim.lsp.config("eslint", { capabilities = capabilities })
    vim.lsp.config("tailwindcss", { capabilities = capabilities })
    vim.lsp.config("gradle_ls", { capabilities = capabilities })
    vim.lsp.config("prismals", { capabilities = capabilities })
    vim.lsp.config("html", {
      capabilities = capabilities,
      filetypes = { "html" },
    })
    vim.lsp.config("emmet_language_server", {
      capabilities = capabilities,
      filetypes = {
        "html",
        "css",
        "scss",
        "javascriptreact",
        "typescriptreact",
      },
    })
    vim.lsp.config("vue_ls", {
      capabilities = capabilities,
      filetypes = { "vue" },
    })
    vim.filetype.add({
      extension = {
        razor = "razor",
        cshtml = "razor",
      },
    })
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "clangd",
        "pyright",
        "ts_ls",
        "cssls",
        "jsonls",
        "eslint",
        "tailwindcss",
        "gradle_ls",
        "prismals",
        "html",
        "emmet_language_server",
        "vue_ls",
      },
      automatic_enable = true,
    })

    vim.lsp.enable({
      "lua_ls",
      "clangd",
      "pyright",
      "ts_ls",
      "cssls",
      "jsonls",
      "eslint",
      "tailwindcss",
      "gradle_ls",
      "prismals",
      "html",
      "emmet_language_server",
      "vue_ls",
    })
  end,
}
