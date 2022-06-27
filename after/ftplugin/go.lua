-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local lsp = require("lib.lsp")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local to_require_map = {
   ["which-key.nvim"] = { ["which-key"] = {} },
   ["nvim-goc.lua"] = { ["nvim-goc"] = {} },
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
-- ────────────────────────────────────────────────────────────
local goc = to_require_map["nvim-goc.lua"]["nvim-goc"]
if not goc then
   msg = string.format("could not load 'nvim-goc'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) else return end
   -- stylua: ignore end
end
-- ────────────────────────────────────────────────────────────
local lsp_server_name = "gopls"
lsp:setup(lsp_server_name)
-- ────────────────────────────────────────────────────────────
local wk = to_require_map["which-key.nvim"]["which-key"]
if not wk then
   msg = string.format("could not load 'which-key'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) else return end
   -- stylua: ignore end
end
wk.register({
   ["c"] = {
      function()
         goc.ClearCoverage()
      end,
      "Clear Coverage",
   },
   ["r"] = {
      function()
         goc.Coverage()
      end,
      "Coverage",
   },
   ["t"] = {
      function()
         goc.CoverageFunc()
      end,
      "Coverage Func",
   },
   ["i"] = {
      function()
         require("telescope").extensions.goimpl.goimpl({})
      end,
      "Generate stub for interface on a type",
   },
}, {
   mode = "n",
   prefix = "<LocalLeader>",
   buffer = vim.api.nvim_get_current_buf(),
   noremap = true,
})
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go-nvim.format').goimport() ]], false)
