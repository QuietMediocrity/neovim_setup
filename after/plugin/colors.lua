require("github-theme").setup({
	theme_style = "dark",
	colors = {
		syntax = {
			keyword = "#44a167",
                        func = "#e1e4e8",
		},
	},
})

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.api.nvim_command("hi statusline guibg=#24292e guifg=#bdbdbd")
