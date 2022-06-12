-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- [ TODO ] => take in a buffer number from user
-- ──────────────────────────────────────────────────────────────────────
-- selene: allow(unused_variable)
-- luacheck: no unused args
return function(register, plugin_loader)
   -- selene: deny(unused_variable)
   -- luacheck: unused args
   if not register then
      return
   end
   register({
      name = "+Buffer",
      ["z"] = { [[<CMD>ZenMode<cr><CMD>TwilightEnable<CR>]], "Zen Mode" },
   }, {
      mode = "n",
      prefix = "<leader>b",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
