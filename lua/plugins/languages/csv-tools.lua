-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
-- TODO
-- - [ ] which-key keymapping
-- https://github.com/chen244/csv-tools.lua/blob/055ffc781bcc383fd2139ed661e6b661641e6cb4/lua/csvtools.lua#L165
-- ────────────────────────────────────────────────────────────

local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup() end
function M.config()
   local to_require_map = {
      ["csv-tools.lua"] = { ["csvtools"] = {} },
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
   local csvtools = to_require_map["csv-tools.lua"]["csvtools"]
   assert(
      csvtools ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "csvtools",
         "csv-tools.lua",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   csvtools.setup({
      before = 10,
      after = 10,
      clearafter = true,
      showoverflow = true,
      titelflow = true,
   })
end
return M
