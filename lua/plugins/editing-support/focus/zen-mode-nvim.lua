-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ────────────────────────────────────────────────────────────
local M = {}
function M.config()
   local module_name = "zen-mode"
   local plugin_name = "zen-mode.nvim"
   local plug = pluginman:load_plugin(plugin_name, module_name)
   assert(
      plug ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         module_name,
         plugin_name,
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   -- stylua: ignore start
   plug.setup({
      {
         window = {
            -- luacheck: max line length 160
            backdrop = 0.95,                --  shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            -- luacheck: max line length 120
            -- ──────────────────────────────────────────────────────────────────────
            -- height and width can be:
            -- * an absolute number of cells when > 1
            -- * a percentage of the width / height of the editor when <= 1
            -- * a function that returns the width or the height
            -- ──────────────────────────────────────────────────────────────────────
            width = 120,                    --  width of the Zen window
            height = 1,                     --  height of the Zen window
            -- ──────────────────────────────────────────────────────────────────────
            --  by default, no options are changed for the Zen window
            --  uncomment any of the options below, or add other vim.wo
            --  options you want to apply
            -- ──────────────────────────────────────────────────────────────────────
            options = {
               signcolumn = "no",           --  disable signcolumn
               number = false,              --  disable number column
               relativenumber = true,       --  disable relative numbers
               cursorline = false,          --  disable cursorline
               cursorcolumn = false,        --  disable cursor column
               foldcolumn = "0",            --  disable fold column
               list = false,                --  disable whitespace characters
            },
         },
         plugins = {
            -- luacheck: max line length 160
            options = {                     --  disable some global vim options (vim.o...) comment the lines to not apply the options
            -- luacheck: max line length 120
               enabled = true,
               ruler = false,               --  disables the ruler text in the cmd line area
               showcmd = false,             --  disables the command in the last line of the screen
            },
            twilight = { enabled = true },  --  enable to start Twilight when zen mode opens
            gitsigns = { enabled = true },  --  disables git signs
            tmux = { enabled = false },     --  disables the tmux statusline
         },
         -- luacheck: no unused args
         -- selene: allow(unused_variable)
         on_open = function(win) end,       --  callback where you can add custom code when the Zen window opens
         -- selene: deny(unused_variable)
         -- luacheck: unused args
         on_close = function() end,         --  callback where you can add custom code when the Zen window closes
      },
   })
   -- stylua: ignore end
end
return M
