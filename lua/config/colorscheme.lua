-------------------------------------------------------
-- Colorscheme: tokyonight (via vim.pack)
-- Variants: tokyonight-night / -storm / -moon / -day
-------------------------------------------------------
vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })

-- Fall back to the built-in habamax if the plugin isn't available yet
if not pcall(vim.cmd.colorscheme, "tokyonight-night") then
  vim.cmd.colorscheme("habamax")
end
