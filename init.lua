vim.env.PATH = table.concat({
  "C:\\ProgramData\\mingw64\\mingw64\\bin",
  "C:\\ProgramData\\chocolatey\\bin",
  "C:\\Program Files\\Git\\cmd",
  vim.env.PATH,
}, ";")

vim.env.CC = "gcc"
vim.env.CXX = "g++"

require("config")
