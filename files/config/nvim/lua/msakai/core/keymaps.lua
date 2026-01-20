vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode with jk" })

-- tab new file
keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
-- tab close
keymap.set("n", "<leader>te", ":tabclose<CR>", { desc = "Close tab" })
-- tab next
keymap.set("n", "<leader>to", ":tabnext<CR>", { desc = "Next tab" })
-- tab previous
keymap.set("n", "<leader>te", ":tabprevious<CR>", { desc = "Previous tab" })

