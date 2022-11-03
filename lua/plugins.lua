-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
-- https://github.com/liranuxx/nvea/blob/master/lua/plugins/tools/init.lua
-- ────────────────────────────────────────────────────────────
-- TODO: add
-- https://github.com/williamboman/mason.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim
local pluginman_status, pluginman = pcall(require, "lib.plugin-manager")
if not pluginman_status then
   return print("plugins: failed to load plugin:lib.plugin-manager ")
end
-- ────────────────────────────────────────────────────────────
pluginman:init()
-- ────────────────────────────────────────────────────────────
local should_sync = pluginman.should_sync
local packer = pluginman.packer
-- ────────────────────────────────────────────────────────────
-- luacheck: max line length 500
packer.startup(function(use)
   --
   -- ──────────────────────────────────────────────────────────────── I ──────────
   --   :::::: C O R E   P L U G I N S : :  :   :    :     :        :          :
   -- ──────────────────────────────────────────────────────────────────────────
   --

   -- ╭──────────────────────────────────────────────────────────╮
   -- │                  neovim-lua-development                  │
   -- ╰──────────────────────────────────────────────────────────╯
   -- stylua: ignore start
   use({ "wbthomason/packer.nvim"                                                                                     })
   use({ "nvim-lua/plenary.nvim"        , opt =  false                                                                })
   use({ "nvim-lua/popup.nvim"          , opt =  false                                                                })
   use({ "MunifTanjim/nui.nvim"         , opt =  false                                                                })
   use({ "rcarriga/nvim-notify"         , opt =  false                                                                })
   -- ~/.local/share/nvim/databases must exist before loading this plugin
   -- or else nvim would show segfault
   -- Lazyloading on events such as BufEnter lead to segfault. Update: this is fixed
   -- So far, only VimEnter has worked without giving a segfault.
   use({ "kkharji/sqlite.lua" ,
   opt =  false,
   cond = function()
      -- https://www.reddit.com/r/neovim/comments/t11k0g/comment/hyes9vb/?utm_source=share&utm_medium=web2x&context=3
      return require("jit").os == "Linux" and vim.fn.executable("sqlite3") ~= 0
   end,
   })
   -- use({ "kyazdani40/nvim-web-devicons" , opt =  true                                                                })
   -- stylua: ignore end
   use({
      "lewis6991/impatient.nvim",
      opt = false,
      config = [[require("plugins.core.impatient-nvim").config()]],
   })
   use({
      "Tastyep/structlog.nvim",
      opt = false,
      event = { "VimEnter" },
      setup = [[require("plugins.core.structlog-nvim").setup()]],
      config = [[require("plugins.core.structlog-nvim"):config()]],
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                       key bindings                       │
   -- ╰──────────────────────────────────────────────────────────╯
   use({
      "folke/which-key.nvim",
      opt = false,
      config = [[require("plugins.core.which-key").config()]],
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                       fuzzy finder                       │
   -- ╰──────────────────────────────────────────────────────────╯
   -- stylua: ignore start
   use({ "ray-x/guihua.lua"             , opt =  false, run = "cd lua/fzy && make"                                    })
   use({ "junegunn/fzf"                 , opt =  false, run = "./install--bin"                                        })
   use({ "ibhagwan/fzf-lua"             , opt =  false, requires = { "kyazdani42/nvim-web-devicons", "junegunn/fzf" } })
   -- stylua: ignore end
   use({
      "nvim-telescope/telescope.nvim",
      opt = false,
      requires = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
      after = { "plenary.nvim", "fzf-lua" },
      config = [[require("plugins.core.telescope").config()]],
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                        completion                        │
   -- ╰──────────────────────────────────────────────────────────╯
   use({
      "rafamadriz/friendly-snippets",
      opt = false,
   })
   use({
      "L3MON4D3/LuaSnip",
      opt = false,
      requires = { "rafamadriz/friendly-snippets" },
      cond = [[require("plugins.core.cmp.luasnip").cond()]],
      setup = [[require("plugins.core.cmp.luasnip").setup()]],
      config = [[require("plugins.core.cmp.luasnip").config()]],
   })
   use({
      "hrsh7th/nvim-cmp",
      opt = false,
      setup = [[require("plugins.core.cmp.nvim-cmp").setup()]],
      config = [[require("plugins.core.cmp.nvim-cmp").config()]],
   })
   local cmp_sources = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      -- FIXME: unavailable ?
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "saadparwaiz1/cmp_luasnip",
      -- FIXME: unavailable ?
      "f3fora/cmp-spell",
      -- FIXME: unused source names
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      -- FIXME: unavailable ?
      "hrsh7th/cmp-cmdline",
      "lukas-reineke/cmp-rg",
      "ray-x/cmp-treesitter",
   }
   for _, source in ipairs(cmp_sources) do
      use({
         source,
         opt = false,
         requires = { "hrsh7th/nvim-cmp" },
         after = { "nvim-cmp" },
         setup = [[require("plugins.core.cmp.nvim-cmp-sources"):setup()]],
         config = string.format('require("plugins.core.cmp.nvim-cmp-sources").sources["%s"]()', source),
      })
   end
   -- FIXME: for some reason this get's loaded twice
   use({
      -- lua print(vim.loop.os_uname().sysname)
      "tzachar/cmp-tabnine",
      opt = false,
      requires = { "hrsh7th/nvim-cmp" },
      after = { "nvim-cmp" },
      cond = function()
         -- https://www.reddit.com/r/neovim/comments/t11k0g/comment/hyes9vb/?utm_source=share&utm_medium=web2x&context=3
         return not (require("jit").arch == "arm64")
      end,
      setup = [[require("plugins.core.cmp.nvim-cmp-sources"):setup()]],
      config = [[ require("plugins.core.cmp.nvim-cmp-sources").sources["tzachar/cmp-tabnine"]() ]],
      run = "./install.sh",
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                           lsp                            │
   -- ╰──────────────────────────────────────────────────────────╯
   use({ "b0o/schemastore.nvim", opt = false })
   -- NOTE: nvim-cmp depends on lspkind-nvim
   use({
      "onsails/lspkind-nvim",
      opt = false,
      setup = [[require("plugins.core.lsp.lspkind-nvim").setup()]],
      config = [[require("plugins.core.lsp.lspkind-nvim").config()]],
   })
   use({ "ray-x/lsp_signature.nvim", opt = false }) -- auto signature trigger
   use({
      "nvim-lua/lsp-status.nvim",
      opt = false,
      setup = [[require("plugins.core.lsp.lsp-status-nvim").setup()]],
      config = [[require("plugins.core.lsp.lsp-status-nvim").config()]],
   })
   use({
      "neovim/nvim-lspconfig",
      opt = false,
      requires = {
         "ray-x/lsp_signature.nvim",
         "nvim-lua/lsp-status.nvim",
      },
      after = {
         "cmp-nvim-lsp",
         "lsp_signature.nvim",
         "lsp-status.nvim",
      },
      setup = [[require("plugins.core.lsp.nvim-lspconfig").setup()]],
      config = [[require("plugins.core.lsp.nvim-lspconfig").config()]],
   })
   use({
      "williamboman/nvim-lsp-installer",
      opt = false,
      cond = [[require("plugins.core.lsp.nvim-lsp-installer").cond()]],
      setup = [[require("plugins.core.lsp.nvim-lsp-installer").setup()]],
      config = [[require("plugins.core.lsp.nvim-lsp-installer").config()]],
   })
   -- FIXME: beaks dockerfile
   use({
      "jose-elias-alvarez/null-ls.nvim",
      -- opt = false,
      disable = true,
      requires = {
         "nvim-lua/plenary.nvim",
         "neovim/nvim-lspconfig",
         "williamboman/nvim-lsp-installer",
      },
      after = {
         "plenary.nvim",
         "nvim-lspconfig",
         "nvim-lsp-installer",
      },
      config = [[require("plugins.core.lsp.null-ls"):config()]],
   })
   use({
      "kosayoda/nvim-lightbulb",
      opt = false,
      requires = {
         "neovim/nvim-lspconfig",
      },
      after = {
         "nvim-lspconfig",
      },
      config = [[require("plugins.core.lsp.nvim-lightbulb").config()]],
   })
   use({
      "tamago324/nlsp-settings.nvim",
      opt = false,
      requires = {
         "neovim/nvim-lspconfig",
         "williamboman/nvim-lsp-installer",
         "rcarriga/nvim-notify",
      },
      after = {
         "nvim-lspconfig",
      },
      config = [[require("plugins.core.lsp.nlsp-settings-nvim").config()]],
   })
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                             treesitter                             │
   -- ╰────────────────────────────────────────────────────────────────────╯
   use({
      "nvim-treesitter/nvim-treesitter",
      opt = false,
      run = "TSUpdate",
      config = [[require("plugins.core.treesitter.nvim-treesitter").config()]],
   })
   use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      opt = false,
      requires = { "nvim-treesitter/nvim-treesitter" },
      after = { "nvim-treesitter" },
   })
   -- TODO: is this enough ?
   use({
      "nvim-treesitter/playground",
      opt = false,
      requires = { "nvim-treesitter/nvim-treesitter" },
      after = { "nvim-treesitter" },
      cmd = { "TSPlaygroundToggle" },
   })
   use({
      "lewis6991/spellsitter.nvim",
      opt = false,
      requires = { "nvim-treesitter/nvim-treesitter" },
      after = { "nvim-treesitter" },
      config = [[require("plugins.core.treesitter.spellsitter-nvim").config()]],
   })
   use({
      "romgrk/nvim-treesitter-context",
      opt = false,
      requires = { "nvim-treesitter/nvim-treesitter" },
      after = { "nvim-treesitter" },
      config = [[require("plugins.core.treesitter.nvim-treesitter-context").config()]],
   })
   -- TODO: enable on specific FTs?
   use({
      "windwp/nvim-ts-autotag",
      opt = false,
      requires = { "nvim-treesitter/nvim-treesitter" },
      after = { "nvim-treesitter" },
      config = [[require("plugins.core.treesitter.nvim-ts-autotag").config()]],
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                Dashboard shown at startup                │
   -- ╰──────────────────────────────────────────────────────────╯
   use({
      "glepnir/dashboard-nvim",
      opt = false,
      config = [[require("plugins.core.dashboard-nvim").config()]],
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                    project management                    │
   -- ╰──────────────────────────────────────────────────────────╯
   -- use({
   --    "ahmedkhalf/project.nvim",
   --    opt = false,
   --    setup = [[require("plugins.core.project-nvim").setup()]],
   --    config = [[require("plugins.core.project-nvim").config()]],
   -- })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                         session                          │
   -- ╰──────────────────────────────────────────────────────────╯
   -- use({
   --    "rmagatti/auto-session",
   --    opt = false,
   --    config = [[require("plugins.core.auto-session").config()]],
   -- })
   -- use({
   --    "rmagatti/session-lens",
   --    opt = false,
   --    requires = {
   --       "rmagatti/auto-session",
   --       "nvim-telescope/telescope.nvim",
   --    },
   --    after = "telescope.nvim",
   --    config = [[require("plugins.core.session-lens").config()]],
   -- })
   -- -- TODO: add configuration
   -- use({
   --    "folke/persistence.nvim",
   --    event = "BufReadPre", -- this will only start session saving when an actual file was opened
   --    module = "persistence",
   --    config = function()
   --       require("persistence").setup()
   --    end,
   -- })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                     Top buffer line                      │
   -- ╰──────────────────────────────────────────────────────────╯
   use({
      "akinsho/bufferline.nvim",
      opt = false,
      requires = { "kyazdani42/nvim-web-devicons" },
      after = { "nvim-web-devicons" },
      setup = [[require("plugins.core.bufferline-nvim").setup()]],
      config = [[require("plugins.core.bufferline-nvim").config()]],
      tag = "v2.11.*",
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                       File Browser                       │
   -- ╰──────────────────────────────────────────────────────────╯
   use({
      "kyazdani42/nvim-tree.lua",
      opt = false,
      -- cmd = { "NvimTreeOpen", "NvimTreeToggle" },
      requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      setup = [[require("plugins.core.nvim-tree").setup()]],
      config = [[require("plugins.core.nvim-tree").config()]],
      commit = "7282f7de8aedf861fe0162a559fc2b214383c51c",
   })
   -- TODO: Add configuration
   use({ "edluffy/hologram.nvim", opt = false })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                  Terminal integrations                   │
   -- ╰──────────────────────────────────────────────────────────╯
   use({
      "akinsho/nvim-toggleterm.lua",
      opt = false,
      -- cmd = { "ToggleTerm", "ToggleTermOpenAll", "ToggleTermCloseAll" },
      config = [[require("plugins.core.nvim-toggleterm").config()]],
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                      Git interface                       │
   -- ╰──────────────────────────────────────────────────────────╯
   use({
      "lewis6991/gitsigns.nvim",
      opt = false,
      tag = "release",
      requires = { "nvim-lua/plenary.nvim" },
      config = [[require("plugins.core.gitsigns-nvim").config()]],
      cond = [[require("plugins.core.gitsigns-nvim").cond()]],
   })

   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                             statusline                             │
   -- ╰────────────────────────────────────────────────────────────────────╯
   use({
      "nvim-lualine/lualine.nvim",
      opt = false,
      requires = {
         "kyazdani42/nvim-web-devicons",
         "onsails/lspkind-nvim",
      },
      after = { "nvim-web-devicons", "lspkind-nvim" },
      setup = [[require("plugins.core.lualine-nvim").setup()]],
      config = [[require("plugins.core.lualine-nvim").config()]],
   })

   --
   -- ────────────────────────────────────────────────────────────────────────── II ──────────
   --   :::::: A U X I L I A R Y   P L U G I N S : :  :   :    :     :        :          :
   -- ────────────────────────────────────────────────────────────────────────────────────
   --

   --
   -- ────────────────────────────────────────────────────────────────────── III ──────────
   --   :::::: E D I T I N G   S U P P O R T : :  :   :    :     :        :          :
   -- ────────────────────────────────────────────────────────────────────────────────
   --
   use({ "gpanders/editorconfig.nvim", event = { "BufRead" } })
   use({ "junegunn/vim-easy-align", event = { "InsertEnter" } })
   -- TODO: add keybinding to open panel
   use({
      "zbirenbaum/copilot.lua",
      event = { "InsertEnter" },
      config = [[require("plugins.editing-support.copilot-nvim").config()]],
   })
   use({
      "ThePrimeagen/refactoring.nvim",
      event = { "BufEnter" },
      requires = {
         "nvim-lua/plenary.nvim",
         "nvim-treesitter/nvim-treesitter",
      },
      setup = [[require("plugins.editing-support.refactoring-nvim").setup()]],
      config = [[require("plugins.editing-support.refactoring-nvim").config()]],
   })
   use({
      "folke/trouble.nvim",
      requires = { "kyazdani42/nvim-web-devicons" },
      after = { "nvim-web-devicons" },
      event = { "BufWinEnter" },
      setup = [[require("plugins.editing-support.trouble-nvim").setup()]],
      config = [[require("plugins.editing-support.trouble-nvim").config()]],
   })
   use({
      "windwp/nvim-spectre",
      requires = { "nvim-lua/plenary.nvim" },
      after = { "plenary.nvim" },
      event = { "BufWinEnter" },
      config = [[require("plugins.editing-support.nvim-spectre").config()]],
   })
   -- TODO: add yoink and setup integration
   use({
      "gbprod/substitute.nvim",
      event = { "BufWinEnter" },
      config = [[require("plugins.editing-support.substitute-nvim").config()]],
   })
   use({
      "johmsalas/text-case.nvim",
      requires = {
         "nvim-telescope/telescope.nvim",
         "nvim-lua/plenary.nvim",
         "nvim-treesitter/nvim-treesitter",
         "folke/which-key.nvim",
      },
      after = {
         "telescope.nvim",
         "plenary.nvim",
         "nvim-treesitter",
         "which-key.nvim",
      },
      event = { "VimEnter" },
      config = [[require("plugins.editing-support.text-case-nvim").config()]],
   })
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                              register                              │
   -- ╰────────────────────────────────────────────────────────────────────╯
   use({
      "tversteeg/registers.nvim",
      cmd = { "Registers" },
      config = [[require("plugins.editing-support.registers.registers-nvim").config()]],
      tag = "v2.2.*",
   })
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                               motion                               │
   -- ╰────────────────────────────────────────────────────────────────────╯
   use({
      "ggandor/lightspeed.nvim",
      opt = false,
      requires = { "tpope/vim-repeat" },
      setup = [[require("plugins.editing-support.motion.lightspeed-nvim").setup()]],
      config = [[require("plugins.editing-support.motion.lightspeed-nvim").config()]],
   })
   use({
      "ur4ltz/surround.nvim",
      event = { "InsertEnter" },
      config = [[require("plugins.editing-support.motion.surround-nvim").config()]],
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                       indentation                        │
   -- ╰──────────────────────────────────────────────────────────╯
   use({
      "lukas-reineke/indent-blankline.nvim",
      event = { "BufWinEnter" },
      setup = [[require("plugins.editing-support.indentation.indent-blankline-nvim").setup()]],
      config = [[require("plugins.editing-support.indentation.indent-blankline-nvim").config()]],
   })
   use({
      "Darazaki/indent-o-matic",
      event = { "BufWinEnter" },
      config = [[require("plugins.editing-support.indentation.indent-o-matic").config()]],
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                         comment                          │
   -- ╰──────────────────────────────────────────────────────────╯
   use({ "JoosepAlviste/nvim-ts-context-commentstring", ft = { "typescriptreact", "javascriptreact" } })
   use({
      "numToStr/Comment.nvim",
      requires = { "JoosepAlviste/nvim-ts-context-commentstring" },
      event = { "BufWinEnter" },
      setup = [[require("plugins.editing-support.comments.comment-nvim").setup()]],
      config = [[require("plugins.editing-support.comments.comment-nvim").config()]],
      commit = "22e71071d9473996563464fde19b108e5504f892",
   })
   -- FIXME: this was breaking treesitter
   -- cmd = { "TodoQuickFix", "TodoLocList", "TodoTrouble", "TodoTelescope" },
   use({
      "folke/todo-comments.nvim",
      requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "folke/trouble.nvim" },
      event = { "BufWinEnter" },
      setup = [[require("plugins.editing-support.comments.todo-comments-nvim").setup()]],
      config = [[require("plugins.editing-support.comments.todo-comments-nvim").config()]],
   })
   -- luacheck: max line length 160
   -- cmd = { "CBlbox", "CBcbox", "CBclbox", "CBccbox", "CBalbox", "CBacbox", "CBaclbox", "CBaccbox", "CBline", "CBcline", "CBcatalog" },
   use({
      "LudoPinelli/comment-box.nvim",
      event = { "BufWinEnter" },
      config = [[require("plugins.editing-support.comments.comment-box-nvim").config()]],
   })
   -- TODO: configure
   use({
      "s1n7ax/nvim-comment-frame",
      event = { "BufWinEnter" },
      requires = {
         "nvim-treesitter",
      },
      after = {
         "nvim-treesitter",
      },
      config = function()
         require("nvim-comment-frame").setup({
            keymap = "<leader>cc",
            multiline_keymap = "<leader>C",
         })
      end,
   })
   -- TODO: configure
   use({
      "glepnir/coman.nvim",
      event = { "BufWinEnter" },
      requires = {
         "nvim-treesitter",
      },
      after = {
         "nvim-treesitter",
      },
   })

   -- luacheck: max line length 120
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                          focus                           │
   -- ╰──────────────────────────────────────────────────────────╯
   use({
      "folke/twilight.nvim",
      cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
      config = [[require("plugins.editing-support.focus.twilight-nvim").config()]],
   })
   use({
      "folke/zen-mode.nvim",
      requires = { "folke/twilight.nvim" },
      after = { "twilight.nvim" },
      cmd = { "ZenMode" },
      config = [[require("plugins.editing-support.focus.zen-mode-nvim").config()]],
   })
   --  ╭──────────────────────────────────────────────────────────╮
   --  │                       note-taking                        │
   --  ╰──────────────────────────────────────────────────────────╯
   -- TODO: add configuration
   use({ "jbyuki/venn.nvim", opt = false })
   --
   -- ────────────────────────────────────────────────────────── IV ──────────
   --   :::::: L A N G U A G E S : :  :   :    :     :        :          :
   -- ────────────────────────────────────────────────────────────────────
   --
   use({
      "nathom/filetype.nvim",
      event = { "BufEnter" },
      config = [[require("plugins.languages.filetype-nvim").config()]],
   })
   use({
      "anuvyklack/pretty-fold.nvim",
      requires = { "anuvyklack/nvim-keymap-amend" },
      event = { "BufEnter" },
      config = [[require("plugins.languages.pretty-fold-nvim").config()]],
      tag = "v3.0",
   })
   use({
      "anuvyklack/fold-preview.nvim",
      requires = { "anuvyklack/nvim-keymap-amend" },
      event = { "BufEnter" },
      config = [[require("plugins.languages.fold-preview-nvim").config()]],
   })
   use({ "kevinhwang91/nvim-bqf", ft = "qf" })
   --  ╭──────────────────────────────────────────────────────────╮
   --  │                        mermaid.js                        │
   --  ╰──────────────────────────────────────────────────────────╯
   use({ "mracos/mermaid.vim", ft = { "mermaid", "mmd" } })
   --  ╭──────────────────────────────────────────────────────────╮
   --  │                           ron                            │
   --  ╰──────────────────────────────────────────────────────────╯
   use({ "ron-rs/ron.vim", ft = { "ron" } })
   --  ╭──────────────────────────────────────────────────────────╮
   --  │                           csv                            │
   --  ╰──────────────────────────────────────────────────────────╯
   use({
      "mechatroner/rainbow_csv",
      ft = { "csv", "tsv" },
   })
   use({
      "chen244/csv-tools.lua",
      ft = { "csv", "tsv" },
   })
   --  ╭──────────────────────────────────────────────────────────╮
   --  │                           rust                           │
   --  ╰──────────────────────────────────────────────────────────╯
   use({
      "simrat39/rust-tools.nvim",
      ft = { "rust", "rs" },
      -- cond = [[require("plugins.languages.rust-tools-nvim").cond()]],
      config = [[require("plugins.languages.rust-tools-nvim").config()]],
   })
   use({
      "Saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      requires = { "nvim-lua/plenary.nvim" },
      config = [[require("plugins.languages.crates-nvim").config()]],
   })
   use({
      "nastevens/vim-cargo-make",
      requires = { "cespare/vim-toml" },
      after = { "filetype.nvim" },
      ft = "cargo-make",
   })
   use({
      "nastevens/vim-duckscript",
      ft = { "cargo-make", "duckscript" },
   })
   --  ╭──────────────────────────────────────────────────────────╮
   --  │                           lua                            │
   --  ╰──────────────────────────────────────────────────────────╯
   use({
      "folke/neodev.nvim",
      ft = "lua",
   })
   --  ╭──────────────────────────────────────────────────────────╮
   --  │                        typescript                        │
   --  ╰──────────────────────────────────────────────────────────╯
   use({
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
   })
   --  ╭──────────────────────────────────────────────────────────╮
   --  │                         markdown                         │
   --  ╰──────────────────────────────────────────────────────────╯
   use({
      "ixru/nvim-markdown",
      ft = { "markdown" },
      requires = { "elzr/vim-json", "cespare/vim-toml" },
      setup = [[require("plugins.languages.nvim-markdown").setup()]],
   })
   use({
      "iamcco/markdown-preview.nvim",
      ft = { "markdown" },
      cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
      run = [[require("plugins.languages.markdown-preview-nvim").run()]],
      setup = [[require("plugins.languages.markdown-preview-nvim").setup()]],
   })
   use({
      "npxbr/glow.nvim",
      ft = { "markdown" },
      run = [[require("plugins.languages.glow-nvim").run()]],
      setup = [[require("plugins.languages.glow-nvim").setup()]],
   })
   -- BufEnter,BufRead,BufWinEnter,FileType,WinEnte
   -- use({
   --    "Iron-E/nvim-marktext",
   --    ft = { "markdown" },
   --    cond = [[require("plugins.languages.nvim-marktext").cond()]],
   --    requires = { "Iron-E/nvim-libmodal" },
   --    after = { "nvim-libmodal" },
   -- })
   --  ╭──────────────────────────────────────────────────────────╮
   --  │                            go                            │
   --  ╰──────────────────────────────────────────────────────────╯
   use({
      "ray-x/go.nvim",
      ft = { "go" },
      requires = {
         "nvim-telescope/telescope.nvim",
         "nvim-lua/plenary.nvim",
         "neovim/nvim-lspconfig",
         "nvim-treesitter/nvim-treesitter",
         "ray-x/guihua.lua",
      },
      after = {
         "telescope.nvim",
         "plenary.nvim",
         "nvim-lspconfig",
         "guihua.lua",
         "nvim-treesitter",
      },
      cond = [[require("plugins.languages.go-nvim").cond()]],
      config = [[require("plugins.languages.go-nvim").config()]],
   })
   use({
      "rafaelsq/nvim-goc.lua",
      ft = { "go" },
      requires = { "nvim-treesitter/nvim-treesitter" },
      after = { "nvim-treesitter" },
      cond = [[require("plugins.languages.nvim-goc").cond()]],
      config = [[require("plugins.languages.nvim-goc").config()]],
   })

   --
   -- ──────────────────────────────────────────────────────────────────── V ──────────
   --   :::::: U S E R   I N T E R F A C E : :  :   :    :     :        :          :
   -- ──────────────────────────────────────────────────────────────────────────────
   --
   -- luacheck: max line length 160
   use({
      "VonHeikemen/fine-cmdline.nvim",
      opt = false,
      requires = {
         "MunifTanjim/nui.nvim",
      },
      config = [[require("plugins.ui.fine-cmdline-nvim").config()]],
   })
   use({
      "norcalli/nvim-colorizer.lua",
      event = { "BufEnter" },
      config = [[require("plugins.ui.nvim-colorizer").config()]],
   })
   use({
      "beauwilliams/focus.nvim",
      cmd = { "FocusSplitLeft", "FocusSplitDown", "FocusSplitUp", "FocusSplitRight" },
      config = [[require("plugins.ui.focus-nvim").config()]],
   })
   use({ "karb94/neoscroll.nvim", event = { "BufEnter" }, config = [[require("plugins.ui.neoscroll-nvim").config()]] })
   -- luacheck: max line length 120
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                          themes                          │
   -- ╰──────────────────────────────────────────────────────────╯
   use({ "shaunsingh/nord.nvim", opt = false })
   use({ "shaunsingh/solarized.nvim", opt = false })
   use({ "shaunsingh/moonlight.nvim", opt = false })
   -- FIXME: some colorschemes are breaking
   -- FIXME: telescope colorscheme does not work
   use({
      "catppuccin/nvim",
      as = "catppuccin",
      opt = false,
      requires = { "ggandor/lightspeed.nvim", "akinsho/bufferline.nvim", "nvim-lualine/lualine.nvim" },
      before = { "lualine.nvim" },
      after = { "lightspeed.nvim" },
      setup = [[require("plugins.ui.themes.catppuccin").setup()]],
      config = [[require("plugins.ui.themes.catppuccin").config()]],
      tag = "v0.2.4",
   })
   -- luacheck: max line length 160
   -- TODO: look into events
   use({
      "NTBBloodbath/doom-one.nvim",
      opt = false,
      requires = {
         "kyazdani42/nvim-web-devicons",
         "akinsho/bufferline.nvim",
         "folke/which-key.nvim",
         "nvim-telescope/telescope.nvim",
         "kyazdani42/nvim-tree.lua",
         "glepnir/dashboard-nvim",
         "lukas-reineke/indent-blankline.nvim",
         "nvim-lualine/lualine.nvim",
         "nvim-treesitter/nvim-treesitter",
         "lewis6991/gitsigns.nvim",
      },
      before = { "lualine.nvim" },
      after = {
         "nvim-web-devicons",
         "bufferline.nvim",
         "which-key.nvim",
         "telescope.nvim",
         "nvim-tree.lua",
         "dashboard-nvim",
         "indent-blankline.nvim",
         "nvim-treesitter",
         "gitsigns.nvim",
      },
      config = [[require("plugins.ui.themes.doom-one-nvim").config()]],
   })
   -- luacheck: max line length 120
   use({
      "rebelot/kanagawa.nvim",
      opt = false,
      requires = { "nvim-lualine/lualine.nvim", "kyazdani42/nvim-web-devicons", "akinsho/bufferline.nvim" },
      before = { "lualine.nvim" },
      after = { "nvim-web-devicons", "bufferline.nvim" },
      config = [[require("plugins.ui.themes.kanagawa-nvim").config()]],
      -- 10/1/2022
      commit = "dda1b8c13e0e7588c014064e5e8baf7f2953dd29",
   })
   use({
      "rose-pine/neovim",
      opt = false,
      as = "rose-pine",
      tag = "v1.*",
      requires = { "nvim-lualine/lualine.nvim", "kyazdani42/nvim-web-devicons", "akinsho/bufferline.nvim" },
      before = { "lualine.nvim" },
      after = { "nvim-web-devicons", "bufferline.nvim" },
      config = [[require("plugins.ui.themes.rose-pine").config()]],
   })
   use({
      "folke/tokyonight.nvim",
      opt = false,
      requires = { "nvim-lualine/lualine.nvim", "kyazdani42/nvim-web-devicons", "akinsho/bufferline.nvim" },
      before = { "lualine.nvim" },
      after = { "bufferline.nvim" },
      setup = [[require("plugins.ui.themes.tokyonight-nvim").setup()]],
      config = [[require("plugins.ui.themes.tokyonight-nvim").config()]],
   })
   use({
      "glepnir/zephyr-nvim",
      opt = false,
      requires = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-lualine/lualine.nvim",
         "kyazdani42/nvim-web-devicons",
         "akinsho/bufferline.nvim",
      },
      before = { "lualine.nvim" },
      after = { "nvim-treesitter", "nvim-web-devicons", "bufferline.nvim" },
      config = [[require("plugins.ui.themes.zephyr-nvim").config()]],
   })
   -- TODO: add config
   use({ "projekt0n/github-nvim-theme", opt = false })
   -- TODO: add config
   use({ "Shatur/neovim-ayu", opt = false })
   -- TODO: add config
   use({
      "olivercederborg/poimandres.nvim",
      opt = false,
      config = function()
         require("poimandres").setup({})
      end,
   })
   -- TODO: add config
   use({ "kvrohit/mellow.nvim", opt = false })

   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                         telescope plugins                          │
   -- ╰────────────────────────────────────────────────────────────────────╯
   use({
      "nvim-telescope/telescope-file-browser.nvim",
      requires = { "nvim-telescope/telescope.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["nvim-telescope/telescope-file-browser.nvim"]() ]],
   })
   use({
      "nvim-telescope/telescope-ui-select.nvim",
      event = "VimEnter",
      requires = { "nvim-telescope/telescope.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["nvim-telescope/telescope-ui-select.nvim"]() ]],
   })
   use({
      "nvim-telescope/telescope-frecency.nvim",
      event = "VimEnter",
      requires = { "nvim-telescope/telescope.nvim", "kkharji/sqlite.lua" },
      cond = function()
         return require("jit").os == "Linux" and vim.fn.executable("sqlite3") ~= 0
      end,
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["nvim-telescope/telescope-frecency.nvim"]() ]],
   })
   use({
      "nvim-telescope/telescope-smart-history.nvim",
      event = "VimEnter",
      cond = function()
         return require("jit").os == "Linux" and vim.fn.executable("sqlite3") ~= 0
      end,
      requires = {
         "nvim-telescope/telescope.nvim",
         -- { "tami5/sqlite.lua", module = "sqlite" }
      },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["nvim-telescope/telescope-smart-history.nvim"]() ]],
   })
   -- sudo apt install -y libx11-dev libxext-dev libxres-dev
   -- python3 -m pip install --user ueberzug
   use({
      "nvim-telescope/telescope-media-files.nvim",
      event = "VimEnter",
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["nvim-telescope/telescope-media-files.nvim"]() ]],
   })
   -- luacheck: max line length 160
   -- stylua: ignore start
   use({
      "ptethng/telescope-makefile",
      event = "VimEnter",
      requires = { "akinsho/nvim-toggleterm.lua", "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["ptethng/telescope-makefile"]() ]],
   })
   -- stylua: ignore end
   -- luacheck: max line length 120
   use({
      "xiyaowong/telescope-emoji.nvim",
      opt = true,
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["xiyaowong/telescope-emoji.nvim"]() ]],
   })
   use({
      "LinArcX/telescope-command-palette.nvim",
      event = "VimEnter",
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["LinArcX/telescope-command-palette.nvim"]() ]],
   })
   use({
      "LinArcX/telescope-env.nvim",
      event = "VimEnter",
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["LinArcX/telescope-env.nvim"]() ]],
   })
   use({
      "nvim-telescope/telescope-hop.nvim",
      event = "VimEnter",
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["nvim-telescope/telescope-hop.nvim"]() ]],
   })
   use({
      "nvim-telescope/telescope-packer.nvim",
      event = "VimEnter",
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["nvim-telescope/telescope-packer.nvim"]() ]],
   })
   -- ────────────────────────────────────────────────────────────
   -- luacheck: max line length 160
   -- stylua: ignore start
   -- use({
   --    "da-moon/telescope-toggleterm.nvim",
   --    requires = { "akinsho/nvim-toggleterm.lua", "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", },
   --    event = { "TermOpen" },
   --    after = { "telescope.nvim" },
   --    config = [[require("plugins.core.telescope-extensions")["https://git.sr.ht/~havi/telescope-toggleterm.nvim"]() ]],
   -- })
   -- stylua: ignore end
   -- luacheck: max line length 120
   -- ────────────────────────────────────────────────────────────
   use({
      "cljoly/telescope-repo.nvim",
      event = "VimEnter",
      cond = function()
         return vim.fn.executable("fd") > 0
      end,
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["cljoly/telescope-repo.nvim"]() ]],
   })
   use({
      "jvgrootveld/telescope-zoxide",
      event = "VimEnter",
      cond = function()
         return vim.fn.executable("zoxide") > 0
      end,
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["jvgrootveld/telescope-zoxide"]() ]],
   })
   use({
      "gbrlsnchs/telescope-lsp-handlers.nvim",
      event = "VimEnter",
      requires = { "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["gbrlsnchs/telescope-lsp-handlers.nvim"]() ]],
   })
   use({
      "nvim-telescope/telescope-project.nvim",
      event = "VimEnter",
      requires = {
         "nvim-telescope/telescope.nvim",
         "nvim-lua/popup.nvim",
         "nvim-lua/plenary.nvim",
         "ahmedkhalf/project.nvim",
      },
      after = { "telescope.nvim" },
      config = [[require("plugins.core.telescope-extensions")["nvim-telescope/telescope-project.nvim"]() ]],
   })
   use({
      "edolphin-ydf/goimpl.nvim",
      ft = { "go" },
      requires = {
         "nvim-telescope/telescope.nvim",
         "nvim-lua/plenary.nvim",
         "nvim-lua/popup.nvim",
         "nvim-treesitter/nvim-treesitter",
      },
      after = {
         "telescope.nvim",
         "plenary.nvim",
         "popup.nvim",
         "nvim-treesitter",
         "which-key.nvim",
      },
      config = [[require("plugins.core.telescope-extensions")["edolphin-ydf/goimpl.nvim"]() ]],
   })
   if should_sync then
      packer.sync()
   end
end)
-- luacheck: max line length 120
