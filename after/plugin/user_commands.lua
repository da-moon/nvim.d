-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- NeatFoldText
vim.api.nvim_create_user_command("SpacesToTabs", function(tbl)
   vim.opt.expandtab = false
   local previous_tabstop = vim.bo.tabstop
   vim.opt.tabstop = tonumber(tbl.args)
   vim.api.nvim_command("retab!")
   vim.opt.tabstop = previous_tabstop
end, { force = true, nargs = 1 })

vim.api.nvim_create_user_command("TabsToSpaces", function(tbl)
   vim.opt.expandtab = true
   local previous_tabstop = vim.bo.tabstop
   vim.opt.tabstop = tonumber(tbl.args)
   vim.api.nvim_command("retab")
   vim.opt.tabstop = previous_tabstop
end, { force = true, nargs = 1 })

-- Vim LSP stuff
vim.api.nvim_create_user_command(
   "LspOrganizeImports",
   "lua vim.lsp.buf.code_action{source = {organizeImports = true}}",
   { force = true }
)
