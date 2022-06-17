-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.config()
   local module_name = "rose-pine"
   local plugin_name = "rose-pine"
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
   if _time.hour >= 9 and _time.hour < 13 then
      plug.setup({
         ---@usage 'main'|'moon'
         dark_variant = "moon",
         bold_vert_split = false,
         dim_nc_background = false,
         disable_background = false,
         disable_float_background = false,
         disable_italics = false,
         ---@usage string hex value or named color from rosepinetheme.com/palette
         groups = {
            border = "highlight_med",
            comment = "muted",
            link = "iris",
            punctuation = "subtle",

            error = "love",
            hint = "iris",
            info = "foam",
            warn = "gold",

            headings = {
               h1 = "iris",
               h2 = "foam",
               h3 = "rose",
               h4 = "gold",
               h5 = "pine",
               h6 = "foam",
            },
            -- or set all headings at once
            -- headings = 'subtle'
         },
      })
      local status_ok, lualine_conf = pcall(require, "lib.plugins.lualine-nvim")
      if status_ok then
         lualine_conf.colors = {
            none = "NONE",
            bg = "#393552",
            fg = "#e0def4",
            fg_gutter = "#3b4261",
            black = "#393b44",
            gray = "#2a2e36",
            red = "#eb6f92",
            green = "#97c374",
            yellow = "#f6c177",
            blue = "#9ccfd8",
            magenta = "#c4a7e7",
            cyan = "#9ccfd8",
            white = "#dfdfe0",
            orange = "#ea9a97",
            pink = "#D67AD2",
            black_br = "#7f8c98",
            red_br = "#e06c75",
            green_br = "#58cd8b",
            yellow_br = "#FFE37E",
            blue_br = "#84CEE4",
            magenta_br = "#B8A1E3",
            cyan_br = "#59F0FF",
            white_br = "#FDEBC3",
            orange_br = "#F6A878",
            pink_br = "#DF97DB",
            comment = "#526175",
            bg_alt = "#232136",
            git = {
               add = "#84Cee4",
               change = "#c4a7e7",
               delete = "#eb6f92",
               conflict = "#f6c177",
            },
         }
      else
         msg = "could not load 'lib.plugins.lualine-nvim' module"
         -- stylua: ignore start
         if logger then logger:warn(msg)  end
         -- stylua: ignore end
      end
      vim.cmd([[colorscheme rose-pine]])
      msg = "using 'rose-pine' color scheme"
      -- stylua: ignore start
      if logger then logger:trace(msg)  end
      -- stylua: ignore end
   end
end
return M
