--[[
  Minimal Neovim config — the only plugins are tokyonight and
  nvim-treesitter, installed with the built-in vim.pack plugin manager
  (Neovim 0.12+).
  Place this at:
    Linux/Mac: ~/.config/nvim/init.lua
    Windows:   ~\AppData\Local\nvim\init.lua
  (with the lua/config/ directory alongside it)

  Requires Neovim 0.12+ (for vim.pack, vim.lsp.config / vim.lsp.enable / vim.lsp.completion).

  There is no LSP plugin, so LSP servers must be installed on your
  system separately (not managed by this config). Install whichever
  of these you need:
    - clangd                         (C / C++)
    - rust-analyzer                  (Rust)
    - gopls                          (Go)
    - ty + ruff                      (Python)  -> uv tool install ty ruff
    - typescript-language-server     (JS/TS)   -> npm i -g typescript-language-server typescript
    - vscode-langservers-extracted   (HTML/CSS)-> npm i -g vscode-langservers-extracted
    - lua-language-server            (Lua, for editing this config)
                                                -> https://github.com/LuaLS/lua-language-server#installation

  Format-on-save (lua/config/format.lua) is enabled for every language
  above except Lua (Python is formatted by ruff's LSP). lua_ls isn't used
  for formatting, so Lua is instead formatted on save by shelling out to
  an external formatter.
    - stylua                         (Lua)     -> cargo install stylua
--]]

require("config.options")     -- leader key + core editor options (must load first)
require("config.colorscheme") -- tokyonight
require("config.treesitter")  -- parsers + highlighting
require("config.keymaps")     -- global keymaps
require("config.diagnostics") -- diagnostic display
require("config.lsp")         -- server configs + LSP keymaps
require("config.completion")  -- native LSP autocomplete
require("config.format")      -- format on save (LSP + stylua)
