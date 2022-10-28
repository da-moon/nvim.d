-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- https://github.com/fedorov7/nvim/blob/master/lua/user/mappings.lua
return function(register)
   if not register then
      return
   end
   -- ─── NORMAL ─────────────────────────────────────────────────────────────────────
   register({
      name = "+Comment",
      ["b"] = {
         name = "+Banner",
         ["l"] = { "<Cmd>lua require('comment-box').lbox()<CR>", "draw a box with the text left justified" },
         ["c"] = { "<Cmd>lua require('comment-box').cbox()<CR>", "draw a box with the text centered" },
      },
   }, {
      mode = "n",
      prefix = "<leader>c",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
   -- ────────────────────────────────────────────────────────────────────────────────
   register({
      name = "+Comment",
      ["b"] = {
         name = "+Banner",
         ["l"] = { "<Cmd>lua require('comment-box').lbox()<CR>", "draw a box with the text left justified" },
         ["c"] = { "<Cmd>lua require('comment-box').cbox()<CR>", "draw a box with the text centered" },
      },
   }, {
      mode = "v",
      prefix = "<Leader>c",
      buffer = nil, --- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, --- use `silent` when creating keymaps
      noremap = true, --- use `noremap` when creating keymaps
      nowait = true, --- use `nowait` when creating keymaps
   })
   -- ────────────────────────────────────────────────────────────────────────────────
   register({
      -- NOTE:  when the cursor is over a comment , Alt-S in insert mode triggers surround
      -- ["<M-s>"] = { "<Cmd>lua require('comment-box').line()<CR>", "Draw a separator line" },
      ["<M-l>"] = {
         "<ESC><CMD>setlocal paste<CR>o<ESC><Cmd>lua require('comment-box').line()<CR><CMD>setlocal nopaste<CR>^ji",
         "Draw a separator line",
      },
   }, {
      noremap = false,
      silent = true,
      buffer = nil,
      mode = "i",
      nowait = true, --- use `nowait` when creating keymaps
   })
   register({
      ["<M-s>"] = {
         "<CMD>setlocal paste<CR>o<ESC><Cmd>lua require('comment-box').line()<CR>j<ESC>^<CMD>setlocal nopaste<CR>",
         "Draw a separator line",
      },
      -- ──────────────────────────────────────────────────────────────────────
      -- ["<M-s>"] = {
      --    function()
      --       -- vim.api.nvim_command("startinsert")
      --       require("comment-box").line()
      --       -- vim.api.nvim_command("stopinsert")
      --    end,
      --    "Draw a separator line",
      -- },
   }, {
      noremap = false,
      silent = true,
      buffer = nil,
      mode = "n",
      nowait = true, --- use `nowait` when creating keymaps
   })
end
