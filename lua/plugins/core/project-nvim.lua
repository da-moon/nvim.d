-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
function M.setup() end
function M.config()
   local module_name = "project_nvim"
   local plugin_name = "project.nvim"
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
      manual_mode = true,
      detection_methods = { "lsp", "pattern" },
      patterns = {
         ".git",
         "_darcs",
         ".hg",
         ".bzr",
         ".svn",
         "Makefile",
         "package.json",
         "go.mod",
         "cargo.toml",
         "=src",
      },
      show_hidden = true,
      ignore_lsp = { "efm", "null-ls" },
      silent_chdir = true,
   })
end
return M
