-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local M = {}
--- Checks for existence of a directory exists a given path.
---@param path string
---@return boolean
function M.is_dir(path)
   local luv = vim.loop
   local stats = luv.fs_stat(path)
   return stats and stats.type == "directory"
end
return M
