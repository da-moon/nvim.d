-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup() end
function M.config()
   local module_name = "comment-box"
   local plugin_name = "comment-box.nvim"
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
      {
         box_width = 70,                 --  width of the boxex
         borders = {                     --  symbols used to draw a box
            top = "─",
            bottom = "─",
            left = "│",
            right = "│",
            top_left = "╭",
            top_right = "╮",
            bottom_left = "╰",
            bottom_right = "╯",
         },
         line_width = 70,                --  width of the lines
         line = {                        --  symbols used to draw a line
            line = "─",
            line_start = "─",
            line_end = "─",
         },
         outer_blank_lines = false,      --  insert a blank line above and below the box
         inner_blank_lines = false,      --  insert a blank line above and below the text
         line_blank_line_above = false,  --  insert a blank line above the line
         line_blank_line_below = false,  --  insert a blank line below the line
      },
   })
   -- stylua: ignore end
end
return M
