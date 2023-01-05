vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves a line up in visual mode." })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves a line down in visual mode." })

-- keeps things centered on jumps
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever (doesn't replace the contents of the buffer on paste)
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- yank the whole file?
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- let's not talk about it.
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format file" })

vim.keymap.set("n", "<C-[>", "<cmd>cnext<CR>zz", { desc = "Jump to next error" })
vim.keymap.set("n", "<C-]>", "<cmd>cprev<CR>zz", { desc = "Jump to previous error" })
vim.keymap.set("n", "<leader>[", "<cmd>lnext<CR>zz", { desc = "Jump to next error in current buffer" })
vim.keymap.set("n", "<leader>]", "<cmd>lprev<CR>zz", { desc = "Jump to previous error in current buffer" })

vim.keymap.set("n", "<C-j>", "m`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>", { desc = "Deletes empty line below the cursor" })
vim.keymap.set("n", "<C-k>", "m`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>", { desc = "Deletes empty line above the cursor"})
vim.keymap.set("n", "<A-j>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>", { desc = "Adds empty line below the cursor" })
vim.keymap.set("n", "<A-k>", ":set paste<CR>m`O<Esc>``:set nopaste<CR>", { desc = "Adds empty line above the cursor" })

vim.keymap.set("n", "<leader>bn", ":bnext<cr>", { desc = "[n]ext [b]uffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<cr>", { desc = "[p]revious [b]uffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<cr>", { desc = "[d]elete [b]uffer" })
vim.keymap.set("n", "<leader>ba", ":badd", { desc = "[a]dd [b]uffer" })
vim.keymap.set("n", "<leader>bb", ":%bd<cr>", { desc = "Close all buffers" })
