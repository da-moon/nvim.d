-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {
   sources = {},
   cmp = nil,
}

local logger = require("lib.logger")()
local msg = ""
function M:init()
   if not self.cmp then
      local plugin_name = "nvim-cmp"
      local module_name = "cmp"
      local plug = pluginman:load_plugin(plugin_name, module_name)
      if not plug then
         msg = string.format("module < %s > from plugin <%s> could not get loaded", module_name, plugin_name)
         -- stylua: ignore start
         if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
      self.cmp = plug
   end
end
function M:_register(name)
   self:init()
   if not self.cmp then
      msg = string.format("cmp module during registration of <%s> was nil", name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
      -- stylua: ignore end
   end
   msg = string.format("registering [ %s ] cmp source", name)
   -- stylua: ignore start
   if logger then logger:trace(msg)  end
   -- stylua: ignore end
   local config = self.cmp.get_config()
   table.insert(config.sources, { name = name })
   self.cmp.setup(config)
end
function M:setup()
   self:init()
end
function M:buffer()
   return function()
      self:_register("buffer")
   end
end
function M:nvim_lsp()
   return function()
      self:_register("nvim_lsp")
   end
end
function M:nvim_lsp_signature_help()
   return function()
      self:_register("nvim_lsp_signature_help")
   end
end
function M:emoji()
   return function()
      self:_register("emoji")
   end
end
function M:path()
   return function()
      self:_register("path")
   end
end
function M:luasnip()
   return function()
      self:_register("luasnip")
   end
end
function M:rg()
   return function()
      self:_register("rg")
   end
end
function M:calc()
   return function()
      self:_register("calc")
   end
end
function M:treesitter()
   return function()
      self:_register("treesitter")
   end
end
function M:spell()
   return function()
      -- vim.opt.spell = true
      -- vim.opt.spelllang = { "en_us" }
      self:_register("spell")
   end
end
function M:cmdline()
   return function()
      self:_register("cmdline")
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this
      -- won't work anymore).
      -- ──────────────────────────────────────────────────────────────────────
      -- [ TODO ] => look into adding the following :
      -- - https://github.com/tzachar/cmp-fuzzy-path
      -- - https://github.com/dmitmel/cmp-cmdline-history
      -- ──────────────────────────────────────────────────────────────────────
      -- cmp.setup.cmdline(":", {
      --    sources = cmp.config.sources({
      --       { name = "path" },
      --    }, {
      --       { name = "cmdline" },
      --    }),
      -- })
   end
end
function M:nvim_lsp_document_symbol()
   return function()
      self:init()
      if not self.cmp then
         msg = "cmp module during registration of nvim_lsp_document_symbol was nil"
         -- stylua: ignore start
         if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
      self.cmp.setup.cmdline("/", {
         sources = self.cmp.config.sources({
            { name = "nvim_lsp_document_symbol" },
         }, {
            { name = "buffer" },
         }),
      })
   end
end
function M:tabnine()
   return function()
      local plugin_name = "cmp-tabnine"
      local module_name = "cmp_tabnine.config"
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
      plug:setup({
         max_lines = 1000,
         max_num_results = 20,
         sort = true,
         run_on_every_keystroke = true,
         snippet_placeholder = "..",
         ignored_file_types = { -- default is not to ignore
            -- uncomment to ignore in lua:
            -- lua = true
         },
      })
      self:_register("cmp_tabnine")
   end
end
M.sources = {
   ["hrsh7th/cmp-nvim-lsp"] = M:nvim_lsp(),
   ["hrsh7th/cmp-nvim-lsp-signature-help"] = M:nvim_lsp_signature_help(),
   ["hrsh7th/cmp-buffer"] = M:buffer(),
   ["hrsh7th/cmp-emoji"] = M:emoji(),
   ["hrsh7th/cmp-path"] = M:path(),
   ["saadparwaiz1/cmp_luasnip"] = M:luasnip(),
   ["lukas-reineke/cmp-rg"] = M:rg(),
   ["hrsh7th/cmp-calc"] = M:calc(),
   ["ray-x/cmp-treesitter"] = M:treesitter(),
   ["hrsh7th/cmp-cmdline"] = M:cmdline(),
   ["f3fora/cmp-spell"] = M:spell(),
   ["hrsh7th/cmp-nvim-lsp-document-symbol"] = M:nvim_lsp_document_symbol(),
   ["tzachar/cmp-tabnine"] = M:tabnine(),
}
return M
