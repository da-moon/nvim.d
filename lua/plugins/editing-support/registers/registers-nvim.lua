-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup()
   vim.g.registers_return_symbol = "⏎" --  '⏎' by default
   vim.g.registers_tab_symbol = "»─" --  '·' by default
   vim.g.registers_space_symbol = " SPC " --  ' ' by default
   vim.g.registers_delay = 1 --  0 by default, milliseconds to wait before
   --  opening the popup window
   vim.g.registers_register_key_sleep = 1 --  0 by default, seconds to wait
   --  before closing the window when a register key is pressed
   vim.g.registers_show_empty_registers = 0 --  1 by default, an additional line
   --  with the registers without content
   vim.g.registers_trim_whitespace = 0 --  1 by default, don't show whitespace
   --  at the begin and end of the registers
   vim.g.registers_hide_only_whitespace = 1 --  0 by default, don't show
   --  registers filled exclusively with whitespace
   vim.g.registers_window_border = "single" --  'none' by default, can be
   --  'none', 'single','double', 'rounded', 'solid', or 'shadow'
   vim.g.registers_window_min_height = 10 --  3 by default, minimum height of
   --  the window when there is the cursor at the bottom
   vim.g.registers_window_max_width = 20 --  100 by default, maximum width of
   --  the window
   vim.g.registers_normal_mode = 0 --  1 by default, open the window in normal
   --  mode
   vim.g.registers_paste_in_normal_mode = 1 --  0 by default, automatically
   --  perform a paste action when selecting a register in normal mode
   vim.g.registers_visual_mode = 0 --  1 by default, open the window in visual
end
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
end
return M
