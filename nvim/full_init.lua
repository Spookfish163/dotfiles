-- Set leader key
vim.g.mapleader = " "

-- Basic settings
vim.opt.background = 'dark'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.syntax = 'on'
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.signcolumn = 'yes'
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Toggle relative/absolute line numbers based on mode
vim.api.nvim_create_autocmd({ 'InsertEnter', 'FocusLost', 'WinLeave' }, {
    callback = function()
        vim.opt.relativenumber = false
    end,
})
vim.api.nvim_create_autocmd({ 'InsertLeave', 'FocusGained', 'WinEnter' }, {
    callback = function()
        vim.opt.relativenumber = true
    end,
})

-- Different cursor shapes for different modes
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Set conceallevel 1 for Obsidian.nvim
vim.opt.conceallevel = 1

-- Better line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Better navigation through very long lines
if vim.o.wrap then
  vim.keymap.set("n", "j", [[v:count ? 'j' : 'gj']], { expr = true })
  vim.keymap.set("n", "k", [[v:count ? 'k' : 'gk']], { expr = true })
end

-- Centered scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Faster scrolling
vim.keymap.set('n', '<C-y>', '<C-y><C-y>')
vim.keymap.set('n', '<C-e>', '<C-e><C-e>')

-- Disable backticks
vim.keymap.set('n', '`', '<NOP>')
vim.keymap.set('n', '``', '<NOP>')
vim.keymap.set('n', '```', '<NOP>')

-- Jump to EOL without leaving insert mode
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'Jump to end of line' })

-- Fast highlight clear
vim.keymap.set('n', '<leader>cc', '<cmd>nohlsearch<CR>')

-- Turn on spellchecker
vim.keymap.set('n', '<leader>cs', '<cmd>setlocal spell spelllang=en_gb<cr>', { desc = 'Turn on spell checker' })

-- System clipboard keymaps
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })

-- Pomodoro mappings
vim.keymap.set("n", "<leader>ts", "<cmd>PomoStart<cr>", { desc = "Pomo: Start Pomodoro" })
vim.keymap.set("n", "<leader>tp", "<cmd>PomoPause<cr>", { desc = "Pomo: Pause/Resume" })
vim.keymap.set("n", "<leader>td", "<cmd>Pomo<cr>", { desc = "Pomo: Show Dashboard" })

-- LSP keybinds
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>lu", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename)

-- Obsidian keybinds
vim.keymap.set("n", "<leader>nn", "<cmd>Obsidian new Brain/<cr>", { desc = "New brain note" })
vim.keymap.set("n", "<leader>ne", "<cmd>Obsidian new Notes/<cr>", { desc = "New ephemeral note" })
vim.keymap.set("n", "<leader>ng", "<cmd>Obsidian new Hobbies/Delta\\ Green/MERIDIAN/<cr>", { desc = "New TTRPG note" })
vim.keymap.set("n", "<leader>np", "<cmd>Obsidian new Hobbies/Piano/<cr>", { desc = "New piano note" })
vim.keymap.set("n", "<leader>nr", "<cmd>Obsidian rename<cr>", { desc = "LSP-like rename ability" })
vim.keymap.set("n", "<leader>nd", "<cmd>Obsidian today<cr>", { desc = "Open daily note" })
vim.keymap.set("n", "<leader>na", "<cmd>Obsidian template<cr>", { desc = "Add template" })
vim.keymap.set("n", "<leader>nb", "<cmd>Obsidian backlinks<cr>", { desc = "Show backlinks" })
vim.keymap.set("n", "<leader>ni", "<cmd>Obsidian paste_img<cr>",
    { desc = "Paste an img link from clipboard, and create asset note" })
vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian tags<cr>", { desc = "Browse tags" })
vim.keymap.set("n", "<leader>nf", "<cmd>Obsidian search<cr>", { desc = "Search notes" })
vim.keymap.set("n", "<leader>nq", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick switch notes" })
vim.keymap.set('n', '<leader>nt', function()
    vim.cmd('edit /var/home/phillip/Documents/syncing_folder/Obsidian_Vaults/Personal/Todo/Todo.md')
end, { desc = 'Open Todo' })

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({

    -- Gitsigns
    {
        'lewis6991/gitsigns.nvim',
        event = 'VeryLazy',
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                vim.keymap.set('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr })

                vim.keymap.set('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr })

                vim.keymap.set('n', '<leader>gt', gs.toggle_current_line_blame, { buffer = bufnr })
            end
        }
    },

    -- Pomodoro
    {
        "4DRIAN0RTIZ/pomo.nvim",
        cmd = { "PomoStart", "PomoPause", "Pomo" },
        config = function()
            require("pomo").setup({})
        end,
    },

    -- Lualine
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = 'gruvbox-material',
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_x = {
                    {
                        function()
                            if package.loaded["pomo"] then
                                return require("pomo").get_lualine_status() or ""
                            end
                            return ""
                        end,
                        --cond = function()
                        --    local ok, pomo = pcall(require, "pomo")
                        --    return ok and pomo.get_lualine_status() ~= ""
                        --end,
                    },
                    'encoding',
                    'fileformat',
                    'filetype'
                },
            },
        },
    },

    -- Import obsidian.nvim setup from its own file
    { import = "plugins" },

    -- Scribble notes
    {
        'Spookfish163/scribble.nvim',
        event = "VeryLazy",
        config = function()
            local scribble = require("scribble")
            scribble.setup({
                pos = "center",
                extension = ".md",
                width = 90,
                height = 42,
                auto_save = true,
                path = "/var/home/phillip/Documents/syncing_folder/Obsidian_Vaults/Personal/Scribbles/",
                encoding = "underscore",
            })
            vim.keymap.set("n", "<leader>s", scribble.toggle, { desc = "Toggle Scribble" })
        end,
    },

    -- Toggleterm
    {
        'akinsho/toggleterm.nvim',
        version = "2.*",
        keys = {
            { '<C-t>', '<cmd>ToggleTerm<cr>', mode = { 'n', 't' }, desc = 'Toggle terminal' },
        },
        opts = { size = 15 },
    },

    -- Oil file manager
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        config = function()
            require("oil").setup({
                use_default_keymaps = false,
                keymaps = {
                    ["<leader>o"] = "actions.close",
                    ["<Tab>"] = "actions.select",
                    ["-"] = { "actions.parent", mode = "n" },
                    ["_"] = { "actions.open_cwd", mode = "n" },
                },
                view_options = {
                    show_hidden = true,
                },
            })
            vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "Open oil file manager" })
        end
    },

    -- fzf lua
    {
        'ibhagwan/fzf-lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('fzf-lua').setup({
                winopts = {
                    height = 0.9,
                    width = 0.9,
                    preview = {
                        vertical = 'up:50%',
                    },
                },
                keymap = {
                    fzf = {
                        ["tab"] = "accept",
                    },
                },
                files = {
                    file_ignore_patterns = {
                        "%.git/", "node_modules/", "__pycache__/", "Personal/Utils/",
                    },
                },
            })
            -- Keybinds
            vim.keymap.set('n', '<leader>ff', require('fzf-lua').files, { desc = 'Find files' })
            vim.keymap.set('n', '<leader>fF', function()
                require('fzf-lua').files({ cwd = '..' })
            end, { desc = 'Find files parent dir' })
            vim.keymap.set('n', '<leader>fg', require('fzf-lua').blines, { desc = 'Live grep current file' })
            vim.keymap.set('n', '<leader>fG', require('fzf-lua').live_grep, { desc = 'Live grep' })
            vim.keymap.set('n', '<leader>fb', require('fzf-lua').buffers, { desc = 'Find buffers' })
            vim.keymap.set('n', '<leader>fz', require('fzf-lua').zoxide, { desc = 'Zoxide directories' })
        end,
    },

    -- Undotree
    {
        "jiaoshijie/undotree",
        config = function()
            require('undotree').setup({
                float_diff = true,
                position = "bottom",
                keymaps = {
                    ['<Tab>'] = "enter",
                },
                window = {
                    winblend = 0,
                    border = "solid",
                },
            })
        end,
        keys = {
            { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
        },
    },

    -- Markdown preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.keymap.set('n', '<leader>ww', '<cmd>MarkdownPreview<cr>')
            vim.keymap.set('n', '<leader>ws', '<cmd>MarkdownPreviewStop<cr>')
        end,
        ft = { "markdown" },
    },

    -- Mini pairs
    {
        "nvim-mini/mini.pairs",
        version = false,
        event = "InsertEnter",
        config = function()
            vim.keymap.set('i', '<BS>', '<BS>', { desc = 'Normal backspace' })
            require('mini.pairs').setup()
        end,
    },
    -- Mini surround
    {
        'nvim-mini/mini.surround',
        version = false,
        keys = {
            { "sa", mode = { "n", "v" } },
            { "sd", mode = "n" },
            { "sr", mode = "n" },
            { "sf", mode = { "n", "v" } },
            { "sF", mode = { "n", "v" } },
            { "sh", mode = { "n", "v" } },
            { "sn", mode = { "n", "v" } },
        },
        config = true,
    },

    -- Vim tmux navigator
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = 'main',
        build = ":TSUpdate",
        config = function()
            require 'nvim-treesitter'.setup {
                install_dir = vim.fn.stdpath('data') .. '/site'
            }
            require 'nvim-treesitter'.install { "python", "rust", "c", "bash", "lua", "query", "markdown", "markdown_inline" }

            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'python', 'rust', 'c', 'cpp', 'bash', 'sh', 'lua', 'markdown' },
                callback = function()
                    vim.treesitter.start()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    -- fix for end_col errors
                    if vim.bo.filetype == "markdown" then
                        vim.g._ts_force_sync_parsing = true
                    end
                end,
            })
        end,
    },

    -- "Trouble" diagnostic viewing
    {
        "folke/trouble.nvim",
        opts = {
            warn_no_results = false,
            open_no_results = true,
            win = {
                size = 10,
            },
            modes = {
                symbols = {
                    win = { size = 40 },
                },
            },
            keys = {
                ["<Tab>"] = "jump",
            },
        },
        cmd = "Trouble",
        keys = {
            -- Toggle virtual lines with trouble window
            {
                "<leader>m",
                function()
                    local trouble = require("trouble")
                    local is_open = trouble.is_open("diagnostics")
                    vim.diagnostic.config({
                        virtual_lines = not is_open,
                    })
                    trouble.toggle("diagnostics")
                end,
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>h",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
        },
    },

    -- Snippets
    { "rafamadriz/friendly-snippets" },
    {
        "L3MON4D3/LuaSnip",
        lazy = true,
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = { "~/.config/nvim/snippets/" }
            })
        end,
    },

    -- Autocomplete
    {
        'saghen/blink.cmp',
        lazy = true,
        event = 'InsertEnter',
        dependencies = {
            'L3MON4D3/LuaSnip',
            version = 'v2.*',
        },
        version = '1.*',
        opts = {
            snippets = { preset = 'luasnip' },
            keymap = { preset = 'default' },
            appearance = {
                nerd_font_variant = 'mono'
            },
            signature = {
                enabled = true,
                trigger = {
                    blocked_trigger_characters = {},
                    blocked_retrigger_characters = {},
                    show_on_insert_on_trigger_character = true,
                },
                window = {
                    winblend = 0,
                    winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
                    direction_priority = { "n" },
                },
            },
            completion = {
                documentation = { auto_show = false },
                trigger = {
                    show_on_trigger_character = true,
                    show_on_insert_on_trigger_character = true,
                },
                menu = { auto_show = true },
                list = { max_items = 8 },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer', },
                per_filetype = {
                    markdown = { 'lsp', 'path', 'snippets', 'buffer', },
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" }
    },

    { "sainnhe/gruvbox-material" },

    -- Still call nvim-lspconfig for options
    { "neovim/nvim-lspconfig" },

    -- Plugin setup end
})

-- LSP setup
-- luals
vim.lsp.config.luals = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            }
        }
    }
}
vim.lsp.enable('luals')

