-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   -- ─── NORMAL MODE ────────────────────────────────────────────────────────────────
   register({
      name = "+Terminal",
      ['"'] = { [[<cmd>ToggleTerm<CR>]], "Toggle" },
      ["'"] = {
         function()
            -- -- https://stackoverflow.com/a/51181334
            -- https://github.com/rsHalford/configs/blob/main/.config/nvim/lua/config/toggleterm.lua
            -- https://github.com/ArchitBhonsle/nvim/blob/main/lua/user/toggleterm.lua
            local bufnr = vim.fn.input("buffer number ?")
            require("toggleterm").toggle_command(bufnr, 12)
         end,
         "Toggle Specific buffer",
      },
      ["c"] = {
         function()
            require("toggleterm").toggle_all("close")
         end,
         "Close All",
      },
      ["h"] = { [[<cmd>ToggleTerm direction=horizontal<CR>]], "Horizontal" },
      ["v"] = { [[<cmd>ToggleTerm direction=vertical<CR>]], "Vertical" },
      ["f"] = { [[<cmd>ToggleTerm direction=float<CR>]], "Floating" },
      ["t"] = { [[<cmd>ToggleTerm direction=tab<CR>]], "Tab" },
      ["1"] = { [[<cmd>ToggleTerm 1<CR>]], "Toggle Terminal 1" },
      ["2"] = { [[<cmd>ToggleTerm 2<CR>]], "Toggle Terminal 2" },
      ["3"] = { [[<cmd>ToggleTerm 3<CR>]], "Toggle Terminal 3" },
      ["4"] = { [[<cmd>ToggleTerm 4<CR>]], "Toggle Terminal 4" },
      ["5"] = { [[<cmd>ToggleTerm 5<CR>]], "Toggle Terminal 5" },
      ["6"] = { [[<cmd>ToggleTerm 6<CR>]], "Toggle Terminal 6" },
      ["7"] = { [[<cmd>ToggleTerm 7<CR>]], "Toggle Terminal 7" },
      ["8"] = { [[<cmd>ToggleTerm 8<CR>]], "Toggle Terminal 8" },
      ["9"] = { [[<cmd>ToggleTerm 9<CR>]], "Toggle Terminal 9" },
   }, {
      mode = "n",
      prefix = '"',
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
   -- ─── INSERT MODE ────────────────────────────────────────────────────────────────
   register({
      ["<C-'>"] = { [[<cmd>ToggleTerm<CR>]], "+Toggle Terminal" },
   }, {
      mode = "i",
      buffer = nil,
      noremap = true,
      silent = true,
      nowait = true,
   })
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                          predifined TUIs                           │
   -- ╰────────────────────────────────────────────────────────────────────╯
   register({
      ["g"] = {
         [[ <cmd>lua require("lib.plugins.toggleterm"):git()<CR> ]],
         "Git",
      },
   }, {
      mode = "n",
      prefix = '"',
      noremap = true,
      nowait = true,
      silent = true,
   })
   -- ──────────────────────────────────────────────────────────────────────
end
