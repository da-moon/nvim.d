-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ────────────────────────────────────────────────────────────

local M = {}
function M.setup() end
function M.config()
   local module_name = "surround"
   local plugin_name = "surround.nvim"
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
   -- stylua: ignore start
   plug.setup({
      context_offset        = 100,
      load_autogroups       = false,
      mappings_style        = "sandwich",
      map_insert_mode       = true,
      quotes                = { "'", '"' },
      brackets              = { "(", "{", "[" },
      space_on_closing_char = false,
      pairs                 = {
         nestable = {
            b = { "(", ")", },
            s = { "[", "]", },
            B = { "{", "}", },
            a = { "<", ">", },
         },
         linear   = {
            q = { "'", "'", },
            t = { "`", "`", },
            d = { '"', '"', },
         },
         prefix   = "s",
      },
   })
   -- stylua: ignore end
end
return M
