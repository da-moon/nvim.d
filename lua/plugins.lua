-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
-- https://github.com/liranuxx/nvea/blob/master/lua/plugins/tools/init.lua
-- ────────────────────────────────────────────────────────────
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
-- stylua: ignore start
packer.startup(function(use)
   --
   -- ──────────────────────────────────────────────────────────────── I ──────────
   --   :::::: C O R E   P L U G I N S : :  :   :    :     :        :          :
   -- ──────────────────────────────────────────────────────────────────────────
   --

   -- ╭──────────────────────────────────────────────────────────╮
   -- │                  neovim-lua-development                  │
   -- ╰──────────────────────────────────────────────────────────╯
   use({ "wbthomason/packer.nvim"                                                                                     })
   use({ "nvim-lua/plenary.nvim"        , opt =  false                                                                })
   use({ "nvim-lua/popup.nvim"          , opt =  false                                                                })
   use({ "MunifTanjim/nui.nvim"         , opt =  false                                                                })
   use({ "kyazdani40/nvim-web-devicons" , opt =  false                                                                })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                       key bindings                       │
   -- ╰──────────────────────────────────────────────────────────╯
   use({
      "folke/which-key.nvim",
      opt      = false,
      config   = [[require("plugins.which-key").config()]],
   })
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                       fuzzy finder                       │
   -- ╰──────────────────────────────────────────────────────────╯
   use({ "ray-x/guihua.lua"             , opt =  false, run = "cd lua/fzy && make"                                    })
   use({ "junegunn/fzf"                 , opt =  false, run = "./install--bin"                                        })
   use({ "ibhagwan/fzf-lua"             , opt =  false, requires = { "kyazdani42/nvim-web-devicons", "junegunn/fzf" } })
   use({
      "nvim-telescope/telescope.nvim",
      opt      = false,
      requires = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
      after    = { "plenary.nvim", "fzf-lua"                   },
      config   = [[require("plugins.telescope").config()]],
   })
   -- stylua: ignore end
   if should_sync then
      packer.sync()
   end
end)
-- luacheck: max line length 120
