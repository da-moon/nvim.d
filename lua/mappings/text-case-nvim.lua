-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   register({
      name = "+text-case",
      ["s"] = { [[<CMD>lua require('textcase').operator('to_snake_case')<CR>]], "Convert to_snake_case" },
      ["."] = { [[<CMD>lua require('textcase').operator('to_dot_case')<CR>]], "Convert to_dot_case" },
      ["t"] = { [[<CMD>lua require('textcase').operator('to_title_case')<CR>]], "Convert to_title_case" },
      ["/"] = { [[<CMD>lua require('textcase').operator('to_path_case')<CR>]], "Convert to_path_case" },
      [">"] = { [[<CMD>lua require('textcase').operator('to_phrase_case')<CR>]], "Convert to_phrase_case" },
   }, {
      mode = "v",
      prefix = "<Leader>et",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
