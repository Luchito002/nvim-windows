return {
  "johnseth97/codex.nvim",
  lazy = true,
  cmd = { "Codex", "CodexToggle" },

  keys = {
    {
      "<leader>ot",
      function()
        require("codex").toggle()
      end,
      desc = "Toggle Codex panel",
      mode = { "n" },
    },
    {
      "<leader>cc",
      function()
        require("codex").toggle()
      end,
      desc = "Toggle Codex panel",
      mode = { "n" },
    },
  },

  opts = {
    keymaps = {
      toggle = nil,
      quit = "<C-q>",
    },
    border = "rounded",
    panel = true,
    width = 0.40,
    height = 0.8,
    cmd = "codex",
    model = nil,
    autoinstall = false,
    use_buffer = false,
  },

  config = function(_, opts)
    require("codex").setup(opts)

    vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "WinEnter" }, {
      group = vim.api.nvim_create_augroup("CodexWindowTweaks", { clear = true }),
      callback = function()
        local ft = vim.bo.filetype
        local name = vim.api.nvim_buf_get_name(0)

        if ft == "codex" or name:lower():find("codex") then
          vim.opt_local.foldenable = false
          vim.opt_local.foldcolumn = "0"
          vim.opt_local.foldmethod = "manual"
          vim.opt_local.foldlevel = 99
          vim.opt_local.foldlevelstart = 99
          vim.opt_local.wrap = true
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end
      end,
    })
  end,
}
