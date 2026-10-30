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

-- Lua (so this config itself gets LSP support: hover, completion, diagnostics)
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
-- Per-buffer LSP behavior: keymaps and server tweaks,
-- applied only in buffers with an active LSP client.
-- (Completion and format-on-save attach in their own modules.)
-------------------------------------------------------
local map = vim.keymap.set

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = bufnr }

    -- Python runs two servers: ty for types/hover/completion, ruff for
    -- lint/format. Let ty own hover so K doesn't show two popups.
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

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
