-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- TODO> take in a buffer number from user
-- ──────────────────────────────────────────────────────────────────────
return function(register)
   if not register then
      return
   end
   register({
      name = "+Editing Support",
      ["f"] = {
         name = "+Spectre",
         ["o"] = {
            function()
               require("spectre").open()
            end,
            "Open Spectre",
         },
         ["w"] = {
            function()
               require("spectre").open_visual({ select_word = true, path = vim.fn.expand("%") })
            end,
            "Open Find and Replace for current word in this open file",
         },
         ["W"] = {
            function()
               require("spectre").open_visual({ select_word = true })
            end,
            "Search current word across all files",
         },
         ["r"] = {
            function()
               require("spectre").open_file_search()
            end,
            "Open Find and Replace",
         },
         -- ["r"] = {
         --    function()
         --       require("spectre").open_visual({ path = vim.fn.expand("%") })
         --    end,
         --    "Open Find and Replace",
         -- },
         ["R"] = {
            function()
               require("spectre").open_visual()
            end,
            "Open Find and Replace across all files",
         },
      },
   }, {
      mode = "n",
      prefix = "<Leader>e",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })

   -- ──────────────────────────────────────────────────────────────────────
   --  sane vscode like key bindings
   register({
      ["<C-r>"] = {
         function()
            require("spectre").open({
               path = vim.fn.expand("%"),
               search_text = require("spectre.utils").get_visual_selection(),
            })
         end,
         "Open Find and Replace",
      },
      -- ["<C-M-r>"] = {
      --    function()
      --       require("spectre").open_visual()
      --    end,
      --    "Open Find and Replace across all files",
      -- },
   }, {
      mode = "v",
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = false, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
   })
end
