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
      ["focus.nvim"] = { ["focus"] = {} },
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
   local focus = to_require_map["focus.nvim"]["focus"]
   assert(
      focus ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "focus",
         "focus.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   focus.setup({
      signcolumn = false, -- disable sign column only on main window
      excluded_filetypes = {
         "calltree",
         "dapui_scopes",
         "dapui_breakpoints",
         "dapui_stacks",
         "dapui_watches",
         "dap-repl",
      },
   })
end
return M
