--:Lazy build luarocks.nvim- =========================
-- Neovim Modern Config (init.lua)
-- =========================
-- Requisitos:
-- - Neovim >= 0.9
-- - git instalado

-- =========================
-- PATH
-- =========================
-- vim.env.PATH = vim.env.PATH .. ":/opt/homebrew/bin"

-- =========================
-- Bootstrap lazy.nvim
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim.git",
    "--filter=blob:none",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Configurações básicas
-- =========================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true

-- =========================
-- Plugins
-- =========================
require("lazy").setup({
  -- Luarocks
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = function()
      require('luarocks-nvim').setup({})
    end,
  },

  -- Tema
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- estilo VSCode
          separator_style = "slant",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = false,
          always_show_bufferline = true,
        },
      })
    end,
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },

  -- Treesitter (syntax highlight)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "go", "bash" },
        highlight = { enable = true },
      })
    end,
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
        },
      })
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "tokyonight" },
        sections = {
          lualine_c = {
            { "filename" },
            {
              function()
                local navic = require("nvim-navic")
                if navic.is_available() then
                  return navic.get_location()
                end
                return ""
              end,
            },
          },
          lualine_x = {
            "venv-selector",
            "encoding",
            "fileformat",
            "filetype",
          },
        },
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },

  -- Snippets
  {
    "rafamadriz/friendly-snippets",
    dependencies = { "L3MON4D3/LuaSnip" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Errors
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        modes = {
          diagnostics = {
            win = {
              position = "right",
              size = 40,
            },
          },
        },
      })
      vim.keymap.set("n", "<leader>xd", function()
        require("trouble").toggle("diagnostics")
      end)
    end,
  },

  -- Breadcrumbs
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
  },

  -- Which Key
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  },

  -- Git Signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Mason LSP Manager
  {
    "neovim/nvim-lspconfig",
    branch = "master",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "ts_ls",
          "gopls",
          -- "sourcekit",
          -- "kotlin_language_server",
          -- "rust_analyzer",
          "clangd",
          "lua_ls",
        },
        automatic_installation = true,
      })

      vim.lsp.config("pyright", {})
      vim.lsp.config("ts_ls", {})
      vim.lsp.config("gopls", {})
      -- vim.lsp.config("sourcekit", {})      
      -- vim.lsp.config("kotlin_language_server", {})      
      -- vim.lsp.config("rust_analyzer", {})
      vim.lsp.config("clangd", {})
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
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
    end,
  },

  -- Venv
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
          "nvim-lua/plenary.nvim"
        },
      },
    },
    ft = "python", -- load when opening Python files
    keys = {
      { "<leader>v", "<cmd>VenvSelect<cr>", desc = "Select Venv" },
    },
    opts = {},
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = "float",
        shade_terminals = true,
      })
    end,
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")

      notify.setup({
        timeout = 3000,
        background_colour = "#000000",
        stages = "fade_in_slide_out",
      })

      vim.notify = notify
    end,
  },
})

-- =========================
-- Keymaps
-- =========================
local keymap = vim.keymap.set

-- Explorer
keymap("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Telescope
keymap("n", "<leader>ff", require('telescope.builtin').find_files, {})
keymap("n", "<leader>fg", require('telescope.builtin').live_grep, {})

-- Save
keymap("n", "<leader>w", ":w<CR>")

-- Quit
keymap("n", "<leader>q", ":q<CR>")

-- Navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Tabs Navigation
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>")
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>")

-- Copy
keymap("v", "<C-c>", '"+y') -- Ctrl+C
keymap("v", "<leader>y", '"+y') -- Visual: Space+y -> Copia seleção
keymap("n", "<leader>y", '"+yy') -- Normal: Space+y -> Copia linha

-- Python vevn
keymap("n", "<leader>v", ":VenvSelect<CR>")

-- Terminal
keymap("n", "<leader>t", "<cmd>ToggleTerm<cr>")
keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>")
keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>")

-- Diagnostics
keymap("n", "<leader>d", vim.diagnostic.open_float) -- ver erro detalhado
keymap("n", "<leader>dl", vim.diagnostic.setloclist) -- lista de erros

-- =========================
-- LSP Keymaps
-- =========================
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }

    -- LSP Keymaps
    keymap("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
    keymap("n", "K", vim.lsp.buf.hover, opts)
    keymap("n", "gr", vim.lsp.buf.references, opts) -- Go to reference
    keymap("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename

    -- Navic
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local navic = require("nvim-navic")
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, args.buf)
    end
  end,
})

-- =========================
-- Notify colors
-- =========================
vim.api.nvim_set_hl(0, "NotifyBackground", {
  bg = "#1a1b26",
})

vim.api.nvim_set_hl(0, "NotifyERRORBorder", {
  fg = "#db4b4b",
  bg = "#1a1b26",
})

vim.api.nvim_set_hl(0, "NotifyINFOBorder", {
  fg = "#7aa2f7",
  bg = "#1a1b26",
})

-- =========================
-- Notify settings
-- =========================
-- vim.fn.jobstart(cmd, {
--   on_exit = function(_, code)
--     if code == 0 then
--       vim.notify("✔ Execution OK")
--     else
--       vim.notify("✖ Execution failed", "error")
--     end
--   end,
-- })

-- =========================
-- Fim
-- =========================
