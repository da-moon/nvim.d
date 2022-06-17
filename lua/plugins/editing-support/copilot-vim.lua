-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup() end
function M.config()
   vim.g.copilot_no_tab_map = true
   vim.g.copilot_assume_mapped = true
   vim.g.copilot_tab_fallback = ""
   vim.g.copilot_filetypes = {
      ["*"] = false,
      python = true,
      lua = true,
      go = true,
      rust = true,
      html = true,
      c = true,
      cpp = true,
      java = true,
      javascript = true,
      typescript = true,
      javascriptreact = true,
      typescriptreact = true,
   }
end
return M
