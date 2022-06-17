-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
function M.setup() end
function M.config()
   local module_name = "nvim-ts-autotag"
   local plugin_name = "nvim-ts-autotag"
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
      filetypes = {
         "html",
         "xml",
         "javascript",
         "javascriptreact",
         "typescriptreact",
         "svelte",
         "vue",
      },
   })
end
return M