-- PyLSP
vim.lsp.config.pylsp = {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_markers = { { 'pyproject.toml', 'poetry.lock' }, '.git' },
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { enabled = false },
                mccabe = { enabled = false },
                pyflakes = { enabled = false },
                flake8 = { enabled = false },
                pylsp_mypy = { enabled = true },
            }
        }
    }
}
vim.lsp.enable('pylsp')

-- Ruff
vim.lsp.config.ruff = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { { 'pyproject.toml', 'poetry.lock' }, '.git' },
}
vim.lsp.enable('ruff')

-- clangd
vim.lsp.config.clangd = {
    cmd = { 'clangd', '--background-index' },
    root_markers = { 'compile_commands.json', 'compile_flags.txt' },
    filetypes = { 'c', 'cpp' },
}
vim.lsp.enable({ 'clangd' })

-- Rust analyzer
vim.lsp.config.rust_analyzer = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'Cargo.lock', 'rust-project.json' },
    settings = {
        ['rust-analyzer'] = {
            typing = {
                continueCommentsOnNewLine = false,
            },
            cargo = {
                allFeatures = true,
            },
            checkOnSave = true,
        },
    }
}
vim.lsp.enable({ 'rust_analyzer' })

-- Bash language server
vim.lsp.config.bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'sh', 'bash' },
    root_markers = { '.git' },
}
vim.lsp.enable({ 'bashls' })

-- Persistent undo history
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'

-- Limit diagnostic noise
vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = false,
    underline = false,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Debug toggle
vim.keymap.set('n', '<leader>lx', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

-- Set Gruvbox Material foreground palette: "material", "mix", or "original"
vim.g.gruvbox_material_foreground = "material"

-- Set background contrast: "hard", "medium", or "soft"
vim.g.gruvbox_material_background = "soft"

-- Set colourscheme
vim.cmd.colorscheme("gruvbox-material")
