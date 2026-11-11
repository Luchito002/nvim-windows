return {
  "seblyng/roslyn.nvim",
  ft = { "cs", "razor" },

  opts = {
    broad_search = true,
    lock_target = false,
    filewatching = "off",
  },

  config = function(_, opts)
    vim.env.ROSLYN_LANGUAGE_SERVER_DAEMON_KEEPALIVE = "0"

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
