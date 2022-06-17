-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ────────────────────────────────────────────────────────────

local M = {}
function M.config()
   local module_name = "filetype"
   local plugin_name = "filetype.nvim"
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
      overrides = {
         literal = {
            ["kitty.conf"] = "kitty",
            [".gitignore"] = "conf",
            ["tsconfig.json"] = "jsonc",
            ["devcontainer.json"] = "jsonc",
         },
         complex = {
            [".clang*"] = "yaml",
         },
         extensions = {
            tf = "terraform",
            tfvars = "terraform",
            tfstate = "json",
            fish = "fish",
            nix = "nix",
            tex = "tex",
            sol = "solidity",
         },
      },
   })
end
return M
