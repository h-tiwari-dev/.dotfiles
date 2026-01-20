-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.colorcolumn = "100"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard (use system clipboard)
opt.clipboard = "unnamedplus"

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- File handling
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- Update time (for better UX)
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Fold settings (using treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

-- Show invisible characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Mouse support
opt.mouse = "a"

-- Confirm to save changes before exiting
opt.confirm = true
