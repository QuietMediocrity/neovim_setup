local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	"sumneko_lua",
	"clangd",
})

local cmp = require("cmp")
local cmp_select = { behaviour = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-y>"] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

lsp.set_preferences({
        sign_icons = { }
})

lsp.setup_nvim_cmp({
	mappings = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "<leader>gD", function() vim.lsp.buf.declaration() end, opts)
	vim.keymap.set("n", "<leader>gi", function() vim.lsp.buf.impementation() end, opts)
	vim.keymap.set("n", "<leader>gt", function() vim.lsp.buf.type_definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

	vim.keymap.set("n", "<leader>df", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

	vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()
