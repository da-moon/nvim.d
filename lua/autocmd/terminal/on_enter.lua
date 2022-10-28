-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────

return function()
   vim.api.nvim_win_set_option(0, "number", false)
   vim.api.nvim_win_set_option(0, "relativenumber", false)
   vim.api.nvim_win_set_option(0, "signcolumn", "no")
   vim.api.nvim_win_set_option(0, "cursorline", false)
   -- ────────────────────────────────────────────────────────────────────────────────
   local opts = { noremap = true }
   -- ────────────────────────────────────────────────────────────────────────────────
   vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
   vim.api.nvim_buf_set_keymap(0, "t", "<C-SPACE>", [[<C-\><C-n>]], opts)
   vim.api.nvim_buf_set_keymap(0, "t", "<C-Down>", [[<C-\><C-n><C-W>j]], opts)
   vim.api.nvim_buf_set_keymap(0, "t", "<C-Up>", [[<C-\><C-n><C-W>k]], opts)
   vim.api.nvim_buf_set_keymap(0, "t", "<C-q>", "<CMD>q<CR>", opts)
   vim.api.nvim_buf_set_keymap(0, "n", "<C-Right>", [[w]], opts)
   vim.api.nvim_buf_set_keymap(0, "n", "<C-Left>", [[b]], opts)
   vim.api.nvim_buf_set_keymap(0, "n", "<A-BS>", [[i<A-BS>]], opts)
   vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", [[^]], opts)
   vim.api.nvim_buf_set_keymap(0, "n", "<C-e>", [[$]], opts)
   vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "q",
      "<cmd>lua vim.cmd(string.format('bd! %d', vim.api.nvim_get_current_buf()))<cr>",
      opts
   )
   -- NOTE> respect bash keybindings
   vim.api.nvim_buf_set_keymap(0, "t", "<C-Right>", [[<nop>]], opts)
   vim.api.nvim_buf_del_keymap(0, "t", "<C-Right>")
   vim.api.nvim_buf_set_keymap(0, "t", "<C-Left>", [[<nop>]], opts)
   vim.api.nvim_buf_del_keymap(0, "t", "<C-Left>")
   vim.api.nvim_buf_set_keymap(0, "t", "<C-a>", [[<nop>]], opts)
   vim.api.nvim_buf_del_keymap(0, "t", "<C-a>")
   vim.api.nvim_buf_set_keymap(0, "t", "<C-e>", [[<nop>]], opts)
   vim.api.nvim_buf_del_keymap(0, "t", "<C-e>")
   vim.api.nvim_buf_set_keymap(0, "t", "<A-BS>", [[<nop>]], opts)
   vim.api.nvim_buf_del_keymap(0, "t", "<A-BS>")
end
