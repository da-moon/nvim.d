-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   register({
      name = "+Applications",
      ["l"] = { "<cmd>Calendar<CR>", "vim-calendar" },
      ["c"] = { "<cmd>Calc<CR>", "vim-calculator" },
      ["g"] = {
         name = "+Git",
         ["s"] = { "Stage Hunk" },
         ["u"] = { "Undo Stage Hunk" },
         ["r"] = { "Reset Hunk" },
         ["R"] = { "Reset Buffer" },
         ["p"] = { "Preview Hunk" },
         ["b"] = { "Blame Line" },
      },
   }, {
      mode = "n",
      prefix = "<leader>a",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
