-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
function M.config()
   local module_name = "which-key"
   local plugin_name = "which-key.nvim"
   local plug = pluginman:load_plugin(plugin_name, module_name)
   assert(
      plug ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         module_name,
         plugin_name,
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   -- stylua: ignore start
   plug.setup({
      plugins = {
         marks     = true,   --  shows a list of your marks on ' and `
         -- ────────────────────────────────────────────────────────────
         registers = false,  --  shows your registers on " in NORMAL or <C-r>
                             --  in INSERT mode
         -- ────────────────────────────────────────────────────────────
         spelling = {
            enabled     = false,  --  enabling this will show WhichKey when
                                  --  pressing z= to select spelling
                                  --  suggestions
            -- ────────────────────────────────────────────────────────────
            suggestions = 20,     --  how many suggestions should be shown in
                                  --  the list?
            -- ────────────────────────────────────────────────────────────
         },
         -- ────────────────────────────────────────────────────────────
         presets = {              --  the presets plugin, adds help for a bunch
                                  --  of default keybindings in Neovim No
                                  --  actual key bindings are created
         -- ────────────────────────────────────────────────────────────
            operators    = true,  --  adds help for operators like d, y, ...
                                  --  and registers them for motion / text
                                  --  object completion
            -- ────────────────────────────────────────────────────────────
            motions      = true,  --  adds help for motions
            -- ────────────────────────────────────────────────────────────
            text_objects = true,  --  help for text objects triggered after
                                  --  entering an operator
            -- ────────────────────────────────────────────────────────────
            windows      = true,  --  default bindings on <c-w>
            -- ────────────────────────────────────────────────────────────
            nav          = true,  --  misc bindings to work with windows
            -- ────────────────────────────────────────────────────────────
            z            = true,  --  bindings for folds, spelling and others
                                  --  prefixed with z
            -- ────────────────────────────────────────────────────────────
            g            = true,  --  bindings for prefixed with g
         },
      },
      -- ────────────────────────────────────────────────────────────
      operators = {  --  add operators that will trigger motion and text
                     --  object completion to enable all native operators, set
                     --  the preset / operators plugin above
      -- ────────────────────────────────────────────────────────────
         gc = "Comments",
      },
      -- ────────────────────────────────────────────────────────────
      key_labels = {  --  override the label used to display some keys. It
                      --  doesn't effect WK in any other way. For example:
      -- ────────────────────────────────────────────────────────────
         ["<space>"] = "SPC",
         ["<cr>"]    = "RET",
         ["<tab>"]   = "TAB",
      },
      icons = {
         breadcrumb = "»",  --  symbol used in the command line area that shows
                            --  your active key combo
         -- ────────────────────────────────────────────────────────────
         separator  = "➜",  --  symbol used between a key and it's label
         -- ────────────────────────────────────────────────────────────
         group      = "+",  --  symbol prepended to a group
         -- ────────────────────────────────────────────────────────────
      },
      popup_mappings = {
         scroll_down = "<c-d>",  --  binding to scroll down inside the popup
         -- ────────────────────────────────────────────────────────────
         scroll_up   = "<c-u>",  --  binding to scroll up inside the popup
         -- ────────────────────────────────────────────────────────────
      },
      window = {
         border   = "none",          --  none, single, double, shadow
         -- ────────────────────────────────────────────────────────────
         position = "bottom",        --  bottom, top
         -- ────────────────────────────────────────────────────────────
         margin   = { 1, 0, 1, 0 },  --  extra window margin [top, right,
                                     --  bottom, left]
         -- ────────────────────────────────────────────────────────────
         padding  = { 2, 2, 2, 2 },  --  extra window padding [top, right,
                                     --  bottom, left]
         -- ────────────────────────────────────────────────────────────
         winblend = 0,
      },
      layout = {
         height  = { min = 4, max = 25 },   --  min and max height of the
                                            --  columns
         -- ────────────────────────────────────────────────────────────
         width   = { min = 20, max = 50 },  --  min and max width of the
                                            --  columns
         -- ────────────────────────────────────────────────────────────
         spacing = 3,                       --  spacing between columns
         -- ────────────────────────────────────────────────────────────
         align   = "left",                  --  align columns left, center or
                                            --  right
         -- ────────────────────────────────────────────────────────────
      },
      -- ────────────────────────────────────────────────────────────
      ignore_missing = false,  --  enable this to hide mappings for which you
                               --  didn't specify a label
      -- ────────────────────────────────────────────────────────────
      hidden         = {       --  hide mapping boilerplate
      -- ────────────────────────────────────────────────────────────
         "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ ",
      },
      -- ────────────────────────────────────────────────────────────
      show_help          = true,    --  show help message on the command line
                                    --  when the popup is visible
      -- ────────────────────────────────────────────────────────────
      triggers           = "auto",  --  automatically setup triggers
      -- ────────────────────────────────────────────────────────────
      triggers_blacklist = {        --  list of mode / prefixes that should
                                    --  never be hooked by WhichKey this is
                                    --  mostly relevant for key maps that start
                                    --  with a native binding most people
                                    --  should not need to change this
      -- ────────────────────────────────────────────────────────────
         i = { "j", "k" },
         v = { "j", "k" },
      },
      -- stylua: ignore end
      -- TODO: load mappings here ?
   })
end
return M
