-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   register({
      ["<c-j>"] = { "<Plug>luasnip-expand-or-jump", "(Snippet) Expand Snippet or Jump to Next Placeholder" },
      ["<c-k>"] = { "<Plug>luasnip-jump-prev", "(Snippet) Jump to Previous Placeholder" },
   }, {
      mode = "i",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
   register({
      ["<c-j>"] = {
         "<Plug>luasnip-expand-or-jump",
         "(Snippet) Expand Snippet or Jump to Next Placeholder",
      },
      ["<c-k>"] = { "<Plug>luasnip-jump-prev", "(Snippet) Jump to Previous Placeholder" },
   }, {
      mode = "s",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
