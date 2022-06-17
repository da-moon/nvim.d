-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- luacheck: max line length 160
-- https://github.com/decayofmind/dotfiles/blob/eb9bcb371c657e2c0cd62f60d6851c51c4e18969/.config/nvim/lua/plugins.lua#L134
-- ──────────────────────────────────────────────────────────────────────
-- luacheck: max line length 120
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
function M.setup() end
function M.config()
   local module_name = "toggleterm"
   local plugin_name = "nvim-toggleterm.lua"
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
      -- size can be a number or function which is passed the current terminal
      size = function(term)
         if term.direction == "horizontal" then
            return 15
         elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
         else
            return 20
         end
      end,
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_terminals = true,
      shade_filetypes = {},
      -- the degree by which to darken to terminal colour
      -- default: 1 for dark backgrounds, 3 for light
      shading_factor = 1,
      start_in_insert = true,
      insert_mappings = false, -- whether or not the open mapping applies in insert mode
      persist_size = true,
      direction = "float",
      -- direction = "horizontal",
      close_on_exit = true, -- close the terminal window when the process exits
      float_opts = {
         -- The border key is *almost* the same as 'nvim_win_open'
         -- see :h nvim_win_open for details on borders however
         -- the 'curved' border is a custom border type
         -- not natively supported but implemented in this plugin.
         border = "double",
         -- https://github.com/liranuxx/nvea/blob/master/lua/plugins/tools/init-toggleterm.lua
         width = math.floor(vim.api.nvim_win_get_width(0) * 0.8),
         height = math.floor(vim.api.nvim_win_get_height(0) * 0.8),
         winblend = 3,
         highlights = { border = "Normal", background = "Normal" },
      },
   })
end
return M
