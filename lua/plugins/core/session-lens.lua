-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- https://github.com/alexzanderr/subrepo/blob/main/auto-session-settings.lua
-- https://github.com/ZenLian/nvim/blob/lua/lua/modules/tools/configs.lua
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ──────────────────────────────────────────────────────────────────────
local M = {}
local function customCloseHook()
   vim.cmd("NvimTreeClose")
   vim.cmd("SymbolsOutlineClose")
   vim.cmd("ToggleTermCloseAll")
end
function M.setup() end
function M.config()
   local module_name = "session-lens"
   local plugin_name = "session-lens"
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
   plug.setup()
end
return M
