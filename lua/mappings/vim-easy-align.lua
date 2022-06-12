-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   -- [ TODO ] => figure out better mappings
   register({
      ga = { "<Plug>(EasyAlign)", "(TextObject) [Selection] EasyAlign" },
   }, {
      mode = "x",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
   register({
      ga = { "<Plug>(EasyAlign)", "(TextObject) EasyAlign" },
   }, {
      mode = "n",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
