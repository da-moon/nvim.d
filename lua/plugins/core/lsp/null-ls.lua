-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- luacheck: max line length 160
-- ──────────────────────────────────────────────────────────────────────
-- https://github.com/mptm436/dotfiles/blob/5aff69b16ab676457da9a00a45ea9d7113878ada/nvim/.config/nvim/lua/ide/lsp.lua#L143
-- ──────────────────────────────────────────────────────────────────────
-- stylua
-- https://github.com/apazzolini/dotfiles/blob/278b2529dd8c87e5fb6299776d518f34ea075842/nvim/lua/andre/stylua.lua#L8
-- ──────────────────────────────────────────────────────────────────────
-- null-ls builtins
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
-- ──────────────────────────────────────────────────────────────────────
-- TODO
-- - [ ] add diagnostics
-- - [ ] move stylua finder to lib and make it a generi repo file finder
-- - [ ] https://github.com/numToStr/dotfiles/blob/master/neovim/.config/nvim/lua/numToStr/plugins/lsp/null-ls.lua
-- ──────────────────────────────────────────────────────────────────────
-- luacheck: max line length 120
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ──────────────────────────────────────────────────────────────────────
local M = {
   path = nil,
   lspconfig_util = nil,
}
-- ╭────────────────────────────────────────────────────────────────────╮
-- │                        function definitions                        │
-- ╰────────────────────────────────────────────────────────────────────╯
local cached_configs = {}
local to_require_map = {
   ["nvim-lspconfig"] = { ["lspconfig.util"] = {} },
   ["plenary.nvim"] = { ["plenary.path"] = {} },
}
function M:stylua_finder()
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
   local path = to_require_map["plenary.nvim"]["plenary.path"]
   local lspconfig_util = to_require_map["nvim-lspconfig"]["lspconfig.util"]
   -- ──────────────────────────────────────────────────────────────────────
   local bufnr = vim.api.nvim_get_current_buf()
   local abspath = path:new(vim.api.nvim_buf_get_name(bufnr)):absolute()
   local root_finder = lspconfig_util.root_pattern(".git")
   if cached_configs[abspath] == nil then
      local file_path = path:new(abspath)
      local root_path = path:new(root_finder(abspath))

      local file_parents = file_path:parents()
      local root_parents = root_path:parents()

      local relative_diff = #file_parents - #root_parents
      for index, dir in ipairs(file_parents) do
         if index > relative_diff then
            break
         end
         local stylua_path = path:new({ dir, ".stylua.toml" })
         if stylua_path:exists() then
            cached_configs[abspath] = stylua_path:absolute()
            break
         end
      end
   end
   return cached_configs[abspath]
end

-- stylua: ignore start
function M.cond() return true end
function M:setup() end
-- stylua: ignore end
-- https://github.com/ionnux/dotfiles/blob/main/dot_config/nvim/lua/config/luasnip/luasnip.lua
function M:config()
   local module_name = "null-ls"
   local plugin_name = "null-ls.nvim"
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
   -- ──────────────────────────────────────────────────────────────────────
   local sources = {}
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                              generic                               │
   -- ╰────────────────────────────────────────────────────────────────────╯
   -- NOTE: install snippet
   -- sudo yarn global add --prefix /usr/local prettier
   if vim.fn.executable("prettier") > 0 then
      -- NOTE: https://github.com/oncomouse/dotfiles/blob/master/conf/vim/lua/dotfiles/null-ls/init.lua
      table.insert(
         sources,
         plug.builtins.formatting.prettier.with({
            -- extra_args = { "--use-tabs" },
            filetypes = {
               "css",
               "graphql",
               "html",
               "json",
               "less",
               "markdown",
               "scss",
               "svelte",
               "vue",
            },
         })
      )
   end
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                                lua                                 │
   -- ╰────────────────────────────────────────────────────────────────────╯
   if vim.fn.executable("stylua") > 0 then
      local stylua_toml = self.stylua_finder()
      if stylua_toml then
         table.insert(
            sources,
            plug.builtins.formatting.stylua.with({
               extra_args = {
                  "--config-path",
                  stylua_toml,
               },
            })
         )
      else
         table.insert(sources, plug.builtins.formatting.stylua)
      end
   end
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                                 go                                 │
   -- ╰────────────────────────────────────────────────────────────────────╯
   if vim.fn.executable("gofmt") > 0 then
      table.insert(sources, plug.builtins.formatting.gofmt)
   end
   if vim.fn.executable("goimports") > 0 then
      table.insert(sources, plug.builtins.formatting.goimports)
   end
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                                rust                                │
   -- ╰────────────────────────────────────────────────────────────────────╯
   if vim.fn.executable("rustfmt") > 0 then
      table.insert(sources, plug.builtins.formatting.rustfmt)
   end
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                                bash                                │
   -- ╰────────────────────────────────────────────────────────────────────╯
   if vim.fn.executable("shfmt") > 0 then
      table.insert(
         sources,
         plug.builtins.formatting.shfmt.with({
            extra_args = { "-i", 2 },
         })
      )
   end
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                             terraform                              │
   -- ╰────────────────────────────────────────────────────────────────────╯
   if vim.fn.executable("terraform") > 0 then
      table.insert(sources, plug.builtins.formatting.terraform_fmt)
   end
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                              eslint_d                              │
   -- ╰────────────────────────────────────────────────────────────────────╯
   if vim.fn.executable("eslint_d") > 0 then
      table.insert(sources, plug.builtins.formatting.eslint_d)
   end
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                              markdown                              │
   -- ╰────────────────────────────────────────────────────────────────────╯
   -- NOTE: install snippet
   -- go install github.com/katbyte/terrafmt@latest
   if vim.fn.executable("terrafmt") > 0 then
      table.insert(sources, plug.builtins.formatting.terrafmt)
   end
   -- NOTE: install snippet
   -- sudo yarn global add --prefix /usr/local remark-cli remark-toc
   if vim.fn.executable("remark") > 0 then
      table.insert(sources, plug.builtins.formatting.remark)
   end
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                                git                                 │
   -- ╰────────────────────────────────────────────────────────────────────╯
   if pcall(require, "gitsigns") then
      table.insert(sources, plug.builtins.code_actions.gitsigns)
   end
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                                misc                                │
   -- ╰────────────────────────────────────────────────────────────────────╯
   if vim.fn.executable("codespell") > 0 then
      table.insert(sources, plug.builtins.formatting.codespell)
   end
   if vim.fn.executable("nginxbeautifier") > 0 then
      table.insert(sources, plug.builtins.formatting.nginx_beautifier)
   end
   if vim.fn.executable("awk") > 0 then
      table.insert(sources, plug.builtins.formatting.trim_whitespace)
      table.insert(sources, plug.builtins.formatting.trim_newlines)
   end
   plug.setup({
      sources = sources,
      on_attach = function(client)
         if client.server_capabilities.document_formatting then
            vim.cmd([[
               augroup LspFormatting
                   autocmd! * <buffer>
                   autocmd BufWritePre <buffer> lua vim.lsp.buf.format({async = true})
               augroup END
            ]])
         end
         -- if client.server_capabilities.document_formatting then
         --    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
         -- end
      end,
   })
end

return M
