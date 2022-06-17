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
   local module_name = "zephyr"
   local plugin_name = "zephyr.nvim"
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
   if _time.hour >= 21 and _time.hour < 24 then
      local status_ok, lualine_conf = pcall(require, "lib.plugins.lualine-nvim")
      if status_ok then
         lualine_conf.colors = {
            base0 = "#1B2229",
            base1 = "#1c1f24",
            base2 = "#202328",
            base3 = "#23272e",
            base4 = "#3f444a",
            base5 = "#5B6268",
            base6 = "#73797e",
            base7 = "#9ca0a4",
            base8 = "#b1b1b1",
            bg_alt = "#282a36",
            bg = "#2E323C",
            bg_popup = "#3E4556",
            bg_highlight = "#2E323C",
            bg_visual = "#b3deef",
            fg = "#bbc2cf",
            fg_alt = "#5B6268",
            red = "#e95678",
            redwine = "#d16d9e",
            orange = "#D98E48",
            yellow = "#f0c674",
            light_green = "#abcf84",
            green = "#afd700",
            dark_green = "#98be65",
            cyan = "#36d0e0",
            blue = "#61afef",
            violet = "#b294bb",
            magenta = "#c678dd",
            teal = "#1abc9c",
            grey = "#928374",
            brown = "#c78665",
            black = "#000000",
            bracket = "#80A0C2",
            currsor_bg = "#4f5b66",
            none = "NONE",
            git = {
               add = "#98be65",
               change = "#61afef",
               delete = "#e95678",
               conflict = "#D98e48",
            },
         }
      else
         msg = "could not load 'lib.plugins.lualine-nvim' module"
         -- stylua: ignore start
         if logger then logger:warn(msg)  end
         -- stylua: ignore end
      end
      vim.cmd([[colorscheme zephyr]])
      msg = "using 'zephyr' color scheme"
      -- stylua: ignore start
      if logger then logger:trace(msg)  end
      -- stylua: ignore end
   end
end
return M
