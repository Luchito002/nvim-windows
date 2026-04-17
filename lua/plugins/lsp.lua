return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "folke/neodev.nvim",
    "seblyng/roslyn.nvim",
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
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
    vim.api.nvim_create_autocmd("LspAttach",
      {
        desc = "LSP keymaps",
        callback = function(args)
          local bufnr = args.buf
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end, opts)
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
    vim.lsp.config("ts_ls", { capabilities = capabilities, flags = { debounce_text_changes = 300 }, })
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

    -- for csharp
    vim.filetype.add({
      extension = {
        razor = "razor",
        cshtml = "razor",
      },
    })
    vim.lsp.config("roslyn", {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
      end,
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
      "roslyn",
      "emmet_language_server",
    })
  end,
}
