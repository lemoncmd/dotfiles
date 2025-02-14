-- encoding
vim.opt.encoding = "utf-8"
vim.scriptencoding = "utf-8"

-- settings
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.showcmd = true
vim.opt.signcolumn = "yes"

vim.opt.number = true
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.virtualedit = "onemore"
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.visualbell = true
vim.opt.showmatch = true
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.showmode = false
vim.opt.wildmode = "list:longest"

vim.opt.list = true
vim.opt.listchars = "tab:?_"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true

vim.opt.whichwrap = "b,s,h,l,<,>,[,],~"

-- mouse
vim.opt.mouse = "a"

-- keymaps

vim.g.mapleader = " "

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<Down>", "gj")
vim.keymap.set("n", "<Up>", "gk")

vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR><Esc>", { remap = true })

vim.keymap.set("i", "jj", "<Esc>", { silent = true })
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-l>", "<Right>")

vim.keymap.set("n", "s", "<Nop>")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sl", "<C-w>l")
vim.keymap.set("n", "sJ", "<C-w>J")
vim.keymap.set("n", "sK", "<C-w>K")
vim.keymap.set("n", "sH", "<C-w>H")
vim.keymap.set("n", "sL", "<C-w>L")
vim.keymap.set("n", "sn", "gt")
vim.keymap.set("n", "sp", "gT")
vim.keymap.set("n", "sr", "<C-w>r")
vim.keymap.set("n", "s=", "<C-w>=")
vim.keymap.set("n", "sw", "<C-w>w")
vim.keymap.set("n", "so", "<C-w>_<C-w>")
vim.keymap.set("n", "sO", "<C-w>=")
vim.keymap.set("n", "sN", ":<C-u>bn<CR>")
vim.keymap.set("n", "sP", ":<C-u>bp<CR>")
vim.keymap.set("n", "st", ":<C-u>tabnew<CR>")
vim.keymap.set("n", "ss", ":<C-u>sp<CR>")
vim.keymap.set("n", "sv", ":<C-u>vs<CR>")
vim.keymap.set("n", "sq", ":<C-u>q<CR>")
vim.keymap.set("n", "sQ", ":<C-u>bd<CR>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true })

-- plugin
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
vim.opt.rtp:prepend(lazypath)

function prequire(...)
  local status, lib = pcall(require, ...)
  if(status) then return lib end
  return nil
end

require("lazy").setup({
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    "sainnhe/sonokai",
    init = function()
      vim.g.sonokai_style = "atlantis"
    end,
    config = function()
      vim.cmd([[colorscheme sonokai]])
      vim.cmd([[highlight Normal ctermbg=none guibg=NONE]])
      vim.cmd([[highlight NonText ctermbg=none guibg=NONE]])
      vim.cmd([[highlight LineNr ctermbg=none guibg=NONE]])
      vim.cmd([[highlight Folded ctermbg=none guibg=NONE]])
      vim.cmd([[highlight EndOfBuffer ctermbg=none guibg=NONE]])
      vim.cmd([[highlight SignColumn ctermbg=none guibg=NONE]])
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", "sainnhe/sonokai" },
    opts = {
      tabline = {
        lualine_a = {
          {
            "tabs",
            max_length = vim.o.columns,
            mode = 2,
            fmt = function(name, context)
              -- Show + if buffer is modified in tab
              local buflist = vim.fn.tabpagebuflist(context.tabnr)
              local winnr = vim.fn.tabpagewinnr(context.tabnr)
              local bufnr = buflist[winnr]
              local mod = vim.fn.getbufvar(bufnr, '&mod')

              return name .. (mod == 1 and ' +' or '')
            end
          }
        },
      },
      winbar = {},
    }
  },
  {
    "rust-lang/rust.vim",
    init = function()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      map_cr = false
    },
    init = function ()
      local npairs = require'nvim-autopairs'
      local Rule   = require'nvim-autopairs.rule'

      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      npairs.add_rules {
        Rule(' ', ' ')
          :with_pair(function (opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1]..brackets[1][2],
              brackets[2][1]..brackets[2][2],
              brackets[3][1]..brackets[3][2],
            }, pair)
          end)
      }
      for _,bracket in pairs(brackets) do
        npairs.add_rules {
          Rule(bracket[1]..' ', ' '..bracket[2])
            :with_pair(function() return false end)
            :with_move(function(opts)
              return opts.prev_char:match('.%'..bracket[2]) ~= nil
            end)
            :use_key(bracket[2])
        }
      end
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp", "nvimdev/lspsaga.nvim" },
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--clang-tidy",
            "--pch-storage=memory"
          },
        },
        pyright = {},
        v_analyzer = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
            },
          },
        },
      }
    },
    config = function(_, opts)
      local lspconfig = require('lspconfig')
      for server, config in pairs(opts.servers) do
        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
  "williamboman/mason.nvim",
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "neovim/nvim-lspconfig" },
    },
    config = function()
      require("mason").setup()

      local registry = require "mason-registry"
      local packages = {
        "clangd",
        "clang-format",
        "pyright",
        "v-analyzer",
        "rust-analyzer",
      }
      registry.refresh(function ()
        for _, pkg_name in ipairs(packages) do
          local pkg = registry.get_package(pkg_name)
          if not pkg:is_installed() then
            pkg:install()
          end
        end
      end)

      require("mason-lspconfig").setup()
    end,
  },
  {
    "saghen/blink.cmp",
    version = '*',
    opts = {
      keymap = { preset = "enter" },
      sources = {
        min_keyword_length = function(ctx)
          -- only applies when typing a command, doesn't apply to arguments
          if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then return 2 end
          return 0
        end,
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
      completion = {
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
          end,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "williamboman/mason.nvim",
      "jayp0521/mason-null-ls.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.clang_format,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end,
      })

      require("null-ls.client").notify_client = function(...)
        local method, params
        if type((arg)[1]) == "table" then
          _, method, params = unpack(arg)
        else
          method, params = unpack(arg)
        end
        if not client then
          require("null-ls.logger"):debug(
            string.format("unable to notify client for method %s (client not active): %s", method, vim.inspect(params))
          )
          return
        end
        client:notify(method, params)
      end
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
    },
    keys = {
      { "[g", "<cmd>Lspsaga diagnostic_jump_prev<CR>", silent = true },
      { "]g", "<cmd>Lspsaga diagnostic_jump_next<CR>", silent = true },
      { "<leader>ac", "<cmd>Lspsaga code_action<CR>", silent = true, nowait = true },
      { "<leader>ar", "<cmd>Lspsaga rename<CR>", silent = true, nowait = true },
      { "<leader>ah", "<cmd>Lspsaga hover_doc<CR>", silent = true, nowait = true },
      { "<leader>ad", "<cmd>Lspsaga peek_definition<CR>", silent = true, nowait = true },
      { "<leader>at", "<cmd>Lspsaga peek_type_definition<CR>", silent = true, nowait = true },
      { "<leader>agd", "<cmd>Lspsaga goto_definition<CR>", silent = true, nowait = true },
      { "<leader>agt", "<cmd>Lspsaga goto_type_definition<CR>", silent = true, nowait = true },
      { "<leader>af", "<cmd>Lspsaga finder<CR>", silent = true, nowait = true },
      { "<leader>t", "<cmd>Lspsaga term_toggle<CR>", silent = true, nowait = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = function ()
      require("nvim-treesitter.install").update({ with_sync = true })
      vim.cmd("TSUpdate")
    end,
    config = function ()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
        ensure_installed = "all",
      })
    end
  },
  "nvim-treesitter/nvim-treesitter-context",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons" },
    keys = {
      { "<leader>ff", function () require("telescope.builtin").find_files() end },
      { "<leader>fg", function () require("telescope.builtin").live_grep() end },
      { "<leader>fb", function () require("telescope.builtin").buffers() end },
      { "<leader>fh", function () require("telescope.builtin").help_tags() end },
    },
  },
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      cmake_generate_options = {
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
      },
      cmake_build_directory = "build/${variant:buildType}",
    },
  },
  {
    "echasnovski/mini.files",
    keys = {
      { "<leader><leader>", function () MiniFiles.open() end }
    },
    lazy = false,
    config = function ()
      require('mini.files').setup({})
    end
  },
  prequire("plugins.codecompanion"),
})
