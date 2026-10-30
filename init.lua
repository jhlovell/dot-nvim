--[[
  Minimal Neovim config — the only plugins are tokyonight and
  nvim-treesitter, installed with the built-in vim.pack plugin manager
  (Neovim 0.12+).
  Place this at:
    Linux/Mac: ~/.config/nvim/init.lua
    Windows:   ~\AppData\Local\nvim\init.lua

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

  Format-on-save is enabled below for every language above except Lua
  (Python is formatted by ruff's LSP). lua_ls isn't used for formatting,
  so Lua is instead formatted on save by shelling out to an external
  formatter.
    - stylua                         (Lua)     -> cargo install stylua
--]]

-------------------------------------------------------
-- Leader key
-------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------------------------------------------------
-- Core options
-------------------------------------------------------
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- sync with system clipboard
opt.breakindent = true
opt.undofile = true           -- persistent undo across sessions
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.termguicolors = true
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.wrap = false
opt.cursorline = true
opt.laststatus = 3 -- one global statusline
opt.pumheight = 10 -- shorter completion popup

-- Indentation: 2 spaces, adjust shiftwidth/tabstop if you prefer 4
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Show whitespace
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Native completion menu behavior (used by vim.lsp.completion below)
opt.completeopt = { "menuone", "noselect", "popup" }

-------------------------------------------------------
-- Colorscheme: tokyonight (via vim.pack)
-- Variants: tokyonight-night / -storm / -moon / -day
-------------------------------------------------------
vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })

-- Fall back to the built-in habamax if the plugin isn't available yet
if not pcall(vim.cmd.colorscheme, "tokyonight-night") then
  vim.cmd.colorscheme("habamax")
end

-------------------------------------------------------
-- Treesitter (via the built-in vim.pack plugin manager)
-- nvim-treesitter's main branch only installs parsers/queries; highlighting
-- is started per-buffer below. Parser builds need the tree-sitter CLI and
-- a C compiler. Update with :lua vim.pack.update() then :TSUpdate.
-------------------------------------------------------
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- Already-installed parsers are skipped; missing ones install asynchronously.
require("nvim-treesitter").install({
  "c", "cpp", "rust", "go", "gomod", "python",
  "javascript", "typescript", "tsx", "html", "css", "scss",
  "lua", "vim", "vimdoc", "markdown", "markdown_inline",
  "bash", "json", "toml", "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    -- pcall: filetypes without a parser keep regex syntax highlighting
    pcall(vim.treesitter.start, args.buf)
  end,
  desc = "Start treesitter highlighting when a parser exists",
})

-------------------------------------------------------
-- Keymaps
-------------------------------------------------------
local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation: intentionally NOT remapped to <C-h/j/k/l>.
-- Vim's built-in <C-w>h / <C-w>j / <C-w>k / <C-w>l already switch windows,
-- identically in vanilla Vim and Neovim, with no custom mapping required.
-- (Adding <C-h/j/k/l> shortcuts would shadow real vim defaults: <C-l>
-- redraws the screen, <C-h> is backspace, <C-j> is like pressing j.)

-- File / session basics
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Open file explorer (netrw)" })

-------------------------------------------------------
-- Diagnostics display
-------------------------------------------------------
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  severity_sort = true,
})

-------------------------------------------------------
-- Native LSP setup (Neovim 0.11+, no plugins)
-- Each server config below is written by hand since nvim-lspconfig
-- (the plugin that normally ships these) is not installed.
-------------------------------------------------------

-- C / C++
vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { ".clangd", "compile_commands.json", ".git" },
})

-- Rust
vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
})

-- Go
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", ".git" },
})

-- Python
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
})

vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
})

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' }
})

-- TypeScript / JavaScript
vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", "tsconfig.json", ".git" },
})

-- HTML
vim.lsp.config("html", {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { "package.json", ".git" },
})

-- CSS / SCSS / LESS
vim.lsp.config("cssls", {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
})

-- Lua (so this config file itself gets LSP support: hover, completion, diagnostics)
vim.lsp.config("lua_ls", {
  cmd = { "/home/jacob/apps/lua-language-server/bin/lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },                    -- Neovim ships LuaJIT
      diagnostics = { globals = { "vim" } },               -- don't flag `vim` as undefined
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true), -- know about Neovim's own Lua API
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.enable({
  "clangd",
  "rust_analyzer",
  "gopls",
  "ty",
  "ruff",
  --  "pyright",
  "ts_ls",
  "html",
  "cssls",
  "lua_ls",
})

-------------------------------------------------------
-- Format on save
-------------------------------------------------------

-- For clangd / rust_analyzer / gopls / ruff / ts_ls / html / cssls,
-- format-on-save is wired up automatically below (inside the LspAttach
-- autocmd) using each server's own LSP formatting support.

-- lua_ls isn't used for formatting, so Lua is formatted on save by
-- shelling out to stylua instead. Runs via stdin/stdout, wrapped
-- in pcall, so a missing/failing formatter is a silent no-op rather than
-- something that errors on every save or corrupts the buffer.
local function format_with_stdin(cmd)
  return function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local input = table.concat(lines, "\n") .. "\n"
    local ok, result = pcall(function()
      return vim.system(cmd, { stdin = input, text = true }):wait()
    end)
    if ok and result.code == 0 and result.stdout and #result.stdout > 0 then
      local view = vim.fn.winsaveview()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(result.stdout, "\n", { trimempty = true }))
      vim.fn.winrestview(view)
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = format_with_stdin({ "stylua", "-" }),
  desc = "Format Lua on save with stylua",
})

-- Keymaps + native autocomplete, applied only in buffers with an active LSP client
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = bufnr }

    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    -- Python runs two servers: ty for types/hover/completion, ruff for
    -- lint/format. Let ty own hover so K doesn't show two popups.
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

    -- Capability is checked at save time, not here: some servers (ruff)
    -- register formatting dynamically after LspAttach fires. One augroup per
    -- buffer so multiple attached clients don't stack duplicate hooks.
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("lsp_format_" .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function()
        if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" }) > 0 then
          vim.lsp.buf.format({ bufnr = bufnr, async = false, timeout_ms = 2000 })
        end
      end,
      desc = "Format on save via LSP",
    })

    -- K and gd shadow vim's built-in keyword/man lookup and local-declaration
    -- search, but ONLY inside buffers with an LSP client attached — a
    -- Neovim-only feature that doesn't exist in vanilla vim. On vanilla vim
    -- (no LSP), K and gd keep their normal default behavior untouched.
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    -- Not [d / ]d: those are vim's built-in "jump to macro definition"
    -- (:help [d), which you'll actually want for C/C++. Using leader here
    -- instead avoids shadowing that default.
    map("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
    map("n", "<leader>dn", vim.diagnostic.goto_next, opts)
  end,
})
