vim.g.cmake_default_config = "build"
vim.g.cmake_console_size = 20

vim.keymap.set("n", "<leader>cmg", ":CMakeGenerate<cr>", { desc = "[cm]ake [g]enerate" })
vim.keymap.set("n", "<leader>cmb", ":CMakeBuild<cr>", { desc = "[cm]ake [b]uild" })
vim.keymap.set("n", "<leader>cmt", ":CMakeBuild ", { desc = "[cm]ake build [t]arget" })
vim.keymap.set("n", "<leader>cmo", ":CMakeOpen<cr>", { desc = "[cm]ake [o]pen build console" })
vim.keymap.set("n", "<leader>cmc", ":CMakeClose<cr>", { desc = "[cm]ake [c]lose build console" })
vim.keymap.set("n", "<leader>cmn", ":CMakeClean<cr>", { desc = "[cm]ake clea[n]" })

vim.keymap.set("n", "<leader>mb", ":make<cr>", { desc = "[m]ake [b]uild" })

vim.keymap.set("n", "<leader>sw", ":ClangdSwitchSourceHeader<cr>", { desc = "[s]witch to paired C/C++ file." })
vim.keymap.set("n", "<leader>cf", ":ClangFormat<cr>", { desc = "[C]lang [F]ormat" })

local cmake_group = vim.api.nvim_create_augroup("nvim_cmake", { clear = true })

vim.api.nvim_create_autocmd("User", {
        pattern = "CMakeBuildFailed",
        command = ":cfirst",
        group = cmake_group,
})
vim.api.nvim_create_autocmd("User", {
        pattern = "CMakeBuildSucceeded",
        command = ":CMakeClose",
        group = cmake_group,
})
