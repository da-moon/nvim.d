-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   register({
      name = "+Editing Support",
      -- [ TODO ] => maybe move to utils
      ["r"] = { [[<cmd>Registers<CR>]], "List Registers" },
   }, {
      mode = "n",
      prefix = "<Leader>e",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
