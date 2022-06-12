-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   register({
      name = "+Help",
      ["?"] = { "<cmd>WhichKey<cr>", "List Normal Mappings" },
      ["n"] = { "<cmd>WhichKey<cr>", "normal" },
      ["v"] = { "<cmd>WhichKey '' v<cr>", "visual" },
      ["i"] = { "<cmd>WhichKey '' i<cr>", "insert" },
      ["x"] = { "<cmd>WhichKey '' x<cr>", "selection" },
   }, {
      mode = "n",
      prefix = "?",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
