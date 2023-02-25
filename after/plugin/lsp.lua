local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
        "clangd",
})

local cmp = require("cmp")
local cmp_select = { behaviour = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-a>"] = cmp.mapping.confirm({ select = true }),
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

local lspkind_comparator = function(conf)
        local lsp_types = require('cmp.types').lsp
        return function(entry1, entry2)
                if entry1.source.name ~= 'nvim_lsp' then
                        if entry2.source.name == 'nvim_lsp' then
                                return false
                        else
                                return nil
                        end
                end
                local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
                local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

                local priority1 = conf.kind_priority[kind1] or 0
                local priority2 = conf.kind_priority[kind2] or 0
                if priority1 == priority2 then
                        return nil
                end
                return priority2 < priority1
        end
end

local label_comparator = function(entry1, entry2)
        return entry1.completion_item.label < entry2.completion_item.label
end

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
                comparators = {
                        lspkind_comparator({
                                kind_priority = {
                                        Field = 11,
                                        Property = 11,
                                        Constant = 10,
                                        Enum = 10,
                                        EnumMember = 10,
                                        Event = 10,
                                        Function = 10,
                                        Method = 10,
                                        Operator = 10,
                                        Reference = 10,
                                        Struct = 10,
                                        Variable = 9,
                                        File = 8,
                                        Folder = 8,
                                        Class = 5,
                                        Color = 5,
                                        Module = 5,
                                        Keyword = 2,
                                        Constructor = 1,
                                        Interface = 1,
                                        Snippet = 0,
                                        Text = 1,
                                        TypeParameter = 1,
                                        Unit = 1,
                                        Value = 1,
                                },
                        }),
                        label_comparator,
                },
        })

        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "<leader>gD", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "<leader>gi", function() vim.lsp.buf.impementation() end, opts)
        vim.keymap.set("n", "<leader>gt", function() vim.lsp.buf.type_definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

        vim.keymap.set("n", "<leader>df", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>dn", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "<leader>dp", function() vim.diagnostic.goto_prev() end, opts)

        vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)

        vim.api.nvim_create_autocmd("CursorHold", {
                buffer = bufnr,
                callback = function()
                        local options = {
                                focusable = false,
                                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                                border = 'rounded',
                                source = 'always',
                                prefix = ' ',
                                scope = 'cursor',
                        }
                        vim.diagnostic.open_float(nil, options)
                end
        })
end)

lsp.setup()

require("luasnip.loaders.from_snipmate").lazy_load({paths = "~/.config/nvim/snippets"})
