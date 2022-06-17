-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.run()
   if vim.fn.executable("glow") == 0 then
      vim.api.nvim_command(":GlowInstall")
   end
end
function M.setup()
   -- vim.g.glow_style = "light"
   vim.g.glow_use_pager = true
end
function M.config() end
return M
