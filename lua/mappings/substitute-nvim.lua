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
      name = "+Editing Support",
      -- [ TODO ] => maybe move to utils
      ["s"] = {
         name = "+Substitute",
         ["l"] = {
            function()
               require("substitute").line()
            end,
            "Substitute Line",
         },
         ["s"] = {
            function()
               require("substitute").operator()
            end,
            "Substitute (Motion)",
         },
         ["e"] = {
            function()
               require("substitute").eol()
            end,
            "Substitute to End of Line",
         },
      },
   }, {
      mode = "n",
      prefix = "<Leader>e",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })

   -- ────────────────────────────────────────────────────────────────────────────────
   register({
      name = "+Editing Support",
      ["s"] = {
         function()
            require("substitute").visual()
         end,
         "Substitute",
      },
   }, {
      mode = "x",
      prefix = "<leader>e",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
