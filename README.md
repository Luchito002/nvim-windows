# Neovim Configuration

This repository contains a personal, Lua-based Neovim setup focused on development workflows (LSP, debugging, testing, Git, search/navigation, and UI quality-of-life improvements).

## Overview

- **Entry point:** `init.lua`
- **Core config:** `lua/config/`
- **Plugins (lazy.nvim specs):** `lua/plugins/`
- **Filetype overrides:** `ftplugin/`

The configuration is modular and follows a clean split-by-concern structure.

## Startup Flow

Startup order is intentionally simple:

1. `init.lua` sets environment values (`PATH`, `CC`, `CXX`)
2. `require("config")` loads `lua/config/init.lua`
3. `lua/config/init.lua` loads:
   - `clipboard`
   - `base`
   - `keymaps`
   - `lazy` (plugin manager bootstrap and setup)
   - `autocmd`
   - `csharp`

## Plugin Management

This config uses [lazy.nvim](https://github.com/folke/lazy.nvim).

- Specs live in `lua/plugins/*.lua`
- They are auto-imported using `spec = { { import = "plugins" } }`
- Plugin versions are pinned in `lazy-lock.json`

After changing plugin specs:

- Run `:Lazy sync`
- Optionally run `:Lazy reload`

## Core Configuration

### Base behavior

- Leader key is set to `<Space>`
- Relative numbers enabled by default
- 4-space indentation
- Persistent undo enabled
- Split behavior and scrolling tuned for coding
- Clipboard setup differs by OS (`unnamedplus`/`unnamed` logic)

### Keymaps

Global maps are defined in `lua/config/keymaps.lua`, with plugin-local maps kept inside each plugin spec.

Notable patterns:

- Fast split management (`ss`, `sv`, `sh/sj/sk/sl`)
- Search recentering (`n`, `N`)
- Terminal escape helper (`<leader><Esc>`)
- Open current file externally on Windows (`<leader>o`)

## Plugin Catalog

Below is the plugin set grouped by purpose.

### UI, UX, and editor feel

- `craftzdog/solarized-osaka.nvim` - Main colorscheme and theme customization
- `rebelot/heirline.nvim` - Custom statusline
- `folke/noice.nvim` - Better command line, messages, and notifications
- `tribela/transparent.nvim` - Transparent background support
- `sphamba/smear-cursor.nvim` - Cursor trail animation
- `NvChad/nvim-colorizer.lua` - Inline color previews
- `nvim-tree/nvim-web-devicons` - File icons
- `numToStr/Comment.nvim` - Fast commenting
- `windwp/nvim-autopairs` - Auto-close pairs/brackets
- `mg979/vim-visual-multi` - Multi-cursor editing
- `kevinhwang91/nvim-ufo` - Enhanced folds
- `folke/flash.nvim` - Navigation motions
- `oribarilan/lensline.nvim` - Lens-style inline info (**disabled**)

### Navigation, search, and workspace tools

- `folke/snacks.nvim` - Picker, explorer, terminal, dashboard, lazygit integration
- `ThePrimeagen/harpoon` - Mark and jump between important files
- `nvim-pack/nvim-spectre` - Project-wide search/replace
- `stevearc/oil.nvim` - File explorer (buffer-style)
- `nvim-telescope/telescope.nvim` - Fuzzy finder (**disabled**, Snacks picker is preferred)
- `nvimtools/hydra.nvim` - Transient keymaps (used for resizing)

### Git

- `lewis6991/gitsigns.nvim` - Git hunks/sign indicators
- `tpope/vim-fugitive` - Full Git workflow inside Neovim

### LSP, completion, snippets, and syntax

- `neovim/nvim-lspconfig` - LSP server setup and keymaps
- `williamboman/mason.nvim` - External tool/LSP installer
- `saghen/blink.cmp` - Completion engine
- `L3MON4D3/LuaSnip` - Snippet engine
- `nvim-treesitter/nvim-treesitter` - Syntax parsing/highlighting/folds
- `jlcrochet/vim-razor` - Razor/Cshtml support
- `seblyng/roslyn.nvim` - C# Roslyn integration
- `mfussenegger/nvim-jdtls` - Java integration helper

### Debugging and testing

- `mfussenegger/nvim-dap` - Debug Adapter Protocol core
- `rcarriga/nvim-dap-ui` - Debugger UI (dependency of DAP config)
- `nvim-neotest/neotest` - Test framework runner
- `Issafalcon/neotest-dotnet` - .NET test adapter

### Databases, markdown, and utilities

- `kristijanhusak/vim-dadbod-ui` + dadbod stack - SQL/database UI
- `MeanderingProgrammer/render-markdown.nvim` - Markdown rendering
- `epwalsh/obsidian.nvim` - Obsidian integration (**disabled**)
- `mistweaverco/kulala.nvim` - HTTP client workflows (**disabled**)
- `folke/todo-comments.nvim` - TODO/FIXME annotations
- `liangxianzhe/floating-input.nvim` - Floating `vim.ui.input`
- `derektata/lorem.nvim` - Lorem ipsum generator
- `eandrju/cellular-automaton.nvim` - Visual effects plugin
- `AndrewRadev/discotheque.vim` - Visual experimentation plugin

### AI / assistant integration

- `sudo-tee/opencode.nvim` - AI coding assistant workflow inside Neovim

## Language and Tooling Setup

### LSP

Configured in `lua/plugins/lsp.lua` with shared `on_attach` mappings and capabilities from `blink.cmp`.

Servers include:

- `lua_ls`, `clangd`, `pyright`, `ts_ls`, `cssls`, `jsonls`, `eslint`, `tailwindcss`, `html`, `emmet_language_server`, `vue_ls`, `gradle_ls`, `prismals`

### C#

- Roslyn support via `roslyn.nvim`
- Razor filetype mappings for `.razor` and `.cshtml`
- C# file template autocreation for empty/new `.cs` files
- Dedicated ftplugin (`ftplugin/csharp.lua`)

### Java

- `ftplugin/java.lua` handles jdtls startup and root/workspace detection

### Debugging

- DAP configuration is split under `lua/config/plugins/dap/`
- Includes C# and Python setup modules
- Uses a helper map set for breakpoint/run/step controls

### Testing

- `neotest` configured with a .NET adapter for running nearest/file/project tests

### Formatting

- `conform.nvim` spec exists but is currently disabled
- Formatting is primarily performed via `vim.lsp.buf.format()` mapping

## Filetype Overrides

- `ftplugin/csharp.lua` - C# local options
- `ftplugin/java.lua` - Java LSP startup routine

## Environment Assumptions

This setup is primarily tuned for Windows (with some mixed Unix/WSL references).

`init.lua` prepends these paths to `PATH`:

- `C:\ProgramData\mingw64\mingw64\bin`
- `C:\ProgramData\chocolatey\bin`
- `C:\Program Files\Git\cmd`

It also sets:

- `CC=gcc`
- `CXX=g++`

Some plugin/tool paths are machine-specific (for example debugger binaries and external CLI paths). If you clone this config on another machine, review hardcoded paths in DAP, Java, and assistant-related plugin configs.

## Recommended First Run

1. Launch `nvim`
2. Run `:Lazy sync`
3. Run `:Mason` and install missing tools/servers
4. Run `:checkhealth`
5. Open a project file and verify LSP, completion, and keymaps

## Troubleshooting

- If startup fails, check `lua/config/lazy.lua` first (lazy bootstrap/import)
- If plugin changes do not apply, run `:Lazy reload` or restart Neovim
- Use `:messages` for hidden startup/runtime errors
- Avoid editing `lazy-lock.json` manually
