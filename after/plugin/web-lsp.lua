-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local lsp = require("lib.lsp")
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local to_require_map = {
   ["nvim-lsp-ts-utils"] = { ["nvim-lsp-ts-utils"] = {} },
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
local lsp_servers = {
   "tsserver",
   "angularls",
   "html",
   "cssls",
   "emmet_ls",
}
for _, lsp_server_name in ipairs(lsp_servers) do
   local opts = {}
   if lsp_server_name == "emmet_ls" then
      opts = vim.tbl_deep_extend("force", opts, {
         filetypes = {
            "html",
            "javascriptreact",
            "typescriptreact",
         },
      })
   end
   if lsp_server_name == "tsserver" then
      local ts_utils = to_require_map["nvim-lsp-ts-utils"]["nvim-lsp-ts-utils"]
      if ts_utils then
         msg = string.format("[ %s ] using 'nvim-lsp-ts-utils' for server config", lsp_server_name)
         -- stylua: ignore start
         if logger then logger:trace(msg) end
         -- stylua: ignore end
         -- https://github.com/jaeheonji/neovim/blob/c31fd36150ce089de70d3fdc2319da1a6702755d/lua/config/nvim-lsp-installer.lua#L56
         opts = vim.tbl_deep_extend("force", opts, {
            init_options = ts_utils.init_options,
            on_attach = function(client, bufnr)
               -- https://github.com/abzcoding/lvim/blob/26f27da2e68245f68ead31cb3bc1c0fd0fa28315/ftplugin/typescript.lua#L10
               ts_utils.setup({
                  debug = false,
                  disable_commands = false,
                  enable_import_on_completion = false,
                  import_all_timeout = 5000, -- ms

                  -- eslint
                  eslint_enable_code_actions = true,
                  eslint_enable_disable_comments = true,
                  eslint_bin = "eslint_d",
                  eslint_config_fallback = nil,
                  eslint_enable_diagnostics = false,

                  -- formatting
                  enable_formatting = false,
                  formatter = "prettierd",
                  formatter_config_fallback = nil,

                  -- parentheses completion
                  complete_parens = false,
                  signature_help_in_parens = false,

                  -- update imports on file move
                  update_imports_on_move = false,
                  require_confirmation_on_move = false,
                  watch_dir = nil,
               })
               -- required to fix code action ranges and filter diagnostics
               ts_utils.setup_client(client)
               msg = string.format("[ %s ] on_attach function called", lsp_server_name)
               -- stylua: ignore start
               if logger then logger:trace(msg) end
               -- stylua: ignore end
               require("lib.lsp-config").lsp_status(client, bufnr)
               require("lib.lsp-config").lsp_signature(client, bufnr)
            end,
         })
      else
         msg = string.format("[ %s ] 'nvim-lsp-ts-utils' not loaded", lsp_server_name)
         -- stylua: ignore start
         if logger then logger:warn(msg) end
         -- stylua: ignore end
         opts = vim.tbl_deep_extend("force", opts, {
            init_options = {
               preferences = {
                  disableSuggestions = true,
                  includeCompletionsForImportStatements = true,
                  importModuleSpecifierPreference = "shortest",
                  lazyConfiguredProjectsFromExternalProject = true,
               },
            },
         })
      end
   end
   lsp:setup(lsp_server_name, opts)
end
