return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  enabled = false,
  config = function()
    local hooks = require("ibl.hooks")

    -- lista base
    local base_highlight = {
      "IndentRed",
      "IndentYellow",
      "IndentBlue",
      "IndentOrange",
      "IndentGreen",
      "IndentViolet",
      "IndentCyan",
    }

    -- función para mezclar (shuffle)
    local function shuffle(tbl)
      local t = vim.tbl_deep_extend("force", {}, tbl)
      for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
      end
      return t
    end

    -- semilla para aleatoriedad
    math.randomseed(os.time())

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "IndentRed",    { fg = "#8A6A6A" })
      vim.api.nvim_set_hl(0, "IndentYellow", { fg = "#8A845F" })
      vim.api.nvim_set_hl(0, "IndentBlue",   { fg = "#6A7F95" })
      vim.api.nvim_set_hl(0, "IndentOrange", { fg = "#8A7A65" })
      vim.api.nvim_set_hl(0, "IndentGreen",  { fg = "#6F8A6F" })
      vim.api.nvim_set_hl(0, "IndentViolet", { fg = "#7F6A8A" })
      vim.api.nvim_set_hl(0, "IndentCyan",   { fg = "#6A8A8A" })
    end)

    require("ibl").setup({
      indent = {
        char = "┊",
        highlight = shuffle(base_highlight),
      },
      scope = {
        enabled = false,
      },
    })
  end,
}
