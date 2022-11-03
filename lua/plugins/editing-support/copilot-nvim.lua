-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
local M = {}
function M.setup() end
function M.config()
   vim.defer_fn(function()
      local to_require_map = {
         ["copilot.lua"] = { ["copilot"] = {} },
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
      local copilot = to_require_map["copilot.lua"]["copilot"]
      assert(
         copilot ~= nil,
         string.format(
            "module < %s > from plugin <%s> could not get loaded  [ %s ]",
            "copilot",
            "copilot.lua",
            debug.getinfo(1, "S").source:sub(2)
         )
      )
      copilot.setup({
         panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
               jump_prev = "[[",
               jump_next = "]]",
               accept = "<CR>",
               refresh = "gr",
               open = "<M-CR>",
            },
         },
         suggestion = {
            enabled = true,
            auto_trigger = false,
            debounce = 75,
            keymap = {
               accept = "<M-l>",
               next = "<M-]>",
               prev = "<M-[>",
               dismiss = "<C-]>",
            },
         },
         filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
         },
         copilot_node_command = "node", -- Node version must be < 18
         plugin_manager_path = vim.fn.stdpath("data") .. "/site/pack/packer",
         server_opts_overrides = {},
      })
   end, 100)
end
return M
