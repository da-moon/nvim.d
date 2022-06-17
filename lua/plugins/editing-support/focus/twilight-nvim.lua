-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ────────────────────────────────────────────────────────────
local M = {}
function M.config()
   local module_name = "twilight"
   local plugin_name = "twilight.nvim"
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
   --  stylua: ignore start
   plug.setup({
      {
         exclude     = {},     --  exclude these filetypes
         treesitter  = true,   --  use treesitter when available for the
                               --  filetype
         context     = 10,     --  amount of lines we will try to show around
                               --  the current line
         -- ──────────────────────────────────────────────────────────────────────
         -- treesitter is used to automatically expand the visible text, but
         -- you can further control the types of nodes that should always be
         -- fully expanded
         -- ──────────────────────────────────────────────────────────────────────
         expand      = {       --  for treesitter, we we always try to expand
                               --  to the top-most ancestor with these types
            "function",
            "method",
            "table",
            "if_statement",
         },
         dimming     = {
            alpha    = 0.25,   --  amount of dimming
            color    = {       --  we try to get the foreground
               "Normal",
               "#ffffff",
            },
                               --  from the highlight groups or fallback color
            inactive = false,  --  when true, other windows will be fully
                               --  dimmed
                               --  (unless they contain the same buffer)
         },
      },
   })
   --  stylua: ignore end
end
return M
