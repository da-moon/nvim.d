-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup() end
function M.config()
   local module_name = "indent-o-matic"
   local plugin_name = "indent-o-matic"
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
      -- Number of lines without indentation before giving up (use -1 for infinite)
      max_lines = 2048,
      -- Space indentations that should be detected
      standard_widths = { 2, 3, 4 },
   })
end
return M
