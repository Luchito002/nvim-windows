return {
  "seblyng/roslyn.nvim",
  ft = "cs",
  opts = {
    broad_search = true,
    lock_target = true,
    filewatching = "roslyn",
  },
  config = function(_, opts)
    require("roslyn").setup(opts)

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client.name == "roslyn" then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end,
    })
  end,
}
