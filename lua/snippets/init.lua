-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
local ls = require("luasnip")
local from_vscode = require("luasnip/loaders/from_vscode")
local go = require("snippets.lua.go")

ls.snippets = {
   go = go,
}
from_vscode.lazy_load()
-- https://github.com/abzcoding/lvim/tree/main/snippets
from_vscode.load({
   paths = {
      vim.fn.stdpath("config") .. "/lua/snippets/json",
   },
})
