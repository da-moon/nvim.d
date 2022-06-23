-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- [ TODO ] => take in a buffer number from user
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   register({
      name = "+Buffer",
      ["<Left>"] = { "<cmd>bn!<cr>", "Next Buffer" },
      ["<Right>"] = { "<cmd>bp!<cr>", "Previous Buffer" },
      ["b"] = {
         function()
            require("telescope.builtin").buffers()
         end,
         "Find Buffer",
      },
      ["s"] = {
         "<cmd>new | setlocal bt=nofile bh=wipe nobl noswapfile nu<cr>",
         "Create new scratch buffer",
      },
      -- ["s"] = {
      --    "<cmd>enew<cr>",
      --    "Create new scratch buffer",
      -- },
      ["Y"] = { [[<cmd>ggVG"+y``<cr>]], "Copy whole buffer to clipboard" },
      ["u"] = { "<Cmd>MundoToggle<cr>", "undo tree" },
      ["P"] = { [[<cmd>ggdG"+P<cr>]], "Copy clipboard to whole buffer" },
      ["p"] = { [["+gP]], "Paste from system clipboard" },
   }, {
      mode = "n",
      prefix = "<leader>b",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
   register({
      name = "+Buffer",
      ["f"] = {
         function()
            vim.lsp.buf.range_formatting()
         end,
         "Range Format",
      },
   }, {
      mode = "x",
      prefix = "<leader>b",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
-- ────────────────────────────────────────────────────────────────────────────────
-- https://github.com/popcorn4dinner/dotfiles/blob/master/nvim/lua/config/which-key.lua
-- local map = vim.api.nvim_set_keymap
-- local opts = { noremap = true, silent = true }
-- Move to previous/next
-- map('n', '<A-,>', ':BufferPrevious<CR>', opts)
-- map('n', '<A-.>', ':BufferNext<CR>', opts)
-- -- Re-order to previous/next
-- map('n', '<A-<>', ':BufferMovePrevious<CR>', opts)
-- map('n', '<A->>', ' :BufferMoveNext<CR>', opts)
-- -- Goto buffer in position...
-- map('n', '<A-1>', ':BufferGoto 1<CR>', opts)
-- map('n', '<A-2>', ':BufferGoto 2<CR>', opts)
-- map('n', '<A-3>', ':BufferGoto 3<CR>', opts)
-- map('n', '<A-4>', ':BufferGoto 4<CR>', opts)
-- map('n', '<A-5>', ':BufferGoto 5<CR>', opts)
-- map('n', '<A-6>', ':BufferGoto 6<CR>', opts)
-- map('n', '<A-7>', ':BufferGoto 7<CR>', opts)
-- map('n', '<A-8>', ':BufferGoto 8<CR>', opts)
-- map('n', '<A-9>', ':BufferGoto 9<CR>', opts)
-- map('n', '<A-0>', ':BufferLast<CR>', opts)
-- -- Close buffer
-- map('n', '<A-c>', ':BufferClose<CR>', opts)
-- -- Wipeout buffer
-- --                 :BufferWipeout<CR>
-- -- Close commands
-- --                 :BufferCloseAllButCurrent<CR>
-- --                 :BufferCloseBuffersLeft<CR>
-- --                 :BufferCloseBuffersRight<CR>
-- -- Magic buffer-picking mode
-- map('n', '<C-p>', ':BufferPick<CR>', opts)
-- -- Sort automatically by...
-- map('n', '<Space>bb', ':BufferOrderByBufferNumber<CR>', opts)
-- map('n', '<Space>bd', ':BufferOrderByDirectory<CR>', opts)
-- map('n', '<Space>bl', ':BufferOrderByLanguage<CR>', opts)
-- ────────────────────────────────────────────────────────────────────────────────
