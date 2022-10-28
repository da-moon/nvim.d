-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- TODO:
-- - [ ] disable nvim.Surround default keybindngs
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   register({
      name = "+Motion",
      ["l"] = {
         name = "+lightspeed",
         ["s"] = { "<Plug>Lightspeed_s", "Search 2 Char Forward" },
         ["S"] = { "<Plug>Lightspeed_S", "Search 2 Char Backward" },
         ["x"] = { "<Plug>Lightspeed_x", "X-Mode 2 Char Forward" },
         ["X"] = { "<Plug>Lightspeed_X", "X-Mode 2 Char Backward" },
         ["t"] = { "<Plug>Lightspeed_t", "Move until 1 Char Forward" },
         ["T"] = { "<Plug>Lightspeed_T", "Move until 1 Char Backward" },
         [";"] = { "<Plug>Lightspeed_;_ft", "Repeat Last Move Forward" },
         [","] = { "<Plug>Lightspeed_,_ft", "Repeat Last Move Backward" },
      },
   }, {
      mode = "n",
      prefix = "<Leader>m",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                        overriding default f                        │
   -- ╰────────────────────────────────────────────────────────────────────╯
   local modes = { "n", "v" }
   for _, mode in ipairs(modes) do
      register({
         ["f"] = { "<Plug>Lightspeed_f", "Move to 1 Char Forward" },
         ["F"] = { "<Plug>Lightspeed_F", "Move to 1 Char Backward" },
      }, {
         mode = mode,
         silent = true,
      })
   end
end
