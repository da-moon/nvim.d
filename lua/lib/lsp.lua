-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
-- Collection of helper functions that makes it easier to work with LSP configs
--
-- ─── IMPORTS ────────────────────────────────────────────────────────────────────
--
local pluginman = require("lib.plugin-manager")
--
-- ─── MODULE VARIABLES ───────────────────────────────────────────────────────────
--
local logger = require("lib.logger")()
local msg = ""
local M = {
   modules = {
      ["nvim-lsp-installer"] = { ["nvim-lsp-installer"] = {} },
      ["lsp_signature.nvim"] = { ["lsp_signature"] = {} },
      ["lsp-status.nvim"] = { ["lsp-status"] = {} },
      ["cmp-nvim-lsp"] = { ["cmp_nvim_lsp"] = {} },
   },
}
--
-- ─── MODULE FUNCTIONS ───────────────────────────────────────────────────────────
--

---initializes LSP setup
---@return nil
function M:init()
   msg = string.format("Initializing LSP...")
   -- stylua: ignore start
   if logger then logger:trace(msg)  end
   -- stylua: ignore end
   for plugin_name, modules in pairs(self.modules) do
      for module_name, _ in pairs(modules) do
         local mod = self.modules[plugin_name][module_name]
         if not next(mod) then
            msg = string.format("trying to load module < %s > from plugin <%s>", module_name, plugin_name)
            -- stylua: ignore start
            if logger then logger:trace(msg)  end
            -- stylua: ignore end
            local plug = pluginman:load_plugin(plugin_name, module_name)
            if not plug then
               msg = string.format("module < %s > from plugin <%s> could not get loaded", module_name, plugin_name)
               -- stylua: ignore start
               if logger then logger:warn(msg)  end
               -- stylua: ignore end
            else
               msg = string.format("loading < %s > from plugin <%s>", module_name, plugin_name)
               -- stylua: ignore start
               if logger then logger:trace(msg)  end
               -- stylua: ignore end
               self.modules[plugin_name][module_name] = plug
            end
         else
            msg = string.format("skip loading < %s > from plugin <%s>", module_name, plugin_name)
            -- stylua: ignore start
            if logger then logger:trace(msg)  end
            -- stylua: ignore end
         end
      end
   end
end
---this function sets up LSP client
---@param name string
---@param opts table
---@return nil
function M:setup(name, opts)
   assert(name ~= nil, "name should not be nil")
   assert(name ~= "", "name should not be empty")
   if opts == nil then
      opts = {}
   end
   local lsp_installer = self.modules["nvim-lsp-installer"]["nvim-lsp-installer"]
   if not next(lsp_installer) then
      self:init()
      lsp_installer = self.modules["nvim-lsp-installer"]["nvim-lsp-installer"]
   end
   if not next(lsp_installer) then
      msg = string.format("could not load 'nvim-lsp-installer'")
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
      -- stylua: ignore end
   end
   local server_is_found, server = lsp_installer.get_server(name)
   if not server_is_found then
      msg = string.format(
         "lsp installer was not able to find configuration/install instruction for '%s' LSP server",
         name
      )
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
      -- stylua: ignore end
   end
   msg = string.format("[ %s ] predefined configuration found", server.name)
   -- stylua: ignore start
   if logger then logger:trace(msg) end
   -- stylua: ignore end

   if not server:is_installed() then
      msg = string.format("Installing [ %s ]", name)
      -- stylua: ignore start
      if logger then logger:info(msg) end
      -- stylua: ignore end
      server:install()
   else
      msg = string.format("[ %s ] server is installed", server.name)
      -- stylua: ignore start
      if logger then logger:warn(msg) end
      -- stylua: ignore end
   end
   -- Default opts
   server:on_ready(function()
      opts = vim.tbl_deep_extend("force", server:get_default_options(), opts)
      opts = vim.tbl_deep_extend("force", opts, {
         capabilities = require("lib.lsp-capabilities"):capabilities(),
         on_attach = function(client, bufnr)
            msg = string.format("[ %s ] on_attach function called ( buffer %s )", server.name, bufnr)
            -- stylua: ignore start
            if logger then logger:trace(msg) end
            -- stylua: ignore end
            require("lib.lsp-config").lsp_status(client, bufnr)
            require("lib.lsp-config").lsp_signature(client, bufnr)
         end,
      })
      -- https://github.com/alpha2phi/neovim-for-beginner/blob/ae2abb02326034a92f61b47e66c3001d4cf9ba70/lua/config/lsp/installer.lua#L6
      -- https://github.com/johnpyp/dotfiles/blob/master/dots/nvim/lua/config/lsp/rust.lua
      if name == "rust_analyzer" then
         local module_name = "rust-tools"
         local plugin_name = "rust-tools.nvim"
         local plug = pluginman:load_plugin(plugin_name, module_name)
         if plug then
            msg = string.format("module < %s > from plugin <%s> could loaded", module_name, plugin_name)
            -- stylua: ignore start
            if logger then logger:trace(msg)  end
            -- stylua: ignore end
            -- FIXME
            plug.setup({
               server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
            })
            return server:attach_buffers()
         end
      end
      server:setup(opts)
   end)
end
-- ────────────────────────────────────────────────────────────
return M
