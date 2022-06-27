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
      ["pretty-fold.nvim"] = { 
         ["pretty-fold"] = {}, 
         ["pretty-fold.preview"] = {} ,
      },
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

   local pretty_fold = to_require_map["pretty-fold.nvim"]["pretty-fold"]
   assert(
      pretty_fold ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "pretty-fold",
         "pretty-fold.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   pretty_fold.setup()
   local pretty_fold_preview = to_require_map["pretty-fold.nvim"]["pretty-fold.preview"]
   assert(
      pretty_fold_preview ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "pretty-fold.preview",
         "pretty-fold.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   pretty_fold_preview.setup()
end
return M
