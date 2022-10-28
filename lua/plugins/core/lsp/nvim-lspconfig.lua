-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- NOTE: I think this should get loaded after lsp starts up ... ( bufread ?)
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
function M.setup() end
function M.config()
   local module_name = "lspconfig"
   local plugin_name = "nvim-lspconfig"
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
   vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticError", text = " " })
   vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticWarn", text = " " })
   vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticInfo", text = " " })
   vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticHint", text = " " })

   -- vim.e.config({ virtual_text = false })
   -- -- enable border for hover
   -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
   --    -- Use a sharp border with `FloatBorder` highlights
   --    border = "single",
   -- })

   -- -- FIXME: this doesn't work
   -- -- disable virtual text
   -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
   --    virtual_text = false,
   -- })
end
return M
