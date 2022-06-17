-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup()
   vim.opt.list = true
   vim.opt.listchars:append("eol:↴")
end
function M.config()
   local module_name = "indent_blankline"
   local plugin_name = "indent-blankline.nvim"
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
      filetype_exclude = {
         "help",
         "terminal",
         "dashboard",
         "NvimTree",
         "peek",
         "packer",
         "lspinfo",
         "qf",
      },
      buftype_exclude = { "terminal", "nofile" },
      show_current_context = true,
      show_current_context_start = true,
      show_trailing_blankline_indent = false,
      show_end_of_line = true,
   })
end
return M
