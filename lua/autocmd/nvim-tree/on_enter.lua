-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────

return function()
   local opts = { noremap = true }
   vim.api.nvim_buf_set_keymap(0, "n", "<C-Up>", "<C-w>k", opts)
   vim.api.nvim_buf_set_keymap(0, "n", "<C-Down>", "<C-w>j", opts)
   vim.api.nvim_buf_set_keymap(0, "n", "<C-Left>", "<C-w>h", opts)
   vim.api.nvim_buf_set_keymap(0, "n", "<C-Right>", "<C-w>l", opts)
end
