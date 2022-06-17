-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.config()
   local to_require_map = {
      ["fine-cmdline.nvim"] = { ["fine-cmdline"] = {} },
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
   local plug = to_require_map["fine-cmdline.nvim"]["fine-cmdline"]
   assert(
      plug ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "fine-cmdline",
         "fine-cmdline.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   plug.setup({
      cmdline = {
         enable_keymaps = true,
         smart_history = true,
         prompt = "❯ ",
      },
      popup = {
         position = {
            row = "10%",
            col = "50%",
         },
         size = {
            width = "60%",
         },
         border = {
            style = "rounded",
         },
         win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
         },
      },
      hooks = {
         before_mount = function(input)
            input.input_props.prompt = ":"
         end,
         -- luacheck: no unused args
         -- selene: allow(unused_variable)
         after_mount = function(input) end,
         --   https://github.com/umaumax/dotfiles/blob/master/.vim/config/setting-end/setting.lua
         set_keymaps = function(imap, feedkeys)
            local fn = require("fine-cmdline").fn
            imap("<Esc>", fn.close)
            imap("<C-c>", fn.close)
            -- imap("<Up>", fn.up_search_history)
            -- imap('<Up>', fn.up_history)
            imap("<Up>", fn.complete_or_next_item)
            -- imap("<Down>", fn.down_search_history)
            -- imap('<Down>', fn.down_history)
            imap("<Down>", fn.stop_complete_or_previous_item)
            -- [ TODO ] => confirm that this does not cause any problems with
            -- the existing keymaps
            imap("<M-Up>", fn.up_search_history)
            imap("<M-Down>", fn.down_search_history)
         end,
      },
      -- selene: deny(unused_variable)
      -- luacheck: unused args
   })
end
return M
