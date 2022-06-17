-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
function M.cond()
   return not vim.g.is_windows
end
function M.config()
   local module_name = "gitsigns"
   local plugin_name = "gitsigns.nvim"
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
      signs = {
         add = {
            hl     = "GitSignsAdd"   ,
            text   = "│"             ,
            numhl  = "GitSignsAddNr" ,
            linehl = "GitSignsAddLn" ,
         },
         change = {
            hl     = "GitSignsChange"   ,
            text   = "│"                ,
            numhl  = "GitSignsChangeNr" ,
            linehl = "GitSignsChangeLn" ,
         },
         delete = {
            hl     = "GitSignsDelete"   ,
            text   = "_"                ,
            numhl  = "GitSignsDeleteNr" ,
            linehl = "GitSignsDeleteLn" ,
         },
         topdelete = {
            hl     = "GitSignsDelete"   ,
            text   = "‾"                ,
            numhl  = "GitSignsDeleteNr" ,
            linehl = "GitSignsDeleteLn" ,
         },
         changedelete = {
            hl     = "GitSignsChange"   ,
            text   = "~"                ,
            numhl  = "GitSignsChangeNr" ,
            linehl = "GitSignsChangeLn" ,
         },
      },
      signcolumn = true,              --  Toggle with `:Gitsigns toggle_signs`
      numhl      = false,             --  Toggle with `:Gitsigns toggle_numhl`
      linehl     = false,             --  Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false,             --  Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
         interval     = 1000 ,
         follow_files = true ,
      },
      current_line_blame_opts = {
         virt_text         = true  ,
         virt_text_pos     = "eol" ,  --  'eol' | 'overlay' | 'right_align'
         delay             = 1000  ,
         ignore_whitespace = false ,
      },
      current_line_blame_formatter_opts = {
         relative_time = false ,
      },
      sign_priority    = 6,
      update_debounce  = 100,
      status_formatter = nil,         --  Use default
      max_file_length  = 40000,
      preview_config   = {
                                      --  Options passed to nvim_open_win
         border   = "single"  ,
         style    = "minimal" ,
         relative = "cursor"  ,
         row      = 0         ,
         col      = 1         ,
      },
      yadm = {
         enable = false,
      },
      on_attach = require("lib.plugins.gitsigns").on_attach,
   })
   -- stylua: ignore end
end
-- ──────────────────────────────────────────────────────────────────────
return M
