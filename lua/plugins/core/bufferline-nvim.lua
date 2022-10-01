-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup()
   local module_name = "nvim-web-devicons"
   local plugin_name = "nvim-web-devicons"
   local plug = pluginman:load_plugin(plugin_name, module_name)
   -- [ FIXME ]
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
   local module_name = "bufferline"
   local plugin_name = "bufferline.nvim"
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
   local icons = require("lib.plugins.lsp-kind").icons
   -- luacheck: max line length 160
   local buffer = require("lib.buffer")
   plug.setup({
      options = {

         numbers = "both", -- values "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string
         close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
         right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
         left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
         middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
         -- NOTE: this plugin is designed with this icon in mind,
         -- and so changing this is NOT recommended, this is intended
         -- as an escape hatch for people who cannot bear it for whatever reason
         indicator = {
            icon = "▎",
            style = 'icon',
         },
         buffer_close_icon = "",
         modified_icon = "●",
         close_icon = "",
         left_trunc_marker = "",
         right_trunc_marker = "",
         --- name_formatter can be used to change the buffer's label in the bufferline.
         --- Please note some names can/will break the
         --- bufferline so use this at your discretion knowing that it has
         --- some limitations that will *NOT* be fixed.
         name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
            -- remove extension from markdown files for example
            if buf.name:match("%.md") then
               return vim.fn.fnamemodify(buf.name, ":t:r")
            end
         end,
         max_name_length = 18,
         max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
         tab_size = 18,
         diagnostics = "nvim_lsp", -- values :  false | "nvim_lsp" | "coc"
         diagnostics_update_in_insert = false,
         diagnostics_indicator = function(_, _, diagnostics_dict, _)
            local symbols = { error = icons.error, warning = icons.warn, info = icons.info }
            local result = {}
            for name, count in pairs(diagnostics_dict) do
               if symbols[name] and count > 0 then
                  table.insert(result, symbols[name] .. count)
               end
            end
            result = table.concat(result, " ")
            return #result > 0 and result or ""
         end,
         -- luacheck: no unused
         -- selene: allow(unused_variable)
         custom_filter = function(buf_number, buf_numbers)
            -- selene: deny(unused_variable)
            -- luacheck: unused
            if buffer.is_ft(buf_number, "dashboard") then
               return false
            elseif buffer.is_ft(buf_number, "packer") then
               return false
            elseif buffer.is_ft(buf_number, "spectre_panel") then
               return false
            else
               return true
            end
         end,
         offsets = {
            {
               filetype = "undotree",
               text = "Undotree",
               highlight = "PanelHeading",
               padding = 1,
            },
            {
               filetype = "NvimTree",
               text = "Explorer",
               highlight = "PanelHeading",
               padding = 1,
            },
            {
               filetype = "DiffviewFiles",
               text = "Diff View",
               highlight = "PanelHeading",
               padding = 1,
            },
            {
               filetype = "flutterToolsOutline",
               text = "Flutter Outline",
               highlight = "PanelHeading",
            },
            {
               filetype = "packer",
               text = "Packer",
               highlight = "PanelHeading",
               padding = 1,
            },
         },
         show_buffer_icons = true, -- disable filetype icons for buffers
         show_buffer_close_icons = true,
         show_close_icon = true,
         show_tab_indicators = true,
         persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
         -- can also be a table containing 2 custom separators
         -- [focused and unfocused]. eg: { '|', '|' }
         separator_style = "thick", -- values: "slant" | "thick" | "thin" | { 'any', 'any' }
         enforce_regular_tabs = false,
         always_show_bufferline = false,
         sort_by = "id",
         groups = {
            options = {
               toggle_hidden_on_enter = true,
            },
            items = {
               { name = "ungrouped" },
               {
                  highlight = { guisp = "#51AFEF" },
                  name = "tests",
                  icon = icons.test,
                  matcher = function(buf)
                     return buf.filename:match("_spec") or buf.filename:match("test")
                  end,
               },
               {
                  name = "view models",
                  highlight = { guisp = "#03589C" },
                  matcher = function(buf)
                     return buf.filename:match("view_model%.dart")
                  end,
               },
               {
                  name = "screens",
                  icon = icons.screen,
                  matcher = function(buf)
                     return buf.path:match("screen")
                  end,
               },
               {
                  highlight = { guisp = "#C678DD" },
                  name = "docs",
                  matcher = function(buf)
                     local List = require("plenary.collections.py_list")
                     local list = List({ "md", "org", "norg", "wiki" })
                     return list:contains(vim.fn.fnamemodify(buf.path, ":e"))
                  end,
               },
               {
                  highlight = { guisp = "#F6A878" },
                  name = "config",
                  matcher = function(buf)
                     return buf.filename:match("go.mod")
                        or buf.filename:match("go.sum")
                        or buf.filename:match("Cargo.toml")
                        or buf.filename:match("manage.py")
                        or buf.filename:match("Makefile")
                  end,
               },
            },
         },
      },
      -- luacheck: max line length 120
   })
end
return M
