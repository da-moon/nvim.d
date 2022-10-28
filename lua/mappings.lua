-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- TODO:
-- - [ ] redefine keybindings based on plugin so that
-- it can be used in Packer's load conditions.
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ──────────────────────────────────────────────────────────────────────
local wk = pluginman:load_plugin("which-key.nvim", "which-key")
if not wk then
   msg = string.format("Failed to load plugin: which-key")
   -- stylua: ignore start
   if logger then return logger:warn(msg) else return end
   -- stylua: ignore end
end
local modules = {
   "mappings.core",
   "mappings.buffer",
   "mappings.packer",
   "mappings.telescope",
   "mappings.files",
   "mappings.terminal",
   "mappings.applications",
   "mappings.lightspeed-nvim",
   "mappings.surround-nvim",
   "mappings.trouble-nvim",
   "mappings.comment-nvim",
   "mappings.comment-box",
   "mappings.todo-comments-nvim",
   "mappings.zen-mode-nvim",
   "mappings.nvim-spectre",
   "mappings.substitute-nvim",
   "mappings.registers-nvim",
   "mappings.help",
   "mappings.luasnip",
   "mappings.lsp",
   "mappings.local-leader",
   "mappings.vim-easy-align",
   "mappings.text-case-nvim",
}
for _, module in ipairs(modules) do
   local status, map = pcall(require, module)
   if not map then
      msg = module .. " not found!"
      -- stylua: ignore start
      if logger then logger:warn(msg)  end
      -- stylua: ignore end
   else
      msg = string.format("loading mappings from [ %s ]", module)
      -- stylua: ignore start
      if logger then logger:trace(msg) end
      -- stylua: ignore end
      map(wk.register)
   end
end
