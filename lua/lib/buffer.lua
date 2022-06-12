-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
local M = {}
function M.add_empty_line(count)
   local cursor_pos = vim.api.nvim_win_get_cursor(0)
   local new_lines = {}
   for _ = 1, math.abs(count) do
      table.insert(new_lines, "")
   end
   if count < 0 then
      vim.api.nvim_put(new_lines, "l", false, false)
      cursor_pos[1] = cursor_pos[1] - count
   else
      vim.api.nvim_put(new_lines, "l", true, false)
   end
   vim.api.nvim_win_set_cursor(0, cursor_pos)
end
-- returns current buffer info
function M.info()
   local bufnr = vim.api.nvim_get_current_buf()
   local bufname = vim.api.nvim_buf_get_name(bufnr)
   return {
      bufnr = bufnr,
      bufname = bufname,
      info = vim.fn.getbufinfo(bufnr)[1],
   }
end
---checks if buffer's filetype is equal to
-- user passed value
function M.is_ft(b, ft)
   return vim.bo[b].filetype == ft
end
return M
