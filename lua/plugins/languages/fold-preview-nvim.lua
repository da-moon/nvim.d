-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.config()
   local to_require_map = {
      ["nvim-keymap-amend"] = { ["keymap-amend"] = {} },
      ["fold-preview.nvim"] = { ["fold-preview"] = {} },
   }
   for plugin_name, modules in pairs(to_require_map) do
      for module_name, _ in pairs(modules) do
         local plug = pluginman:load_plugin(plugin_name, module_name)
         if not plug then
            msg = string.format("module < %s > from plugin <%s> could not get loaded", module_name, plugin_name)
            -- stylua: ignore start
            if logger then logger:warn(msg)  end
            -- stylua: ignore end
         else
            to_require_map[plugin_name][module_name] = plug
         end
      end
   end

   local fold_preview = to_require_map["fold-preview.nvim"]["fold-preview"]
   assert(
      fold_preview ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "fold-preview",
         "fold-preview.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   fold_preview.setup()
end
return M
