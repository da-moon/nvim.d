-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
function M.config()
   local module_name = "nvim-lightbulb"
   local plugin_name = "nvim-lightbulb"
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
   -- luacheck: max line length 160
   plug.setup({ -- LSP client names to ignore
      -- Example: {"sumneko_lua", "null-ls"}
      ignore = {},
      sign = {
         enabled = true,
         -- Priority of the gutter sign
         priority = 10,
      },
      float = {
         enabled = false,
         -- Text to show in the popup float
         text = "💡",
         -- Available keys for window options:
         -- - height     of floating window
         -- - width      of floating window
         -- - wrap_at    character to wrap at for computing height
         -- - max_width  maximal width of floating window
         -- - max_height maximal height of floating window
         -- - pad_left   number of columns to pad contents at left
         -- - pad_right  number of columns to pad contents at right
         -- - pad_top    number of lines to pad contents at top
         -- - pad_bottom number of lines to pad contents at bottom
         -- - offset_x   x-axis offset of the floating window
         -- - offset_y   y-axis offset of the floating window
         -- - anchor     corner of float to place at the cursor (NW, NE, SW, SE)
         -- - winblend   transparency of the window (0-100)
         win_opts = {},
      },
      virtual_text = {
         enabled = false,
         -- Text to show at virtual text
         text = "💡",
         -- highlight mode to use for virtual text (replace, combine, blend), see :help nvim_buf_set_extmark() for reference
         hl_mode = "replace",
      },
      status_text = {
         enabled = false,
         -- Text to provide when code actions are available
         text = "💡",
         -- Text to provide when no actions are available
         text_unavailable = "",
      },
   })
   vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
end
return M
