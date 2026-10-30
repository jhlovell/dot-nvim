-------------------------------------------------------
-- Leader key
-- Set before anything defines <leader> mappings.
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
