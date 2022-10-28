-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- NOTE I think this should get loaded after lsp starts up ... ( bufread ?)
local M = {}
function M.setup() end
function M.config()
   local plugin_name = "impatient"
   local status_ok, plug = pcall(require, plugin_name)
   if not status_ok then
      return print(string.format("[ %s ] : '%s' not found", debug.getinfo(1, "S").source:sub(2)), plugin_name)
   end
   plug.enable_profile()
end
return M
