-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- https://github.com/fedorov7/nvim/blob/master/lua/user/mappings.lua
return function(register)
   if not register then
      return
   end
   -- ─── NORMAL ─────────────────────────────────────────────────────────────────────
   -- FIXME: I can't find this mapping
   register({
      name = "+Comment",
      ["t"] = { "<cmd>TodoTelescope<cr>", "search-todo" },
   }, {
      mode = "n",
      prefix = "<leader>c",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
   -- ────────────────────────────────────────────────────────────────────────────────
end
