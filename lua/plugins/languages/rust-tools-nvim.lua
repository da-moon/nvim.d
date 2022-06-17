-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.cond()
   return vim.fn.executable("cargo") > 0
end
function M.setup() end
function M.config()
   local to_require_map = {
      ["rust-tools.nvim"] = { ["rust-tools"] = {} },
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
   local plug = to_require_map["rust-tools.nvim"]["rust-tools"]
   assert(
      plug ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "rust-tools",
         "rust-tools.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   plug.setup({
      tools = {
         autoSetHints = true,
         hover_with_actions = true,
         runnables = { use_telescope = true },
         inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = " ", -- ⟵
            other_hints_prefix = "⟹  ",
         },
      },
   })
end
return M
