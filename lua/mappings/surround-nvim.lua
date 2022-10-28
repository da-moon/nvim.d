-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- TODO>
-- - [ ] disable nvim.Surround default keybindngs
-- ──────────────────────────────────────────────────────────────────────
-- FIXME
return function(register)
   if not register then
      return
   end
   -- register({
   --    name = "+Motion",
   --    ["s"] = {
   --       name = "+Vim-surround",
   --       ["a"] = "Add Surround <Motion>",
   --       ["q"] = "Repeat Last Surround",
   --       ["d"] = "Delete Surround <Motion>",
   --       ["r"] = "Replace Surround <Motion>",
   --       ["t"] = {
   --          name = "+toggle-brackets",
   --          ["b"] = "Toggle Brackets",
   --          ["q"] = "Toggle Quotes",
   --          ["B"] = "Toggle Brackets",
   --       },
   --    },
   -- }, {
   --    mode = "n",
   --    prefix = "<Leader>m",
   --    buffer = nil,
   --    silent = true,
   --    noremap = true,
   --    nowait = true,
   -- })
end
