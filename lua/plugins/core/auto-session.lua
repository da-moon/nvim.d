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
   local module_name = "auto-session"
   local plugin_name = "auto-session"
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
   plug.setup({
      log_level = "info",
      -- auto_session_enable_last_session = true,
      auto_session_enable_last_session = false,
      auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      -- auto_session_enabled = true,
      auto_session_enabled = false,

      auto_save_enabled = true,
      auto_restore_enabled = false,
      auto_session_suppress_dirs = nil,
      auto_session_pre_save_cmds = {
         customCloseHook,
      },
   })
   -- ──────────────────────────────────────────────────────────────────────
end
return M
