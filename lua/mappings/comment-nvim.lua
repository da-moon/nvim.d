-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- https://github.com/fedorov7/nvim/blob/master/lua/user/mappings.lua
-- selene: allow(unused_variable)
-- luacheck: no unused args
local function D(name, alt)
   -- selene: deny(unused_variable)
   -- luacheck: unused args
   vim.deprecate("require('Comment.api')." .. name, "require('Comment.api')." .. alt, "0.7", "Comment.nvim", false)
end
return function(register)
   if not register then
      return
   end
   -- ─── NORMAL ─────────────────────────────────────────────────────────────────────
   register({
      name = "+Comment",
      -- https://github.com/numToStr/Comment.nvim/blob/22e71071d9473996563464fde19b108e5504f892/lua/Comment/api.lua#L211
      ["l"] = {
         function()
            local ctype_line = require("Comment.utils").ctype.line
            local count = require("Comment.opfunc").count
            local conf = require("Comment.config"):get()
            local line_counter = vim.v.count
            if line_counter == 0 then
               line_counter = 1
            end
            if conf == nil then
               conf = {}
            end
            count(line_counter, conf, ctype_line)
         end,
         "Line",
      },
      -- extra
      ["<Right>"] = {
         function()
            require("Comment.api").insert_linewise_eol()
         end,
         "add-comment-at-the-end-of-line",
      },
      ["<Up>"] = {
         function()
            require("Comment.api").insert_linewise_above()
         end,
         "add-comment-on-the-line-above",
      },
      ["<Down>"] = {
         function()
            require("Comment.api").insert_linewise_below()
         end,
         "add-comment-on-the-line-below",
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
      -- https://github.com/numToStr/Comment.nvim/blob/22e71071d9473996563464fde19b108e5504f892/lua/Comment/api.lua#L211
      -- vim.api.nvim_input("<esc>")
      ["l"] = {
         [[<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>]],
         "Line",
      },
   }, {
      mode = "x",
      prefix = "<Leader>c",
      buffer = nil, --- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, --- use `silent` when creating keymaps
      noremap = true, --- use `noremap` when creating keymaps
      nowait = true, --- use `nowait` when creating keymaps
   })
   -- ────────────────────────────────────────────────────────────────────────────────
end
