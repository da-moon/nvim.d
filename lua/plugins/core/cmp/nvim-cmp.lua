-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ──────────────────────────────────────────────────────────────────────
local has_words_before = function()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
-- ──────────────────────────────────────────────────────────────────────

local M = {}
-- stylua: ignore start
function M.cond() return true end
-- stylua: ignore end
function M.setup() end
function M.config()
   local to_require_map = {
      ["nvim-cmp"] = { ["cmp"] = {} },
      ["LuaSnip"] = { ["luasnip"] = {} },
      ["lspkind-nvim"] = { ["lspkind"] = {} },
   }
   -- [ TODO ] =>  move to setup
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
   local cmp = to_require_map["nvim-cmp"]["cmp"]
   assert(
      cmp ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "cmp",
         "nvim-cmp",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   local luasnip = to_require_map["LuaSnip"]["luasnip"]
   local lspkind = to_require_map["lspkind-nvim"]["lspkind"]
   cmp.setup({
      mapping = {
         -- ["<TAB>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
         ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
         ["<C-Space>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
         ["<A-Up>"] = cmp.mapping.scroll_docs(-4),
         ["<A-Down>"] = cmp.mapping.scroll_docs(4),
         ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
               cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
               luasnip.expand_or_jump()
            elseif has_words_before() then
               cmp.complete()
            else
               fallback()
            end
         end, { "i", "s" }),
         ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
               cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
               luasnip.jump(-1)
            else
               fallback()
            end
         end, { "i", "s" }),
      },
      snippet = {
         expand = function(args)
            if luasnip then
               luasnip.lsp_expand(args.body)
            else
               msg = string.format("luasnip is nil")
               -- stylua: ignore start
               if logger then return logger:warn(msg) else return end
               -- stylua: ignore end
            end
         end,
      },
      formatting = {
         format = function(entry, vim_item)
            if lspkind then
               vim_item.kind = (lspkind.presets.default[vim_item.kind] or " ") .. " " .. vim_item.kind
            else
               msg = string.format("lspkind is nil")
               -- stylua: ignore start
               if logger then return logger:warn(msg) else return end
               -- stylua: ignore end
            end
            vim_item.menu = ({
               buffer = "[Buffer]",
               cmdline = "[CMD]",
               nvim_lsp = "[LSP]",
               luasnip = "[LuaSnip]",
               nvim_lua = "[Lua]",
               path = "[Path]",
               cmp_tabnine = "[TN]",
               nvim_lsp_signature_help = "[Signature]",
               nvim_lsp_document_symbol = "[Symbol]",
               calc = "[Calc]",
            })[entry.source.name]
            return vim_item
         end,
      },
      sources = {},
   })
   vim.cmd([[
		" gray
		highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
		" blue
		highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
		highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
		" light blue
		highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
		highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
		highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
		" pink
		highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
		highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
		" front
		highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
		highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
		highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
	]])
end
return M
