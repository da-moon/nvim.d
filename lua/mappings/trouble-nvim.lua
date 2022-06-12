-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- selene: allow(unused_variable)
-- luacheck: no unused args
return function(register)
   -- selene: deny(unused_variable)
   -- luacheck: unused args
   if not register then
      return
   end
   register({
      name = "+Trouble",
      ["x"] = {
         function()
            require("trouble").toggle()
         end,
         "Toggle Trouble",
      },
      ["w"] = {
         function()
            require("trouble").toggle("workspace_diagnostics")
         end,
         "Toggle Trouble LSP Workspace Diagnostics",
      },
      ["d"] = {
         function()
            require("trouble").toggle("document_diagnostics")
         end,
         "Toggle Trouble LSP Document Diagnostics",
      },
      ["l"] = {
         function()
            require("trouble").toggle("loclist")
         end,
         "Toggle Trouble loclist",
      },
      ["q"] = {
         function()
            require("trouble").toggle("quickfix")
         end,
         "Toggle Trouble quickfix",
      },
      ["r"] = {
         function()
            require("trouble").toggle("lsp_references")
         end,
         "Toggle Trouble LSP References",
      },
   }, {
      mode = "n",
      prefix = "<Leader>x",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
