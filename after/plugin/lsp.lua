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

vim.diagnostic.config({
        virtual_text = false,
        float = ({
                border = 'rounded',
                source = 'always',
        }),
})

lsp.set_preferences({
        sign_icons = {}
})

lsp.setup_nvim_cmp({
        mappings = cmp_mappings
})

local lspkind = require('lspkind')
local luasnip = require('luasnip')

lsp.on_attach(function(client, bufnr)
        cmp.setup({
                window = ({
                        documentation = cmp.config.window.bordered()
                }),
                formatting = ({
                        fields = ({
                                cmp.ItemField.Abbr,
                                cmp.ItemField.Kind,
                                cmp.ItemField.Menu,
                        }),
                        -- format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
                        format = lspkind.cmp_format({
                                mode = 'text',
                                maxwidth = 65,
                                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                                with_text = true,
                        })
                }),
                mapping = ({
                        ["<Tab>"] = cmp.mapping(function(fallback)
                                if cmp.visible() then
                                        cmp.select_next_item()
                                elseif luasnip.expand_or_jumpable() then
                                        luasnip.expand_or_jump()
                                else
                                        fallback()
                                end
                        end, { "i", "s" }),

                        ["<S-Tab>"] = cmp.mapping(function(fallback)
                                if cmp.visible() then
                                        cmp.select_prev_item()
                                elseif luasnip.jumpable(-1) then
                                        luasnip.jump(-1)
                                else
                                        fallback()
                                end
                        end, { "i", "s" }),
                }),
                snippet = {
                        expand = function(args)
                                if not luasnip then
                                        return
                                end
                                luasnip.lsp_expand(args.body)
                        end,
                },
        })

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

        vim.api.nvim_create_autocmd("CursorHold", {
                buffer = bufnr,
                callback = function()
                        local opts = {
                                focusable = false,
                                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                                border = 'rounded',
                                source = 'always',
                                prefix = ' ',
                                scope = 'cursor',
                        }
                        vim.diagnostic.open_float(nil, opts)
                end
        })
end)

lsp.setup()
