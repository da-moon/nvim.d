-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.cond()
   return vim.fn.executable("go") > 0
end
function M.setup() end
function M.config()
   local to_require_map = {
      ["nvim-treesitter"] = { ["nvim-treesitter"] = {} },
      ["nvim-goc.lua"] = { ["nvim-goc"] = {} },
   }
   for plugin_name, modules in pairs(to_require_map) do
      for module_name, _ in pairs(modules) do
         local plug = pluginman:load_plugin(plugin_name, module_name)
         if not plug then
            msg = string.format("module < %s > from plugin <%s> could not get loaded", module_name, plugin_name)
               -- stylua: ignore start
               if logger then logger:warn(msg)  end
            -- stylua: ignore end
         end
         to_require_map[plugin_name][module_name] = plug
      end
   end
   local goc = to_require_map["nvim-goc.lua"]["nvim-goc"]
   assert(
      goc ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "goc",
         "nvim-goc.lua",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   goc.setup({})
end
return M
