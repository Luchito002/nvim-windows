return {
  "nvim-mini/mini.icons",
  config = function()
    require("mini.icons").setup()

    -- Hace que plugins que usan devicons funcionen automáticamente
    require("mini.icons").mock_nvim_web_devicons()
  end,
}
