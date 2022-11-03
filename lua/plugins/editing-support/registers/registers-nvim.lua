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
      ["registers.nvim"] = { ["registers"] = {} },
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
   local registers = to_require_map["registers.nvim"]["registers"]
   assert(
      registers ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "registers",
         "registers.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   registers.setup({
      bind_keys = {
         normal = false,
         registers = registers.apply_register({ delay = 0.1 }),
      },
      system_clipboard = true,
      register_user_command = true,
      show_empty = false,
      symbols = {
         newline = "⏎",
         tab = "»─",
         space = " SPC ",
      },
      trim_whitespace = false,
      hide_only_whitespace = true,
      window = {
         max_width = 20,
         border = "single",
      },
   })
end

return M
