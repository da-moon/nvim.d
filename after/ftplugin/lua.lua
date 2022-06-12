-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local lsp = require("lib.lsp")
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local to_require_map = {
   ["lua-dev.nvim"] = { ["lua-dev"] = {} },
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
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
local lsp_server_name = "sumneko_lua"
local opts = {
   settings = {
      Lua = {
         runtime = {
            version = "LuaJIT",
            path = runtime_path,
         },
         diagnostics = {
            globals = { "vim" },
         },
         workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
         },
      },
   },
}
local luadev = to_require_map["lua-dev.nvim"]["lua-dev"]
if luadev then
   msg = string.format("[ %s ] overriding 'opts' with lua-dev", lsp_server_name)
   -- stylua: ignore start
   if logger then logger:trace(msg) end
   -- stylua: ignore end
   -- https://github.com/g2boojum/dotfiles/blob/306361ca4ea3e572ed30d6dac3868da951f71c29/neovim/.config/nvim/lua/config/lsp/installer.lua#L14
   opts = luadev.setup({ lspconfig = opts })
else
   msg = string.format("[ %s ] lua-dev not loaded", lsp_server_name)
   -- stylua: ignore start
   if logger then logger:warn(msg) end
   -- stylua: ignore end
end
lsp:setup(lsp_server_name, opts)
