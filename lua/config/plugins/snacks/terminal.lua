return {
  shell = "pwsh.exe",

  win = {
    style = "terminal",
    position = "float",

    -- tamaño relativo (centrado automático)
    width = 0.85,
    height = 0.75,

    border = "rounded",

    -- opcional: transparencia
    wo = {
      winblend = 10,
    },
  },

  -- comportamiento del terminal
  start_insert = true,
  auto_insert = true,
  auto_close = false,
}
