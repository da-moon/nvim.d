-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
-- https://github.com/liranuxx/nvea/blob/master/lua/plugins/tools/init.lua
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ────────────────────────────────────────────────────────────
pluginman:init()
-- ────────────────────────────────────────────────────────────
local should_sync = pluginman.should_sync
local packer = pluginman.packer
-- ────────────────────────────────────────────────────────────
-- luacheck: max line length 500
-- stylua: ignore start
packer.startup(function(use)
   use({ "wbthomason/packer.nvim"                                                 })
   use({ "nvim-lua/plenary.nvim"        , opt = false                             })
   use({ "nvim-lua/popup.nvim"          , opt = false                             })
   use({ "MunifTanjim/nui.nvim"         , opt = false                             })
   use({ "kyazdani40/nvim-web-devicons" , opt = false                             })
   use({ "ray-x/guihua.lua"             , opt = false, run = "cd lua/fzy && make" })
   -- stylua: ignore end
   -- luacheck: max line length 120
   if should_sync then
      packer.sync()
   end
end)
