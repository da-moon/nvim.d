-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup() end
function M.config()
   local to_require_map = {
      ["refactoring.nvim"] = { ["refactoring"] = {} },
      ["telescope.nvim"] = { ["telescope"] = {} },
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
   local refactoring = to_require_map["refactoring.nvim"]["refactoring"]
   assert(
      refactoring ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "refactoring.nvim",
         "refactoring",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   local telescope = to_require_map["telescope.nvim"]["telescope"]
   assert(
      telescope ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "cmp",
         "nvim-cmp",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   refactoring.setup({
      -- prompt for return type
      prompt_func_return_type = {
         go = true,
      },
      -- prompt for function parameters
      prompt_func_param_type = {
         go = true,
      },
   })
   local extension_name = "refactoring"
   local ext_status, _ = pcall(telescope.load_extension, extension_name)
   if not ext_status then
      msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
      -- stylua: ignore end
   end
end
return M
