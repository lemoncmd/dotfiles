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

require("lazy").setup({
  "lukas-reineke/indent-blankline.nvim",
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
    keys = {
      {
        mode = "i",
        "<CR>",
        function()
          local npairs = require("nvim-autopairs")
          if vim.fn["coc#pum#visible"]() ~= 0 then
            return vim.fn["coc#pum#confirm"]()
          else
            return npairs.autopairs_cr()
          end
        end,
        expr = true,
        replace_keycodes = false,
      }
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
    "neoclide/coc.nvim",
    branch = "release",
    lazy = false,
    keys = {
      { "[g", "<Plug>(coc-diagnostic-prev)", silent = true },
      { "]g", "<Plug>(coc-diagnostic-next)", silent = true },
      { "<leader>ac", "<Plug>(coc-codeaction-cursor)", silent = true, nowait = true },
    },
    init = function()
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
    end
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
})
