-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   register({
      --   https://github.com/fedorov7/nvim/blob/master/lua/user/mappings.lua
      ["x"] = { [["+x]], "Cut to system clipboard" },
      ["y"] = { [["+y]], "Copy to system clipboard" },
   }, {
      mode = "v",
      prefix = "<LocalLeader>",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
