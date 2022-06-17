-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local utils = require("lib.utils")
local logger = require("lib.logger")()
local msg = ""
-- ──────────────────────────────────────────────────────────────────────
local M = {}
-- stylua: ignore start
function M.cond() return true end
-- stylua: ignore end
function M.setup()
   -- ──────────────────────────────────────────────────────────────────────
   local name = "friendly-snippets"
   local plug_path = string.format("/site/pack/packer/start/%s", name)
   plug_path = vim.fn.stdpath("data") .. plug_path
   if not utils.is_dir(plug_path) then
      msg = string.format("< %s > plugin directory (%s) was not found", name, plug_path)
      -- stylua: ignore start
      if logger then logger:trace(msg)  end
      -- stylua: ignore end
   end
end

-- https://github.com/ionnux/dotfiles/blob/main/dot_config/nvim/lua/config/luasnip/luasnip.lua
function M.config()
   local to_require_map = {
      ["LuaSnip"] = {
         ["luasnip"] = {},
         ["luasnip.util.types"] = {},
      },
   }
   -- loading
   for plugin_name, modules in pairs(to_require_map) do
      for module_name, _ in pairs(modules) do
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
         to_require_map[plugin_name][module_name] = plug
      end
   end
   -- ──────────────────────────────────────────────────────────────────────
   local plug = to_require_map["LuaSnip"]["luasnip"]
   local types = to_require_map["LuaSnip"]["luasnip.util.types"]
   plug.config.setup({
      history = false,
      -- updateevents = 'InsertLeave',
      updateevents = "InsertLeave",
      enable_autosnippets = true,
      region_check_events = "CursorHold",
      delete_check_events = "TextChanged",
      -- store_selection_keys = "<Tab>",
      ext_opts = {
         [types.choiceNode] = {
            active = {
               virt_text = { { " Choice", "Error" } },
            },
         },
         [types.insertNode] = {
            active = {
               virt_text = { { "● ", "Comment" } },
            },
         },
      },
   })
   require("snippets")
end
return M
