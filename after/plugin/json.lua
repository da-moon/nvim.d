-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local lsp = require("lib.lsp")
local pluginman = require("lib.plugin-manager")
--
-- ─── MODULE VARIABLES ───────────────────────────────────────────────────────────
--
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local lsp_server_name = "jsonls"
local opts = {}
local module_name = "schemastore"
local plugin_name = "schemastore.nvim"
local schemastore = pluginman:load_plugin(plugin_name, module_name)
if schemastore then
   msg = string.format("module < %s > from plugin <%s> could loaded", module_name, plugin_name)
   -- stylua: ignore start
   if logger then logger:trace(msg)  end
   -- stylua: ignore end
   opts = {
      settings = {
         json = {
            schemas = schemastore.json.schemas(),
         },
      },
   }
end
lsp:setup(lsp_server_name, opts)
vim.cmd(
   "autocmd FileType json,jsonc set softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 smartindent autoindent expandtab"
)
