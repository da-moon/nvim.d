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
      name = "+text-case",
      -- FIXME: these do not work
      ["s"] = {
         function()
            require("textcase.plugin.api").to_snake_case()
         end,
         "Convert to_snake_case",
      },
      ["."] = {
         function()
            require("textcase.plugin.api").to_dot_case()
         end,
         "Convert to_dot_case",
      },
      ["t"] = {
         function()
            require("textcase.plugin.api").to_title_case()
         end,
         "Convert to_title_case",
      },
      ["/"] = {
         function()
            require("textcase.plugin.api").to_path_case()
         end,
         "Convert to_path_case",
      },
      [">"] = {
         function()
            require("textcase.plugin.api").to_phrase_case()
         end,
         "Convert to_phrase_case",
      },
   }, {
      mode = "v",
      prefix = "<Leader>et",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
