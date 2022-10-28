-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
-- ──────────────────────────────────────────────────────────────────────
function M.register_q(term)
   vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end
-- ╭────────────────────────────────────────────────────────────────────╮
-- │                                git                                 │
-- ╰────────────────────────────────────────────────────────────────────╯
-- FIXME> figure out why this does not work
function M:git()
   local bin = "gitui"
   -- ──────────────────────────────────────────────────────────────────────
   if vim.fn.executable(bin) == 0 then
      bin = "lazygit"
   end
   if vim.fn.executable(bin) == 0 then
      return nil
   end
   -- ──────────────────────────────────────────────────────────────────────
   if vim.fn.executable(bin) == 0 then
      return nil
   end
   -- ────────────────────────────────────────────────────────────
   local module_name = "toggleterm.terminal"
   local plugin_name = "nvim-toggleterm.lua"
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
   return plug.Terminal:new({ cmd = bin, direction = "float", count = 5, on_open = self.register_q })
   --  lua require("toggleterm.terminal").Terminal:new({ cmd = "gitui", direction = "float", count = 5 })
end
return M
