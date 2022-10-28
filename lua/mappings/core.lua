-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
local pluginman = require("lib.plugin-manager")
return function(register)
   if not register then
      return
   end
   -- ─── NORMAL ─────────────────────────────────────────────────────────────────────
   -- TODO see if this can be mapped in packer directly
   register({
      ["<A-CR>"] = {
         function()
            local module_name = "fine-cmdline"
            local plugin_name = "fine-cmdline.nvim"
            local plug = pluginman:load_plugin(plugin_name, module_name)
            if plug then
               plug.open()
            end
         end,
         "Open Command",
      },
      ["<BS>"] = { "i<BS><ESC>l", "remove last character" },
      ["<leader><leader>"] = { "<esc>q", "Toggle recording mode" },
      ["<A-BS>"] = { "dvb", "Remove last word" },
      ["<A-Down>"] = { "<cmd>m .+1<cr>==g", "Swap Line Upwards" },
      ["<A-Up>"] = { "<cmd>m .-2<cr>==g", "Swap Line Downwards" },

      -- ["<C-Up>"] = { "<C-w>k", "<ctrl+up> moves cursor above current pane" },
      ["<C-Up>"] = { "<CMD>FocusSplitUp<CR>", "<ctrl+up> moves cursor above current pane" },
      -- ["<C-Down>"] = { "<C-w>j", "<ctrl+down> moves cursor below current pane" },
      ["<C-Down>"] = { "<CMD>FocusSplitDown<CR>", "<ctrl+down> moves cursor below current pane" },
      -- ["<C-Left>"] = { "<C-w>h", "<ctrl+left> moves cursor to the left of current pane" },
      ["<C-Left>"] = { "<CMD>FocusSplitLeft<CR>", "<ctrl+left> moves cursor to the left of current pane" },
      -- ["<C-Right>"] = { "<C-w>l", "<ctrl+right> moves cursor to the right of current pane" },
      ["<C-Right>"] = { "<CMD>FocusSplitRight<CR>", "<ctrl+right> moves cursor to the right of current pane" },
      ["<C-a>"] = { "^", "Move to First Real Character in Line" },
      ["<C-e>"] = { "$", "Move to EOL" },
      -- ──────────────────────────────────────────────────────────────────────
      -- luacheck: max line length 200
      -- howtogeek.com/howto/ubuntu/keyboard-shortcuts-for-bash-command-shell-for-ubuntu-debian-suse-redhat-linux-etc/#:~:text=Ctrl%2BE%20or%20End%3A%20Go,left%20(back)%20one%20word.
      -- luacheck: max line length 120
      ["<C-l>"] = { "<cmd>nohlsearch<cr>", "Clear Search" },
      -- ──────────────────────────────────────────────────────────────────────
      ["<A-j>"] = { ":resize -2<CR>", "Resize up with 'ctrl + h' " },
      ["<A-l>"] = { ":vertical resize +2<CR>", "Resize right with 'ctrl +l'" },
      ["<A-k>"] = { ":resize +2<CR>", "Resize down with 'ctrl + j'" },
      ["<A-h>"] = { ":vertical resize -2<CR>", "Resize left with 'ctrl + k'" },
      ["<C-s>"] = { "<cmd>w<cr>", "Save current buffer" },
      -- ["<CS-s>"] = { "<cmd>wa<cr>", "Save all open buffers" },
      -- TODO> move somewhere else
      ["<Leader>q"] = {
         name = "+Quickfix movement",
         ["n"] = { ":cnext<CR>", "Next quickfix list" },
         ["p"] = { ":cprev<CR>", "Previous quickfix list" },
      },
      ["t"] = {
         name = "+Tabs",
         ["n"] = { "<Cmd>tabnew<CR>", "New" },
         ["o"] = { "<Cmd>tabonly<CR>", "Close all other" },
         ["q"] = { "<Cmd>tabclose<CR>", "Close" },
         ["<Right>"] = { "<Cmd>tabnext<CR>", "Next" },
         ["<Left>"] = { "<Cmd>tabprevious<CR>", "Previous" },
      },
      -- TODO> add commands to select a block
      ["v"] = {
         name = "+Visual",
         -- https://stackoverflow.com/questions/7406949/vim-faster-way-to-select-blocks-of-text-in-visual-mode
         ["p"] = { [[Vap]], "select paragraph under the cursor" },
         ["v"] = { [[viw]], "select word under cursor" },
         ['"'] = { [[vi"]], "select word inside double quotes" },
         ["'"] = { [[vi']], "select word inside single quotes" },
      },
   }, {
      mode = "n",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
   -- luacheck: max line length 190
   register({
      ["<A-Up>"] = { [[<cmd>m '>+1<cr>gv=gv]], "Swap Line Upwards" },
      -- TODO> make it behave more like spacevim
      -- --  https://superuser.com/questions/310417/how-to-keep-in-visual-mode-after-identing-by-shift-in-vim
      -- ["<"] = { [[ <cmd>\<gv<cr> ]], "Indent left" }, --- sane indentation that does not exit visual mode after one indent
      -- [">"] = { [[ <cmd>\>gv<cr> ]], "Indent right" }, --- sane indentation that does not exit visual mode after one indent
   }, {
      mode = "v", --- visual mode
      buffer = nil, --- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, --- use `silent` when creating keymaps
      noremap = true, --- use `noremap` when creating keymaps
      nowait = true, --- use `nowait` when creating keymaps
   })
   -- luacheck: max line length 120
   -- ────────────────────────────────────────────────────────────────────────────────
   register({
      ["<C-s>"] = { "<esc><cmd>w<cr>", "Save current buffer" },
      ["<A-BS>"] = { "<esc>dvbi", "Remove last word" },
      ["<A-Down>"] = { "<esc><cmd>m .+1<cr>==gi", "Swap Line Upwards" },
      ["<A-Up>"] = { "<esc><cmd>m .-2<cr>==gi", "Swap Line Downwards" },

      -- ["<CS-s>"] = { "<esc><cmd>wa<cr>i", "Save all opened buffer" },
   }, {
      mode = "i",
      buffer = nil, --- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, --- use `silent` when creating keymaps
      noremap = true, --- use `noremap` when creating keymaps
      nowait = true, --- use `nowait` when creating keymaps
   })

   -- ────────────────────────────────────────────────────────────────────────────────
   -- [ NOTE ] => clearing 'q' mapping.
   -- vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = false })
   vim.api.nvim_set_keymap("n", "q", "<cmd>q<cr>", { noremap = true })
   -- ────────────────────────────────────────────────────────────────────────────────
   -- -- [ FIXME ]
   -- lvim.keys.normal_mode["<S-l>"] = ":BufferNext<CR>"
   -- lvim.keys.normal_mode["<S-h>"] = ":BufferPrevious<CR>"

   -- -- [ FIXME ]
   -- lvim.keys.normal_mode["<C-q>"] = ":call QuickFixToggle()<CR>"
end
