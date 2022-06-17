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
      ["nvim-lspconfig"] = { ["lspconfig"] = {} },
      ["nvim-lsp-installer"] = { ["nvim-lsp-installer"] = {} },
      ["nvim-notify"] = { ["notify"] = {} },
      ["nlsp-settings.nvim"] = { ["nlspsettings"] = {} },
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
   -- -- [ TODO ] => refactor other modules to use this pattern
   local module_name = "nlspsettings"
   local plugin_name = "nlsp-settings.nvim"
   -- local nlspsettings = to_require_map[plugin_name][module_name]
   local nlspsettings = to_require_map["nlsp-settings.nvim"]["nlspsettings"]
   assert(
      nlspsettings ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         module_name,
         plugin_name,
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   -- local nlspsettings = require("nlspsettings")
   nlspsettings.setup({
      ---settings refs
      -- https://github.com/abzcoding/lvim/tree/main/lsp-settings
      config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
      local_settings_dir = ".nlsp-settings",
      local_settings_root_markers = { ".git" },
      append_default_schemas = true,
      loader = "json",
      -- nvim_notify = {
      --    enable = true,
      --    timeout = 5000,
      -- },
   })
end
return M
