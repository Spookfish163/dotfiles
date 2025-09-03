-- Set leader key
vim.g.mapleader = " "

-- Basic settings
vim.opt.background = 'dark'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.syntax = 'on'
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.signcolumn = 'yes'

-- Toggle relative/absolute line numbers based on mode
vim.api.nvim_create_autocmd({'InsertEnter', 'FocusLost', 'WinLeave'}, {
  callback = function()
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd({'InsertLeave', 'FocusGained', 'WinEnter'}, {
  callback = function()
    vim.opt.relativenumber = true
  end,
})

-- Search settings
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Tab settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Centered scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Enhanced scrolling
vim.keymap.set('n', '<C-Y>', '<C-Y><C-Y>')
vim.keymap.set('n', '<C-E>', '<C-E><C-E>')

-- System clipboard keymaps
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })

-- Cursor shapes for different modes
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

    -- Toggleterm
{
    'akinsho/toggleterm.nvim',
    version = "2.*",
    opts = { size = 15 },
    vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm<cr>', { desc = 'Toggle terminal' }),
    vim.keymap.set('t', '<Esc>', '<cmd>ToggleTerm<cr>', { desc = 'Toggle terminal' }),
},

    -- Oil file manager
{
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  lazy = false,
  config = function()
    require("oil").setup({
      keymaps = {
        ["<leader>o"] = "actions.close",
        ["<Tab>"] = "actions.select",
      },
    })
    vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "Open oil file manager" })
  end
},

    -- Undotree
{
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_DiffpanelHeight = 0
  end
},

    -- Nvim surround
{
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({})
    end
},

    -- Auto Pairs
{
  "windwp/nvim-autopairs",
  config = function()
    require("nvim-autopairs").setup({
        fast_wrap = { map = "<C-l>", },
        enable_check_bracket_line = true,
        disable_filetype = { "TelescopePrompt", "markdown" },
        })
    vim.keymap.set('n', '<C-p>', function()
      require("nvim-autopairs").toggle()
    end)
  end,
},

    -- Vim tmux manager
{
  "christoomey/vim-tmux-navigator",
  lazy = false,
},

    -- Syntax highlighting
{
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "python", "rust", "c", "bash", "lua", "query", "markdown", "markdown_inline" },
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      modules = {},
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
},

    -- LSP Configuration
{
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require('lspconfig')
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- PyLSP
    lspconfig.pylsp.setup({
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = { enabled = false },  -- Disabled since using ruff
            mccabe = { enabled = false },       -- Disabled since using ruff
            pyflakes = { enabled = false },     -- Disabled since using ruff
            flake8 = { enabled = false },       -- Disabled since using ruff
            pylsp_mypy = { enabled = true },    -- Type checking
          }
        }
      }
    })
    -- Ruff server (Python linting)
    lspconfig.ruff.setup({
      capabilities = capabilities,
      init_options = {
        settings = {
          args = {},
        }
      }
    })

    -- Rust analyzer
    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
          },
            checkOnSave = true,
        },
      },
    })

    -- Lua LS
    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = {'vim'},
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })

    -- C/C++ (clangd)
    lspconfig.clangd.setup({
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
      },
    })

    -- Bash language server
    lspconfig.bashls.setup({
      capabilities = capabilities,
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
      ["<tab>"] = "jump",
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

    -- Autocomplete
{
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono'
    },
    signature = {
      enabled = true,
      trigger = {
        blocked_trigger_characters = {"<>"},
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
    documentation = { auto_show = true },
    trigger = {
      show_on_trigger_character = true,
      show_on_insert_on_trigger_character = true,
        },
    menu = {
        auto_show = true,
        },
    list = {
        max_items = 10,
        },
    },
    sources = {
      default = { 'lsp', 'snippets', 'path', 'buffer' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" }
},

    -- Colour scheme
{ "sainnhe/gruvbox-material" },

-- Plugin setup end
})

-- Fast highlight clear
vim.keymap.set('n', '<leader>c', '<cmd>nohlsearch<CR>')

-- Persistent undo history
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'

-- Limit diagnostic noise
vim.diagnostic.config({
  virtual_text = false,       -- Disable inline diagnostic text
  underline = false,          -- Disable underlines
  signs = true,               -- Keep gutter signs (W, H, E)
  update_in_insert = false,   -- Don't update diagnostics in insert mode
  severity_sort = true,       -- Sort by severity
})

-- Debug toggle
vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

-- Set colourscheme
vim.g.gruvbox_material_foreground = "material"
vim.g.gruvbox_material_background = "soft"
vim.cmd.colorscheme("gruvbox-material")
