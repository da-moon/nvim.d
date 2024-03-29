-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   register({
      name = "+Packer",
      ["C"] = { [[<cmd>PackerClean<cr>]], "Clean Plugins" },
      ["c"] = { [[<cmd>PackerCompile<cr>]], "Compile Plugins" },
      ["i"] = { [[<cmd>PackerInstall<cr>]], "Install Missing Plugins" },
      ["s"] = { [[<cmd>PackerStatus<cr>]], "List Plugins" },
      ["S"] = { [[<cmd>PackerSync<cr>]], "Sync Plugins" },
      ["u"] = { [[<cmd>PackerUpdate<cr>]], "Update Plugins" },
      ["p"] = { [[<cmd>PackerProfile<cr>]], "Packer Profile" },
   }, {
      mode = "n",
      prefix = "<leader>p",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
