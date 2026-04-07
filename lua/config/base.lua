vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.wo.number = true
vim.opt.relativenumber = true
vim.o.termguicolors = true
vim.o.fillchars = 'eob: '

vim.o.cursorline = false

-- for not to lose the windows terminal cursor styles
-- vim.opt.guicursor = ""

vim.api.nvim_create_autocmd("BufWinLeave", {
  callback = function()
    if vim.bo.filetype == "oil" then
      os.execute(
        "touch '/mnt/c/Users/luis/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json'")
    end
  end,
})

vim.g.python3_host_prog = vim.fn.expand("~/.venvs/nvim/bin/python3")

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 10
--vim.opt.shell = 'fish'
vim.opt.backupskip = '/tmp/*,/private/tmp/*'
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.ai = true
vim.opt.si = true
vim.opt.wrap = true
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules*/' }

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Line color when splitting windows
-- vim.cmd('highlight WinSeparator guibg=#4A628A guifg=#7AB2D3')
vim.cmd('highlight WinSeparator guifg=#5F8FA3')

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = "set nopaste"
})

vim.opt.formatoptions:append { 'r' }

vim.g.mapleader = " "
vim.g.mapleader = " "

-- Autocomplete for cmdline
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
