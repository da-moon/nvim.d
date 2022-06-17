-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup()
   -- setting up syntax concealing
   -- Nothing is concealed
   -- vim.g.vim_markdown_conceal = 0
   -- -- Links are concealed
   -- vim.g.vim_markdown_conceal = 1
   -- -- Links and text formatting is concealed (default)
   vim.g.vim_markdown_conceal = 2

   -- Enable TOC window auto-fit
   vim.g.vim_markdown_toc_autofit = 1
   -- Text emphasis restriction to single-lines
   vim.g.vim_markdown_emphasis_multiline = 1
   -- enable LaTeX math
   vim.g.vim_markdown_math = 1
   -- enable YAML Front Matter
   vim.g.vim_markdown_frontmatter = 1
   -- enable TOML Front Matter
   vim.g.vim_markdown_toml_frontmatter = 1
   -- enable JSON Front Matter
   vim.g.vim_markdown_json_frontmatter = 1
   -- disable all default mappings
   vim.g.vim_markdown_no_default_key_mappings = 1
   -- Fenced code block languages
   vim.g.vim_markdown_fenced_languages = {
      "lua",
      "toml",
      "json",
      "yaml",
      "html",
      "make",
      "go",
      "typescript",
      "javascript",
      "python",
      "sh",
      "hcl",
      "js=javascript",
      "ts=typescript",
      "shell=sh",
      "console=sh",
      "viml=vim",
      "ini=dosini",
   }
end
function M.config() end
return M
