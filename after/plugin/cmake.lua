vim.g.cmake_default_config = "build"
vim.g.cmake_console_size = 40

vim.keymap.set("n", "<leader>cmg", ":CMakeGenerate<cr>", { desc = "[cm]ake [g]enerate" })
vim.keymap.set("n", "<leader>cmb", ":CMakeBuild<cr>", { desc = "[cm]ake [b]uild" })
vim.keymap.set("n", "<leader>cmt", ":CMakeBuildTarget<cr>", { desc = "[cm]ake build [t]arget" })
vim.keymap.set("n", "<leader>cmo", ":CMakeOpen<cr>", { desc = "[cm]ake [o]pen build console" })
vim.keymap.set("n", "<leader>cmc", ":CMakeClose<cr>", { desc = "[cm]ake [c]lose build console" })
vim.keymap.set("n", "<leader>cmn", ":CMakeClean<cr>", { desc = "[cm]ake clea[n]" })

vim.keymap.set("n", "<leader>mb", ":make<cr>", { desc = "[m]ake [b]uild" })
vim.keymap.set("n", "<leader>mo", ":make<cr>", { desc = "[m]ake [o]pen output" })
vim.keymap.set("n", "<leader>mc", ":make<cr>", { desc = "[m]ake [c]lose output" })

vim.keymap.set("n", "<leader>cf", ":ClangFormat<cr>", { desc = "[C]lang [F]ormat" })

-- qm_todo: I am not sure those commands work...
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
