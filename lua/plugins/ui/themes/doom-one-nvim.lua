-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────

local M = {}
function M.setup() end
function M.config()
   local module_name = "doom-one"
   local plugin_name = "doom-one.nvim"
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
   local _time = os.date("*t")
   if _time.hour >= 0 and _time.hour < 1 then
      plug.setup({
         cursor_coloring = false,
         terminal_colors = true,
         italic_comments = false,
         enable_treesitter = true,
         transparent_background = false,
         pumblend = {
            enable = true,
            transparency_amount = 20,
         },
         plugins_integrations = {
            gitsigns = true,
            telescope = true,
            indent_blankline = true,
            dashboard = true,
            whichkey = true,
            nvim_tree = true,
            bufferline = true,
            barbar = false,
            neogit = false,
            startify = false,
            vim_illuminate = false,
            lspsaga = false,
            neorg = false,
            gitgutter = false,
         },
      })
      local status_ok, lualine_conf = pcall(require, "lib.plugins.lualine-nvim")
      -- TODO:update lib.plugins.lualine-nvim and set it automatically based on time
      -- Maybe do it in setup function ?
      if status_ok then
         lualine_conf.colors = {
            grey = "#3f444a",
            red = "#ff6c6b",
            orange = "#da8548",
            green = "#98be65",
            yellow = "#ECBE7B",
            blue = "#51afef",
            dark_blue = "#2257A0",
            magenta = "#c678dd",
            violet = "#a9a1e1",
            cyan = "#46D9FF",
            white = "#efefef",

            bg_alt = "#282c34",
            bg = "#21242b",
            bg_highlight = "#21252a",
            bg_popup = "#3E4556",
            bg_statusline = "#3E4556",
            bg_highlighted = "#4A4A45",

            fg = "#bbc2cf",
            fg_alt = "#5B6268",

            git = {
               add = "#98be65",
               change = "#51afef",
               delete = "#ff6c6b",
               conflict = "#da8548",
            },
         }
      else
         msg = "could not load 'lib.plugins.lualine-nvim' module"
         -- stylua: ignore start
         if logger then logger:warn(msg)  end
         -- stylua: ignore end
      end
      vim.cmd([[colorscheme doom-one]])
      msg = "using 'doom-one' color scheme"
      -- stylua: ignore start
      if logger then logger:trace(msg)  end
      -- stylua: ignore end
   end
end
return M
