-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- [ TODO ] :
-- - [ ] redfine keybindings based on plugin so that
-- it can be used in Packer's load conditions.
-- ──────────────────────────────────────────────────────────────────────
local packer_status, packer = pcall(require, "packer")
if not packer_status then
   return print("mappings: failed to load plugin: packer")
end
local pluginman_status, pluginman = pcall(require, "lib.plugin-manager")
if not pluginman_status then
   return print("mappings: failed to load plugin:lib.plugin-manager ")
end
local wk = pluginman:load_plugin("which-key.nvim", "which-key")
if not wk then
   return print("Failed to load plugin: which-key")
end
local modules = {
   "mappings.core",
   "mappings.packer",
}
for _, module in ipairs(modules) do
   local status, map = pcall(require, module)
   if not status then
      print(module .. " not found!")
   else
      map(wk.register, packer.loader)
   end
end
