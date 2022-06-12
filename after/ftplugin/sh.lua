-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local lsp = require("lib.lsp")
-- ────────────────────────────────────────────────────────────
local lsp_server_name = "bashls"
lsp:setup(lsp_server_name)
