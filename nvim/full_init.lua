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

-- Disable backticks (only relevant to my push to talk key)
vim.keymap.set('n', '`', '<NOP>')
vim.keymap.set('n', '``', '<NOP>')
vim.keymap.set('n', '```', '<NOP>')

-- System clipboard keymaps
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })

-- Cursor shapes for different modes
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Obsidian mappings
vim.keymap.set("n", "<leader>nn", "<cmd>ObsidianNew<cr>", { desc = "New Obsidian note" })
vim.keymap.set("n", "<leader>nb", "<cmd>ObsidianBacklinks<cr>", { desc = "Show backlinks" })
vim.keymap.set("n", "<leader>nt", "<cmd>ObsidianTags<cr>", { desc = "Browse tags" })
vim.keymap.set("n", "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch notes" })

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

    -- Obsidian nvim
{
  "epwalsh/obsidian.nvim",
  version = "3.13.1",
  lazy = false,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "Personal",
        path = "~/Documents/syncing_folder/Obsidian_Vaults/Personal/",
        strict = true,
        overrides = {
            notes_subdir = "Zettel",
        },
      },
    },
      daily_notes = {
      folder = "Daily Notes",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
    },
    completion = {
      nvim_cmp = false,
      blink = true,
      min_chars = 2,
    },
    notes_subdir = "Zettel",
    new_notes_location = "notes_subdir",

    -- Simple note ID generation
    note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

    templates = {
      folder = "Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },

    ui = { enable = false },
    picker = { name = "telescope.nvim" },
    sort_by = "modified",
    sort_reversed = true,
    search_max_lines = 1000,
    open_notes_in = "current",

    -- Callback to set up keymaps when entering a note
    callbacks = {
      enter_note = function(_, note)
        -- Remove default Enter mapping and add Tab for smart_action
        vim.keymap.del("n", "<CR>", { buffer = note.bufnr })
        vim.keymap.set("n", "<Tab>", function()
          return require("obsidian").util.smart_action()
        end, {
          buffer = note.bufnr,
          desc = "Obsidian smart action",
          expr = true,
        })
      end,
    },
  },
},

    -- Scribble notes
{
   'AnkushRoy-code/scribble.nvim',
   event = "VeryLazy",
   config = function()
       local scribble = require("scribble")
       scribble.setup({
            pos = "center",
            extension = ".md",
            width = 90,
            height = 43,
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
  config = function()
    require("toggleterm").setup()
    size = 25,
    vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm<cr>', { desc = 'Toggle terminal' })
    vim.keymap.set('t', '<Esc>', '<cmd>ToggleTerm<cr>', { desc = 'Toggle terminal' })
  end
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

    -- Telescope fuzzy finder
{
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    'jvgrootveld/telescope-zoxide'
  },
  config = function()
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ["<Tab>"] = require('telescope.actions').select_default,
          },
        },
        file_ignore_patterns = {
            "%.git/", "node_modules/", "__pycache__/", "zArchive/",
            },
        -- Make telescope windows vertical
        layout_strategy = "vertical",
        layout_config = {
          width = 0.9,
          height = 0.9,
          preview_height = 0.4,
        },
      },
    -- Change default telescope zoxide behaviour to edit instead of cd
    extensions = {
        zoxide = {
          mappings = {
            default = {
              action = function(selection)
                vim.cmd.edit(selection.path)
              end
            },
            ["<Tab>"] = {
                action = function(selection)
                    vim.cmd.edit(selection.path)
                end
            },
          }
        }
      }
    })

    require('telescope').load_extension('fzf')
    require('telescope').load_extension('zoxide')

    -- Telescope zoxide bind
    vim.keymap.set('n', '<leader>z', require('telescope').extensions.zoxide.list, { desc = 'Zoxide directories' })
    -- Telescope binds
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
  end,
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
        disable_filetype = {
            "TelescopePrompt", "markdown"
                },
        fast_wrap = {
            map = '<C-e>',
            before_key = "h",
            after_key = "l",
            cursor_pos_before = false,
            manual_position = false,
            }
        })
    vim.keymap.set('n', '<C-P>', function()
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
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "python", "rust", "c", "bash", "lua", "query", "markdown", "markdown_inline" },
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
  opts = {},
  cmd = "Trouble",
  keys = {
    {
      "<leader>m",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>h",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>xl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
},

    -- Autocomplete
{
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
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
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 1500,
        },
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

-- Colour schemes
{ "loctvl842/monokai-pro.nvim" },
{ "sainnhe/gruvbox-material" },
{ "sainnhe/sonokai" },

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

-- Set Gruvbox Material foreground palette: "material", "mix", or "original"
vim.g.gruvbox_material_foreground = "material"

-- Set background contrast: "hard", "medium", or "soft"
vim.g.gruvbox_material_background = "soft"

-- Set colourscheme
vim.cmd.colorscheme("gruvbox-material")
