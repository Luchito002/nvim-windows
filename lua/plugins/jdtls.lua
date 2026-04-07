return {
  "mfussenegger/nvim-jdtls",
  -- dependencies = {
  --   "mfussenegger/nvim-dap"
  -- },
  lazy = true,
  -- config = function()
  --   local has = function(x)
  --     return vim.fn.has(x) == 1
  --   end

  --   local is_unix = has "unix" or has "macunix"
  --   local is_win = has "win32"

  --   local path = is_win and '~/AppData/Local/nvim-data/mason/bin/jdtls.cmd' or
  --       is_unix and '~/.local/share/nvim/mason/bin/jdtls' or
  --       ''

  --   local config = {
  --     cmd = { vim.fn.expand(path) },
  --     root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw', 'pom.xml' }, { upward = true })[1]),
  --   }

  --   require('jdtls').start_or_attach(config)
  -- end
}
