# AGENTS.md

## Overview
- This repo is a personal Neovim configuration (Lua-based).
- Entry point: `init.lua` → `lua/config/init.lua`.
- Plugin management uses `lazy.nvim` with specs under `lua/plugins/`.
- Lazy bootstrap is initialized in `lua/config/lazy.lua` (required from `lua/config/init.lua`). If startup breaks, check this first.

## Architecture
- `lua/config/`: core editor setup (options, keymaps, autocmds, lazy bootstrap, language-specific config).
- `lua/plugins/`: one file per plugin (lazy.nvim spec tables).
- `ftplugin/`: filetype-specific overrides.
- `lazy-lock.json`: pinned plugin versions; do not edit manually.

## Plugin System (lazy.nvim)
- Plugins are declared as modules in `lua/plugins/*.lua` and auto-loaded via:
  - `require("lazy").setup({ spec = { { import = "plugins" } } })`
- Each file should return a spec table (or list of specs).
- Prefer modifying existing plugin specs instead of creating duplicates.
- After changes, run inside Neovim:
  - `:Lazy sync` (install/update plugins)
  - `:Lazy reload` (reload specs without full restart when possible)
  - Restart Neovim if behavior seems stale (common after keymap/LSP changes).

## Key Conventions
- Keep config split by concern (don’t dump logic into `init.lua`).
- Follow existing pattern: small, focused plugin files.
- Avoid introducing new plugin managers or restructuring lazy setup.
- Prefer extending existing config modules over creating new top-level ones.

## LSP / Tooling
- LSP, DAP, and tooling are configured via plugins (see `lua/plugins/lsp.lua`, `mason.lua`, `dap.lua`).
- Mason is used for installing external tools; changes may require `:Mason`.
- If a server/tool is missing, install via `:Mason` rather than adding ad-hoc setup code.

## Verification
- There is no test suite. Verify by launching Neovim:
  - `nvim`
- Check for errors on startup and when triggering plugin features.
- Use:
  - `:checkhealth`
  - `:Lazy`
  - `:messages` (for startup/runtime errors that didn’t surface clearly)

## Common Pitfalls
- Breaking lazy spec structure (must return valid tables).
- Forgetting to run `:Lazy sync` after adding plugins.
- Duplicating plugin definitions across files.
- Editing generated or lock files (`lazy-lock.json`).
- Adding the same plugin in multiple files (lazy will merge specs, causing subtle bugs).
- Misplacing config: plugin-specific setup should live in its spec, not global config.

## Safe Changes
- Adding a plugin: create a new file in `lua/plugins/` or extend an existing one.
- Updating config: modify relevant module in `lua/config/`.
- Filetype behavior: use `ftplugin/`.
- Keymaps: prefer defining in `lua/config/keymaps.lua` unless tightly coupled to a plugin (then keep in that plugin spec).
- Options/autocmds: keep in `lua/config/` modules; avoid scattering across plugin files.

If unsure, follow the pattern used by nearby files—this repo is highly consistent.
