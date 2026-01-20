require("msakai.core")
require("msakai.lazy")

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})

vim.cmd([[
	set expandtab
	set autoindent
	set smartindent
	set tabstop=2
	set shiftwidth=2
	set number
	set hlsearch
	set ignorecase
	set incsearch
	set laststatus=2
	set clipboard=unnamedplus
	syntax on

	ignoremap <silent> jk <ESG>
]])
