-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- https://github.com/fedorov7/nvim/blob/master/lua/user/mappings.lua
-- selene: allow(unused_variable)
-- luacheck: no unused args
return function(register)
   -- selene: deny(unused_variable)
   -- luacheck: unused args
   if not register then
      return
   end
   -- ─── NORMAL ─────────────────────────────────────────────────────────────────────
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
