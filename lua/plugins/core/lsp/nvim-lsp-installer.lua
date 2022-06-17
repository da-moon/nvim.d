-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
function M.cond()
   return true
end
function M.setup() end
function M.config()
   local module_name = "nvim-lsp-installer"
   local plugin_name = "nvim-lsp-installer"
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
   -- stylua: ignore end
   plug.settings({
      ui = {
         icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
         },
         keymaps = {
            -- Keymap to expand a server in the UI
            toggle_server_expand = "<CR>",
            -- Keymap to install a server
            install_server = "i",
            -- Keymap to reinstall/update a server
            update_server = "u",
            -- Keymap to update all installed servers
            update_all_servers = "U",
            -- Keymap to uninstall a server
            uninstall_server = "X",
         },
      },
      -- install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" },
      max_concurrent_installers = 4,
   })
end
return M
