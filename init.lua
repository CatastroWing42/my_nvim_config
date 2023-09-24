vim.g.mapleader = ' '
local opt = vim.opt

opt.number = true
-- opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.wrap = false
opt.ignorecase = true
opt.hlsearch = true
opt.incsearch = true


-- opt.cursorline = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

opt.swapfile = false


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "bluz71/vim-nightfly-guicolors", priority = 1000
    },
    --{
    --  "folke/tokyonight.nvim",
    --  lazy = false,
    --  priority = 1000,
    --  opts = {},
    --}
    {
          "nvim-tree/nvim-tree.lua",
          version = "*",
          lazy = false,
          dependencies = {
            "nvim-tree/nvim-web-devicons",
          },
          config = function()
            require("nvim-tree").setup {
                filters = {
                    dotfiles = true,
                },
            }
          end,
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
             -- Set up nvim-cmp.
            local cmp = require'cmp'

            cmp.setup({
            snippet = {
              -- REQUIRED - you must specify a snippet engine
              expand = function(args)
                --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
              end,
            },
            window = {
              -- completion = cmp.config.window.bordered(),
              -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              --{ name = 'vsnip' }, -- For vsnip users.
               { name = 'luasnip' }, -- For luasnip users.
              -- { name = 'ultisnips' }, -- For ultisnips users.
              -- { name = 'snippy' }, -- For snippy users.
            }, {
              { name = 'buffer' },
            })
            })

            -- Set configuration for specific filetype.
            cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
              { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
            }, {
              { name = 'buffer' },
            })
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' }
            }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
            })

            -- Set up lspconfig.
            --local capabilities = require('cmp_nvim_lsp').default_capabilities()
            -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
            --require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
                --capabilities = capabilities
            --}
        end
    },
    { "rafamadriz/friendly-snippets" },
    { "tpope/vim-fugitive" },
    { "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "gruvbox"
                }
            })
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.3',
        dependencies = {
            "BurntSushi/ripgrep",
            "sharkdp/fd",
            "nvim-treesitter/nvim-treesitter"
        }
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- import cmp-nvim-lsp plugin
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            local my_attach = function(client, bufnr)
                local keymap = vim.keymap -- for conciseness

                local opts = { noremap = true, silent = true }
              opts.buffer = bufnr

              -- set keybinds
              opts.desc = "Show LSP references"
              keymap.set("n", "<C-]>", vim.lsp.buf.references, opts) -- show definition, references

              opts.desc = "Go to declaration"
              keymap.set("n", "<C-[>", vim.lsp.buf.declaration, opts) -- go to declaration

              opts.desc = "Show LSP definitions"
              keymap.set("n", "<C-[>", vim.lsp.buf.definitions, opts) -- show lsp definitions

              opts.desc = "Show LSP implementations"
              keymap.set("n", "<C-[>", vim.lsp.buf.implementations, opts) -- show lsp implementations

              opts.desc = "Show LSP type definitions"
              keymap.set("n", "<C-[>", vim.lsp.buf.type_definition, opts) -- show lsp type definitions

              opts.desc = "See available code actions"
              keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

              opts.desc = "Smart rename"
              keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

              opts.desc = "Show buffer diagnostics"
              keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

              opts.desc = "Show line diagnostics"
              keymap.set("n", "<space>e", vim.diagnostic.open_float, opts) -- show diagnostics for line

              opts.desc = "Go to previous diagnostic"
              --keymap.set("n", "<C-K>", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

              opts.desc = "Go to next diagnostic"
              --keymap.set("n", "<C-J>", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

              opts.desc = "Show documentation for what is under cursor"
              keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

              opts.desc = "Restart LSP"
              keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
            end

            -- used to enable autocompletion (assign to every lsp server config)
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- Change the Diagnostic symbols in the sign column (gutter)
            -- (not in youtube nvim video)
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
              local hl = "DiagnosticSign" .. type
              vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            lspconfig["clangd"].setup({
              capabilities = capabilities,
              on_attach = my_attach,
            })
            lspconfig["pylsp"].setup({
              capabilities = capabilities,
              on_attach = my_attach,
            })
        end,
    }
})

vim.cmd([[colorscheme nightfly]])

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local ls = require("luasnip")
--vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-l>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-h>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-e>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})
require("luasnip.loaders.from_vscode").lazy_load()
ls.filetype_extend("c", { "cdoc" })
ls.filetype_extend("cpp", { "cppdoc" })
ls.filetype_extend("sh", { "shelldoc" })
ls.filetype_extend("python", { "pydoc" })
ls.filetype_extend("rust", { "rustdoc" })

tree_opt = {path = "./"}
vim.keymap.set('n', 'tt',     function() require("nvim-tree.api").tree.open(tree_opt) end, {})

vim.keymap.set('n', '<C-j>',     ":cnext<CR>", {silent = true})
vim.keymap.set('n', '<C-k>',     ":cprev<CR>", {silent = true})
vim.keymap.set('n', '<C-h>',     ":col<CR>", {silent = true})
vim.keymap.set('n', '<C-l>',     ":cnew<CR>", {silent = true})
--opt.ma = true

local builtin = require('telescope.builtin')
--local actions = require('telescope.actions')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<C-\\>', builtin.grep_string, {})

--actions.smart_send_to_qflist()
--actions.open_qflist()
