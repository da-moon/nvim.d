-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {
   _capabilities = vim.lsp.protocol.make_client_capabilities(),
}
M._capabilities.textDocument.completion.completionItem.snippetSupport = true
M._capabilities.textDocument.completion.completionItem.resolveSupport = {
   properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
   },
}

---Merge with capablities
---@param opt table
---@param behaviour string
-- https://neovim.io/doc/user/lua.html
function M:tbl_extend(behaviour, opt)
   msg = string.format("Merging with exisitng capablities \n [%s]", vim.inspect(opt))
   -- stylua: ignore start
   if logger then logger:trace(msg) end
   -- stylua: ignore end
   self._capabilities = vim.tbl_extend(behaviour, self._capabilities or {}, opt)
end

---Merge recursively with capablities
---@param opt any
-- https://neovim.io/doc/user/lua.html
function M:tbl_deep_extend(behaviour, opt)
   msg = string.format("Merging recursively with exisitng capablities \n [%s]", vim.inspect(opt))
   -- stylua: ignore start
   if logger then logger:trace(msg)  end
   -- stylua: ignore end
   self._capabilities = vim.tbl_deep_extend(behaviour, self._capabilities or {}, opt)
end

---capablities function returns sane lsp client capabilities
--true it's opt parameter, it allows for updating internal capablities table
---@param opt any
---@return any
function M:capabilities()
   local to_require_map = {
      ["cmp-nvim-lsp"] = { ["cmp_nvim_lsp"] = {} },
   }
   for plugin_name, modules in pairs(to_require_map) do
      for module_name, _ in pairs(modules) do
         local plug = pluginman:load_plugin(plugin_name, module_name)
         if not plug then
            msg = string.format("module < %s > from plugin <%s> could not get loaded  [ %s ]", module_name, plugin_name)
            -- stylua: ignore start
            if logger then logger:warn(msg)  end
            -- stylua: ignore end
         end
         to_require_map[plugin_name][module_name] = plug
      end
   end
   local cmp_nvim_lsp = to_require_map["cmp-nvim-lsp"]["cmp_nvim_lsp"]
   if cmp_nvim_lsp then
      msg = string.format("cmp_nvim_lsp loaded")
      -- stylua: ignore start
      if logger then logger:debug(msg)  end
      -- stylua: ignore end
      local update_capabilities_status, _ = pcall(cmp_nvim_lsp.update_capabilities, self._capabilities)
      if update_capabilities_status then
         msg = string.format("cmp_nvim_lsp updated lsp capabilities successfully")
         -- stylua: ignore start
         if logger then logger:debug(msg) end
         -- stylua: ignore end
      else
         msg = string.format("cmp_nvim_lsp failed to update lsp capabilities")
         -- stylua: ignore start
         if logger then logger:debug(msg) end
         -- stylua: ignore end
      end
   else
      msg = string.format("cmp_nvim_lsp failed to load")
      -- stylua: ignore start
      if logger then logger:error(msg) end
      -- stylua: ignore end
   end
   return M._capabilities
end
return M
