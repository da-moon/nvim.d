-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- NOTE: I think this should get loaded after lsp starts up ... ( bufread ?)
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup()
   local module_name = "nvim-web-devicons"
   local plugin_name = "nvim-web-devicons"
   local plug = pluginman:load_plugin(plugin_name, module_name)
   -- FIXME:
   assert(
      plug ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         module_name,
         plugin_name,
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   if not plug then
      msg = "No icon plugin found. Please install 'kyazdani42/nvim-web-devicons'"
      -- stylua: ignore start
      if logger then return logger:warn(msg)  end
      -- stylua: ignore end
   end
end
function M.config()
   local module_name = "trouble"
   local plugin_name = "trouble.nvim"
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
   plug.setup({
      position = "bottom", -- position of the list can be: bottom, top, left, right
      auto_open = false,
      auto_close = true,
      -- luacheck: max line length 160
      -- mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
      -- luacheck: max line length 120
      mode = "document_diagnostics",
      height = 10, -- height of the trouble list when position is top or bottom
      width = 50, -- width of the list when position is left or right
      icons = true, -- use devicons for filenames
      fold_open = "", -- icon used for open folds
      fold_closed = "", -- icon used for closed folds
      group = true, -- group results by file
      padding = true, -- add an extra new line on top of the list
      action_keys = { -- key mappings for actions in the trouble list
         -- map to {} to remove a mapping, for example:
         -- close = {},
         close = "q", -- close the list
         cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
         refresh = "r", -- manually refresh
         jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
         open_split = { "<c-x>" }, -- open buffer in new split
         open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
         open_tab = { "<c-t>" }, -- open buffer in new tab
         jump_close = { "o" }, -- jump to the diagnostic and close the list
         toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
         toggle_preview = "P", -- toggle auto_preview
         hover = "K", -- opens a small popup with the full multiline message
         preview = "p", -- preview the diagnostic location
         close_folds = { "zM", "zm" }, -- close all folds
         open_folds = { "zR", "zr" }, -- open all folds
         toggle_fold = { "zA", "za" }, -- toggle fold of current file
         previous = "k", -- preview item
         next = "j", -- next item
      },
      indent_lines = true, -- add an indent guide below the fold icons
      -- luacheck: max line length 160
      auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      -- luacheck: max line length 120
      auto_fold = false, -- automatically fold a file trouble list at creation
      -- luacheck: max line length 160
      auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
      -- luacheck: max line length 120
      signs = {
         -- icons / text used for a diagnostic
         error = "",
         warning = "",
         hint = "",
         information = "",
         other = "﫠",
      },
      use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
   })
end
return M
