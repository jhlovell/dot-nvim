-------------------------------------------------------
-- Keymaps (global; LSP-only maps live in config/lsp.lua)
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
