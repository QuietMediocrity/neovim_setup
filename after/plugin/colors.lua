require("github-theme").setup({
	theme_style = "dark",
	colors = {
		syntax = {
			keyword = "#46ad6c"
		}
	},
})

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.api.nvim_command("hi statusline guibg=#24292e guifg=#bdbdbd")
