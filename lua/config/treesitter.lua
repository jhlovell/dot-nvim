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
  "bash", "json", "toml", "yaml", "java",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    -- pcall: filetypes without a parser keep regex syntax highlighting
    pcall(vim.treesitter.start, args.buf)
  end,
  desc = "Start treesitter highlighting when a parser exists",
})
