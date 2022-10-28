-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   -- ╭──────────────────────────────────────────────────────────╮
   -- │                         cleanup                          │
   -- ╰──────────────────────────────────────────────────────────╯
   vim.keymap.set("n", "<Leader>tb", [[<nop>]], { noremap = true })
   vim.keymap.del("n", "<Leader>tb")
   vim.keymap.set("n", "<Leader>td", [[<nop>]], { noremap = true })
   vim.keymap.del("n", "<Leader>td")
   -- ────────────────────────────────────────────────────────────
   register({
      name = "+Telescope",
      ["r"] = { [[<cmd>Telescope neoclip<cr>]], "Clipboard Register" },
      ["t"] = { [[<cmd>Telescope toggleterm<cr>]], "Terminals" },
      ["c"] = { "<cmd>Telescope colorscheme<cr>", "Change Theme" },
      ["h"] = {
         function()
            require("telescope.builtin").help_tags()
         end,
         "List Help Tags",
      },
   }, {
      mode = "n",
      prefix = "<leader>t",
      buffer = nil,
      silent = true,
      -- FIXME:
      noremap = true,
      nowait = true,
   })
   register({
      ["<C-f>"] = {
         function()
            require("telescope.builtin").current_buffer_fuzzy_find()
         end,
         "Live fuzzy search inside of the currently open buffer",
      },
   }, {
      mode = "n",
      buffer = nil,
      noremap = false,
   })
   register({
      ["<C-f>"] = {
         function()
            require("telescope.builtin").current_buffer_fuzzy_find()
         end,
         "Live fuzzy search inside of the currently open buffer",
      },
   }, {
      mode = "i",
      buffer = nil,
      noremap = false,
   })
end
