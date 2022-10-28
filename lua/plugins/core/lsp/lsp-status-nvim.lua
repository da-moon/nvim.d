-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- NOTE think this should get loaded after lsp starts up ... ( bufread ?)
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
local LSP = require("lib.lsp-capabilities")
function M.cond()
   return true
end
function M.setup() end
function M.config()
   local module_name = "lsp-status"
   local plugin_name = "lsp-status.nvim"
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
   LSP:tbl_extend("keep", plug.capabilities)
   msg = string.format("updated < %s > LSP capabilities", plugin_name)
   -- stylua: ignore start
   if logger then logger:trace(msg) end
   -- stylua: ignore end
   local lsp_status_util = pluginman:load_plugin(plugin_name, "lsp-status.util")
   plug.config({
      select_symbol = function(cursor_pos, symbol)
         if symbol.valueRange then
            local value_range = {
               ["start"] = {
                  character = 0,
                  line = vim.fn.byte2line(symbol.valueRange[1]),
               },
               ["end"] = {
                  character = 0,
                  line = vim.fn.byte2line(symbol.valueRange[2]),
               },
            }
            return lsp_status_util.in_range(cursor_pos, value_range)
         end
      end,
   })
   plug.register_progress()
end
return M
